CREATE FUNCTION [meta].[EntityKeyColumnMasterDuplicate]
(
	@EntityId int,
  @IsMaster bit
)
RETURNS varchar(255)
AS
BEGIN
  DECLARE @Suffix varchar(50);

  IF @IsMaster = 1
    SET @Suffix = '_Master';
  ELSE
    SET @Suffix = '_Duplicate';

	RETURN meta.EntityKeyColumnWithSuffix(@EntityId, @Suffix);
END