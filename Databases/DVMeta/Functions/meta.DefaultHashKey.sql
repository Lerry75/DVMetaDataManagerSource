CREATE FUNCTION [meta].[DefaultHashKey] ()
RETURNS VARCHAR(255)
AS
BEGIN
  RETURN (SELECT REPLICATE('0', meta.SqlDataTypeHashKeyLength()));
END
