CREATE TABLE [meta].[ProcessType]
(
	[ProcessTypeId] VARCHAR(3) NOT NULL, 
  [ProcessTypeName] VARCHAR(50) NOT NULL, 
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL, 
  CONSTRAINT [PK_ProcessType] PRIMARY KEY CLUSTERED ([ProcessTypeId]) 
)
