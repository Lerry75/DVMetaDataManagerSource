CREATE FUNCTION [meta].[EntityViewNameStaging]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT(meta.StagingSchema(), '.[v', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
