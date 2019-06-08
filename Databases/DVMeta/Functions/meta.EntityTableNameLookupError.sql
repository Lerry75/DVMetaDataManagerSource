CREATE FUNCTION [meta].[EntityTableNameLookupError]
(
	@HubLnk int
  ,@UsedBy int
  ,@HashKeySuffix varchar(50)
)
RETURNS varchar(255)
AS
BEGIN
	RETURN (SELECT CONCAT(meta.WarehouseErrorSchema(), '.[', meta.EntityTypeId(@UsedBy), '_', meta.EntityNameLookupError(@UsedBy), CASE meta.EntityTypeId(@UsedBy) WHEN 'Lnk' THEN CONCAT('_', meta.EntityName(@HubLnk), @HashKeySuffix) END, ']'));
END
