CREATE FUNCTION [meta].[SqlDataType]
(
	@DataTypeId int
)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN (SELECT SqlDataType FROM meta.DataTypeMapping WHERE DataTypeId = @DataTypeId);
END
