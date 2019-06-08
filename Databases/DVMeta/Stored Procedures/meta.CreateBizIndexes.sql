CREATE PROCEDURE [meta].[CreateBizIndexes]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- RowStore
  IF meta.StorageTypeId(@EntityId) = 'Row'
    EXEC meta.CreateBizIndexesRowStore @EntityId, @PrintOnly

  -- ColumnStore
  IF meta.StorageTypeId(@EntityId) = 'Col'
    EXEC meta.CreateBizIndexesColumnStore @EntityId, @PrintOnly

  -- ColumnStore and RowStore
  IF meta.StorageTypeId(@EntityId) = 'CR'
    EXEC meta.CreateBizIndexesColumnRowStore @EntityId, @PrintOnly

END