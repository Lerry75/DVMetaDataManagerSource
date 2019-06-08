CREATE FUNCTION [meta].[PartitioningTypeId]
(
	@EntityId int
)
RETURNS char(1)
AS
BEGIN
	RETURN (SELECT PartitioningTypeId FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
