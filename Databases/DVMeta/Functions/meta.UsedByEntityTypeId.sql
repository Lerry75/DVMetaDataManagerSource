create FUNCTION [meta].[UsedByEntityTypeId]
(
  @EntityId int
)
RETURNS TABLE 
AS
RETURN 
(
  SELECT DISTINCT [meta].[EntityTypeId]([UsedBy]) AS UsedBy FROM [meta].[EDWEntityRelationship] WHERE [HubLnk] =  @EntityId
)