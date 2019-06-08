CREATE FUNCTION [meta].[HubLnkEntityTypeId]
(
	@EntityId int
)
RETURNS varchar(4)
AS
BEGIN
	RETURN (SELECT DISTINCT [meta].[EntityTypeId]([HubLnk]) FROM [meta].[EDWEntityRelationship] WHERE [HubLnk] =  @EntityId);
END


GO