CREATE PROCEDURE [meta].[CreateEDWTable]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Hubs, Links, Satellite, Transaction Satellite, Record Tracking Satellite, Same-As-Link
  IF meta.EntityTypeId(@EntityId) NOT IN ('Hub', 'Lnk', 'Sat', 'TSat', 'RSat', 'SAL')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWTable'))
    ,@TemplateKeyColumns NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWTable_key_columns'))
	  ,@TemplateColumns NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWTable_column_names'))
	  ,@Sql NVARCHAR(MAX)
	  ,@HashDiff NVARCHAR(MAX) = ''
    ,@LoadDateShort NVARCHAR(MAX) = ''
	  ,@LoadEndDate NVARCHAR(MAX) = ''
	  ,@Columns NVARCHAR(MAX) = ''
	  ,@KeyColumn NVARCHAR(255)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#edw_db#')
          , '#schema#', '#edw_schema#')
        , '#object_name#', '[#entity_prefix##entity_type#_#entity_name#]')
      , '#object_type#', 'TABLE'
    );

  -- Search for key columns
  IF meta.EntityTypeId(@EntityId) IN ('Hub', 'Lnk', 'SAL')
    SET @KeyColumn = meta.EntityKeyColumn(@EntityId);

  IF meta.EntityTypeId(@EntityId) IN ('Sat', 'TSat', 'RSat')
	  SET @KeyColumn = (SELECT meta.EntityKeyColumn(HubLnk) FROM meta.EDWEntityRelationship WHERE UsedBy = @EntityId);

  -- Search for attribute columns
  IF meta.EntityTypeId(@EntityId) = 'Hub'
    SET @Columns = (
      SELECT REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', AttributeName), '#data_type#', meta.SqlDataType(DataTypeId))
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
	      AND IsStagingOnly = 0
      ORDER BY [Order]
      FOR XML PATH('')
    );
  
  IF meta.EntityTypeId(@EntityId) = 'Lnk'
    SET @Columns = (
	    SELECT REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', ColumnName), '#data_type#', DataType)
      FROM (
	      SELECT REPLACE(REPLACE(meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix)), '[', ''), ']','') ColumnName
		      ,meta.SqlDataTypeHashKey() DataType
          ,EntityRelationshipId [Order]
        FROM meta.EDWEntityRelationship
        WHERE UsedBy = @EntityId
   
        UNION ALL 

        SELECT AttributeName
		      ,meta.SqlDataType(DataTypeId)
          ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
        FROM meta.EDWAttribute
        WHERE EDWEntityId = @EntityId
		      AND IsStagingOnly = 0
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

  IF meta.EntityTypeId(@EntityId) IN ('Sat', 'TSat')
    SET @Columns = (
      SELECT REPLACE(REPLACE(@TemplateColumns, '#column_name#', AttributeName), '#data_type#', meta.SqlDataType(DataTypeId))
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
	      AND IsStagingOnly = 0
      ORDER BY [Order]
      FOR XML PATH('')
    );

  IF meta.EntityTypeId(@EntityId) = 'SAL'
    SET @Columns = (
	    SELECT REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', ColumnName), '#data_type#', DataType)
      FROM (
	      SELECT REPLACE(REPLACE(meta.EntityKeyColumnMasterDuplicate(HubLnk, 1), '[', ''), ']','') ColumnName
		      ,meta.SqlDataTypeHashKey() DataType
          ,0 [Order]
        FROM meta.EDWEntityRelationship
        WHERE UsedBy = @EntityId
   
        UNION ALL 

        SELECT REPLACE(REPLACE(meta.EntityKeyColumnMasterDuplicate(HubLnk, 0), '[', ''), ']','') ColumnName
		      ,meta.SqlDataTypeHashKey() DataType
          ,1 [Order]
        FROM meta.EDWEntityRelationship
        WHERE UsedBy = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

  -- Add LoadDateShort column for TLnk, TSat and RSat
  IF meta.EntityTypeId(@EntityId) IN ('TSat', 'RSat')
    OR EXISTS (
        SELECT *
        FROM meta.EDWEntityRelationship
        WHERE HubLnk = @EntityId
          AND meta.EntityTypeId(UsedBy) = 'TSat'
      )
  BEGIN
	  SET @LoadDateShort = REPLACE(REPLACE(@TemplateColumns, '#column_name#', 'LoadDateShort'), '#data_type#', '[date]');
  END

  -- Add LoadEndDate column for Satellites
  IF meta.EntityTypeId(@EntityId) = 'Sat'
  BEGIN
	  SET @HashDiff = REPLACE(REPLACE(@TemplateColumns, '#column_name#', 'HashDiff'), '#data_type#', meta.SqlDataTypeHashKey());
	  SET @LoadEndDate = REPLACE(REPLACE(@TemplateKeyColumns, '#column_name#', 'LoadEndDate'), '#data_type#', '[datetime2]');
  END

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
  SET @Sql = REPLACE(@Sql, '#entity_prefix#', CASE meta.EntityTypeId(@EntityId) WHEN 'Sat' THEN 'tbl_' ELSE '' END);
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.EntityTableName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', @KeyColumn);
  SET @Sql = REPLACE(@Sql, '#data_type_hash_key#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#hash_diff_column#', @HashDiff);
  SET @Sql = REPLACE(@Sql, '#load_date_short_column#', @LoadDateShort);
  SET @Sql = REPLACE(@Sql, '#load_end_date_column#', @LoadEndDate);
  SET @Sql = REPLACE(@Sql, '#column_names#', @Columns);
  SET @Sql = REPLACE(@Sql, '#edw_db#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#edw_schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#meta_db#', meta.MetaDbName());
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupData() ELSE CONCAT(meta.PartitionSchemeData(@EntityId), '([LoadDate])') END);
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupIndex() ELSE CONCAT(meta.PartitionSchemeIndex(@EntityId), '([LoadDate])') END);
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END