CREATE PROCEDURE [meta].[CreateBizPitTable]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Point In Time and Bridge
  IF meta.EntityTypeId(@EntityId) NOT IN ('Pit')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = (SELECT meta.TemplateText('BizPitTable'))
    ,@TemplateColumns NVARCHAR(MAX) = (SELECT meta.TemplateText('BizPitTable_column_names'))
	  ,@Sql NVARCHAR(MAX)
	  ,@Columns NVARCHAR(MAX)
	  ,@ReferencedEntityId INT
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#edw_db#')
          , '#schema#', '#biz_schema#')
        , '#object_name#', '[#entity_type#_#entity_name#]')
      , '#object_type#', 'TABLE'
    );

  SELECT @ReferencedEntityId = HubLnk
  FROM meta.EDWEntityRelationship
  WHERE UsedBy = @EntityId;

  -- Search for columns
  SET @Columns = (
    SELECT REPLACE(REPLACE(@TemplateColumns, '#referenced_entity_name#', meta.EntityName(UsedBy)), '#referenced_key_column#', REPLACE(REPLACE(meta.EntityKeyColumn(@ReferencedEntityId), '[', ''), ']', ''))
    FROM meta.EDWEntityRelationship 
    WHERE HubLnk = @ReferencedEntityId
      AND meta.EntityTypeId(UsedBy) = 'Sat'
    ORDER BY EntityRelationshipId
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
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.EntityTableName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#column_names#', @Columns);
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#referenced_key_column#', meta.EntityKeyColumn(@ReferencedEntityId));
  SET @Sql = REPLACE(@Sql, '#data_type_hash_key#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#biz_schema#', meta.WarehouseBusinessSchema());
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupData() ELSE CONCAT(meta.PartitionSchemeData(@EntityId), '([SnapshotDate])') END);
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupIndex() ELSE CONCAT(meta.PartitionSchemeIndex(@EntityId), '([SnapshotDate])') END);
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END