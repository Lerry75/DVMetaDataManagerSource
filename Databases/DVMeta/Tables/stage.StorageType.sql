CREATE TABLE [stage].[StorageType]
(
	[StorageTypeId] VARCHAR(3) NOT NULL, 
  [StorageTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
)