CREATE FUNCTION [dbo].[PhysicalFileName] 
(
  @DbName VARCHAR(50)
  ,@LogicalFileName VARCHAR(60)
)
RETURNS VARCHAR(255)
AS
BEGIN
  DECLARE @InstanceDefaultDataPath VARCHAR(200) = CONVERT(VARCHAR(200), SERVERPROPERTY('InstanceDefaultDataPath'));

	RETURN 
    CASE 
      WHEN RIGHT(@InstanceDefaultDataPath, 1) = '\'
        THEN CONCAT(@InstanceDefaultDataPath, REPLACE(REPLACE(REPLACE(@DbName, '[', ''), ']', ''), '''', ''), '_', @LogicalFileName, '.mdf')
        ELSE CONCAT(@InstanceDefaultDataPath, '\', REPLACE(REPLACE(REPLACE(@DbName, '[', ''), ']', ''), '''', ''), '_', @LogicalFileName, '.mdf')
    END;
END