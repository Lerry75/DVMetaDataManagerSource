CREATE FUNCTION [meta].[EntityName]
(
	@EntityId int
)
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT EntityName FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
