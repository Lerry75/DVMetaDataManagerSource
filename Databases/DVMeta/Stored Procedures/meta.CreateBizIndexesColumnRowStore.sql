CREATE PROCEDURE [meta].[CreateBizIndexesColumnRowStore]
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

  -- Applies to SQL Server 2016 and above
  IF dbo.SqlInstanceMajorVersion() < 13
  BEGIN
    RAISERROR('Current SQL Server version does not support column store and b-tree indexes on the same table.', 16, 1);
	  RETURN;
  END

  DECLARE @Sql NVARCHAR(MAX) = ''
	  ,@NCI NVARCHAR(MAX) = ''
    ,@Database NVARCHAR(50);

  -- ColumnStore and RowStore
  IF meta.StorageTypeId(@EntityId) = 'CR'
  BEGIN
    DECLARE 
      @TemplatePit NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesColumnRowStore_pit'))
      ,@TemplateBr NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesColumnRowStore_bridge'))
      ,@TemplateAdditional NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesColumnRowStore_common'))
      ,@ReferencedEntityId INT
      ,@IndexOptions NVARCHAR(max);

    SELECT @ReferencedEntityId = HubLnk
    FROM meta.EDWEntityRelationship
    WHERE UsedBy = @EntityId;

    -- Objects for PIT
    IF meta.EntityTypeId(@EntityId) = 'Pit'
      SET @Sql += @TemplatePit;

  	-- Objects for BRIDGE
	  IF meta.EntityTypeId(@EntityId) = 'Br'
      SET @Sql += @TemplateBr;

	  -- Create specific non clustered index
	  IF meta.EntityTypeId(@EntityId) IN ('Pit')
	  BEGIN
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

    -- Check for index options
    IF meta.PartitioningTypeId(@EntityId) NOT IN ('N') AND dbo.SqlInstanceMajorVersion() > 11
	    SET @IndexOptions = meta.TemplateText('IndexOptionsRowStore_partitioned');
    ELSE
      SET @IndexOptions = meta.TemplateText('IndexOptionsRowStore_nonpartitioned');

  END

  -- Replace Placeholders
  SET @Sql = REPLACE(@Sql, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.[EntityTableName](@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#referenced_key_column#', meta.EntityKeyColumn(@ReferencedEntityId));
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupData() ELSE CONCAT(meta.PartitionSchemeData(@EntityId), '([SnapshotDate])') END);
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupIndex() ELSE CONCAT(meta.PartitionSchemeIndex(@EntityId), '([SnapshotDate])') END);
  SET @Sql = REPLACE(@Sql, '#default_hash_key#', meta.DefaultHashKey());
  SET @Sql = REPLACE(@Sql, '#index_options#', @IndexOptions);
  SET @Sql = REPLACE(@Sql, '#date_range_start#', meta.DateRangeStart());
  SET @Sql = REPLACE(@Sql, '#rowstore_compression#', meta.RowStoreCompressionLevel());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END