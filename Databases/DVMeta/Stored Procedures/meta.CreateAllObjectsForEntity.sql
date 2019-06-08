CREATE PROCEDURE [meta].[CreateAllObjectsForEntity]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Create Staging entities
  IF meta.EntityTypeId(@EntityId) IN ('Hub', 'Lnk', 'SAL')
  BEGIN
	  PRINT '-- ***   Creating staging table ***';
    EXEC meta.CreateStagingTable @EntityId, @PrintOnly;

	  PRINT '-- ***   Creating staging view ***';
    EXEC meta.CreateStagingView @EntityId, @PrintOnly;
  END
  
  IF meta.EntityTypeId(@EntityId) IN ('Sat', 'TSat')
  BEGIN
    DECLARE @ParentEntityId int = (SELECT meta.ParentEntityId(@EntityId));

	  PRINT '-- ***   Creating parent staging table ***';
	  EXEC meta.CreateStagingTable @ParentEntityId, @PrintOnly;

	  PRINT '-- ***   Creating parent staging view ***';
    EXEC meta.CreateStagingView @ParentEntityId, @PrintOnly;
  END

  -- Create EDW or Biz table partitioning
  PRINT '-- ***   Creating partitioning objects ***';
  EXEC meta.CreateTablePartitioning @EntityId, @PrintOnly;

  -- Create EDW, Biz, Error tables
  IF meta.CreateEntity(@EntityId) = 1
  BEGIN
    PRINT '-- ***   Creating edw table(s) ***';
    EXEC meta.CreateTable @EntityId, @PrintOnly;
  END
  ELSE
    PRINT '-- ***   Skipping edw table creation ***';

  -- Create EDW views
  IF meta.CreateEntity(@EntityId) = 1
  BEGIN
    PRINT '-- ***   Creating edw view(s) ***';
    EXEC meta.CreateEDWView @EntityId, @PrintOnly;
  END
  ELSE
    PRINT '-- ***   Skipping edw view creation ***';

  -- Create indexes and constraints for EDW or Biz table;
  IF meta.CreateEntity(@EntityId) = 1
  BEGIN
    PRINT '-- ***   Creating indexes ***';
    EXEC meta.CreateIndexes @EntityId, @PrintOnly;
  END
  ELSE
    PRINT '-- ***   Skipping indexes creation ***';

  -- Create EDW UpdateEndDate procedure
  PRINT '-- ***   Creating upload end date procedure ***';
  EXEC meta.CreateEDWUpdateLoadEndDateProc @EntityId, @PrintOnly;

  -- Create PIT extract procedure
  PRINT '-- ***   Creating point in time extract procedure ***';
  EXEC meta.CreateEDWGetPitProc @EntityId, @PrintOnly;

  -- Create EDW or Biz initialization procedure for partitioning
  PRINT '-- ***   Creating initialize entity procedure ***';
  EXEC meta.CreateInitializeEntityProc @EntityId, @PrintOnly;

  -- Create EDW or Biz finalization procedure for statistics management
  PRINT '-- ***   Creating finalize entity procedure ***';
  EXEC meta.CreateFinalizeEntityProc @EntityId, @PrintOnly;

  -- Insert edw ghost record
  PRINT '-- ***   Creating ghost records handling procedures ***';
  EXEC meta.CreateEDWGhostRecordInsertProc @EntityId, @PrintOnly;
  EXEC meta.CreateEDWGhostRecordDeleteProc @EntityId, @PrintOnly;
END
