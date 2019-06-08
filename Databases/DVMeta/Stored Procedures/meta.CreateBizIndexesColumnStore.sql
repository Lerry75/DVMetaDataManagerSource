CREATE PROCEDURE [meta].[CreateBizIndexesColumnStore]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Point In Time and Bridge
  IF meta.EntityTypeId(@EntityId) NOT IN ('Pit', 'Br')
    RETURN;

  DECLARE @Sql NVARCHAR(MAX) = ''
	  ,@NCI NVARCHAR(MAX) = ''
    ,@Database NVARCHAR(50);

  -- ColumnStore only
  IF meta.StorageTypeId(@EntityId) = 'Col'
  BEGIN
    DECLARE 
	    @Template NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesColumnStore_all'))
      ,@TemplateAdditional NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesColumnStore_common'))
      ,@ReferencedEntityId INT;

    SET @Sql += @Template;

    -- Create specific constraints (applies to SQL Server 2016 and above)
	  IF meta.EntityTypeId(@EntityId) IN ('Pit') AND dbo.SqlInstanceMajorVersion() >= 13
	  BEGIN
      SELECT @ReferencedEntityId = HubLnk
      FROM meta.EDWEntityRelationship
      WHERE UsedBy = @EntityId;

	    SET @NCI = (
	      SELECT REPLACE(REPLACE(REPLACE(REPLACE(@TemplateAdditional, '#referenced_entity_type#', meta.EntityTypeId(UsedBy)), '#referenced_entity_name#', meta.EntityName(UsedBy)), '#referenced_entity_table_name#', meta.[EntityTableName](UsedBy)), '#referenced_key_column#', REPLACE(REPLACE(meta.EntityKeyColumn(UsedBy), '[', ''), ']', ''))
		    FROM meta.EDWEntityRelationship
		    WHERE HubLnk = @ReferencedEntityId
		      AND meta.EntityTypeId(UsedBy) = 'Sat'
		    ORDER BY EntityRelationshipId
		    FOR XML PATH('')
	    );

	    SET @Sql += @NCI;
	  END
  END

  -- Replace Placeholders
  SET @Sql = REPLACE(@Sql, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.[EntityTableName](@EntityId));
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupData() ELSE CONCAT(meta.PartitionSchemeData(@EntityId), '([SnapshotDate])') END);
  SET @Sql = REPLACE(@Sql, '#default_hash_key#', meta.DefaultHashKey());
  SET @Sql = REPLACE(@Sql, '#date_range_start#', meta.DateRangeStart());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END