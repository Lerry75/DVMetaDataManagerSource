CREATE FUNCTION [meta].[PartitionSchemeIndex]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT('[PSch_', EntityTypeId, '_', EntityName, '_Index]') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
