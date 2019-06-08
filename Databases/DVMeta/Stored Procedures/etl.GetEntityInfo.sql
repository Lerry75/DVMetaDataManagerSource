CREATE PROCEDURE [etl].[GetEntityInfo]
  @EntityId int,
  @ProcessId int

AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @ReferredEntityId int
    ,@ReferredEntityTypeId varchar(4)
    ,@ParentEntityId int;

  SELECT @ReferredEntityId = UsedBy
    ,@ReferredEntityTypeId = meta.EntityTypeId(UsedBy)
  FROM meta.EDWEntityRelationship EntRel
    JOIN meta.ProcessEntityRelationship ProcRel ON EntRel.UsedBy = ProcRel.EntityId
      AND ProcRel.ProcessId = @ProcessId
  WHERE HubLnk = @EntityId
    AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat');

  IF meta.EntityTypeId(@EntityId) IN ('Sat', 'TSat', 'RSat')
    SELECT @ParentEntityId = HubLnk
    FROM meta.EDWEntityRelationship EntRel
      JOIN meta.ProcessEntityRelationship ProcRel ON EntRel.HubLnk = ProcRel.EntityId
    WHERE UsedBy = @EntityId

  IF meta.EntityTypeId(@EntityId) = 'RSat'
    SELECT @ReferredEntityId = UsedBy
      ,@ReferredEntityTypeId = meta.EntityTypeId(UsedBy)
    FROM meta.EDWEntityRelationship EntRel
      JOIN meta.ProcessEntityRelationship ProcRel ON EntRel.UsedBy = ProcRel.EntityId
        AND ProcRel.ProcessId = @ProcessId
    WHERE HubLnk = @ParentEntityId
      AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat');

  IF @ReferredEntityId IS NULL
      SET @ReferredEntityId = @EntityId;

  SELECT meta.EntityName(@EntityId) EntityName
    ,meta.EntityTypeId(@EntityId) EntityType
    ,meta.EntityTableNameEDW(@EntityId, 1) EntityTableName
    ,meta.EntityName(@ReferredEntityId) EntityNameStaging
    ,CASE meta.EntityTypeId(@EntityId)
      WHEN 'Pit' THEN CONCAT(meta.WarehouseRawSchema(), '.[Get_', meta.EntityTypeId(@EntityId), '_', meta.EntityName(@EntityId), ']')
      ELSE meta.EntityViewNameStaging(@ReferredEntityId)
    END EntityViewNameStaging
    ,CASE 
      WHEN meta.EntityTypeId(@EntityId) = 'Lnk' AND @ReferredEntityTypeId = 'TSat'
      THEN CONVERT(BIT, 1)
      ELSE CONVERT(BIT, 0)
    END IsTLnk
    ,meta.CreateEntity(@EntityId) CreateEntity
    ,ISNULL(@ParentEntityId, -1) ParentEntityId;

END