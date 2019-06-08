CREATE PROCEDURE [meta].[CreateEDWIndexesColumnStore]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Hubs, Links, Satellite, Transaction Satellite, Same-As-Link
  IF meta.EntityTypeId(@EntityId) NOT IN ('Hub', 'Lnk', 'Sat', 'TSat', 'RSat', 'SAL')
    RETURN;

  DECLARE @Sql NVARCHAR(MAX) = ''
	  ,@FKs NVARCHAR(MAX) = ''
    ,@Database NVARCHAR(50);

  -- ColumnStore only
  IF meta.StorageTypeId(@EntityId) = 'Col'
  BEGIN
    DECLARE 
	    @Template NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnStore_all'))
      ,@TemplatePrimaryKey NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnStore_pk'))
      ,@TemplateForeignKey NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnStore_fk'))
      ,@TemplateCheck NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnStore_check'))
      ,@IndexOptions NVARCHAR(MAX);

    SET @Sql += @Template;

	  -- Applies to SQL Server 2016 and above
    IF dbo.SqlInstanceMajorVersion() >= 13
	  BEGIN
      -- Create Primary Key
      IF meta.EntityTypeId(@EntityId) IN ('Hub', 'Lnk', 'SAL')
        SET @Sql += @TemplatePrimaryKey;

	    -- Create Foreign Keys for Lnk, Sat, TSat, RSat
      IF meta.EntityTypeId(@EntityId) IN ('Lnk', 'Sat', 'TSat', 'RSat')
      BEGIN
	      SET @FKs = (
	        SELECT 
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        @TemplateForeignKey, '#referenced_entity_type#', meta.EntityTypeId(HubLnk)
                      ), '#referenced_entity_name#', meta.EntityName(HubLnk)
                    ), '#referenced_entity_table_name#', meta.EntityTableName(HubLnk)
                  ), '#referenced_key_column#', CASE meta.PartitioningTypeId(HubLnk) WHEN 'N' THEN meta.EntityKeyColumn(HubLnk) ELSE CONCAT(meta.EntityKeyColumn(HubLnk), ', [LoadDate]') END
                ), '#referencing_key_column#', CASE meta.PartitioningTypeId(HubLnk) WHEN 'N' THEN meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix)) ELSE CONCAT(meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix)), ', [LoadDate]') END
              ), '#column_suffix#', meta.CleanSuffix(HashKeySuffix)
            )
		      FROM meta.EDWEntityRelationship
		      WHERE UsedBy = @EntityId
		      ORDER BY EntityRelationshipId
		      FOR XML PATH('')
	      );

	      SET @Sql += @FKs;
      END

      -- Create Foreign Keys for SAL
	    IF meta.EntityTypeId(@EntityId) IN ('SAL')
	    BEGIN
	      SET @FKs = (
          SELECT CONCAT(Tmpl, '')
          FROM (
	          SELECT 
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        REPLACE(
                          @TemplateForeignKey, '#referenced_entity_type#', meta.EntityTypeId(HubLnk)
                        ), '#referenced_entity_name#', meta.EntityName(HubLnk)
                      ), '#referenced_entity_table_name#', meta.EntityTableName(HubLnk)
                    ), '#referenced_key_column#', CASE meta.PartitioningTypeId(HubLnk) WHEN 'N' THEN meta.EntityKeyColumn(HubLnk) ELSE CONCAT(meta.EntityKeyColumn(HubLnk), ', [LoadDate]') END
                  ), '#column_suffix#', '_Master'
                ), '#referencing_key_column#', CASE meta.PartitioningTypeId(HubLnk) WHEN 'N' THEN meta.EntityKeyColumnMasterDuplicate(HubLnk, 1) ELSE CONCAT(meta.EntityKeyColumnMasterDuplicate(HubLnk, 1), ', [LoadDate]') END
              ) Tmpl
		          ,0 [Order]
            FROM meta.EDWEntityRelationship
		        WHERE UsedBy = @EntityId

            UNION ALL

            SELECT 
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        REPLACE(
                          @TemplateForeignKey, '#referenced_entity_type#', meta.EntityTypeId(HubLnk)
                        ), '#referenced_entity_name#', meta.EntityName(HubLnk)
                      ), '#referenced_entity_table_name#', meta.[EntityTableName](HubLnk)
                    ), '#referenced_key_column#', CASE meta.PartitioningTypeId(HubLnk) WHEN 'N' THEN meta.EntityKeyColumn(HubLnk) ELSE CONCAT(meta.EntityKeyColumn(HubLnk), ', [LoadDate]') END
                  ), '#column_suffix#', '_Duplicate'
                ), '#referencing_key_column#', CASE meta.PartitioningTypeId(HubLnk) WHEN 'N' THEN meta.EntityKeyColumnMasterDuplicate(HubLnk, 0) ELSE CONCAT(meta.EntityKeyColumnMasterDuplicate(HubLnk, 0), ', [LoadDate]') END
              ) Tmpl
		          ,1 [Order]
            FROM meta.EDWEntityRelationship
		        WHERE UsedBy = @EntityId
          ) Z
          ORDER BY [Order]
		      FOR XML PATH('')
	      );

	      SET @Sql += @FKs;
	    END

      -- Check constraint for SATELLITE
      IF meta.EntityTypeId(@EntityId) IN ('Sat')
	      SET @Sql += @TemplateCheck;

      -- Check for index options
      IF meta.PartitioningTypeId(@EntityId) NOT IN ('N') AND dbo.SqlInstanceMajorVersion() > 11
	      SET @IndexOptions = meta.TemplateText('IndexOptionsRowStore_partitioned');
      ELSE
        SET @IndexOptions = meta.TemplateText('IndexOptionsRowStore_nonpartitioned');

    END

  END

  -- Replace Placeholders
  SET @Sql = REPLACE(@Sql, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityName(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.[EntityTableName](@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.EntityKeyColumn(@EntityId) ELSE CONCAT(meta.EntityKeyColumn(@EntityId), ' ASC, [LoadDate]') END);
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupData() ELSE CONCAT(meta.PartitionSchemeData(@EntityId), '([LoadDate])') END);
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', CASE meta.PartitioningTypeId(@EntityId) WHEN 'N' THEN meta.FileGroupIndex() ELSE CONCAT(meta.PartitionSchemeIndex(@EntityId), '([LoadDate])') END);
  SET @Sql = REPLACE(@Sql, '#index_options#', @IndexOptions);
  SET @Sql = REPLACE(@Sql, '#fk_check#', CASE meta.DisabledForeignKey() WHEN 1 THEN 'NOCHECK' ELSE 'CHECK' END);
  SET @Sql = REPLACE(@Sql, '#date_range_end#', meta.DateRangeEnd());
  SET @Sql = REPLACE(@Sql, '#rowstore_compression#', meta.RowStoreCompressionLevel());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&lt;', '<');
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END