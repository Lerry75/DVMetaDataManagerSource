CREATE FUNCTION [meta].[EntityTableNameEDW]
(
	@EntityId int
  ,@OverrideWithViewName bit
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT(CASE WHEN meta.EntityTypeId(@EntityId) IN ('Pit', 'Br') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END, '.[', IIF(@OverrideWithViewName = 0, CASE WHEN meta.EntityTypeId(@EntityId) IN ('Sat') THEN 'tbl_' ELSE '' END, ''), EntityTypeId, '_', EntityName, ']') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
