CREATE TABLE [meta].[EDWEntity] (
    [EntityId]           INT            IDENTITY (1, 1) NOT NULL,
    [EntityName]         VARCHAR (50)   NOT NULL,
    [EntityDescription]  VARCHAR (255)  NULL,
    [EntityTypeId]       VARCHAR (4)    NOT NULL,
    [StorageTypeId]      VARCHAR (3)    NOT NULL,
    [PartitioningTypeId] CHAR (1)       NOT NULL,
    [CreateEntity]       BIT            CONSTRAINT [DF_EDWEntity_CreateEntity] DEFAULT ((1)) NOT NULL,
    [LastUpdateTime]     DATETIME2 (7)  NULL,
    [LastChangeUserName] NVARCHAR (128) NULL,
    CONSTRAINT [PK_EDWEntity] PRIMARY KEY CLUSTERED ([EntityId] ASC),
    CONSTRAINT [FK_EDWEntity_EntityType] FOREIGN KEY ([EntityTypeId]) REFERENCES [meta].[EntityType] ([EntityTypeId]),
    CONSTRAINT [FK_EDWEntity_PartitioningType] FOREIGN KEY ([PartitioningTypeId]) REFERENCES [meta].[PartitioningType] ([PartitioningTypeId]),
    CONSTRAINT [FK_EDWEntity_StorageType] FOREIGN KEY ([StorageTypeId]) REFERENCES [meta].[StorageType] ([StorageTypeId])
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_EDWEntity_Key] ON [meta].[EDWEntity] ([EntityTypeId], [EntityName]);

GO
CREATE TRIGGER [meta].[EDWEntity_audit]
ON [meta].[EDWEntity]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[EDWEntity] (
    [LoadDate]
    ,[EntityId]
    ,[EntityName]
    ,[EntityDescription]
    ,[EntityTypeId]
    ,[StorageTypeId]
    ,[PartitioningTypeId]
    ,[CreateEntity]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[EntityId]
    ,[EntityName]
    ,[EntityDescription]
    ,[EntityTypeId]
    ,[StorageTypeId]
    ,[PartitioningTypeId]
    ,[CreateEntity]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.EntityId = d.EntityId);

  INSERT INTO [audit].[EDWEntity] (
    [LoadDate]
    ,[EntityId]
    ,[EntityName]
    ,[EntityDescription]
    ,[EntityTypeId]
    ,[StorageTypeId]
    ,[PartitioningTypeId]
    ,[CreateEntity]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[EntityId]
    ,[EntityName]
    ,[EntityDescription]
    ,[EntityTypeId]
    ,[StorageTypeId]
    ,[PartitioningTypeId]
    ,[CreateEntity]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.EntityId = d.EntityId);

  INSERT INTO [audit].[EDWEntity] (
    [LoadDate]
    ,[EntityId]
    ,[EntityName]
    ,[EntityDescription]
    ,[EntityTypeId]
    ,[StorageTypeId]
    ,[PartitioningTypeId]
    ,[CreateEntity]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[EntityId]
    ,i.[EntityName]
    ,i.[EntityDescription]
    ,i.[EntityTypeId]
    ,i.[StorageTypeId]
    ,i.[PartitioningTypeId]
    ,i.[CreateEntity]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.EntityId = d.EntityId;

END