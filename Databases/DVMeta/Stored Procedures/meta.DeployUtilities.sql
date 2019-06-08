CREATE PROCEDURE [meta].[DeployUtilities]
  @PrintOnly bit = 0

AS

BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt NVARCHAR(MAX) = ''#body#'';
EXEC sys.sp_executesql @Stmt;

'
    ,@TemplateGhostRecordProcDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
	  ,@Sql NVARCHAR(MAX)
    ,@SqlDrop NVARCHAR(MAX)
    ,@TemplateGetHash NVARCHAR(MAX)
    ,@TemplateGhostRecordProc NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#db_name#')
          , '#schema#', '[dbo]')
        , '#object_name#', '[GetHash]')
      , '#object_type#', 'FUNCTION'
    );

  SET @TemplateGhostRecordProcDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateGhostRecordProcDrop
            , '#db_name#', '#db_name#')
          , '#schema#', '[dbo]')
        , '#object_name#', '[InsertGhostRecords]')
      , '#object_type#', 'PROCEDURE'
    );

  IF meta.LegacyNonUnicodeInputForHash() = 0
    SET @TemplateGetHash = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('Utilities_get_hash_actual'), '''', ''''''));
  ELSE
    SET @TemplateGetHash = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('Utilities_get_hash_legacy'), '''', ''''''));

  SET @TemplateGhostRecordProc = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('Utilities_insert_ghost_records'), '''', ''''''));

  -- Replace Placeholders for Staging database (GetHash)
  SET @SqlDrop = REPLACE(@TemplateDrop, '#db_name#', meta.StagingDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#printonly#', @PrintOnly);

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@SqlDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@TemplateGetHash, '#data_type_hash_key#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#hash_algorithm#', meta.HashAlgorithm());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  
  SET @Database = meta.StagingDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

  -- Replace Placeholders for EDW database (GetHash)
  SET @SqlDrop = REPLACE(@TemplateDrop, '#db_name#', meta.WarehouseDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#printonly#', @PrintOnly);

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@SqlDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@TemplateGetHash, '#data_type_hash_key#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#hash_algorithm#', meta.HashAlgorithm());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

  -- Replace Placeholders for EDW database (InsertGhostRecords)
  SET @SqlDrop = REPLACE(@TemplateGhostRecordProcDrop, '#db_name#', meta.WarehouseDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#printonly#', @PrintOnly);

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@SqlDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@TemplateGhostRecordProc, '#printonly#', @PrintOnly);

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;
END
