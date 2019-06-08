CREATE FUNCTION [meta].[EntityId]
(
	@EntityName varchar(50),
	@EntityType varchar(4)
)
RETURNS INT
AS
BEGIN
	RETURN (SELECT EntityId FROM meta.EDWEntity WHERE EntityName = @EntityName AND EntityTypeId = @EntityType);
END
