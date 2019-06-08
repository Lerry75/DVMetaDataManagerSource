CREATE PROCEDURE [etl].[GetStagingTablesByProcess]
  @ProcessId int

AS
BEGIN
  SET NOCOUNT ON;

  SELECT
    StagingTableName = meta.EntityTableNameStaging(UsedBy) 
    ,EDWEntities = CONCAT(meta.EntityTableName(EntityId), ', ', meta.EntityTableName(UsedBy))
  FROM meta.ProcessEntityRelationship PER
    JOIN meta.EDWEntityRelationship ER ON PER.EntityId = ER.HubLnk
  WHERE ProcessId = @ProcessId
    AND meta.EntityTypeId(EntityId) in ('Hub', 'Lnk')
    AND meta.EntityTypeId(UsedBy) in ('Sat', 'TSat')

  UNION ALL

  SELECT 
    meta.EntityTableNameStaging(EntityId)
    ,meta.EntityTableName(EntityId)
  FROM meta.ProcessEntityRelationship PER
  WHERE ProcessId = @ProcessId
    AND meta.EntityTypeId(EntityId) in ('Hub', 'Lnk')
    AND NOT EXISTS (
      SELECT *
      FROM meta.EDWEntityRelationship ER
      WHERE PER.EntityId = ER.HubLnk
        AND meta.EntityTypeId(UsedBy) in ('Sat', 'TSat')
    )

  ORDER BY EDWEntities;

 END