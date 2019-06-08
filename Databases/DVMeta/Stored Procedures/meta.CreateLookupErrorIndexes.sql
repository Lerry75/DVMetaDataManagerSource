CREATE PROCEDURE [meta].[CreateLookupErrorIndexes]
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
    @Sql NVARCHAR(MAX) = '' 
    ,@Template NVARCHAR(MAX) = (SELECT meta.TemplateText('LookupErrorIndexes'))
    ,@IndexOptions NVARCHAR(MAX)
    ,@Database NVARCHAR(50);
      
  -- Create indexes on Sat lookup error table
  IF meta.EntityTypeId(@EntityId) = 'Sat'
  BEGIN   
    SET @Sql = @Sql + REPLACE(@Template, '#hub_name#', '') 
    SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityNameLookupError(@EntityId));
    SET @Sql = REPLACE(@Sql, '#_#', ''); 
  END
  
  -- Create indexes Lnk lookup error table(s)
  IF meta.EntityTypeId(@EntityId) = 'Lnk'
  BEGIN
    SET @Sql += (
      SELECT REPLACE(@Template, '#hub_name#', CONCAT(meta.EntityName(HubLnk), meta.CleanSuffix(HashKeySuffix)))      
      FROM meta.EDWEntityRelationship 
      WHERE UsedBy = @EntityId
      ORDER BY EntityRelationshipId
      FOR XML PATH('')
    );

    SET @Sql = REPLACE(@Sql, '#entity_name#', meta.EntityNameLookupError(@EntityId));
    SET @Sql = REPLACE(@Sql, '#_#', '_'); 
  END

  -- Index options
  SET @IndexOptions = 'DATA_COMPRESSION = #rowstore_compression#';
 
  -- Replace Placeholders   
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', meta.FileGroupIndex());
  SET @Sql = REPLACE(@Sql, '#index_options#', @IndexOptions);
  SET @Sql = REPLACE(@Sql, '#error_schema#', meta.WarehouseErrorSchema());
  SET @Sql = REPLACE(@Sql, '#entity_type#', meta.EntityTypeId(@EntityId));
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#rowstore_compression#', meta.RowStoreCompressionLevel());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');
  SET @Sql = REPLACE(@Sql, '&amp;#x0D;', '');
  SET @Sql = REPLACE(@Sql, '&lt;', '<');

  SET @Database = meta.WarehouseDbName();
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;
    	  	
END