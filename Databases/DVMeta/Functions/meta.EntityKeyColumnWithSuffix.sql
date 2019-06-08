CREATE FUNCTION [meta].[EntityKeyColumnWithSuffix]
(
	@EntityId int,
  @Suffix varchar(50)
)
RETURNS varchar(255)
AS
BEGIN
	RETURN CONCAT('[', REPLACE(REPLACE(meta.EntityKeyColumn(@EntityId), '[', ''), ']', ''), @Suffix, ']');
END