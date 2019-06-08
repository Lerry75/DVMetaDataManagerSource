CREATE PROCEDURE [meta].[CreateEDWGhostRecordInsertProc]
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
    ,@TemplateColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('EDWGhostRecordInsertProc_column_names'), '''', ''''''))
	  ,@TemplateValues NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('EDWGhostRecordInsertProc_column_values'), '''', ''''''))
	  ,@Columns NVARCHAR(MAX)
	  ,@Values NVARCHAR(MAX)
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
        , '#object_name#', '[GhostRecordInsert_#entity_type#_#entity_name#]')
      , '#object_type#', 'PROCEDURE'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('EDWGhostRecordInsertProc'), '''', ''''''))

  SET @Columns = (
    SELECT REPLACE(@TemplateColumns, '#column_name#', AttributeName)
    FROM meta.EDWAttribute 
    WHERE EDWEntityId = @EntityId
      AND IsStagingOnly = 0
    ORDER BY [Order]
    FOR XML PATH('')
  )

  SET @Values = (
    SELECT REPLACE(@TemplateValues, '#column_value#',
      CASE 
	      WHEN DataTypeId IN (1, 2, 3, 4, 13, 14, 21, 22) THEN '0'
		    WHEN DataTypeId IN (15, 16, 17, 18) THEN '''''#date_range_start#'''''
		    WHEN DataTypeId IN (19) THEN '''''00:00:00'''''
		    ELSE '''''Unknown'''''
	    END)
    FROM meta.EDWAttribute
    WHERE EDWEntityId = @EntityId
      AND IsStagingOnly = 0
    ORDER BY [Order]
	  FOR XML PATH('')
  )

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
  SET @Sql = REPLACE(@Sql, '#column_names#', @Columns);
  SET @Sql = REPLACE(@Sql, '#column_values#', @Values);
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#load_end_date_column#', CASE WHEN meta.EntityTypeId(@EntityId) = 'Sat' THEN '  ,[LoadEndDate]' ELSE '' END);
  SET @Sql = REPLACE(@Sql, '#end_date_value#', CASE WHEN meta.EntityTypeId(@EntityId) = 'Sat' THEN '  ,''''#date_range_end#''''' ELSE '' END);
  SET @Sql = REPLACE(@Sql, '#hash_diff_column#', CASE WHEN meta.EntityTypeId(@EntityId) = 'Sat' THEN '  ,[HashDiff]' ELSE '' END);
  SET @Sql = REPLACE(@Sql, '#hash_diff_value#', CASE WHEN meta.EntityTypeId(@EntityId) = 'Sat' THEN '  ,CONVERT(#data_type_hash_key#, ''''#default_hash_key#'''')' ELSE '' END);
  SET @Sql = REPLACE(@Sql, '#data_type_hash_key#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#default_hash_key#', meta.DefaultHashKey());
  SET @Sql = REPLACE(@Sql, '#edw_schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#date_range_start#', meta.DateRangeStart());
  SET @Sql = REPLACE(@Sql, '#date_range_end#', meta.DateRangeEnd());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END