CREATE TABLE [stage].[EDWEntity]
(
	[EntityId] INT NOT NULL, 
	[EntityName] VARCHAR(50) NOT NULL,
  [EntityDescription] VARCHAR(255) NULL,
  [EntityTypeId] VARCHAR(4) NOT NULL, 
	[StorageTypeId] VARCHAR(3) NOT NULL,
	[PartitioningTypeId] CHAR(1) NOT NULL, 
  [CreateEntity] BIT NULL, 
	[LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL 
)
