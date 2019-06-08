CREATE TABLE [meta].[ProcessEntityRelationship] (
    [ProcessEntityRelationshipId] INT            IDENTITY (1, 1) NOT NULL,
    [ProcessId]                   INT            NOT NULL,
    [EntityId]                    INT            NOT NULL,
    [LastUpdateTime]              DATETIME2 (7)  NULL,
    [LastChangeUserName]          NVARCHAR (128) NULL,
    CONSTRAINT [PK_ProcessEntityRelationship] PRIMARY KEY CLUSTERED ([ProcessEntityRelationshipId] ASC),
    CONSTRAINT [FK_ProcessEntityRelationship_EntityId_EDWEntity] FOREIGN KEY ([EntityId]) REFERENCES [meta].[EDWEntity] ([EntityId]),
    CONSTRAINT [FK_ProcessEntityRelationship_ProcessId_Process] FOREIGN KEY ([ProcessId]) REFERENCES [meta].[Process] ([ProcessId])
);



GO
CREATE TRIGGER [meta].[ProcessEntityRelationship_audit]
ON [meta].[ProcessEntityRelationship]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[ProcessEntityRelationship] (
    [LoadDate]
    ,[ProcessEntityRelationshipId]
    ,[ProcessId]
    ,[EntityId]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[ProcessEntityRelationshipId]
    ,[ProcessId]
    ,[EntityId]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.[ProcessEntityRelationshipId] = d.[ProcessEntityRelationshipId]);

  INSERT INTO [audit].[ProcessEntityRelationship] (
    [LoadDate]
    ,[ProcessEntityRelationshipId]
    ,[ProcessId]
    ,[EntityId]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[ProcessEntityRelationshipId]
    ,[ProcessId]
    ,[EntityId]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.[ProcessEntityRelationshipId] = d.[ProcessEntityRelationshipId]);

  INSERT INTO [audit].[ProcessEntityRelationship] (
    [LoadDate]
    ,[ProcessEntityRelationshipId]
    ,[ProcessId]
    ,[EntityId]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[ProcessEntityRelationshipId]
    ,i.[ProcessId]
    ,i.[EntityId]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.[ProcessEntityRelationshipId] = d.[ProcessEntityRelationshipId];

END