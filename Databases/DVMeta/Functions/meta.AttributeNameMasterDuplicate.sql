CREATE FUNCTION [meta].[AttributeNameMasterDuplicate]
(
	@AttributeId int,
  @IsMaster bit
)
RETURNS varchar(100)
AS
BEGIN
  DECLARE @AttributeName varchar(100) = (SELECT AttributeName FROM meta.EDWAttribute WHERE AttributeId = @AttributeId);

  IF @IsMaster = 1
    SET @AttributeName += '_Master';
  ELSE
    SET @AttributeName += '_Duplicate';

	RETURN @AttributeName;
END