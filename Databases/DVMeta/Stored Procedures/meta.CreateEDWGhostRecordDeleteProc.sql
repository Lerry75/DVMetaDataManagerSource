CREATE PROCEDURE [meta].[CreateEDWGhostRecordDeleteProc]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Valid for Hubs and Sat only
  IF meta.EntityTypeId(@EntityId) NOT IN ('Hub', 'Sat')
    RETURN;

  -- Valid for Sat related to Hub only
  IF meta.EntityTypeId(@EntityId) = 'Sat'
    AND
    (
      SELECT meta.EntityTypeId(HubLnk)
      FROM meta.EDWEntityRelationship EntRel
      WHERE UsedBy = @EntityId
    ) != 'Hub'
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt nvarchar(MAX) = ''#body#'';
EXEC sys.sp_executesql @Stmt;
'
    ,@Database NVARCHAR(50)
    ,@Sql NVARCHAR(MAX)
    ,@SqlDrop NVARCHAR(MAX);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#edw_db#')
          , '#schema#', '#edw_schema#')
        , '#object_name#', '[GhostRecordDelete_#entity_type#_#entity_name#]')
      , '#object_type#', 'PROCEDURE'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('EDWGhostRecordDeleteProc'), '''', ''''''))

  -- Replace Placeholders
  SET @SqlDrop = REPLACE(@TemplateDrop, '#meta_db#', meta.MetaDbName());
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

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@SqlDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Template, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.[EntityTableName](@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#data_type_hash_key#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#default_hash_key#', meta.DefaultHashKey());
  SET @Sql = REPLACE(@Sql, '#edw_schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END