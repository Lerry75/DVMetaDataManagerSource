CREATE PROCEDURE [meta].[DeployDatabases]
  @PrintOnly bit = 0

AS

BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for on-premises instances only
  IF dbo.SqlInstanceOnPrem() = 0
    RETURN;

  DECLARE 
    @Template nvarchar(MAX) = (SELECT meta.TemplateText('Databases'))
	  ,@Sql NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  -- Replace Placeholders
  SET @Sql = REPLACE(@Template, '#staging_db#', meta.StagingDbName());
  SET @Sql = REPLACE(@Sql, '#edw_db#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#staging_db_no_brackets#', REPLACE(REPLACE(meta.StagingDbName(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#edw_db_no_brackets#', REPLACE(REPLACE(meta.WarehouseDbName(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#physical_filename_staging#', dbo.PhysicalFileName(meta.StagingDbName(), ''));
  SET @Sql = REPLACE(@Sql, '#physical_filename_staging_log#', dbo.PhysicalFileNameLog(meta.StagingDbName(), 'log'));
  SET @Sql = REPLACE(@Sql, '#physical_filename_edw#', dbo.PhysicalFileName(meta.WarehouseDbName(), ''));
  SET @Sql = REPLACE(@Sql, '#physical_filename_edw_log#', dbo.PhysicalFileNameLog(meta.WarehouseDbName(), 'log'));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);

  SET @Database = '[master]';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END
