CREATE FUNCTION [meta].[EntityViewName]
(
	@EntityId int
)
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CONCAT('v', EntityName) FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
