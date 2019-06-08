CREATE TABLE [meta].[EDWAttribute] (
    [AttributeId]        INT            IDENTITY (1, 1) NOT NULL,
    [AttributeName]      VARCHAR (50)   NOT NULL,
    [EDWEntityId]        INT            NOT NULL,
    [DataTypeId]         INT            NOT NULL,
    [Order]              SMALLINT       NULL,
    [IsStagingOnly]      BIT            NOT NULL,
    [LastUpdateTime]     DATETIME2 (7)  NULL,
    [LastChangeUserName] NVARCHAR (128) NULL,
    CONSTRAINT [PK_EDWAttribute] PRIMARY KEY CLUSTERED ([AttributeId] ASC),
    CONSTRAINT [FK_EDWAttribute_EDWDataType] FOREIGN KEY ([DataTypeId]) REFERENCES [meta].[DataType] ([DataTypeId]),
    CONSTRAINT [FK_EDWAttribute_EDWEntity] FOREIGN KEY ([EDWEntityId]) REFERENCES [meta].[EDWEntity] ([EntityId])
);



GO
CREATE TRIGGER [meta].[EDWAttribute_audit]
ON [meta].[EDWAttribute]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[EDWAttribute] (
    [LoadDate]
    ,[AttributeId]
    ,[AttributeName]
    ,[EDWEntityId]
    ,[DataTypeId]
    ,[Order]
    ,[IsStagingOnly]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[AttributeId]
    ,[AttributeName]
    ,[EDWEntityId]
    ,[DataTypeId]
    ,[Order]
    ,[IsStagingOnly]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.[AttributeId] = d.[AttributeId]);

  INSERT INTO [audit].[EDWAttribute] (
    [LoadDate]
    ,[AttributeId]
    ,[AttributeName]
    ,[EDWEntityId]
    ,[DataTypeId]
    ,[Order]
    ,[IsStagingOnly]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[AttributeId]
    ,[AttributeName]
    ,[EDWEntityId]
    ,[DataTypeId]
    ,[Order]
    ,[IsStagingOnly]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.[AttributeId] = d.[AttributeId]);

  INSERT INTO [audit].[EDWAttribute] (
    [LoadDate]
    ,[AttributeId]
    ,[AttributeName]
    ,[EDWEntityId]
    ,[DataTypeId]
    ,[Order]
    ,[IsStagingOnly]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[AttributeId]
    ,i.[AttributeName]
    ,i.[EDWEntityId]
    ,i.[DataTypeId]
    ,i.[Order]
    ,i.[IsStagingOnly]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.[AttributeId] = d.[AttributeId];

END