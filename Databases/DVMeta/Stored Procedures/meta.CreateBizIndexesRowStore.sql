CREATE PROCEDURE [meta].[CreateBizIndexesRowStore]
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

  -- RowStore only
  IF meta.StorageTypeId(@EntityId) = 'Row'
  BEGIN
    DECLARE 
      @TemplatePit NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesRowStore_pit'))
      ,@TemplateBr NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesRowStore_bridge'))
      ,@TemplateAdditional NVARCHAR(MAX) = (SELECT meta.TemplateText('BizIndexesRowStore_common'))
      ,@ReferencedEntityId INT
      ,@KeyColumns NVARCHAR(MAX)
      ,@IndexOptions NVARCHAR(max);

	  -- Objects for PIT
	  IF meta.EntityTypeId(@EntityId) IN ('Pit')
	  BEGIN
      SET @Sql += @TemplatePit;

      SELECT @ReferencedEntityId = HubLnk
      FROM meta.EDWEntityRelationship
      WHERE UsedBy = @EntityId;

      -- Create specific non clustered index
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

	  -- Objects for BRIDGE
	  IF meta.EntityTypeId(@EntityId) IN ('Br')
    BEGIN
      SET @Sql += @TemplateBr;

      SET @KeyColumns = (
        SELECT CONCAT(meta.EntityKeyColumn(HubLnk), ' ASC, ')
        FROM meta.EDWEntityRelationship 
        WHERE UsedBy = @EntityId
        ORDER BY EntityRelationshipId
        FOR XML PATH('')
      );

      SET @Sql = REPLACE(@Sql, '#key_columns#', @KeyColumns);
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