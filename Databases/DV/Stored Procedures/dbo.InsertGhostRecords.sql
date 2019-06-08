CREATE PROCEDURE [dbo].[InsertGhostRecords]
  @Force bit = 0

AS

SET NOCOUNT ON;

DECLARE 
  @TemplateInsert nvarchar(MAX) = '
EXEC #schema#.#ghost_insert_proc_name#;
'
  ,@TemplateDelete nvarchar(MAX) = '
EXEC #schema#.#ghost_delete_proc_name#;
'
  ,@Sql nvarchar(MAX);

SET @Sql = (
  SELECT REPLACE(REPLACE(@TemplateInsert, '#schema#', SCHEMA_NAME(schema_id)), '#ghost_insert_proc_name#', [name])
  FROM sys.objects
  WHERE [type] = 'P'
    AND [name] LIKE 'GhostRecordInsert%'
  ORDER BY [name]
  FOR XML PATH('')
)

IF @Force = 1
  SET @Sql = (
    SELECT REPLACE(REPLACE(@TemplateDelete, '#schema#', SCHEMA_NAME(schema_id)), '#ghost_delete_proc_name#', [name])
    FROM sys.objects
    WHERE [type] = 'P'
      AND [name] LIKE 'GhostRecordDelete%'
    ORDER BY [name] DESC
    FOR XML PATH('')
  )
	+ @Sql;

SET @Sql = REPLACE(@Sql, '&#x0D;', '');

IF (@Sql IS NOT NULL)
    EXEC sys.sp_executesql @Sql;