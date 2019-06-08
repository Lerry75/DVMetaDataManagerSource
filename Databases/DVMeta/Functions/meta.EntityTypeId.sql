CREATE FUNCTION [meta].[EntityTypeId]
(
	@EntityId int
)
RETURNS varchar(4)
AS
BEGIN
	RETURN (SELECT EntityTypeId FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
