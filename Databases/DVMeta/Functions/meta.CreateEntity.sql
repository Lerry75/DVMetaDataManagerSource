CREATE FUNCTION [meta].[CreateEntity]
(
	@EntityId int
)
RETURNS BIT
AS
BEGIN
	RETURN (SELECT CreateEntity FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
