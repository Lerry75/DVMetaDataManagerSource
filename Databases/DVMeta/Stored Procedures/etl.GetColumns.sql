CREATE PROCEDURE [etl].[GetColumns]
  @EntityId int
  ,@LookupOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @Columns AS TABLE(ColumnName varchar(255), ColumnNameBraket varchar(257), SqlDataType varchar(50), DataTypeSize int, Sort int, IsHashKey bit, ReferencedEntityId int, HashKeySuffix varchar(50));
  DECLARE @ReferencedEntityId int;
  
  IF meta.EntityTypeId(@EntityId) NOT IN ('Pit', 'Br')
  BEGIN
    IF @LookupOnly = 0
      INSERT INTO @Columns
      VALUES
        (REPLACE(REPLACE(meta.EntityKeyColumn(@EntityId), '[', ''), ']',''), meta.EntityKeyColumn(@EntityId), meta.SqlDataTypeHashKey(), meta.SqlDataTypeHashKeyLength(), 1, 1, @EntityId, '')
        ,('LoadDate', '[LoadDate]', 'datetime2', 7, 2, 0, 0, '')
        ,('RecordSource', '[RecordSource]', 'varchar(50)', 50, 4, 0, 0, '');
  END
  ELSE
  BEGIN
    SELECT @ReferencedEntityId = HubLnk
    FROM meta.EDWEntityRelationship
    WHERE UsedBy = @EntityId

    IF @LookupOnly = 0
      INSERT INTO @Columns
      VALUES
        (REPLACE(REPLACE(meta.EntityKeyColumn(@EntityId), '[', ''), ']',''), meta.EntityKeyColumn(@EntityId), meta.SqlDataTypeHashKey(), meta.SqlDataTypeHashKeyLength(), 1, 1, @EntityId, '')
        ,('SnapshotDateShort', '[SnapshotDateShort]', 'date', 3, 3, 0, 0, '');
        
    INSERT INTO @Columns
    VALUES
      (REPLACE(REPLACE(meta.EntityKeyColumn(@ReferencedEntityId), '[', ''), ']',''), meta.EntityKeyColumn(@ReferencedEntityId), meta.SqlDataTypeHashKey(), meta.SqlDataTypeHashKeyLength(), 2, 1, @ReferencedEntityId, '')
      ,('SnapshotDate', '[SnapshotDate]', 'datetime2', 7, 2, 0, 0, '');
  END

  -- LoadDateShort for TLnk, TSat and RSat
  IF @LookupOnly = 0
    IF meta.EntityTypeId(@EntityId) IN ('TSat', 'RSat')
      OR EXISTS (
          SELECT *
          FROM meta.EDWEntityRelationship
          WHERE HubLnk = @EntityId
            AND meta.EntityTypeId(UsedBy) = 'TSat'
        )
      INSERT INTO @Columns
      VALUES
        ('LoadDateShort', '[LoadDateShort]', 'date', 3, 3, 0, 0, '')

  IF meta.EntityTypeId(@EntityId) = 'Hub'
    INSERT INTO @Columns
    SELECT AttributeName
      ,'[' + AttributeName + ']'
      ,meta.SqlDataType(DataTypeId)
      ,ISNULL(meta.DataTypeSize(DataTypeId), 0)
      ,[Order] + 10
      ,0
      ,0
      ,''
    FROM meta.EDWAttribute
    WHERE EDWEntityId = @EntityId
      AND IsStagingOnly = 0
    ORDER BY [Order];

  IF meta.EntityTypeId(@EntityId) = 'Lnk'
    INSERT INTO @Columns
	  SELECT ColumnName
      ,ColumnNameBraket
      ,DataType
      ,DataTypeSize
      ,[Order]
      ,IsHashKey
      ,ReferencedEntityId
      ,HashKeySuffix
    FROM (
	    SELECT REPLACE(REPLACE(meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix)), '[', ''), ']','') ColumnName
        ,meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix)) ColumnNameBraket
		    ,meta.SqlDataTypeHashKey() DataType
        ,meta.SqlDataTypeHashKeyLength() DataTypeSize
        ,EntityRelationshipId + 10 [Order]
        ,1 IsHashKey
        ,HubLnk ReferencedEntityId
        ,meta.CleanSuffix(HashKeySuffix) HashKeySuffix
      FROM meta.EDWEntityRelationship
      WHERE UsedBy = @EntityId
   
      UNION ALL 

      SELECT AttributeName
        ,'[' + AttributeName + ']'
		    ,meta.SqlDataType(DataTypeId)
        ,ISNULL(meta.DataTypeSize(DataTypeId), 0)
        ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
        ,0
        ,0
        ,''
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
		    AND IsStagingOnly = 0
	  ) Z;

    IF meta.EntityTypeId(@EntityId) = 'SAL'
    INSERT INTO @Columns
	  SELECT ColumnName
      ,ColumnNameBraket
      ,DataType
      ,DataTypeSize
      ,[Order]
      ,IsHashKey
      ,ReferencedEntityId
      ,HashKeySuffix
    FROM (
	    SELECT REPLACE(REPLACE(meta.EntityKeyColumnMasterDuplicate(HubLnk, 1), '[', ''), ']','') ColumnName
        ,meta.EntityKeyColumnMasterDuplicate(HubLnk, 1) ColumnNameBraket
		    ,meta.SqlDataTypeHashKey() DataType
        ,meta.SqlDataTypeHashKeyLength() DataTypeSize
        ,EntityRelationshipId + 10 [Order]
        ,1 IsHashKey
        ,HubLnk ReferencedEntityId
        ,meta.CleanSuffix(HashKeySuffix) HashKeySuffix
      FROM meta.EDWEntityRelationship
      WHERE UsedBy = @EntityId
   
      UNION ALL 

	    SELECT REPLACE(REPLACE(meta.EntityKeyColumnMasterDuplicate(HubLnk, 0), '[', ''), ']','') ColumnName
        ,meta.EntityKeyColumnMasterDuplicate(HubLnk, 0) ColumnNameBraket
		    ,meta.SqlDataTypeHashKey() DataType
        ,meta.SqlDataTypeHashKeyLength() DataTypeSize
        ,EntityRelationshipId + 1000 [Order]
        ,1 IsHashKey
        ,HubLnk ReferencedEntityId
        ,meta.CleanSuffix(HashKeySuffix) HashKeySuffix
      FROM meta.EDWEntityRelationship
      WHERE UsedBy = @EntityId
	  ) Z;

  IF meta.EntityTypeId(@EntityId) = 'Sat'
    INSERT INTO @Columns
    VALUES
      ('HashDiff', '[HashDiff]', meta.SqlDataTypeHashKey(), meta.SqlDataTypeHashKeyLength(), 4, 1, 0, '');

  IF meta.EntityTypeId(@EntityId) IN ('Sat', 'TSat', 'RSat')
    IF @LookupOnly = 0
      INSERT INTO @Columns
      SELECT AttributeName
        ,'[' + AttributeName + ']'
        ,meta.SqlDataType(DataTypeId)
        ,ISNULL(meta.DataTypeSize(DataTypeId), 0)
        ,[Order] + 10
        ,0
        ,0
        ,''
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
	      AND IsStagingOnly = 0;
    ELSE
      INSERT INTO @Columns
      VALUES
        (REPLACE(REPLACE(meta.EntityKeyColumn(@EntityId), '[', ''), ']',''), meta.EntityKeyColumn(@EntityId), meta.SqlDataTypeHashKey(), meta.SqlDataTypeHashKeyLength(), 1, 1, meta.ParentEntityId(@EntityId), '');

  IF meta.EntityTypeId(@EntityId) IN ('Pit', 'Br')
    IF @LookupOnly = 0
    BEGIN
      INSERT INTO @Columns
      SELECT meta.EntityName(UsedBy) + '_' + REPLACE(REPLACE(meta.EntityKeyColumn(@ReferencedEntityId), '[', ''), ']', '')
        ,'[' + meta.EntityName(UsedBy) + '_' + REPLACE(REPLACE(meta.EntityKeyColumn(@ReferencedEntityId), '[', ''), ']', '') + ']'
        ,meta.SqlDataTypeHashKey()
        ,meta.SqlDataTypeHashKeyLength()
        ,EntityRelationshipId * 2 + 1000
        ,1
        ,@ReferencedEntityId
        ,''
      FROM meta.EDWEntityRelationship
      WHERE HubLnk = @ReferencedEntityId
      AND meta.EntityTypeId(UsedBy) = 'Sat'

      UNION ALL

      SELECT meta.EntityName(UsedBy) + '_' + 'LoadDate'
        ,'[' + meta.EntityName(UsedBy) + '_' + 'LoadDate]'
        ,'datetime2'
        ,7
        ,EntityRelationshipId * 2 + 1001
        ,0
        ,0
        ,''
      FROM meta.EDWEntityRelationship 
      WHERE HubLnk = @ReferencedEntityId
      AND meta.EntityTypeId(UsedBy) = 'Sat';

    END

  SELECT ColumnName
    ,ColumnNameBraket
    ,SqlDataType
    ,DataTypeSize
    ,IsHashKey
    ,ReferencedEntityId
    ,HashKeySuffix
  FROM @Columns
  ORDER BY Sort;

END