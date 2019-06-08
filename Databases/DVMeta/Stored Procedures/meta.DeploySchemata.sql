CREATE PROCEDURE [meta].[DeploySchemata]
  @PrintOnly bit = 0

AS

BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  DECLARE 
    @Template NVARCHAR(MAX) = (SELECT meta.TemplateText('Schemata'))
	  ,@Sql NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  -- Replace Placeholders
  SET @Sql = REPLACE(@Template, '#staging_db#', meta.StagingDbName());
  SET @Sql = REPLACE(@Sql, '#edw_db#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#staging_schema#', meta.StagingSchema());
  SET @Sql = REPLACE(@Sql, '#edw_schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#biz_schema#', meta.WarehouseBusinessSchema());
  SET @Sql = REPLACE(@Sql, '#error_schema#', meta.WarehouseErrorSchema());
  SET @Sql = REPLACE(@Sql, '#staging_schema_no_brackets#', REPLACE(REPLACE(meta.StagingSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#edw_schema_no_brackets#', REPLACE(REPLACE(meta.WarehouseRawSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#biz_schema_no_brackets#', REPLACE(REPLACE(meta.WarehouseBusinessSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#error_schema_no_brackets#', REPLACE(REPLACE(meta.WarehouseErrorSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);

  SET @Sql = REPLACE(@Template, '#schema#', meta.StagingSchema());
  SET @Sql = REPLACE(@Sql, '#schema_no_brackets#', REPLACE(REPLACE(meta.StagingSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  
  SET @Database = meta.StagingDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Template, '#schema#', meta.WarehouseRawSchema());
  SET @Sql = REPLACE(@Sql, '#schema_no_brackets#', REPLACE(REPLACE(meta.WarehouseRawSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  
  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Template, '#schema#', meta.WarehouseBusinessSchema());
  SET @Sql = REPLACE(@Sql, '#schema_no_brackets#', REPLACE(REPLACE(meta.WarehouseBusinessSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Template, '#schema#', meta.WarehouseErrorSchema());
  SET @Sql = REPLACE(@Sql, '#schema_no_brackets#', REPLACE(REPLACE(meta.WarehouseErrorSchema(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END
