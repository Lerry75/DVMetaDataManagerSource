CREATE PROCEDURE [meta].[CreateLookupErrorTable] 
 @EntityId int
,@PrintOnly bit = 0

AS
BEGIN
  
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;
  
  -- Valid for Satellites only
  IF meta.EntityTypeId(@EntityId) NOT IN ('Sat', 'Lnk')
    RETURN;

  DECLARE 
    @TemplateDrop NVARCHAR(MAX) = (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
DECLARE @Stmt_#id##column_suffix# nvarchar(MAX) = ''#body#'';
EXEC sys.sp_executesql @Stmt_#id##column_suffix#;
'	
    ,@TemplateKeyColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('LookupErrorTable_key_columns'), '''', ''''''))
    ,@TemplateHashColumns NVARCHAR(MAX) = (SELECT REPLACE(meta.TemplateText('LookupErrorTable_columns_hash'), '''', ''''''))
    ,@SqlDrop NVARCHAR(MAX)
    ,@Sql NVARCHAR(MAX)
    ,@Columns NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDrop = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDrop
            , '#db_name#', '#edw_db#')
          , '#schema#', '#error_schema#')
        , '#object_name#', '[#entity_type#_#entity_name##_##hub_name#]')
      , '#object_type#', 'TABLE'
    );

  SET @Template = REPLACE(@Template, '#body#', REPLACE(meta.TemplateText('LookupErrorTable'), '''', ''''''))
    
  -- Search for Biz Keys in Sat
  IF meta.EntityTypeId(@EntityId) = 'Sat'
  BEGIN
    SET @Columns = (
      SELECT 
        REPLACE(
          REPLACE(
            @TemplateKeyColumns, '#column_name#', AttributeName
          ), '#data_type#', meta.SqlDataType(DataTypeId)
        )
      FROM (
        SELECT A.AttributeName
          ,A.DataTypeId
	        ,ROW_NUMBER() OVER (ORDER BY ER.EntityRelationshipId, A.[Order]) [Order]
        FROM meta.EDWEntityRelationship ER
	        JOIN meta.EDWAttribute A ON ER.[HubLnk] = A.EDWEntityId
        WHERE UsedBy = @EntityId  
      ) Z	 
      ORDER BY [Order] ASC		    
      FOR XML PATH('')
    );

    IF @Columns IS NULL
      SET @Columns = '';
	         
    SET @SqlDrop = (
      SELECT 
        REPLACE(@TemplateDrop, '#hub_name#', '')
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId  
      FOR XML PATH('')    
    );

    SET @Sql = (
      SELECT 
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                @Template, '#id#', HubLnk
              ), '#key_or_hashkey_columns#', @Columns
            ), '#hub_name#', ''
          ), '#column_suffix#', meta.CleanSuffix(HashKeySuffix)
        )
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId  
      FOR XML PATH('')    
    );

    SET @SqlDrop = REPLACE(@SqlDrop, '#entity_name#', meta.EntityNameLookupError(@EntityId));
    SET @SqlDrop = REPLACE(@SqlDrop, '#_#', ''); 

    SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityNameLookupError(@EntityId));
    SET @Sql = REPLACE(@Sql, '#_#', ''); 

  END

  -- Search for Hash Keys in Lnk
  IF meta.EntityTypeId(@EntityId) = 'Lnk'
  BEGIN

    SET @SqlDrop = (
      SELECT 
        REPLACE(@TemplateDrop, '#hub_name#', CONCAT(meta.EntityName(HubLnk), meta.CleanSuffix(HashKeySuffix)))
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId  
      FOR XML PATH('')
    );

    SET @Sql = (
      SELECT 
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                @Template, '#id#', HubLnk
              ), '#key_or_hashkey_columns#', REPLACE(REPLACE(@TemplateHashColumns, '#key_column#', meta.EntityKeyColumnWithSuffix(HubLnk, meta.CleanSuffix(HashKeySuffix))), '#key_datatype#' , meta.SqlDataTypeHashKey())
            ), '#hub_name#', CONCAT(meta.EntityName(HubLnk), meta.CleanSuffix(HashKeySuffix))
          ), '#column_suffix#', meta.CleanSuffix(HashKeySuffix)
        )
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId  
      FOR XML PATH('')
    );

    SET @SqlDrop = REPLACE(@SqlDrop, '#entity_name#', meta.EntityNameLookupError(@EntityId));
    SET @SqlDrop = REPLACE(@SqlDrop, '#_#', '_'); 

    SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityNameLookupError(@EntityId));
    SET @Sql = REPLACE(@Sql, '#_#', '_'); 

  END
 
  -- Replace Placeholders
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

  SET @Sql = REPLACE(@Sql, '#error_schema#', meta.WarehouseErrorSchema());
  SET @Sql = REPLACE(@Sql, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_column#', meta.EntityKeyColumn(@EntityId));
  SET @Sql = REPLACE(@Sql, '#key_datatype#', meta.SqlDataTypeHashKey());
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');
  SET @Sql = REPLACE(@Sql, '&amp;#x0D;', '');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;
    	  	
END