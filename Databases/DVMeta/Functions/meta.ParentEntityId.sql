CREATE FUNCTION [meta].[ParentEntityId]
(
	@EntityId int
)
RETURNS int
AS
BEGIN
	RETURN (SELECT TOP 1 HubLnk FROM meta.EDWEntityRelationship WHERE UsedBy = @EntityId);
END
