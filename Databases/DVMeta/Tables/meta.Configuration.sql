CREATE TABLE [meta].[Configuration] (
    [Id]          VARCHAR (50)  NOT NULL,
    [Value]       VARCHAR (50)  NOT NULL,
    [Description] VARCHAR (MAX) NULL
);



GO
CREATE TRIGGER [meta].[Configuration_audit]
ON [meta].[Configuration]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[Configuration] (
    [LoadDate]
    ,[Id]
    ,[Value]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[Id]
    ,[Value]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.[Id] = d.[Id]);

  INSERT INTO [audit].[Configuration] (
    [LoadDate]
    ,[Id]
    ,[Value]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[Id]
    ,[Value]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.[Id] = d.[Id]);

  INSERT INTO [audit].[Configuration] (
    [LoadDate]
    ,[Id]
    ,[Value]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[Id]
    ,i.[Value]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.[Id] = d.[Id];

END