CREATE FUNCTION [dbo].[NewLogicalFileName] 
(
  @FileGroupName VARCHAR(50)
)
RETURNS VARCHAR(60)
AS
BEGIN
	RETURN CONCAT(REPLACE(REPLACE(REPLACE(@FileGroupName, '[', ''), ']', ''), '''', ''), '_', CONVERT(INT, (SELECT Rnd FROM [dbo].[Rand]) * 100000));
END