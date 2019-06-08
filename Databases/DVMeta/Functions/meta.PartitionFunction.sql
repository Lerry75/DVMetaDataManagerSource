CREATE FUNCTION [meta].[PartitionFunction]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT('[PFn_', EntityTypeId, '_', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
