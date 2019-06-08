CREATE FUNCTION [meta].[PartitionSchemeData]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT('[PSch_', EntityTypeId, '_', EntityName, '_Data]') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
