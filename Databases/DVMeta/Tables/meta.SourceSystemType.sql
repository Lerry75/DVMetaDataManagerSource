CREATE TABLE [meta].[SourceSystemType]
(
	[SourceSystemTypeId] VARCHAR(3) NOT NULL, 
  [SourceSystemTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL, 
  CONSTRAINT [PK_SourceSystemType] PRIMARY KEY CLUSTERED ([SourceSystemTypeId]) 
)
