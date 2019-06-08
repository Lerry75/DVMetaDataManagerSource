CREATE PROCEDURE [meta].[CreateBizBrTable]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Point In Time and Bridge
  IF meta.EntityTypeId(@EntityId) NOT IN ('Br')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = (SELECT meta.TemplateText('BizBridgeTable'))
    ,@TemplateKeyColumns NVARCHAR(MAX) = (SELECT meta.TemplateText('BizBridgeTable_key_columns'))
    ,@TemplateColumns NVARCHAR(MAX) = (SELECT meta.TemplateText('BizBridgeTable_column_names'))
	  ,@Sql NVARCHAR(MAX)
	  ,@KeyColumns NVARCHAR(MAX)
    ,@Columns NVARCHAR(MAX)
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

  -- Search for columns
  SET @KeyColumns = (
    SELECT REPLACE(@TemplateKeyColumns, '#referenced_key_column#', meta.EntityKeyColumn(HubLnk))
    FROM meta.EDWEntityRelationship 
    WHERE UsedBy = @EntityId
    ORDER BY EntityRelationshipId
    FOR XML PATH('')
  );

  SET @Columns = (
    SELECT REPLACE(REPLACE(REPLACE(@TemplateColumns, '#referenced_entity_name#', meta.EntityName(B.EDWEntityId)), '#referenced_column#', B.AttributeName), '#data_type#', meta.SqlDataType(B.DataTypeId))
    FROM meta.EDWEntityRelationship A
      JOIN meta.EDWAttribute B ON A.HubLnk = B.EDWEntityId
    WHERE UsedBy = @EntityId
     AND meta.EntityTypeId(A.HubLnk) = 'Lnk'
    ORDER BY A.EntityRelationshipId
      ,B.[Order]
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
  SET @Sql = REPLACE(@Sql, '#key_columns#', @KeyColumns);
  SET @Sql = REPLACE(@Sql, '#column_names#', ISNULL(@Columns, ''));
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