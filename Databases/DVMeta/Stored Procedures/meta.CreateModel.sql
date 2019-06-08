CREATE PROCEDURE [meta].[CreateModel]
  @PrintOnly bit = 0

AS
BEGIN
  SET NOCOUNT ON;

  PRINT '-- *** Validating Model ***';
  IF (SELECT COUNT(*) FROM meta.ValidateModel()) != 0
  BEGIN
    PRINT '-- *** There are validation errors. ***';

    SELECT RuleId
	    ,RuleCategory
	    ,RuleName
	    ,Reason
	    ,EntityId
	    ,EntityTypeName
	    ,EntityName
    FROM meta.ValidateModel();

    RETURN;
  END
  ELSE
    PRINT '-- *** Validation OK. ***';

  DECLARE 
    @TemplateUtilities NVARCHAR(MAX) = '
PRINT '''';
PRINT ''-- *** Deploying databases ***'';
EXEC meta.DeployDatabases @PrintOnly = #printonly#;

PRINT '''';
PRINT ''-- *** Deploying filegroups ***'';
EXEC meta.DeployFileGroups @PrintOnly = #printonly#;

PRINT ''-- *** Set database options ***'';
EXEC meta.SetDatabaseOptions @PrintOnly = #printonly#;

PRINT ''-- *** Deploying schemata ***'';
EXEC meta.DeploySchemata @PrintOnly = #printonly#;

PRINT ''-- *** Deploying utilities ***'';
EXEC meta.DeployUtilities @PrintOnly = #printonly#;
'
    ,@TemplateDropEntities NVARCHAR(MAX) = '
PRINT ''-- *** Dropping table #schema#.[#entity_type#_#entity_name#] ***'';' + (SELECT meta.TemplateText('DropObject'))
    ,@Template NVARCHAR(MAX) = '
PRINT ''-- *** Creating items for entity #entityid# - #schema#.[#entity_type#_#entity_name#] ***'';
EXEC [meta].[CreateAllObjectsForEntity] @EntityId = #entityid#, @PrintOnly = #printonly#;
'
    ,@Sql NVARCHAR(MAX)
    ,@Database NVARCHAR(50);

  SET @TemplateDropEntities = 
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(@TemplateDropEntities
            , '#db_name#', '#edw_db#')
          , '#schema#', '#schema#')
        , '#object_name#', '[#entity_prefix##entity_type#_#entity_name#]')
      , '#object_type#', 'TABLE'
    );

  SET @Sql = @TemplateUtilities;

  IF EXISTS (SELECT * FROM meta.EDWEntity)
  BEGIN
    -- Drop entites
    SET @Sql += (
      SELECT REPLACE(
          REPLACE(REPLACE(REPLACE(@TemplateDropEntities, '#entity_type#', meta.EntityTypeId(EntityId)), '#entity_name#', EntityName), '#entity_prefix#', CASE meta.EntityTypeId(EntityId) WHEN 'Sat' THEN 'tbl_' ELSE '' END)
        ,'#schema#'
        ,CASE WHEN meta.EntityTypeId(EntityId) IN ('Br', 'Pit') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END)
      FROM meta.EDWEntity
      ORDER BY 
        CASE EntityTypeId 
	        WHEN 'Br' THEN 1
		      WHEN 'Pit' THEN 2
          WHEN 'Sat' THEN 3
	        WHEN 'TSat' THEN 4
		      WHEN 'RSat' THEN 5
		      WHEN 'Lnk' THEN 6
          WHEN 'SAL' THEN 7
	        ELSE 999
        END
	    FOR XML PATH('')
    );

    -- Drop lookup error tables
    IF EXISTS (SELECT * FROM meta.EDWEntity WHERE EntityTypeId IN ('Lnk', 'Sat'))
      SET @Sql += (
        SELECT REPLACE(
            REPLACE(REPLACE(REPLACE(@TemplateDropEntities, '#entity_type#', meta.EntityTypeId(EntityId)), '#entity_name#', meta.EntityNameLookupError(EntityId)), '#entity_prefix#', '')
          ,'#schema#'
          ,meta.WarehouseErrorSchema())
        FROM meta.EDWEntity
        WHERE EntityTypeId IN ('Lnk', 'Sat')
	      FOR XML PATH('')
      );

    -- Create new entities
    SET @Sql += (
	    SELECT REPLACE(
          REPLACE(REPLACE(REPLACE(@Template, '#entityid#', EntityId), '#entity_type#', meta.EntityTypeId(EntityId)), '#entity_name#', EntityName)
        ,'#schema#'
        ,CASE WHEN meta.EntityTypeId(EntityId) IN ('Br', 'Pit') THEN meta.WarehouseBusinessSchema() ELSE meta.WarehouseRawSchema() END)
      FROM meta.EDWEntity
      ORDER BY 
        CASE EntityTypeId 
          WHEN 'Hub' THEN 1
	        WHEN 'Lnk' THEN 2
          WHEN 'SAL' THEN 3
		      WHEN 'Sat' THEN 4
	        WHEN 'TSat' THEN 5
		      WHEN 'RSat' THEN 6
	        ELSE 999
        END
	    FOR XML PATH('')
    );
  END

  -- Replace Placeholders
  SET @Sql = REPLACE(@Sql, '#edw_db#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);
  SET @Sql = REPLACE(@Sql, '&#x0D;', '');

  SET @Database = '';
  EXEC dbo.ExecuteOrPrint
    @Database
    ,@Sql
END
