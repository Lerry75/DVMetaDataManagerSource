CREATE TABLE [meta].[EntityType]
(
	[EntityTypeId] VARCHAR(4) NOT NULL, 
  [EntityTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL, 
  CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED ([EntityTypeId]) 
)
