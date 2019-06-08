CREATE PROCEDURE [meta].[CreateTable]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- EDW Entities
  IF meta.EntityTypeId(@EntityId) IN ('Hub', 'Lnk', 'Sat', 'TSat', 'RSat', 'SAL')
    EXEC meta.CreateEDWTable @EntityId, @PrintOnly;

  -- Business Entities
  IF meta.EntityTypeId(@EntityId) IN ('Pit')
    EXEC meta.CreateBizPitTable @EntityId, @PrintOnly;

  IF meta.EntityTypeId(@EntityId) IN ('Br')
    EXEC meta.CreateBizBrTable @EntityId, @PrintOnly;

  -- Lookup Error Entities
  IF meta.EntityTypeId(@EntityId) IN ('Lnk', 'Sat')
	  EXEC meta.CreateLookupErrorTable @EntityId, @PrintOnly;

END