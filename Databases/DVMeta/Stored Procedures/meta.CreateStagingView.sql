CREATE PROCEDURE [meta].[CreateStagingView]
  @EntityId int,
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for Hubs, Links, Same-As-Link
  IF meta.EntityTypeId(@EntityId) NOT IN ('Hub', 'Lnk', 'SAL')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt_#id# nvarchar(MAX) = ''#body#'';
EXEC sys.sp_executesql @Stmt_#id#;
'
	  ,@TemplateColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('StagingView_column_names'), '''', ''''''))
	  ,@TemplateHashColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('StagingView_hash_columns'), '''', ''''''))
	  ,@TemplateHash NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('StagingView_key_columns'), '''', ''''''))
	  ,@SqlDrop NVARCHAR(MAX)
    ,@Sql NVARCHAR(MAX)
	  ,@KeyColumns NVARCHAR(MAX)
	  ,@HashKeyColumns NVARCHAR(MAX)
	  ,@Columns NVARCHAR(MAX)
	  ,@ColumnsHashDiff NVARCHAR(MAX)
	  ,@HashDiff NVARCHAR(MAX)
	  ,@ForeignHashKeys NVARCHAR(MAX) = ''
    ,@HubId INT
    ,@HashKeySuffix VARCHAR(50)
    ,@TempHashKeys NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#staging_db#')
          , '#schema#', '#staging_schema#')
        , '#object_name#', '[#sat_entity_name#]')
      , '#object_type#', 'VIEW'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('StagingView'), '''', ''''''))
  SET @Template = REPLACE(@Template, '#column_names#', '#column_names_#id##')
  SET @Template = REPLACE(@Template, '#hash_diff_column#', '#hash_diff_column_#id##')

  -- Search for key columns and hash key in Hub
  IF meta.EntityTypeId(@EntityId) = 'Hub'
  BEGIN
    SET @KeyColumns = (
      SELECT REPLACE(@TemplateColumns, '#column_name#', AttributeName)
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
      ORDER BY [Order]
      FOR XML PATH('')
    );

	  SET @HashKeyColumns = (
      SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(AttributeName, DataTypeId), '''', ''''''))
      FROM meta.EDWAttribute
      WHERE EDWEntityId = @EntityId
      ORDER BY [Order]
      FOR XML PATH('')
    );
  END
  
  -- Search for key columns and hash key in Lnk
  IF meta.EntityTypeId(@EntityId) = 'Lnk'
  BEGIN
    SET @KeyColumns = (
	    SELECT REPLACE(@TemplateColumns, '#column_name#', AttributeName)
      FROM (
	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', A.AttributeName, meta.CleanSuffix(ER.HashKeySuffix)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
   
        UNION ALL 

        SELECT A.AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
        FROM meta.EDWAttribute A
        WHERE EDWEntityId = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

	  SET @HashKeyColumns = (
	    SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(AttributeName, DataTypeId), '''', ''''''))
      FROM (
	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', A.AttributeName, meta.CleanSuffix(ER.HashKeySuffix)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
   
        UNION ALL 

        SELECT A.AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY [Order]) + 1000
        FROM meta.EDWAttribute A
        WHERE EDWEntityId = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

	  -- Replace foreign Hask Keys for Links
	  DECLARE ent CURSOR FOR 
	    SELECT HubLnk
        ,HashKeySuffix
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId;
	  OPEN ent;
	  FETCH NEXT FROM ent INTO @HubId, @HashKeySuffix;
	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	    SET @TempHashKeys = (
	      SELECT REPLACE(@TemplateHashColumns, '#column_name#',  REPLACE(meta.ColumnForHash(CONCAT(meta.EntityName(@HubId), '_', AttributeName, meta.CleanSuffix(@HashKeySuffix)), DataTypeId), '''', ''''''))
        FROM meta.EDWAttribute
        WHERE EDWEntityId = @HubId
          AND IsStagingOnly = 0
        ORDER BY [Order]
		    FOR XML PATH('')
	    )

	    SET @ForeignHashKeys += REPLACE(REPLACE(@TemplateHash, '#key_column#', meta.EntityKeyColumnWithSuffix(@HubId, meta.CleanSuffix(@HashKeySuffix))), '#hash_columns#', @TempHashKeys) + CHAR(13) + CHAR(10);
	  
	    FETCH NEXT FROM ent INTO @HubId, @HashKeySuffix;
	  END
	  CLOSE ent;
	  DEALLOCATE ent;
  END

  -- Search for key columns and hash key in SAL
  IF meta.EntityTypeId(@EntityId) = 'SAL'
  BEGIN
    SET @KeyColumns = (
	    SELECT REPLACE(@TemplateColumns, '#column_name#', AttributeName)
      FROM (
	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', meta.AttributeNameMasterDuplicate(A.AttributeId, 1)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
   
        UNION ALL 

	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', meta.AttributeNameMasterDuplicate(A.AttributeId, 0)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) + 1000 [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

	  SET @HashKeyColumns = (
	    SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(AttributeName, DataTypeId), '''', ''''''))
      FROM (
	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', meta.AttributeNameMasterDuplicate(A.AttributeId, 1)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
   
        UNION ALL 

	      SELECT CONCAT(meta.EntityName(A.EDWEntityId), '_', meta.AttributeNameMasterDuplicate(A.AttributeId, 0)) AttributeName
		      ,A.DataTypeId
          ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) + 1000 [Order]
        FROM meta.EDWEntityRelationship ER
          JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId
	    ) Z
	    ORDER BY [Order]
      FOR XML PATH('')
	  );

	  -- Replace foreign Hask Keys for Links
	  DECLARE ent CURSOR FOR 
	    SELECT HubLnk
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId;
	  OPEN ent;
	  FETCH NEXT FROM ent INTO @HubId;
	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	    SET @TempHashKeys = (
	      SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(CONCAT(meta.EntityName(@HubId), '_', meta.AttributeNameMasterDuplicate(AttributeId, 1)), DatatypeId), '''', ''''''))
        FROM meta.EDWAttribute
        WHERE EDWEntityId = @HubId
          AND IsStagingOnly = 0
        ORDER BY [Order]
		    FOR XML PATH('')
	    )

	    SET @ForeignHashKeys = @ForeignHashKeys + REPLACE(REPLACE(@TemplateHash, '#key_column#', meta.EntityKeyColumnMasterDuplicate(@HubId, 1)), '#hash_columns#', @TempHashKeys) + CHAR(13) + CHAR(10);

      SET @TempHashKeys = (
	      SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(CONCAT(meta.EntityName(@HubId), '_', meta.AttributeNameMasterDuplicate(AttributeId, 0)), DataTypeId), '''', ''''''))
        FROM meta.EDWAttribute
        WHERE EDWEntityId = @HubId
          AND IsStagingOnly = 0
        ORDER BY [Order]
		    FOR XML PATH('')
	    )

	    SET @ForeignHashKeys = @ForeignHashKeys + REPLACE(REPLACE(@TemplateHash, '#key_column#', meta.EntityKeyColumnMasterDuplicate(@HubId, 0)), '#hash_columns#', @TempHashKeys) + CHAR(13) + CHAR(10);
	  
	    FETCH NEXT FROM ent INTO @HubId;
	  END
	  CLOSE ent;
	  DEALLOCATE ent;
  END

  -- Search for Satellite columns
  IF EXISTS (
    SELECT *
	  FROM meta.EDWEntityRelationship
	  WHERE [HubLnk] = @EntityId
	    AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat')
  )
  BEGIN
    SET @SqlDrop = (
      SELECT REPLACE(@TemplateDrop, '#sat_entity_name#', meta.EntityViewName(UsedBy))
      FROM meta.EDWEntityRelationship 
      WHERE [HubLnk] = @EntityId
	      AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat')
      FOR XML PATH('')
    );

    SET @Sql = (
      SELECT REPLACE(REPLACE(REPLACE(@Template, '#entity_view_name#', meta.EntityViewNameStaging(UsedBy)), '#entity_table_name#', meta.EntityTableNameStaging(UsedBy)), '#id#', UsedBy)
      FROM meta.EDWEntityRelationship 
      WHERE [HubLnk] = @EntityId
	      AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat')
      FOR XML PATH('')
    );

	  -- Replace columns
	  DECLARE @SatEntityId int;
	  DECLARE cols CURSOR FOR 
	    SELECT UsedBy
	    FROM meta.EDWEntityRelationship 
      WHERE [HubLnk] = @EntityId
	      AND meta.EntityTypeId(UsedBy) IN ('Sat', 'TSat');
	  OPEN cols;
	  FETCH NEXT FROM cols INTO @SatEntityId;
	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	    SET @Columns = (
        SELECT REPLACE(@TemplateColumns, '#column_name#', AttributeName)
        FROM meta.EDWAttribute
        WHERE EDWEntityId = @SatEntityId
        ORDER BY [Order]
        FOR XML PATH('')
      );

	    SET @Sql = REPLACE(@Sql, replace('#column_names_#id##', '#id#', @SatEntityId), @Columns);

	    -- Replace HashDiff
	    IF meta.EntityTypeId(@SatEntityId) = 'Sat'
	    BEGIN
	      SET @ColumnsHashDiff = (
          SELECT REPLACE(@TemplateHashColumns, '#column_name#', REPLACE(meta.ColumnForHash(AttributeName, DataTypeId), '''', ''''''))
          FROM meta.EDWAttribute
          WHERE EDWEntityId = @SatEntityId
		        AND IsStagingOnly = 0
          ORDER BY [Order]
          FOR XML PATH('')
        );
	    
		    SET @HashDiff = REPLACE(REPLACE(@TemplateHash, '#key_column#', '[HashDiff]'), '#hash_columns#', @ColumnsHashDiff);
	    END
	    ELSE
	      SET @HashDiff = '';

	    SET @Sql = REPLACE(@Sql, replace('#hash_diff_column_#id##', '#id#', @SatEntityId), @HashDiff);

	    FETCH NEXT FROM cols INTO @SatEntityId;
	  END
	  CLOSE cols;
	  DEALLOCATE cols;
  END
  ELSE
  BEGIN
	  SET @SqlDrop = @TemplateDrop;
    SET @Sql = REPLACE(REPLACE(REPLACE(@Template, '#hash_diff_column_#id##', ''), '#column_names_#id##', ''), '#id#', @EntityId);
  END

  -- Replace Placeholders
  SET @SqlDrop = REPLACE(@SqlDrop, '#sat_entity_name#', meta.EntityViewName(@EntityId));
  SET @SqlDrop = REPLACE(@SqlDrop, '#meta_db#', meta.MetaDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#edw_db#', meta.WarehouseDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#staging_db#', meta.StagingDbName());
  SET @SqlDrop = REPLACE(@SqlDrop, '#entity_prefix#', CASE meta.EntityTypeId(@EntityId) WHEN 'Sat' THEN 'tbl_' ELSE '' END);
  SET @SqlDrop = REPLACE(@SqlDrop, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @SqlDrop = REPLACE(@SqlDrop, '#entity_name#', meta.EntityName(@EntityId));
  SET @SqlDrop = REPLACE(@SqlDrop, '#schema#', CASE WHEN meta.EntityTypeId(@EntityId) IN ('Pit', 'Br') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END);
  SET @SqlDrop = REPLACE(@SqlDrop, '#edw_schema#', meta.WarehouseRawSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#biz_schema#', meta.WarehouseBusinessSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#error_schema#', meta.WarehouseErrorSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#staging_schema#', meta.StagingSchema());
  SET @SqlDrop = REPLACE(@SqlDrop, '#printonly#', @PrintOnly);
  SET @SqlDrop = REPLACE(@SqlDrop, '&#x0D;', '');

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@SqlDrop
	  ,@PrintOnly;

  SET @Sql = REPLACE(@Sql, '#entity_view_name#', meta.EntityViewNameStaging(@EntityId));
  SET @Sql = REPLACE(@Sql, '#entity_table_name#', meta.EntityTableNameStaging(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_columns#', @KeyColumns);
  SET @Sql = REPLACE(@Sql, '#hash_columns#', @HashKeyColumns);
  SET @Sql = REPLACE(@Sql, '#foreign_hash_keys#', @ForeignHashKeys);
  SET @Sql = REPLACE(@Sql, '#staging_db#', meta.StagingDbName());
  SET @Sql = REPLACE(@Sql, '#staging_schema#', meta.StagingSchema());
  SET @Sql = REPLACE(@Sql, '#meta_db#', meta.MetaDbName());
  SET @Sql = REPLACE(@Sql, '#hash_delimiter#', meta.HashDelimiter());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = meta.StagingDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END