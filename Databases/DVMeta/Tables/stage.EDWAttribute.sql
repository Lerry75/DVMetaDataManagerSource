
CREATE TABLE [stage].[EDWAttribute]
(
	[AttributeId] INT NOT NULL, 
  [AttributeName] VARCHAR(50) NOT NULL, 
  [EDWEntityId] INT NOT NULL, 
  [DataTypeId] INT NOT NULL, 
  [Order] SMALLINT NULL, 
  [IsStagingOnly] BIT NOT NULL, 
	[LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL 
)
