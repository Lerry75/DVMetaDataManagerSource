CREATE TABLE [stage].[Process]
(
	[ProcessId] INT NOT NULL, 
	[ProcessName] VARCHAR(50) NOT NULL,
	[ProcessDescription] VARCHAR(255) NULL,
  [ProcessTypeId] VARCHAR(3) NOT NULL, 
	[SourceSystemTypeId] VARCHAR(3) NOT NULL,
  [ContactInfo] VARCHAR(255) NULL,
  [SupportGroup] VARCHAR(255) NULL,
	[LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
)
