CREATE FUNCTION [meta].[EntityTableNameStaging]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT(meta.StagingSchema(), '.[', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
