CREATE FUNCTION [meta].[EntityKeyColumn]
(
	@EntityId int
)
RETURNS varchar(255)
AS
BEGIN
  DECLARE @KeyColumn varchar(255);

	IF meta.EntityTypeId(@EntityId) IN ('Hub', 'Lnk')
	  SELECT @KeyColumn = CONCAT('[HK_', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId

	IF meta.EntityTypeId(@EntityId) IN ('Sat', 'TSat', 'RSat')
	  SELECT @KeyColumn = CONCAT('[HK_', meta.EntityName([HubLnk]), ']') FROM meta.EDWEntityRelationship WHERE UsedBy = @EntityId
	
	IF meta.EntityTypeId(@EntityId) IN ('Pit', 'Br')
	  SELECT @KeyColumn = CONCAT('[HK_', meta.EntityTypeId(@EntityId), '_', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId

  IF meta.EntityTypeId(@EntityId) IN ('SAL')
	  SELECT @KeyColumn = CONCAT('[HK_SAL_', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId

	RETURN @KeyColumn;
END