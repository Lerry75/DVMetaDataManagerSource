CREATE TABLE [audit].[EDWAttribute] (
    [LoadDate]      DATETIME2 (7)  NOT NULL,
    [AttributeId]   INT            NOT NULL,
    [AttributeName] VARCHAR (50)   NULL,
    [EDWEntityId]   INT            NULL,
    [DataTypeId]    INT            NULL,
    [Order]         SMALLINT       NULL,
    [IsStagingOnly] BIT            NULL,
    [UserName]      NVARCHAR (128) NULL,
    [Operation]     CHAR (6)       NOT NULL,
    CONSTRAINT [PK_EDWAttribute] PRIMARY KEY CLUSTERED ([LoadDate] ASC, [AttributeId] ASC)
);

