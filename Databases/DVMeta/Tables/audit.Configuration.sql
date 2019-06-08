CREATE TABLE [audit].[Configuration] (
    [LoadDate]    DATETIME2 (7)  NOT NULL,
    [Id]          VARCHAR (50)   NOT NULL,
    [Value]       VARCHAR (50)   NULL,
    [UserName]    NVARCHAR (128) NULL,
    [Operation]   CHAR (6)       NOT NULL
);

