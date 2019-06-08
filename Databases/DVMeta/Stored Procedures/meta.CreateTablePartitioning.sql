CREATE PROCEDURE [meta].[CreateTablePartitioning]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Satellite, Transaction Satellite, Record Tracking Satellite, Same-As-Link, Bridge, PIT
  IF meta.EntityTypeId(@EntityId) NOT IN ('Lnk', 'Sat', 'TSat', 'RSat', 'SAL', 'Br', 'Pit')
    RETURN;

  IF meta.PartitioningTypeId(@EntityId) = 'N'
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = ''
    ,@Template NVARCHAR(MAX) = (SELECT meta.TemplateText('TablePartitioning'))
	  ,@Sql NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop += 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(meta.TemplateText('DropObject')
            , '#db_name#', '#edw_db#')
          , '#schema#', '')
        , '#object_name#', '#partition_scheme_data#')
      , '#object_type#', 'PS'
    );

  SET @TemplateDrop += 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(meta.TemplateText('DropObject')
            , '#db_name#', '#edw_db#')
          , '#schema#', '')
        , '#object_name#', '#partition_scheme_index#')
      , '#object_type#', 'PS'
    );

  SET @TemplateDrop += 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(meta.TemplateText('DropObject')
            , '#db_name#', '#edw_db#')
          , '#schema#', '')
        , '#object_name#', '#partition_function#')
      , '#object_type#', 'PF'
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
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#partition_function#', meta.PartitionFunction(@EntityId));
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#partition_scheme_data#', meta.PartitionSchemeData(@EntityId));
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#partition_scheme_index#', meta.PartitionSchemeIndex(@EntityId));
  SET @TemplateDrop = REPLACE(@TemplateDrop, '#printonly#', @PrintOnly);

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@TemplateDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Template, '#edw_db#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#partition_function#', meta.PartitionFunction(@EntityId));
  SET @Sql = REPLACE(@Sql, '#partition_scheme_data#', meta.PartitionSchemeData(@EntityId));
  SET @Sql = REPLACE(@Sql, '#partition_scheme_index#', meta.PartitionSchemeIndex(@EntityId));
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', meta.FileGroupIndex());
  SET @Sql = REPLACE(@Sql, '#date_range_start#', meta.DateRangeStart());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END