CREATE TABLE [meta].[Template]
(
  [TemplateId] VARCHAR(50) NOT NULL,
  [TemplateDescription] VARCHAR(255) NULL,
  [TemplateAttribute] VARCHAR(20) NOT NULL,
  [TemplateText] NVARCHAR(MAX) NOT NULL,
  [LastUpdateTime] DATETIME2(7) NULL,
  [LastChangeUserName] NVARCHAR(128) NULL,
  CONSTRAINT [PK_Template] PRIMARY KEY CLUSTERED ([TemplateId] ASC)
);

GO

CREATE TRIGGER [meta].[Template_audit]
ON [meta].[Template]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

  INSERT INTO [audit].[Template] (
    [LoadDate]
    ,[TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[TemplateText]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[TemplateText]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'INSERT'
  FROM inserted i
  WHERE NOT EXISTS (
    SELECT *
    FROM deleted d
    WHERE i.[TemplateId] = d.[TemplateId]);

  INSERT INTO [audit].[Template] (
    [LoadDate]
    ,[TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[TemplateText]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,[TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[TemplateText]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'DELETE'
  FROM deleted i
  WHERE NOT EXISTS (
    SELECT *
    FROM inserted d
    WHERE i.[TemplateId] = d.[TemplateId]);

  INSERT INTO [audit].[Template] (
    [LoadDate]
    ,[TemplateId]
    ,[TemplateDescription]
    ,[TemplateAttribute]
    ,[TemplateText]
    ,[UserName]
    ,[Operation])
  SELECT 
    [LoadDate] = SYSUTCDATETIME()
    ,i.[TemplateId]
    ,i.[TemplateDescription]
    ,i.[TemplateAttribute]
    ,i.[TemplateText]
    ,[UserName] = CURRENT_USER
    ,[Operation] = 'UPDATE'
  FROM inserted i
    INNER JOIN deleted d ON i.[TemplateId] = d.[TemplateId];

END