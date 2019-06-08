CREATE PROCEDURE [meta].[CreateEDWIndexesColumnRowStore]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Hubs, Links, Satellite, Transaction Satellite, Record Tracking Satellite, Same-As-Link
  IF meta.EntityTypeId(@EntityId) NOT IN ('Hub', 'Lnk', 'Sat', 'TSat', 'RSat', 'SAL')
    RETURN;

  -- Applies to SQL Server 2016 and above
  IF dbo.SqlInstanceMajorVersion() < 13
  BEGIN
    RAISERROR('Current SQL Server version does not support column store and b-tree indexes on the same table.', 16, 1);
	  RETURN;
  END

  DECLARE @Sql NVARCHAR(MAX) = ''
    ,@Columns NVARCHAR(MAX) = ''
	  ,@FKs NVARCHAR(MAX) = ''
    ,@Database NVARCHAR(50);

  -- ColumnStore and RowStore
  IF meta.StorageTypeId(@EntityId) = 'CR'
  BEGIN
    DECLARE 
      @TemplateHubLnk NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnRowStore_hub_link'))
      ,@TemplateSat NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnRowStore_sat'))
      ,@TemplateTSat NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnRowStore_tsat'))
      ,@TemplateForeignKey NVARCHAR(MAX) = (SELECT meta.TemplateText('EDWIndexesColumnRowStore_fk'))
      ,@IndexOptions NVARCHAR(MAX);

    -- Objects for HUB
    IF meta.EntityTypeId(@EntityId) = 'Hub'
    BEGIN
      SET @Sql += @TemplateHubLnk;

	    SET @Columns = (
	      SELECT CONCAT('[', AttributeName, '],')
        FROM meta.EDWAttribute 
        WHERE EDWEntityId = @EntityId
		    ORDER BY [Order]
		    FOR XML PATH('')
	    );

	    IF LEN(@Columns) > 0
	      SET @Columns = LEFT(@Columns, LEN(@Columns) - 1);
    END
  
    -- Objects for LINK
    IF meta.EntityTypeId(@EntityId) = 'Lnk'
    BEGIN
	    SET @Sql += @TemplateHubLnk;
    
	    SET @Columns = (
	      SELECT CONCAT('[', ColumnName, '],')
        FROM (
	        SELECT 
            REPLACE(
              REPLACE(
                meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix)), '[', ''
              ), ']',''
            ) ColumnName
            ,EntityRelationshipId [Order]
          FROM meta.EDWEntityRelationship
          WHERE UsedBy = @EntityId
   
          UNION ALL 

          SELECT A.AttributeName
            ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
          FROM meta.EDWAttribute A
          WHERE EDWEntityId = @EntityId
	      ) Z
	      ORDER BY [Order]
        FOR XML PATH('')
	    );

	    IF LEN(@Columns) > 0
	      SET @Columns = LEFT(@Columns, LEN(@Columns) - 1);

    END

    -- Objects for SAME-AS-LINK
    IF meta.EntityTypeId(@EntityId) = 'SAL'
    BEGIN
	    SET @Sql += @TemplateHubLnk;
    
	    SET @Columns = (
	      SELECT CONCAT(ColumnName, ',')
        FROM (
	        SELECT meta.EntityKeyColumnMasterDuplicate(HubLnk, 1) ColumnName
            ,0 [Order]
          FROM meta.EDWEntityRelationship
          WHERE UsedBy = @EntityId
   
          UNION ALL 

          SELECT meta.EntityKeyColumnMasterDuplicate(HubLnk, 0) ColumnName
            ,1 [Order]
          FROM meta.EDWEntityRelationship
          WHERE UsedBy = @EntityId
	      ) Z
	      ORDER BY [Order]
        FOR XML PATH('')
	    );

	    IF LEN(@Columns) > 0
	      SET @Columns = LEFT(@Columns, LEN(@Columns) - 1);

    END

	  -- Objects for SATELLITE
    IF meta.EntityTypeId(@EntityId) = 'Sat'
      SET @Sql += @TemplateSat;

	  -- Objects for Transaction and Record Tracking SATELLITE
	  IF meta.EntityTypeId(@EntityId) IN ('TSat', 'RSat')
      SET @Sql += @TemplateTSat;

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
                    ), '#referenced_entity_table_name#', meta.EntityTableName(HubLnk)
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
  SET @Sql = REPLACE(@Sql, '#column_names#', @Columns);
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