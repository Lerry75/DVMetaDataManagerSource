CREATE PROCEDURE [meta].[CreateStagingTable]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Hubs, Links, Same-As-Link
  IF meta.EntityTypeId(@EntityId) NOT IN ('Hub', 'Lnk', 'SAL')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt_#id# nvarchar(MAX) = ''#body#'';
EXEC sys.sp_executesql @Stmt_#id#;
'
    ,@TemplateKeyColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('StagingTable_key_columns'), '''', ''''''))
	  ,@TemplateColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('StagingTable_column_names'), '''', ''''''))
	  ,@SqlDrop NVARCHAR(MAX)
    ,@Sql NVARCHAR(MAX)
	  ,@KeyColumns NVARCHAR(MAX)
	  ,@Columns NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#staging_db#')
          , '#schema#', '#staging_schema#')
        , '#object_name#', '[#sat_entity_name#]')
      , '#object_type#', 'TABLE'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('StagingTable'), '''', ''''''))
  SET @Template = REPLACE(@Template, '#column_names#', '#column_names_#id##')

  -- Search for key columns in Hub
  IF meta.EntityTypeId(@EntityId) = 'Hub'
    SET @KeyColumns = (
      SELECT REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', AttributeName), '#data_type#', meta.SqlDataType(DataTypeId))
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
      ORDER BY [Order]
      FOR XML PATH('')
    );

  -- Search for key columns in Lnk
  IF meta.EntityTypeId(@EntityId) = 'Lnk'
    SET @KeyColumns = (
	    SELECT REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', AttributeName), '#data_type#', meta.SqlDataType(DataTypeId))
      FROM (
	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', A.AttributeName, meta.CleanSuffix(ER.HashKeySuffix)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
   
        UNION ALL 

        SELECT A.AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
        FROM meta.EDWAttribute A
        WHERE EDWEntityId = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

  -- Search for key columns in SAL
  IF meta.EntityTypeId(@EntityId) = 'SAL'
    SET @KeyColumns = (
	    SELECT REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', AttributeName), '#data_type#', meta.SqlDataType(DataTypeId))
      FROM (
	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', meta.AttributeNameMasterDuplicate(A.AttributeId, 1)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId

        UNION ALL

        SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', meta.AttributeNameMasterDuplicate(A.AttributeId, 0)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) + 1000 [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

  -- Search for Satellite columns
  IF EXISTS (
    SELECT *
	  FROM meta.EDWEntityRelationship
	  WHERE [HubLnk] = @EntityId
	    AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat')
  )
  BEGIN
    SET @SqlDrop = (
      SELECT REPLACE(@TemplateDrop, '#sat_entity_name#', meta.EntityName(UsedBy))
      FROM meta.EDWEntityRelationship 
      WHERE [HubLnk] = @EntityId
	      AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat')
      FOR XML PATH('')
    )

    SET @Sql = (
      SELECT REPLACE(REPLACE(@Template, '#entity_table_name#', meta.EntityTableNameStaging(UsedBy)), '#id#', UsedBy)
      FROM meta.EDWEntityRelationship 
      WHERE [HubLnk] = @EntityId
	      AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat')
      FOR XML PATH('')
    )

	  -- Replace columns
	  DECLARE @SatEntityId int;
	  DECLARE cols CURSOR FOR 
	    SELECT UsedBy
	    FROM meta.EDWEntityRelationship 
        WHERE [HubLnk] = @EntityId
	        AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat');
	  OPEN cols;
	  FETCH NEXT FROM cols INTO @SatEntityId;
	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	    SET @Columns = (
        SELECT REPLACE(REPLACE(@TemplateColumns, '#column_name#', AttributeName), '#data_type#', meta.SqlDataType(DataTypeId))
        FROM meta.EDWAttribute
        WHERE EDWEntityId = @SatEntityId
        ORDER BY [Order]
        FOR XML PATH('')
      )

	    SET @Sql = REPLACE(@Sql, replace('#column_names_#id##', '#id#', @SatEntityId), @Columns);

	    FETCH NEXT FROM cols INTO @SatEntityId;
	  END
	  CLOSE cols;
	  DEALLOCATE cols;
  END
  ELSE
  BEGIN
    SET @SqlDrop = @TemplateDrop;
    SET @Sql = REPLACE(REPLACE(@Template, '#column_names_#id##', ''), '#id#', @EntityId);
  END

  -- Replace Placeholders
  SET @SqlDrop = REPLACE(@SqlDrop, '#sat_entity_name#', meta.EntityName(@EntityId));
  SET @SqlDrop = REPLACE(@SqlDrop, '#meta_db#', meta.MetaDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#edw_db#', meta.WarehouseDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#staging_db#', meta.StagingDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#entity_prefix#', CASE meta.EntityTypeId(@EntityId) WHEN 'Sat' THEN 'tbl_' ELSE '' END);
  SET @SqlDrop = REPLACE(@SqlDrop, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @SqlDrop = REPLACE(@SqlDrop, '#entity_name#', meta.EntityName(@EntityId));
  SET @SqlDrop = REPLACE(@SqlDrop, '#schema#', CASE WHEN meta.EntityTypeId(@EntityId) IN ('Pit', 'Br') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END);
  SET @SqlDrop = REPLACE(@SqlDrop, '#edw_schema#', meta.WarehouseRawSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#biz_schema#', meta.WarehouseBusinessSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#error_schema#', meta.WarehouseErrorSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#staging_schema#', meta.StagingSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#printonly#', @PrintOnly);
  SET @SqlDrop = REPLACE(@SqlDrop, '&#x0D;', '');

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@SqlDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.EntityTableNameStaging(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_columns#', @KeyColumns);
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.StagingDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END