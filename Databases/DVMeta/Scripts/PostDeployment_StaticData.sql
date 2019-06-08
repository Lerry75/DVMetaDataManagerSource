/*
Post-Deployment Script
*/
SET NOCOUNT ON;

/* [meta].[Environment] */
DECLARE @Environment VARCHAR(50) = 'Development';
DECLARE @SchemaVersion VARCHAR(50) = '1.1.0.1';

CREATE TABLE [#Environment]
(
  [Id] VARCHAR(50) NOT NULL , 
  [Value] VARCHAR(50) NOT NULL
)

INSERT INTO [#Environment]
(
  [Id]
  ,[Value]
)
VALUES
	('Environment', @Environment)
  ,('SchemaVersion', @SchemaVersion);

MERGE INTO [meta].[Environment] t
USING [#Environment] s
  ON t.[Id] = s.[Id]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([Id], [Value])
  VALUES (s.[Id], s.[Value]);
GO

/* [meta].[Configuration] */
CREATE TABLE [#Configuration]
(
  [Id] VARCHAR(50) NOT NULL, 
  [Value] VARCHAR(50) NOT NULL,
  [Description] VARCHAR(MAX) NULL
);

INSERT INTO [#Configuration]
(
  [Id]
  ,[Value]
  ,[Description]
)
VALUES
  ('FileGroupData', 'DATA', 'Database filegroup used for data storage.')
  ,('FileGroupIndex', 'INDEX', 'Database filegroup used for index storage.')
  ,('HashAlgorithm', 'SHA1', 'Hash algorithm used for business keys and diff hashing.')
  ,('HashCulture', 'en-US', 'Local culture used for hashing numeric data types.')
  ,('HashDelimiter', '|', 'Field delimiter used for hashing.')
  ,('StagingDbName', 'TEMP_DVStaging', 'Database target name for publishing staging entities. Database must be on the same DVMeta instance.')
  ,('StagingSchema', 'dsa', 'Schema used to publish entities in staging database.')
  ,('WarehouseBusinessSchema', 'business', 'Schema used to publish business vault entities in vault database.')
  ,('WarehouseDbName', 'TEMP_DV', 'Database target name for publishing raw and business vault entities. Database must be on the same DVMeta instance.')
  ,('WarehouseRawSchema', 'edw', 'Schema used to publish raw vault entities in vault database.')
  ,('WarehouseErrorSchema', 'error', 'Schema used to publish error entities in vault database.')
  ,('VirtualizedLoadEndDate', 'true', 'Enable use of on-the-fly calculated LoadEndDate for Satellites. It avoids updates during satellites loading.')
  ,('DisabledForeignKey', 'false', 'Enable/disable foreign key constraints in vault database.')
  ,('CompressRowStore', 'true', 'Enable/disable ROW level compression for RowStore tables in vault database.');

MERGE INTO [meta].[Configuration] t
USING [#Configuration] s
  ON t.[Id] = s.[Id]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([Id], [Value], [Description])
  VALUES (s.[Id], s.[Value], s.[Description]);
GO

/* [meta].[DataType] */
CREATE TABLE [#DataType]
(
  [DataTypeId] INT NOT NULL, 
  [DataTypeName] VARCHAR(50) NOT NULL, 
  [Size] INT NULL,
  [Precision] INT NULL,
  [Scale] INT NULL,
  [LastUpdateTime] DATETIME2 NOT NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
);

INSERT INTO [#DataType]
(
	[DataTypeId]
	,[DataTypeName]
	,[Size]
	,[Precision]
  ,[Scale]
	,[LastUpdateTime]
)
VALUES
  (1, 'Integer', NULL, NULL, NULL, meta.DateRangeStart())
  ,(2, 'Small Integer', NULL, NULL, NULL, meta.DateRangeStart())
  ,(3, 'Tiny Integer', NULL, NULL, NULL, meta.DateRangeStart())
  ,(4, 'Boolean', NULL, NULL, NULL, meta.DateRangeStart())
  ,(5, 'Short Text (Unicode)', 20, NULL, NULL, meta.DateRangeStart())
  ,(6, 'Medium Text (Unicode)', 50, NULL, NULL, meta.DateRangeStart())
  ,(7, 'Long Text (Unicode)', 255, NULL, NULL, meta.DateRangeStart())
  ,(8, 'Very Long Text (Unicode)', NULL, NULL, NULL, meta.DateRangeStart())
  ,(9, 'Short Text', 20, NULL, NULL, meta.DateRangeStart())
  ,(10, 'Medium Text', 50, NULL, NULL, meta.DateRangeStart())
  ,(11, 'Long Text', 255, NULL, NULL, meta.DateRangeStart())
  ,(12, 'Very Long Text', NULL, NULL, NULL, meta.DateRangeStart())
  ,(13, 'Real', NULL, NULL, NULL, meta.DateRangeStart())
  ,(14, 'Float', NULL, NULL, NULL, meta.DateRangeStart())
  ,(15, 'Short Date Time', NULL, NULL, NULL, meta.DateRangeStart())
  ,(16, 'Date Time', NULL, NULL, NULL, meta.DateRangeStart())
  ,(17, 'Date Time 2', NULL, NULL, NULL, meta.DateRangeStart())
  ,(18, 'Date', NULL, NULL, NULL, meta.DateRangeStart())
  ,(19, 'Time', NULL, NULL, NULL, meta.DateRangeStart())
  ,(20, 'HashKey', 40, NULL, NULL, meta.DateRangeStart())
  ,(21, 'Big Integer', NULL, NULL, NULL, meta.DateRangeStart())
  ,(22, 'Numeric', NULL, 28, 18, meta.DateRangeStart());

MERGE INTO [meta].[DataType] t
USING [#DataType] s
  ON t.[DataTypeId] = s.[DataTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([DataTypeId], [DataTypeName], [Size], [Precision], [Scale], [LastUpdateTime])
  VALUES (s.[DataTypeId], s.[DataTypeName], s.[Size], s.[Precision], s.[Scale], s.[LastUpdateTime]);
GO

/* [meta].[DataTypeMapping] */
CREATE TABLE [#DataTypeMapping] (
  [DataTypeId]  INT NOT NULL,
  [SqlDataType] VARCHAR(50) NOT NULL
);

INSERT INTO [#DataTypeMapping]
(
    [DataTypeId]
    ,[SqlDataType]
)
VALUES
  (1, 'int')
  ,(2, 'smallint')
  ,(3, 'tinyint')
  ,(4, 'bit')
  ,(5, 'nvarchar(20)')
  ,(6, 'nvarchar(50)')
  ,(7, 'nvarchar(255)')
  ,(8, 'nvarchar(MAX)')
  ,(9, 'varchar(20)')
  ,(10, 'varchar(50)')
  ,(11, 'varchar(255)')
  ,(12, 'varchar(MAX)')
  ,(13, 'real')
  ,(14, 'float')
  ,(15, 'smalldatetime')
  ,(16, 'datetime')
  ,(17, 'datetime2')
  ,(18, 'date')
  ,(19, 'time')
  ,(20, 'char(40)')
  ,(21, 'bigint')
  ,(22, 'numeric(28,18)');

MERGE INTO [meta].[DataTypeMapping] t
USING [#DataTypeMapping] s
  ON t.[DataTypeId] = s.[DataTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([DataTypeId], [SqlDataType])
  VALUES (s.[DataTypeId], s.[SqlDataType]);
GO

/* [meta].[EntityType] */
CREATE TABLE [#EntityType]
(
  [EntityTypeId] VARCHAR(4) NOT NULL, 
  [EntityTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NOT NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
);

INSERT INTO [#EntityType]
(
	[EntityTypeId]
	,[EntityTypeName]
	,[LastUpdateTime]
)
VALUES
  ('Br', 'Bridge', meta.DateRangeStart())
  ,('Hub', 'Hub', meta.DateRangeStart())
  ,('Lnk', 'Link', meta.DateRangeStart())
  ,('Pit', 'Point In Time', meta.DateRangeStart())
  ,('RSat', 'Record Tracking Satellite', meta.DateRangeStart())
  ,('Sat', 'Satellite', meta.DateRangeStart())
  ,('TSat', 'Satellite (No history)', meta.DateRangeStart())
  ,('SAL', 'Same As Link', meta.DateRangeStart());

MERGE INTO [meta].[EntityType] t
USING [#EntityType] s
  ON t.[EntityTypeId] = s.[EntityTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([EntityTypeId], [EntityTypeName], [LastUpdateTime])
  VALUES (s.[EntityTypeId], s.[EntityTypeName], s.[LastUpdateTime]);
GO

/* [meta].[PartitioningType] */
CREATE TABLE [#PartitioningType]
(
  [PartitioningTypeId] CHAR(1) NOT NULL, 
  [PartitioningTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NOT NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
);

INSERT INTO [#PartitioningType]
(
	[PartitioningTypeId]
	,[PartitioningTypeName]
	,[LastUpdateTime]
)
VALUES
  ('D', 'Daily', meta.DateRangeStart())
  ,('H', 'Hourly', meta.DateRangeStart())
  ,('M', 'Monthly', meta.DateRangeStart())
  ,('N', 'None', meta.DateRangeStart());

MERGE INTO [meta].[PartitioningType] t
USING [#PartitioningType] s
  ON t.[PartitioningTypeId] = s.[PartitioningTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([PartitioningTypeId], [PartitioningTypeName], [LastUpdateTime])
  VALUES (s.[PartitioningTypeId], s.[PartitioningTypeName], s.[LastUpdateTime]);
GO

/* [meta].[ProcessType] */
CREATE TABLE [#ProcessType]
(
  [ProcessTypeId] VARCHAR(3) NOT NULL, 
  [ProcessTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NOT NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
);

INSERT INTO [#ProcessType]
(
	[ProcessTypeId]
	,[ProcessTypeName]
	,[LastUpdateTime]
)
VALUES
  ('EDW', 'Raw Data', meta.DateRangeStart())
  ,('BIZ', 'Business', meta.DateRangeStart());

MERGE INTO [meta].[ProcessType] t
USING [#ProcessType] s
  ON t.[ProcessTypeId] = s.[ProcessTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([ProcessTypeId], [ProcessTypeName], [LastUpdateTime])
  VALUES (s.[ProcessTypeId], s.[ProcessTypeName], s.[LastUpdateTime]);
GO

/* [meta].[SourceSystemType] */
CREATE TABLE [#SourceSystemType]
(
  [SourceSystemTypeId] VARCHAR(3) NOT NULL, 
  [SourceSystemTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NOT NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
);

INSERT INTO [#SourceSystemType]
(
	[SourceSystemTypeId]
	,[SourceSystemTypeName]
	,[LastUpdateTime]
)
VALUES
  ('NA', 'N/A', meta.DateRangeStart())
  ,('CSV', 'CSV file(s)', meta.DateRangeStart())
  ,('SP', 'MS SharePoint', meta.DateRangeStart())
  ,('SQL', 'Relational Database', meta.DateRangeStart())
  ,('WEB', 'Web Service', meta.DateRangeStart())
  ,('XLS', 'Excel file(s)', meta.DateRangeStart())
  ,('XML', 'XML file(s)', meta.DateRangeStart())
  ,('OTH', 'Other', meta.DateRangeStart());

MERGE INTO [meta].[SourceSystemType] t
USING [#SourceSystemType] s
  ON t.[SourceSystemTypeId] = s.[SourceSystemTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([SourceSystemTypeId], [SourceSystemTypeName], [LastUpdateTime])
  VALUES (s.[SourceSystemTypeId], s.[SourceSystemTypeName], s.[LastUpdateTime]);
GO

/* [meta].[StorageType] */
CREATE TABLE [#StorageType]
(
  [StorageTypeId] VARCHAR(3) NOT NULL, 
  [StorageTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NOT NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
);

INSERT INTO [#StorageType]
(
	[StorageTypeId]
	,[StorageTypeName]
	,[LastUpdateTime]
)
VALUES
  ('Col', 'ColumnStore', meta.DateRangeStart())
  ,('CR', 'ColumnStore + RowStore', meta.DateRangeStart())
  ,('Row', 'RowStore', meta.DateRangeStart());

MERGE INTO [meta].[StorageType] t
USING [#StorageType] s
  ON t.[StorageTypeId] = s.[StorageTypeId]
WHEN NOT MATCHED BY TARGET  
THEN
  INSERT ([StorageTypeId], [StorageTypeName], [LastUpdateTime])
  VALUES (s.[StorageTypeId], s.[StorageTypeName], s.[LastUpdateTime]);
GO

/* [meta].[Template] */
IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizBridgeTable')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizBridgeTable'
    ,'Bridge table creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE TABLE #entity_table_name# (
  [SnapshotDate] [datetime2] NOT NULL
#key_columns#
#column_names#
) ON #filegroup_data#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizBridgeTable_key_columns')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizBridgeTable_key_columns'
    ,'Bridge table creation script: key columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,#referenced_key_column# #data_type_hash_key# NOT NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizBridgeTable_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizBridgeTable_column_names'
    ,'Bridge table creation script: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#referenced_entity_name#_#referenced_column#] #data_type# NOT NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizPitTable')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizPitTable'
    ,'Point In Time table creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE TABLE #entity_table_name# (
  #key_column# #data_type_hash_key# NOT NULL
  ,#referenced_key_column# #data_type_hash_key# NOT NULL
  ,[SnapshotDate] [datetime2] NOT NULL
  ,[SnapshotDateShort] [date] NULL
#column_names#
) ON #filegroup_data#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizPitTable_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizPitTable_column_names'
    ,'Point In Time table creation script: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
  ,[#referenced_entity_name#_#referenced_key_column#] #data_type_hash_key# NOT NULL
  ,[#referenced_entity_name#_LoadDate] [datetime2] NOT NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWTable')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWTable'
    ,'EDW entity creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE TABLE #entity_table_name# (
  #key_column# #data_type_hash_key# NOT NULL
  ,[LoadDate] [datetime2] NOT NULL
#load_date_short_column#
#load_end_date_column#
  ,[RecordSource] [varchar](50) NOT NULL
#hash_diff_column#
#column_names#
) ON #filegroup_data#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWTable_key_columns')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWTable_key_columns'
    ,'EDW entity creation script: key columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#] #data_type# NOT NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWTable_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWTable_column_names'
    ,'EDW entity creation script: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#] #data_type# NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'LookupErrorIndexes')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'LookupErrorIndexes'
    ,'Indexes creation script for Lookup Error tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED INDEX [IX_#entity_type#_#entity_name##_##hub_name#_LoadDate] ON #error_schema#.[#entity_type#_#entity_name##_##hub_name#] ([LoadDate]) WITH (#index_options#) ON #filegroup_data#;
ALTER TABLE #error_schema#.[#entity_type#_#entity_name##_##hub_name#] ADD CONSTRAINT [PK_#entity_type#_#entity_name##_##hub_name#] PRIMARY KEY NONCLUSTERED ([Id] ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'TablePartitioning')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'TablePartitioning'
    ,'Partitioning creation script for entities'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PARTITION FUNCTION #partition_function#([datetime2]) AS RANGE LEFT FOR VALUES (''#date_range_start#'');
CREATE PARTITION SCHEME #partition_scheme_data# AS PARTITION #partition_function# ALL TO (#filegroup_data#);
CREATE PARTITION SCHEME #partition_scheme_index# AS PARTITION #partition_function# ALL TO (#filegroup_index#);
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'Databases')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'Databases'
    ,'Deployment script for staging and EDW databases'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
IF NOT EXISTS
(
  SELECT *
  FROM sys.databases
  WHERE [name] = ''#staging_db_no_brackets#''
)
  CREATE DATABASE #staging_db#
  ON PRIMARY 
  (NAME = N''#staging_db_no_brackets#'', FILENAME = N''#physical_filename_staging#'')
  LOG ON 
  (NAME = N''#staging_db_no_brackets#_log'', FILENAME = N''#physical_filename_staging_log#'');

IF NOT EXISTS
(
  SELECT *
  FROM sys.databases
  WHERE [name] = ''#edw_db_no_brackets#''
)
  CREATE DATABASE #edw_db#
  ON PRIMARY 
  (NAME = N''#edw_db_no_brackets#'', FILENAME = N''#physical_filename_edw#'')
  LOG ON 
  (NAME = N''#edw_db_no_brackets#_log'', FILENAME = N''#physical_filename_edw_log#'');
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'FileGroups')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'FileGroups'
    ,'Deployment script for database filegroups'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
DECLARE @Stmt nvarchar(MAX);

IF NOT EXISTS
(
  SELECT *
  FROM #staging_db#.sys.filegroups
  WHERE [name] = ''#filegroup_data_no_brackets#''
)
BEGIN
  USE #staging_db#;

  SET @Stmt = ''
ALTER DATABASE #staging_db# ADD FILEGROUP #filegroup_data#;
ALTER DATABASE #staging_db# ADD FILE (NAME = N''''#logical_filename_staging_data#'''', FILENAME = N''''#physical_filename_staging_data#'''') TO FILEGROUP #filegroup_data#;
ALTER DATABASE #staging_db# MODIFY FILEGROUP #filegroup_data# DEFAULT;
'';

  EXEC sys.sp_executesql @Stmt;
END

IF NOT EXISTS
(
  SELECT *
  FROM #staging_db#.sys.filegroups
  WHERE [name] = ''#filegroup_index_no_brackets#''
)
BEGIN
  USE #staging_db#;

  SET @Stmt = ''
ALTER DATABASE #staging_db# ADD FILEGROUP #filegroup_index#;
ALTER DATABASE #staging_db# ADD FILE (NAME = N''''#logical_filename_staging_index#'''', FILENAME = N''''#physical_filename_staging_index#'''') TO FILEGROUP #filegroup_index#;
'';

  EXEC sys.sp_executesql @Stmt;
END

IF NOT EXISTS
(
  SELECT *
  FROM #edw_db#.sys.filegroups
  WHERE [name] = ''#filegroup_data_no_brackets#''
)
BEGIN
  USE #edw_db#;

  SET @Stmt = ''
ALTER DATABASE #edw_db# ADD FILEGROUP #filegroup_data#;
ALTER DATABASE #edw_db# ADD FILE (NAME = N''''#logical_filename_edw_data#'''', FILENAME = N''''#physical_filename_edw_data#'''') TO FILEGROUP #filegroup_data#;
ALTER DATABASE #edw_db# MODIFY FILEGROUP #filegroup_data# DEFAULT;
'';

  EXEC sys.sp_executesql @Stmt;
END

IF NOT EXISTS
(
  SELECT *
  FROM #edw_db#.sys.filegroups
  WHERE [name] = ''#filegroup_index_no_brackets#''
)
BEGIN
  USE #edw_db#;

  SET @Stmt = ''
ALTER DATABASE #edw_db# ADD FILEGROUP #filegroup_index#;
ALTER DATABASE #edw_db# ADD FILE (NAME = N''''#logical_filename_edw_index#'''', FILENAME = N''''#physical_filename_edw_index#'''') TO FILEGROUP #filegroup_index#;
'';

  EXEC sys.sp_executesql @Stmt;
END

'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'Schemata')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'Schemata'
    ,'Deployment script for database schemas'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
DECLARE @Stmt nvarchar(MAX);

IF NOT EXISTS
(
  SELECT *
  FROM INFORMATION_SCHEMA.SCHEMATA
  WHERE SCHEMA_NAME = ''#schema_no_brackets#''
)
BEGIN
  SET @Stmt = ''
CREATE SCHEMA #schema# AUTHORIZATION [dbo];
'';

  EXEC sys.sp_executesql @Stmt;
END
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'DatabaseOptions')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'DatabaseOptions'
    ,'Deployment script for database options'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER DATABASE #db_name# SET AUTO_CREATE_STATISTICS ON #incremental_statistics#;
ALTER DATABASE #db_name# SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT;

'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGetPitProc')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGetPitProc'
    ,'Creation script for populating PIT procedure'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #edw_schema#.[Get_#entity_type#_#entity_name#]
  @SnapshotDate datetime2

WITH RECOMPILE
AS

SELECT 
  #key_column# = 
    dbo.GetHash(
      CONCAT(
	      ''''
#hash_columns#
	    )
    )
  ,#referenced_entity_type#.#referenced_key_column#
  ,[SnapshotDate] = @SnapshotDate
  ,[SnapshotDateShort] = CONVERT(date, @SnapshotDate)
#column_names#
FROM #referenced_entity_table_name# #referenced_entity_type#
#join_conditions#
ORDER BY #referenced_entity_type#.#referenced_key_column#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGetPitProc_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGetPitProc_column_names'
    ,'Creation script for populating PIT procedure: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
  ,[#referenced_entity_name#_#key_column#] = ISNULL(#referenced_entity_type#_#referenced_entity_id#.[#key_column#], REPLICATE(''0'', #hash_type_len#))
  ,[#referenced_entity_name#_LoadDate] = ISNULL(#referenced_entity_type#_#referenced_entity_id#.[LoadDate], ''#date_range_start#'')'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGetPitProc_columns_hash')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGetPitProc_columns_hash'
    ,'Creation script for populating PIT procedure: hash columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'        ,CONCAT(#column_name#, ''#hash_delimiter#'')
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGetPitProc_join_conditions')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGetPitProc_join_conditions'
    ,'Creation script for populating PIT procedure: join conditions'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
  LEFT JOIN #edw_schema#.[#referenced_entity_type#_#referenced_entity_name#] #referenced_entity_type#_#referenced_entity_id# ON #entity_type#.[#key_column#] = #referenced_entity_type#_#referenced_entity_id#.[#key_column#]
    AND @SnapshotDate BETWEEN #referenced_entity_type#_#referenced_entity_id#.[LoadDate] AND #referenced_entity_type#_#referenced_entity_id#.[LoadEndDate]'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGhostRecordDeleteProc')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGhostRecordDeleteProc'
    ,'Creation script for Ghost Record delete procedure'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #edw_schema#.[GhostRecordDelete_#entity_type#_#entity_name#]

AS

SET NOCOUNT ON;

DELETE FROM #entity_table_name# WHERE #key_column# = CONVERT(#data_type_hash_key#, ''#default_hash_key#'');
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGhostRecordInsertProc')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGhostRecordInsertProc'
    ,'Creation script for Ghost Record insert procedure'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #edw_schema#.[GhostRecordInsert_#entity_type#_#entity_name#]

AS

SET NOCOUNT ON;

IF NOT EXISTS 
(
  SELECT *
  FROM #entity_table_name# 
  WHERE #key_column# = CONVERT(#data_type_hash_key#, ''#default_hash_key#'')
)
  INSERT INTO #entity_table_name#
  (
    #key_column#
    ,[LoadDate]
  #load_end_date_column#
    ,[RecordSource]
  #hash_diff_column#
  #column_names#
  )
  VALUES
  (
    CONVERT(#data_type_hash_key#, ''#default_hash_key#'')
    ,''#date_range_start#''
  #end_date_value#
    ,''SYSTEM''
  #hash_diff_value#
  #column_values#
  );
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGhostRecordInsertProc_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGhostRecordInsertProc_column_names'
    ,'Creation script for Ghost Record insert procedure: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#]
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWGhostRecordInsertProc_column_values')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWGhostRecordInsertProc_column_values'
    ,'Creation script for Ghost Record insert procedure: column values'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,#column_value#
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWUpdateLoadEndDateProc')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWUpdateLoadEndDateProc'
    ,'Creation script for Upload End Date procedure'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #edw_schema#.[UpdateLoadEndDate_#entity_type#_#entity_name#]
    @LoadDate DATETIME2

AS

UPDATE Sat
SET [LoadEndDate] = DATEADD(ss, -1, @LoadDate) 
FROM #entity_table_name# Sat
  JOIN #entity_table_name# Sat_current ON Sat.#key_column# = Sat_current.#key_column# 
    AND Sat.[LoadEndDate] = Sat_current.[LoadEndDate]
WHERE Sat_current.[LoadDate] = @LoadDate
  AND Sat.[LoadDate] < @LoadDate
  AND Sat.[LoadEndDate] = ''#date_range_end#'';
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'FinalizeEntityProc_partitioned')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'FinalizeEntityProc_partitioned'
    ,'Creation script for Finalize entity procedure (partitioned)'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #schema#.[FinalizeEntity_#entity_type#_#entity_name#]
    @LoadDate DATETIME2

AS

DECLARE @Sql NVARCHAR(MAX) = ''
UPDATE STATISTICS #entity_table_name# WITH RESAMPLE ON PARTITIONS(#partition_number#), ALL, NORECOMPUTE;
'';

SET @Sql = REPLACE(@Sql, ''#partition_number#'', $PARTITION.#partition_function#(@LoadDate));

EXEC sys.sp_executesql @Sql;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'FinalizeEntityProc_nonpartitioned')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'FinalizeEntityProc_nonpartitioned'
    ,'Creation script for Finalize entity procedure (non-partitioned)'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #schema#.[FinalizeEntity_#entity_type#_#entity_name#]
    @LoadDate DATETIME2

AS

UPDATE STATISTICS #entity_table_name# WITH ALL, NORECOMPUTE;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'InitializeEntityProc_partitioned')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'InitializeEntityProc_partitioned'
    ,'Creation script for Initialize entity procedure (partitioned)'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #schema#.[InitializeEntity_#entity_type#_#entity_name#]
    @LoadDate DATETIME2

AS

DECLARE @PartitionDate #date_data_type# = #date_value#;

IF NOT EXISTS (
  SELECT *
  FROM sys.partition_range_values prv
    JOIN sys.partition_functions pf ON prv.function_id = pf.function_id
  WHERE pf.name = ''#partition_function_no_brackets#''
    AND prv.value = @PartitionDate
)
BEGIN
  ALTER PARTITION SCHEME #partition_scheme_data# NEXT USED #filegroup_data#;
  ALTER PARTITION SCHEME #partition_scheme_index# NEXT USED #filegroup_index#;
  ALTER PARTITION FUNCTION #partition_function#() SPLIT RANGE (@PartitionDate);
END
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'InitializeEntityProc_nonpartitioned')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'InitializeEntityProc_nonpartitioned'
    ,'Creation script for Initialize entity procedure (non-partitioned)'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE #schema#.[InitializeEntity_#entity_type#_#entity_name#]
    @LoadDate DATETIME2

AS

RETURN
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWView')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWView'
    ,'EDW entity view creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE VIEW #edw_schema#.[#entity_type#_#entity_name#]

AS

SELECT
  #key_column#
  ,[LoadDate]
#load_end_date_column#
  ,[RecordSource]
#hash_diff_column#
#column_names#
FROM #entity_table_name#
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWView_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWView_column_names'
    ,'EDW entity view creation script: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#]
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWView_virtualized_load_end_date_column')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWView_virtualized_load_end_date_column'
    ,'EDW entity view creation script: virtualized load end date column'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[LoadEndDate] = ISNULL(DATEADD(ss, -1, LAG([LoadDate]) OVER(PARTITION BY #key_column# ORDER BY [LoadDate] DESC)), ''#date_range_end#'')
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'LookupErrorTable')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'LookupErrorTable'
    ,'Lookup error table creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE TABLE #error_schema#.[#entity_type#_#entity_name##_##hub_name#] (
  [Id] [bigint] IDENTITY(1,1) NOT NULL
  ,#key_column# #key_datatype# NOT NULL
  ,[LoadDate] [datetime2](7) NOT NULL
  ,[RecordSource] [varchar](50) NOT NULL
#key_or_hashkey_columns#
) ON #filegroup_data#
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'LookupErrorTable_key_columns')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'LookupErrorTable_key_columns'
    ,'Lookup error table creation script: key columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#] #data_type# NOT NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'LookupErrorTable_columns_hash')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'LookupErrorTable_columns_hash'
    ,'Lookup error table creation script: hash columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,#key_column# #key_datatype# NOT NULL'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingTable')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingTable'
    ,'Staging table creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE TABLE #entity_table_name# (
  [Id] [int] IDENTITY(1,1) NOT NULL
  ,[LoadDate] [datetime2] NOT NULL
  ,[RecordSource] [varchar](50) NOT NULL
#key_columns#
#column_names#
) ON #filegroup_data#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingTable_key_columns')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingTable_key_columns'
    ,'Staging table creation script: key columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#] #data_type# NOT NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingTable_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingTable_column_names'
    ,'Staging table creation script: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#] #data_type# NULL
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingView')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingView'
    ,'Staging view creation script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE VIEW #entity_view_name#

AS

SELECT
  [Id]
  ,#key_column# = 
    dbo.GetHash(
      CONCAT(
       ''''
#hash_columns#
      )
    )
  ,[LoadDate]
  ,[LoadDateShort] = CONVERT(date, [LoadDate])
  ,[RecordSource]
#hash_diff_column#
#foreign_hash_keys#
#key_columns#
#column_names#
FROM #entity_table_name#
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingView_column_names')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingView_column_names'
    ,'Staging view creation script: column names'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,[#column_name#]
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingView_hash_columns')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingView_hash_columns'
    ,'Staging view creation script: hash columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'        ,CONCAT(#column_name#, ''#hash_delimiter#'')
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'StagingView_key_columns')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'StagingView_key_columns'
    ,'Staging view creation script: key columns'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'  ,#key_column# = 
    dbo.GetHash(
      CONCAT(
	      ''''
#hash_columns#
	    )
    )'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'Utilities_get_hash_actual')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'Utilities_get_hash_actual'
    ,'Utility procedure creation script: GetHash (current)'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE FUNCTION [dbo].[GetHash]
(
	@value NVARCHAR(MAX)
)
RETURNS #data_type_hash_key#
AS
BEGIN
	RETURN CONVERT(#data_type_hash_key#, HASHBYTES(''#hash_algorithm#'', UPPER(@value)), 2)
END
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'Utilities_get_hash_legacy')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'Utilities_get_hash_legacy'
    ,'Utility procedure creation script: GetHash (legacy)'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE FUNCTION [dbo].[GetHash]
(
	@value VARCHAR(8000)
)
RETURNS #data_type_hash_key#
AS
BEGIN
	RETURN CONVERT(#data_type_hash_key#, HASHBYTES(''#hash_algorithm#'', UPPER(@value)), 2)
END
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'Utilities_insert_ghost_records')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'Utilities_insert_ghost_records'
    ,'Utility procedure creation script: InsertGhostRecords'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE PROCEDURE [dbo].[InsertGhostRecords]
  @Force bit = 0

AS

SET NOCOUNT ON;

DECLARE 
  @TemplateInsert nvarchar(MAX) = ''
EXEC #schema#.#ghost_insert_proc_name#;
''
  ,@TemplateDelete nvarchar(MAX) = ''
EXEC #schema#.#ghost_delete_proc_name#;
''
  ,@Sql nvarchar(MAX);

SET @Sql = (
  SELECT REPLACE(REPLACE(@TemplateInsert, ''#schema#'', SCHEMA_NAME(schema_id)), ''#ghost_insert_proc_name#'', [name])
  FROM sys.objects
  WHERE [type] = ''P''
    AND [name] LIKE ''GhostRecordInsert%''
  ORDER BY [name]
  FOR XML PATH('''')
)

IF @Force = 1
  SET @Sql = (
    SELECT REPLACE(REPLACE(@TemplateDelete, ''#schema#'', SCHEMA_NAME(schema_id)), ''#ghost_delete_proc_name#'', [name])
    FROM sys.objects
    WHERE [type] = ''P''
      AND [name] LIKE ''GhostRecordDelete%''
    ORDER BY [name] DESC
    FOR XML PATH('''')
  )
	+ @Sql;

SET @Sql = REPLACE(@Sql, ''&#x0D;'', '''');

IF (@Sql IS NOT NULL)
    EXEC sys.sp_executesql @Sql;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'IndexOptionsRowStore_partitioned')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'IndexOptionsRowStore_partitioned'
    ,'Options for RowStore partitioned indexes'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'DATA_COMPRESSION = #rowstore_compression#, STATISTICS_INCREMENTAL = ON'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'IndexOptionsRowStore_nonpartitioned')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'IndexOptionsRowStore_nonpartitioned'
    ,'Options for RowStore non-partitioned indexes'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'DATA_COMPRESSION = #rowstore_compression#'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesColumnRowStore_pit')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesColumnRowStore_pit'
    ,'Index creation script for ColumnStore/RowStore: PIT table'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_SnapshotDate] ON #entity_table_name# ([SnapshotDate] ASC) WITH (#index_options#) ON #filegroup_index#;
CREATE UNIQUE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_Key] ON #entity_table_name# (#referenced_key_column# ASC, [SnapshotDate] ASC) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesColumnRowStore_bridge')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesColumnRowStore_bridge'
    ,'Index creation script for ColumnStore/RowStore: Bridge table'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_SnapshotDate] ON #entity_table_name# ([SnapshotDate] ASC) WITH (#index_options#) ON #filegroup_index#;
CREATE UNIQUE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_Key] ON #entity_table_name# (#referenced_key_column# ASC, [SnapshotDate] ASC) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesColumnRowStore_common')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesColumnRowStore_common'
    ,'Index creation script for ColumnStore/RowStore: common script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_#referenced_entity_name#] ON #entity_table_name# ([#referenced_entity_name#_#referenced_key_column#] ASC, [#referenced_entity_name#_LoadDate] ASC) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [DF_#entity_type#_#entity_name#_#referenced_entity_name#_#referenced_key_column#] DEFAULT (''#default_hash_key#'') FOR [#referenced_entity_name#_#referenced_key_column#];
ALTER TABLE #entity_table_name# ADD CONSTRAINT [DF_#entity_type#_#entity_name#_#referenced_entity_name#_LoadDate] DEFAULT (''#date_range_start#'') FOR [#referenced_entity_name#_LoadDate];
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesColumnStore_all')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesColumnStore_all'
    ,'Index creation script for ColumnStore: all tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesColumnStore_common')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesColumnStore_common'
    ,'Index creation script for ColumnStore: common script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER TABLE #entity_table_name# ADD CONSTRAINT [DF_#entity_type#_#entity_name#_#referenced_entity_name#_#referenced_key_column#] DEFAULT (''#default_hash_key#'') FOR [#referenced_entity_name#_#referenced_key_column#];
ALTER TABLE #entity_table_name# ADD CONSTRAINT [DF_#entity_type#_#entity_name#_#referenced_entity_name#_LoadDate] DEFAULT (''#date_range_start#'') FOR [#referenced_entity_name#_LoadDate];
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesRowStore_pit')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesRowStore_pit'
    ,'Index creation script for RowStore: PIT table'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED INDEX [IX_#entity_type#_#entity_name#_SnapshotDate] ON #entity_table_name# ([SnapshotDate] ASC) WITH (#index_options#) ON #filegroup_data#;
CREATE UNIQUE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_Key] ON #entity_table_name# (#referenced_key_column# ASC, [SnapshotDate] ASC) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesRowStore_bridge')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesRowStore_bridge'
    ,'Index creation script for RowStore: Bridge table'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED INDEX [IX_#entity_type#_#entity_name#_SnapshotDate] ON #entity_table_name# ([SnapshotDate] ASC) WITH (#index_options#) ON #filegroup_data#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_columns# [SnapshotDate] ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'BizIndexesRowStore_common')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'BizIndexesRowStore_common'
    ,'Index creation script for RowStore: common script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_#referenced_entity_name#] ON #entity_table_name# ([#referenced_entity_name#_#referenced_key_column#] ASC, [#referenced_entity_name#_LoadDate] ASC) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [DF_#entity_type#_#entity_name#_#referenced_entity_name#_#referenced_key_column#] DEFAULT (''#default_hash_key#'') FOR [#referenced_entity_name#_#referenced_key_column#];
ALTER TABLE #entity_table_name# ADD CONSTRAINT [DF_#entity_type#_#entity_name#_#referenced_entity_name#_LoadDate] DEFAULT (''#date_range_start#'') FOR [#referenced_entity_name#_LoadDate];
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnRowStore_hub_link')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnRowStore_hub_link'
    ,'Index creation script for ColumnStore/RowStore (raw vault): hub & link tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadDate] ON #entity_table_name# ([LoadDate]) WITH (#index_options#) ON #filegroup_index#;
CREATE UNIQUE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_Key] ON #entity_table_name# (#column_names#) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnRowStore_sat')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnRowStore_sat'
    ,'Index creation script for ColumnStore/RowStore (raw vault): satellite tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadDate] ON #entity_table_name# ([LoadDate]) WITH (#index_options#) ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadEndDate] ON #entity_table_name# (LoadEndDate, #key_column#) INCLUDE (HashDiff) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC, [LoadDate] ASC) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# WITH CHECK ADD CONSTRAINT [CK_#entity_type#_#entity_name#_LoadDate] CHECK (([LoadDate] <= [LoadEndDate]));
ALTER TABLE #entity_table_name# WITH CHECK ADD CONSTRAINT [CK_#entity_type#_#entity_name#_LoadEndDate] DEFAULT (''#date_range_end#'') FOR [LoadEndDate];
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnRowStore_tsat')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnRowStore_tsat'
    ,'Index creation script for ColumnStore/RowStore (raw vault): non-historized satellite tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadDate] ON #entity_table_name# ([LoadDate], #key_column#) WITH (#index_options#) ON #filegroup_data#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC, [LoadDate] ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnRowStore_fk')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnRowStore_fk'
    ,'Index creation script for ColumnStore/RowStore (raw vault): foreign keys'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER TABLE #entity_table_name# WITH #fk_check# ADD CONSTRAINT [FK_#entity_type#_#entity_name#_#referenced_entity_type#_#referenced_entity_name##column_suffix#] FOREIGN KEY (#referencing_key_column#) REFERENCES #referenced_entity_table_name# (#referenced_key_column#);
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnStore_all')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnStore_all'
    ,'Index creation script for ColumnStore (raw vault): all tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_#entity_type#_#entity_name#] ON #entity_table_name# ON #filegroup_data#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnStore_pk')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnStore_pk'
    ,'Index creation script for ColumnStore (raw vault): primary key'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnStore_fk')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnStore_fk'
    ,'Index creation script for ColumnStore (raw vault): foreign keys'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER TABLE #entity_table_name# WITH #fk_check# ADD CONSTRAINT [FK_#entity_type#_#entity_name#_#referenced_entity_type#_#referenced_entity_name##column_suffix#] FOREIGN KEY (#referencing_key_column#) REFERENCES #referenced_entity_table_name# (#referenced_key_column#);
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesColumnStore_check')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesColumnStore_check'
    ,'Index creation script for ColumnStore (raw vault): check constraints'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER TABLE #entity_table_name# WITH CHECK ADD CONSTRAINT [CK_#entity_type#_#entity_name#_LoadDate] CHECK (([LoadDate] <= [LoadEndDate]));
ALTER TABLE #entity_table_name# WITH CHECK ADD CONSTRAINT [CK_#entity_type#_#entity_name#_LoadEndDate] DEFAULT (''#date_range_end#'') FOR [LoadEndDate];
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesRowStore_hub_link')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesRowStore_hub_link'
    ,'Index creation script for RowStore (raw vault): hub & link tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadDate] ON #entity_table_name# ([LoadDate]) WITH (#index_options#) ON #filegroup_data#;
CREATE UNIQUE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_Key] ON #entity_table_name# (#column_names#) INCLUDE (#key_column#) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesRowStore_sat')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesRowStore_sat'
    ,'Index creation script for RowStore (raw vault): satellite tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadDate] ON #entity_table_name# ([LoadDate]) WITH (#index_options#) ON #filegroup_data#;
CREATE NONCLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadEndDate] ON #entity_table_name# (LoadEndDate, #key_column#) INCLUDE (HashDiff) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC, [LoadDate] ASC) WITH (#index_options#) ON #filegroup_index#;
ALTER TABLE #entity_table_name# WITH CHECK ADD CONSTRAINT [CK_#entity_type#_#entity_name#_LoadDate] CHECK (([LoadDate] <= [LoadEndDate]));
ALTER TABLE #entity_table_name# WITH CHECK ADD CONSTRAINT [CK_#entity_type#_#entity_name#_LoadEndDate] DEFAULT (''#date_range_end#'') FOR [LoadEndDate];
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesRowStore_tsat')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesRowStore_tsat'
    ,'Index creation script for RowStore (raw vault): non-historized satellite tables'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
CREATE CLUSTERED INDEX [IX_#entity_type#_#entity_name#_LoadDate] ON #entity_table_name# ([LoadDate]) WITH (#index_options#) ON #filegroup_data#;
ALTER TABLE #entity_table_name# ADD CONSTRAINT [PK_#entity_type#_#entity_name#] PRIMARY KEY NONCLUSTERED (#key_column# ASC, [LoadDate] ASC) WITH (#index_options#) ON #filegroup_index#;
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'EDWIndexesRowStore_fk')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'EDWIndexesRowStore_fk'
    ,'Index creation script for RowStore (raw vault): foreign keys'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
ALTER TABLE #entity_table_name# WITH #fk_check# ADD CONSTRAINT [FK_#entity_type#_#entity_name#_#referenced_entity_type#_#referenced_entity_name##column_suffix#] FOREIGN KEY (#referencing_key_column#) REFERENCES #referenced_entity_table_name# (#referenced_key_column#);
'
  );

IF NOT EXISTS (SELECT 1 FROM [meta].[Template] WHERE [TemplateId] = 'DropObject')
  INSERT INTO [meta].[Template]
  (
    [TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[LastUpdateTime]
    ,[TemplateText]
  )
  VALUES
  (
    'DropObject'
    ,'Drop object script'
    ,'Protected'
    ,meta.DateRangeStart()
    ,'
EXEC dbo.DropObject @Database = ''#db_name#'', @ObjectSchema = ''#schema#'', @ObjectName = ''#object_name#'', @ObjectType = ''#object_type#'', @PrintOnly = #printonly#;
'
  );


/* Validating current configuration */
PRINT '-- *** Validating current configuration ***';
IF (SELECT COUNT(*) FROM meta.ValidateConfiguration()) != 0
BEGIN
  DECLARE 
    @Msg NVARCHAR(MAX) = CONCAT('Following validation rule(s) did break:', CHAR(13), CHAR(10));
  
  SELECT @Msg += 
  (
    SELECT CONCAT('RuleId: ', RuleId, CHAR(13), CHAR(10), 'RuleCategory: ', RuleCategory, CHAR(13), CHAR(10), 'RuleName: ', RuleName, CHAR(13), CHAR(10), 'Reason: ', Reason, CHAR(13), CHAR(10), 'Configuration Id: ', ConfigurationId, CHAR(13), CHAR(10), 'Current Value: ', ConfigurationValue, CHAR(13), CHAR(10), '-+-+-+-+-+-+-+-+-', CHAR(13), CHAR(10))
    FROM meta.ValidateConfiguration()
    FOR XML PATH('')
  );

  SET @Msg = REPLACE(@Msg, '&#x0D;', '');

  PRINT '-- *** There are validation errors. ***';
  THROW 60000, @Msg, 1;

  RETURN;
END
ELSE
  PRINT '-- *** Validation OK. ***';