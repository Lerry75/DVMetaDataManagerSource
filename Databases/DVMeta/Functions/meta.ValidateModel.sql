CREATE FUNCTION [meta].[ValidateModel]()
RETURNS @BrokenRule TABLE
(
  [RuleId] int
  ,[RuleCategory] varchar(50)
  ,[RuleName] varchar(50)
  ,[Reason] varchar(255)
  ,[EntityId] int
  ,[EntityTypeName] varchar(50)
  ,[EntityName] varchar(50)
)
AS
BEGIN
  DECLARE @RuleId int
    ,@RuleCategory varchar(50)
    ,@RuleName varchar(50)
    ,@Reason varchar(255);

  -- Rule 1
  SET @RuleId = 1;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Not Related Entities';
  SET @Reason = 'Lnk, Sat, TSat, RSat, SAL, Pit, Br entities must have relationships defined.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity E
  WHERE meta.EntityTypeId(EntityId) NOT IN ('Hub')
    AND NOT EXISTS 
    (
      SELECT *
      FROM meta.EDWEntityRelationship ER
      WHERE E.EntityId = ER.UsedBy
    );

  -- Rule 2
  SET @RuleId = 2;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'meta.EDWEntityRelationship.HubLnk content';
  SET @Reason = 'Column HubLnk in meta.EDWEntityRelationship must contain Hub or Lnk enitities only.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,HubLnk
    ,meta.EntityTypeId(HubLnk)
    ,meta.EntityName(HubLnk)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(HubLnk) NOT IN ('Hub', 'Lnk');

  -- Rule 3
  SET @RuleId = 3;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'meta.EDWEntityRelationship.UsedBy content';
  SET @Reason = 'Column UsedBy in meta.EDWEntityRelationship must NOT contain Hub enitities.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(UsedBy)
    ,meta.EntityName(UsedBy)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(UsedBy) IN ('Hub');

  -- Rule 4
  SET @RuleId = 4;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Entity relationship check - Count';
  SET @Reason = 'Sat, TSat, RSat, SAL entities can only be related to one entity.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(UsedBy)
    ,meta.EntityName(UsedBy)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat', 'RSat', 'SAL')
  GROUP BY UsedBy
  HAVING COUNT(*) != 1;

  -- Rule 5
  SET @RuleId = 5;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Hub relationship check';
  SET @Reason = 'Hub entity can only be related to Lnk, Sat, TSat, SAL, Pit, Br.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(HubLnk)
    ,meta.EntityName(HubLnk)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(HubLnk) = 'Hub'
    AND meta.EntityTypeId(UsedBy) NOT IN ('Lnk', 'Sat', 'TSat', 'SAL', 'Pit', 'Br');

  -- Rule 6
  SET @RuleId = 6;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Link parent relationship check';
  SET @Reason = 'Link entity can only be parent for Sat, TSat, RSat, Pit, Br.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(HubLnk)
    ,meta.EntityName(HubLnk)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(HubLnk) = 'Lnk'
    AND meta.EntityTypeId(UsedBy) NOT IN ('Sat', 'TSat', 'RSat', 'Pit', 'Br');

  -- Rule 7
  SET @RuleId = 7;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Hub-Link relationship check';
  SET @Reason = 'Lnk entity in UsedBy column must have at least 2 records with a Hub in HubLnk column.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(UsedBy)
    ,meta.EntityName(UsedBy)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(HubLnk) = 'Hub'
    AND meta.EntityTypeId(UsedBy) = 'Lnk'
  GROUP BY UsedBy
  HAVING COUNT(*) < 2;

  -- Rule 8
  SET @RuleId = 8;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Hub, Sat, TSat attribute check';
  SET @Reason = 'Hub, Sat, TSat entities must contain at least 1 attribute.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity E
  WHERE meta.EntityTypeId(EntityId) IN ('Hub', 'Sat', 'TSat')
    AND NOT EXISTS 
    (
      SELECT *
	    FROM meta.EDWAttribute A 
	    WHERE E.EntityId = A.EDWEntityId
    );

  -- Rule 9
  SET @RuleId = 9;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'RSat, SAL, Pit attribute check';
  SET @Reason = 'RSat, SAL, Pit entities must NOT contain any attribute.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity E
  WHERE meta.EntityTypeId(EntityId) IN ('RSat', 'SAL', 'Pit')
    AND EXISTS 
    (
      SELECT *
	    FROM meta.EDWAttribute A 
	    WHERE E.EntityId = A.EDWEntityId
    );

  -- Rule 10
  SET @RuleId = 10;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Satellite relationship check';
  SET @Reason = 'Sat, TSat, RSat entities can only be related to either Hub or Lnk.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(UsedBy)
    ,meta.EntityName(UsedBy)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat', 'RSat')
    AND meta.EntityTypeId(HubLnk) NOT IN ('Hub', 'Lnk');

  -- Rule 11
  SET @RuleId = 11;
  SET @RuleCategory = 'Model';
  SET @RuleName = 'Same-As-Link relationship check';
  SET @Reason = 'SAL entity can only be related to a Hub.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,UsedBy
    ,meta.EntityTypeId(UsedBy)
    ,meta.EntityName(UsedBy)
  FROM meta.EDWEntityRelationship 
  WHERE meta.EntityTypeId(UsedBy) = 'SAL'
    AND meta.EntityTypeId(HubLnk) NOT IN ('Hub');

  -- Rule 101
  SET @RuleId = 101;
  SET @RuleCategory = 'Platform';
  SET @RuleName = 'Max number of attributes exceeded';
  SET @Reason = 'Sat entity can NOT have more than 250 attributes.';

  INSERT INTO @BrokenRule
  SELECT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EDWEntityId
    ,meta.EntityTypeId(EDWEntityId)
    ,meta.EntityName(EDWEntityId)
  FROM meta.EDWAttribute
  WHERE meta.EntityTypeId(EDWEntityId) = 'Sat'
    AND IsStagingOnly = 0
  GROUP BY EDWEntityId
  HAVING COUNT(*) > 250;

  -- Rule 102
  SET @RuleId = 102;
  SET @RuleCategory = 'Platform';
  SET @RuleName = 'Partitoning check';
  SET @Reason = 'Partitioning is applicable to Lnk, Sat, TSat, RSat, Br, Pit entities only.';

  INSERT INTO @BrokenRule
  SELECT DISTINCT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity
  WHERE PartitioningTypeId NOT IN ('N')
    AND meta.EntityTypeId(EntityId) NOT IN ('Lnk', 'Sat', 'TSat', 'RSat', 'Br', 'Pit')
    AND CreateEntity = 1;

  -- Rule 103
  SET @RuleId = 103;
  SET @RuleCategory = 'Platform';
  SET @RuleName = 'Partitioning on RowStore not supported';
  SET @Reason = 'Partitioning is supported for ''ColumnStore'' and ''ColumnStore + RowStore'' storage types only.';

  INSERT INTO @BrokenRule
  SELECT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity
  WHERE PartitioningTypeId NOT IN ('N')
    AND StorageTypeId NOT IN ('Col')
    AND CreateEntity = 1;

  -- Rule 104
  SET @RuleId = 104;
  SET @RuleCategory = 'Platform';
  SET @RuleName = 'ColumnStore storage not supported';
  SET @Reason = '(Clustered) ColumnStore storage is not supported on current SQL Server version.';

  INSERT INTO @BrokenRule
  SELECT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity
  WHERE StorageTypeId IN ('Col')
    AND dbo.SqlInstanceMajorVersion() <= 11;

  -- Rule 105
  SET @RuleId = 105;
  SET @RuleCategory = 'Platform';
  SET @RuleName = 'ColumnStore + RowStore storage not supported';
  SET @Reason = 'ColumnStore + RowStore storage is not supported on current SQL Server version.';

  INSERT INTO @BrokenRule
  SELECT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,EntityId
    ,meta.EntityTypeId(EntityId)
    ,meta.EntityName(EntityId)
  FROM meta.EDWEntity
  WHERE StorageTypeId IN ('CR')
    AND dbo.SqlInstanceMajorVersion() <= 12;

  RETURN;
END
