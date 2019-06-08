CREATE FUNCTION [meta].[FileGroupIndex] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN
    CASE
      WHEN dbo.SqlInstanceOnPrem() = 1
        THEN (SELECT CONCAT('[', [Value], ']') FROM meta.[Configuration] WHERE Id = 'FileGroupIndex')
        ELSE meta.FileGroupPrimary()
    END;
END