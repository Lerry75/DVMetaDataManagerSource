CREATE PROCEDURE [dbo].[DropObject]
  @Database varchar(100),
  @ObjectSchema varchar(100),
  @ObjectName varchar(200),
  @ObjectType varchar(100),
  @PrintOnly bit = 0

AS

SET NOCOUNT ON;

DECLARE @Sql nvarchar(MAX);

IF @ObjectType IN ('TABLE')
  SET @Sql = '
IF EXISTS
(
  SELECT * 
  FROM INFORMATION_SCHEMA.TABLES 
  WHERE TABLE_TYPE = ''BASE TABLE''
    AND TABLE_SCHEMA = ''#objectschema#''
    AND TABLE_NAME = ''#objectname#''
)
  DROP TABLE [#objectschema#].[#objectname#];
'

IF @ObjectType IN ('VIEW')
  SET @Sql = '
IF EXISTS
(
  SELECT *
  FROM INFORMATION_SCHEMA.TABLES 
  WHERE TABLE_TYPE = ''VIEW''
    AND TABLE_SCHEMA = ''#objectschema#''
    AND TABLE_NAME = ''#objectname#''
)
  DROP VIEW [#objectschema#].[#objectname#];
'

IF @ObjectType IN ('PROCEDURE', 'PROC', 'STORED PROCEDURE')
  SET @Sql = '
IF EXISTS
(
  SELECT * 
  FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE ROUTINE_TYPE = ''PROCEDURE''
    AND ROUTINE_SCHEMA = ''#objectschema#''
    AND ROUTINE_NAME = ''#objectname#''
)
  DROP PROCEDURE [#objectschema#].[#objectname#];
'

IF @ObjectType IN ('FUNCTION', 'FUNC')
  SET @Sql = '
IF EXISTS
(
  SELECT * 
  FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE ROUTINE_TYPE = ''FUNCTION''
    AND ROUTINE_SCHEMA = ''#objectschema#''
    AND ROUTINE_NAME = ''#objectname#''
)
  DROP FUNCTION [#objectschema#].[#objectname#];
'

IF @ObjectType IN ('PARTITION FUNCTION', 'PF')
  SET @Sql = '
IF EXISTS
(
  SELECT * 
  FROM sys.partition_functions 
  WHERE name = ''#objectname#''
)
  DROP PARTITION FUNCTION [#objectname#];
'

IF @ObjectType IN ('PARTITION SCHEME', 'PS')
  SET @Sql = '
IF EXISTS
(
  SELECT * 
  FROM sys.partition_schemes 
  WHERE name = ''#objectname#''
)
  DROP PARTITION SCHEME [#objectname#];
'

IF @Sql IS NOT NULL
BEGIN
  SET @Sql = REPLACE(@Sql, '#objectschema#', REPLACE(REPLACE(@ObjectSchema, '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#objectname#', REPLACE(REPLACE(@ObjectName, '[', ''), ']', ''));

  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;
END