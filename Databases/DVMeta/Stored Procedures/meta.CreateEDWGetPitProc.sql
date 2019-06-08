CREATE PROCEDURE [meta].[CreateEDWGetPitProc]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for PIT and Bridge only
  IF meta.EntityTypeId(@EntityId) NOT IN ('Pit')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt nvarchar(MAX) = ''#body#'';
EXEC sys.sp_executesql @Stmt;
'
	  ,@TemplateColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('EDWGetPitProc_column_names'), '''', ''''''))
	  ,@TemplateHashColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('EDWGetPitProc_columns_hash'), '''', ''''''))
	  ,@TemplateJoins NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('EDWGetPitProc_join_conditions'), '''', ''''''))
	  ,@Sql NVARCHAR(MAX)
	  ,@HashKeyColumns NVARCHAR(MAX)
	  ,@Columns NVARCHAR(MAX)
	  ,@Joins NVARCHAR(MAX)
	  ,@ReferencedEntityId INT
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#edw_db#')
          , '#schema#', '#edw_schema#')
        , '#object_name#', '[Get_#entity_type#_#entity_name#]')
      , '#object_type#', 'PROCEDURE'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('EDWGetPitProc'), '''', ''''''))

  IF meta.EntityTypeId(@EntityId) = 'Pit'
    SELECT @ReferencedEntityId = HubLnk
    FROM meta.EDWEntityRelationship
    WHERE UsedBy = @EntityId
	    AND meta.EntityTypeId(HubLnk) IN ('Hub', 'Lnk');
  ELSE
    SET @ReferencedEntityId = 0;	-- To Be Implemented for Bridge


  SET @Columns = (
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(@TemplateColumns, '#key_column#', REPLACE(REPLACE(meta.EntityKeyColumn(@ReferencedEntityId), '[', ''), ']', '')), '#referenced_entity_name#', meta.EntityName(UsedBy)), '#referenced_entity_type#', meta.EntityTypeId(UsedBy)), '#referenced_entity_id#', UsedBy)
    FROM meta.EDWEntityRelationship
    WHERE HubLnk = @ReferencedEntityId
      AND meta.EntityTypeId(UsedBy) = 'Sat'
    ORDER BY EntityRelationshipId
    FOR XML PATH('')
  );
  
  SET @Joins = (
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@TemplateJoins, '#key_column#', REPLACE(REPLACE(meta.EntityKeyColumn(@ReferencedEntityId), '[', ''), ']', '')), '#entity_type#', meta.EntityTypeId(@ReferencedEntityId)), '#referenced_entity_name#', meta.EntityName(UsedBy)), '#referenced_entity_type#', meta.EntityTypeId(UsedBy)), '#referenced_entity_id#', UsedBy)
    FROM meta.EDWEntityRelationship
    WHERE HubLnk = @ReferencedEntityId
      AND meta.EntityTypeId(UsedBy) = 'Sat'
    ORDER BY EntityRelationshipId
    FOR XML PATH('')
  );

  SET @HashKeyColumns = (
    SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(ColumnName, DataTypeId), '''', ''''''))
    FROM (
      SELECT CONCAT('[', meta.EntityTypeId(@ReferencedEntityId), '].', meta.EntityKeyColumn(HubLnk)) ColumnName
        ,20 DataTypeId  -- [HashKey] data type
        ,EntityRelationshipId [Order]
      FROM meta.EDWEntityRelationship
      WHERE UsedBy = @ReferencedEntityId
   
      UNION ALL 

      SELECT CONCAT('[', meta.EntityTypeId(@ReferencedEntityId), '].[', AttributeName, ']')
        ,DataTypeId
        ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @ReferencedEntityId
		    AND IsStagingOnly = 0
	      
      UNION ALL

	    SELECT '@SnapshotDate'
        ,17   -- [Date Time 2] data type
	      ,9999
    ) Z
    ORDER BY [Order]
    FOR XML PATH('')
  );

  -- Replace Placeholders
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#meta_db#', meta.MetaDbName());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#edw_db#', meta.WarehouseDbName());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#staging_db#', meta.StagingDbName());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#entity_prefix#', CASE meta.EntityTypeId(@EntityId) WHEN 'Sat' THEN 'tbl_' ELSE '' END);
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#entity_name#', meta.EntityName(@EntityId));
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#schema#', CASE WHEN meta.EntityTypeId(@EntityId) IN ('Pit', 'Br') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END);
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#edw_schema#', meta.WarehouseRawSchema());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#biz_schema#', meta.WarehouseBusinessSchema());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#error_schema#', meta.WarehouseErrorSchema());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#staging_schema#', meta.StagingSchema());
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#printonly#', @PrintOnly);

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@TemplateDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Template, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#referenced_entity_table_name#', meta.EntityTableName(@ReferencedEntityId));
  SET @Sql = REPLACE(@Sql, '#referenced_entity_type#', meta.EntityTypeId(@ReferencedEntityId));
  SET @Sql = REPLACE(@Sql, '#referenced_key_column#', meta.EntityKeyColumn(@ReferencedEntityId));
  SET @Sql = REPLACE(@Sql, '#column_names#', @Columns);
  SET @Sql = REPLACE(@Sql, '#join_conditions#', @Joins);
  SET @Sql = REPLACE(@Sql, '#hash_columns#', @HashKeyColumns);
  SET @Sql = REPLACE(@Sql, '#hash_type_len#', meta.SqlDataTypeHashKeyLength());
  SET @Sql = REPLACE(@Sql, '#edw_schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#date_range_start#', meta.DateRangeStart());
  SET @Sql = REPLACE(@Sql, '#hash_delimiter#', meta.HashDelimiter());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END