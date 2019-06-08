CREATE TABLE [meta].[DataTypeMapping] (
  [DataTypeId]  INT          NOT NULL,
  [SqlDataType] VARCHAR (50) NOT NULL,
  CONSTRAINT [PK_DataTypeMapping] PRIMARY KEY CLUSTERED ([DataTypeId] ASC)
);

