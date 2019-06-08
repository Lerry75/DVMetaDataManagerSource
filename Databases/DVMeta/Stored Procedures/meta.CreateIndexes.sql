CREATE PROCEDURE [meta].[CreateIndexes]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- EDW Entities
  IF meta.EntityTypeId(@EntityId) IN ('Hub', 'Lnk', 'Sat', 'TSat', 'RSat', 'SAL')
    EXEC meta.CreateEDWIndexes @EntityId, @PrintOnly

  -- Business Entities
  IF meta.EntityTypeId(@EntityId) IN ('Pit', 'Br')
    EXEC meta.CreateBizIndexes @EntityId, @PrintOnly

  -- Lookup Error Entities
  IF meta.EntityTypeId(@EntityId) IN ('Lnk', 'Sat')
    EXEC meta.CreateLookupErrorIndexes @EntityId, @PrintOnly

END