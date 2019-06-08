CREATE TABLE [meta].[Process] (
    [ProcessId]          INT            IDENTITY (1, 1) NOT NULL,
    [ProcessName]        VARCHAR (50)   NOT NULL,
    [ProcessDescription] VARCHAR (255)  NULL,
    [ProcessTypeId]      VARCHAR (3)    NOT NULL,
    [SourceSystemTypeId] VARCHAR (3)    NOT NULL,
    [ContactInfo]        VARCHAR (255)  NULL,
    [SupportGroup]       VARCHAR (255)  NULL,
    [LastUpdateTime]     DATETIME2 (7)  NULL,
    [LastChangeUserName] NVARCHAR (128) NULL,
    CONSTRAINT [PK_Process] PRIMARY KEY CLUSTERED ([ProcessId] ASC),
    CONSTRAINT [FK_Process_ProcessType] FOREIGN KEY ([ProcessTypeId]) REFERENCES [meta].[ProcessType] ([ProcessTypeId]),
    CONSTRAINT [FK_Process_SourceSystemType] FOREIGN KEY ([SourceSystemTypeId]) REFERENCES [meta].[SourceSystemType] ([SourceSystemTypeId])
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Process_Key] ON [meta].[Process] ([ProcessName]);

GO
CREATE TRIGGER [meta].[Process_audit]
ON [meta].[Process]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[Process] (
    [LoadDate]
    ,[ProcessId]
    ,[ProcessName]
    ,[ProcessDescription]
    ,[ProcessTypeId]
    ,[SourceSystemTypeId]
    ,[ContactInfo]
    ,[SupportGroup]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[ProcessId]
    ,[ProcessName]
    ,[ProcessDescription]
    ,[ProcessTypeId]
    ,[SourceSystemTypeId]
    ,[ContactInfo]
    ,[SupportGroup]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.[ProcessId] = d.[ProcessId]);

  INSERT INTO [audit].[Process] (
    [LoadDate]
    ,[ProcessId]
    ,[ProcessName]
    ,[ProcessDescription]
    ,[ProcessTypeId]
    ,[SourceSystemTypeId]
    ,[ContactInfo]
    ,[SupportGroup]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[ProcessId]
    ,[ProcessName]
    ,[ProcessDescription]
    ,[ProcessTypeId]
    ,[SourceSystemTypeId]
    ,[ContactInfo]
    ,[SupportGroup]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.[ProcessId] = d.[ProcessId]);

  INSERT INTO [audit].[Process] (
    [LoadDate]
    ,[ProcessId]
    ,[ProcessName]
    ,[ProcessDescription]
    ,[ProcessTypeId]
    ,[SourceSystemTypeId]
    ,[ContactInfo]
    ,[SupportGroup]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[ProcessId]
    ,i.[ProcessName]
    ,i.[ProcessDescription]
    ,i.[ProcessTypeId]
    ,i.[SourceSystemTypeId]
    ,i.[ContactInfo]
    ,i.[SupportGroup]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.[ProcessId] = d.[ProcessId];

END