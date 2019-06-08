CREATE TABLE [meta].[PartitioningType]
(
	[PartitioningTypeId] CHAR(1) NOT NULL, 
  [PartitioningTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL, 
  CONSTRAINT [PK_PartitioningType] PRIMARY KEY CLUSTERED ([PartitioningTypeId]) 
)