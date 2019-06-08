CREATE FUNCTION [meta].[FileGroupData] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN
    CASE
      WHEN dbo.SqlInstanceOnPrem() = 1
        THEN (SELECT CONCAT('[', [Value], ']') FROM meta.[Configuration] WHERE Id = 'FileGroupData')
        ELSE meta.FileGroupPrimary()
    END;
END