CREATE PROCEDURE [meta].[CreateEDWUpdateLoadEndDateProc] 
  @EntityId int,
  @PrintOnly bit = 0

AS

BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Satellites only
  IF meta.EntityTypeId(@EntityId) NOT IN ('Sat') 
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt nvarchar(MAX) = ''#body#'';   
EXEC sys.sp_executesql @Stmt;
'
    ,@Sql NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#edw_db#')
          , '#schema#', '#edw_schema#')
        , '#object_name#', '[UpdateLoadEndDate_#entity_type#_#entity_name#]')
      , '#object_type#', 'PROCEDURE'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('EDWUpdateLoadEndDateProc'), '''', ''''''))

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
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.[EntityTableName](@EntityId));
  SET @Sql = REPLACE(@Sql, '#edw_schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#date_range_end#', meta.DateRangeEnd());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END
