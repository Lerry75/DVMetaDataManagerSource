CREATE TABLE [stage].[SourceSystemType]
(
	[SourceSystemTypeId] VARCHAR(3) NOT NULL, 
  [SourceSystemTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
)
