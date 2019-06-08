CREATE FUNCTION [meta].[StorageTypeId]
(
	@EntityId int
)
RETURNS varchar(3)
AS
BEGIN
	RETURN (SELECT StorageTypeId FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
