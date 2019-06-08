CREATE FUNCTION [meta].[DataTypeSize]
(
	@DataTypeId int
)
RETURNS INT
AS
BEGIN
	RETURN (SELECT Size FROM meta.DataType WHERE DataTypeId = @DataTypeId);
END
