CREATE PROCEDURE [meta].[CreateEDWIndexes]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- RowStore
  IF meta.StorageTypeId(@EntityId) = 'Row'
    EXEC meta.CreateEDWIndexesRowStore @EntityId, @PrintOnly

  -- ColumnStore
  IF meta.StorageTypeId(@EntityId) = 'Col'
    EXEC meta.CreateEDWIndexesColumnStore @EntityId, @PrintOnly

  -- ColumnStore and RowStore
  IF meta.StorageTypeId(@EntityId) = 'CR'
    EXEC meta.CreateEDWIndexesColumnRowStore @EntityId, @PrintOnly

END