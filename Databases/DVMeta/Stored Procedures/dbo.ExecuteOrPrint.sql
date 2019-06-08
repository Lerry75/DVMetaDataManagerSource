CREATE PROCEDURE [dbo].[ExecuteOrPrint]
  @Database NVARCHAR(100),
	@Sql NVARCHAR(MAX),
	@PrintOnly BIT = 0

AS
BEGIN
  DECLARE @lf char(2) = char(13) + char(10)
	  ,@p int;

  IF dbo.SqlInstanceOnPrem() = 1 AND LTRIM(RTRIM(@Database)) != ''
    SET @Sql = CONCAT('USE ', @Database, ';', @lf, @Sql);

  IF (@PrintOnly = 1)
    WHILE @Sql <> ''
    BEGIN
      SET @p = PATINDEX('%' + @lf + '%', @sql);
      IF @p = 0
        SET @p = 4000;
          
	    PRINT LEFT(@Sql, @p - 1);
      SET @Sql = SUBSTRING(@Sql, @p + 2, 10000000);
    END
  ELSE
    IF NULLIF(LTRIM(@Sql), '') IS NULL
      RAISERROR('T-SQL statement is (null) or emtpy.', 16, 1);
    ELSE
      IF dbo.SqlInstanceOnPrem() = 1 OR LTRIM(RTRIM(@Database)) = ''
        EXEC sys.sp_executesql @Sql;
      ELSE
      BEGIN
        SET @Database = REPLACE(REPLACE(@Database, '[', ''), ']', '');
        EXEC sys.sp_execute_remote @Database, @Sql;
      END
END
