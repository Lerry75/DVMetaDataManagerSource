CREATE TABLE [stage].[DataType]
(
  [DataTypeId] INT NOT NULL, 
  [DataTypeName] VARCHAR(50) NOT NULL, 
  [Size] INT NULL,
  [Precision] INT NULL,
  [Scale] INT NULL,
  [LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
)
