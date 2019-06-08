CREATE FUNCTION [meta].[EntityTableName]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN meta.EntityTableNameEDW(@EntityId, 0);
END
