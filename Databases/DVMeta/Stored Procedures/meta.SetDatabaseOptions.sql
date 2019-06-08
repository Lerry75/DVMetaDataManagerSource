CREATE PROCEDURE [meta].[SetDatabaseOptions]
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  DECLARE 
    @Template NVARCHAR(MAX) = (SELECT meta.TemplateText('DatabaseOptions'))
	  ,@Sql NVARCHAR(MAX)
    ,@Incremental NVARCHAR(50)
    ,@Database NVARCHAR(50);

  IF dbo.SqlInstanceMajorVersion() > 11
    SET @Incremental = '(INCREMENTAL = ON)';
  ELSE
    SET @Incremental = '';

  -- Replace Placeholders for Staging database
  SET @Sql = REPLACE(@Template, '#db_name#', meta.StagingDbName());
  SET @Sql = REPLACE(@Sql, '#incremental_statistics#', @Incremental);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = '[master]';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

  -- Replace Placeholders for EDW database
  SET @Sql = REPLACE(@Template, '#db_name#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#incremental_statistics#', @Incremental);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;
END
