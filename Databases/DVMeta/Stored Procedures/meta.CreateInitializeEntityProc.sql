CREATE PROCEDURE [meta].[CreateInitializeEntityProc] 
  @EntityId int,
  @PrintOnly bit = 0

AS

BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for all entities
  
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
          , '#schema#', '#schema#')
        , '#object_name#', '[InitializeEntity_#entity_type#_#entity_name#]')
      , '#object_type#', 'PROCEDURE'
    );

  IF meta.EntityTypeId(@EntityId) IN ('Lnk', 'Sat', 'TSat', 'RSat', 'Br', 'Pit') 
    AND meta.PartitioningTypeId(@EntityId) != 'N'
	  SET @Sql = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('InitializeEntityProc_partitioned'), '''', ''''''));
  ELSE
    SET @Sql = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('InitializeEntityProc_nonpartitioned'), '''', ''''''));

  IF meta.PartitioningTypeId(@EntityId) = 'M'	-- Monthly
    SET @Sql = REPLACE(REPLACE(@Sql, '#date_value#', 'DATETIME2FROMPARTS(YEAR(@LoadDate), MONTH(@LoadDate), DAY(EOMONTH(@LoadDate)), 23, 59, 59, 9999999, 7)'), '#date_data_type#', 'DATETIME2');
  
  IF meta.PartitioningTypeId(@EntityId) = 'D'	-- Daily
    SET @Sql = REPLACE(REPLACE(@Sql, '#date_value#', 'DATETIME2FROMPARTS(YEAR(@LoadDate), MONTH(@LoadDate), DAY(@LoadDate), 23, 59, 59, 9999999, 7)'), '#date_data_type#', 'DATETIME2');

  IF meta.PartitioningTypeId(@EntityId) = 'H'	-- Hourly
    SET @Sql = REPLACE(REPLACE(@Sql, '#date_value#', 'DATETIME2FROMPARTS(YEAR(@LoadDate), MONTH(@LoadDate), DAY(@LoadDate), DATEPART(HOUR, @LoadDate), 59, 59, 9999999, 7)'), '#date_data_type#', 'DATETIME2');

  
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

  SET @Sql = REPLACE(@Sql, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#schema#', CASE WHEN meta.EntityTypeId(@EntityId) IN ('Pit', 'Br') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END);
  SET @Sql = REPLACE(@Sql, '#partition_function#', meta.PartitionFunction(@EntityId));
  SET @Sql = REPLACE(@Sql, '#partition_function_no_brackets#', REPLACE(REPLACE(meta.PartitionFunction(@EntityId), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#partition_scheme_data#', meta.PartitionSchemeData(@EntityId));
  SET @Sql = REPLACE(@Sql, '#partition_scheme_index#', meta.PartitionSchemeIndex(@EntityId));
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', meta.FileGroupIndex());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END
