CREATE TABLE [audit].[Template]
(
  [LoadDate] DATETIME2(7) NOT NULL,
  [TemplateId] VARCHAR(50) NOT NULL,
  [TemplateDescription] VARCHAR(255) NULL,
  [TemplateAttribute] VARCHAR(20) NOT NULL,
  [TemplateText] NVARCHAR(MAX) NOT NULL,
  [UserName] NVARCHAR(128) NULL,
  [Operation] CHAR(6) NOT NULL,
  CONSTRAINT [PK_Template] PRIMARY KEY CLUSTERED ([LoadDate] ASC, [TemplateId] ASC)
);
