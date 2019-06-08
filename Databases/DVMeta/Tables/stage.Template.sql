CREATE TABLE [stage].[Template]
(
  [TemplateId] VARCHAR(50) NOT NULL,
  [TemplateDescription] VARCHAR(255) NULL,
  [TemplateAttribute] VARCHAR(20) NOT NULL,
  [TemplateText] NVARCHAR(MAX) NOT NULL,
  [LastUpdateTime] DATETIME2(7) NULL,
  [LastChangeUserName] NVARCHAR(128) NULL
);
