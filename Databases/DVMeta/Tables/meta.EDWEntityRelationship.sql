CREATE TABLE [meta].[EDWEntityRelationship] (
    [EntityRelationshipId] INT            IDENTITY (1, 1) NOT NULL,
    [HubLnk]               INT            NOT NULL,
    [UsedBy]               INT            NOT NULL,
    [HashKeySuffix]        VARCHAR (50)   NULL,
    [LastUpdateTime]       DATETIME2 (7)  NULL,
    [LastChangeUserName]   NVARCHAR (128) NULL,
    CONSTRAINT [PK_EDWEntityRelationship] PRIMARY KEY CLUSTERED ([EntityRelationshipId] ASC),
    CONSTRAINT [FK_EDWEntityRelationship_HubLnk_EDWEntity] FOREIGN KEY ([HubLnk]) REFERENCES [meta].[EDWEntity] ([EntityId]),
    CONSTRAINT [FK_EDWEntityRelationship_UsedBy_EDWEntity] FOREIGN KEY ([UsedBy]) REFERENCES [meta].[EDWEntity] ([EntityId])
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_EDWEntityRelationship_Key] ON [meta].[EDWEntityRelationship] ([HubLnk], [UsedBy], [HashKeySuffix]);

GO
CREATE TRIGGER [meta].[EDWEntityRelationship_audit]
ON [meta].[EDWEntityRelationship]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[EDWEntityRelationship] (
    [LoadDate]
    ,[EntityRelationshipId]
    ,[HubLnk]
    ,[UsedBy]
    ,[HashKeySuffix]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[EntityRelationshipId]
    ,[HubLnk]
    ,[UsedBy]
    ,[HashKeySuffix]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.[EntityRelationshipId] = d.[EntityRelationshipId]);

  INSERT INTO [audit].[EDWEntityRelationship] (
    [LoadDate]
    ,[EntityRelationshipId]
    ,[HubLnk]
    ,[UsedBy]
    ,[HashKeySuffix]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[EntityRelationshipId]
    ,[HubLnk]
    ,[UsedBy]
    ,[HashKeySuffix]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.[EntityRelationshipId] = d.[EntityRelationshipId]);

  INSERT INTO [audit].[EDWEntityRelationship] (
    [LoadDate]
    ,[EntityRelationshipId]
    ,[HubLnk]
    ,[UsedBy]
    ,[HashKeySuffix]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[EntityRelationshipId]
    ,i.[HubLnk]
    ,i.[UsedBy]
    ,i.[HashKeySuffix]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.[EntityRelationshipId] = d.[EntityRelationshipId];

END