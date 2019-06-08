CREATE TABLE [audit].[Process] (
    [LoadDate]           DATETIME2 (7)  NOT NULL,
    [ProcessId]          INT            NOT NULL,
    [ProcessName]        VARCHAR (50)   NULL,
    [ProcessDescription] VARCHAR (255)  NULL,
    [ProcessTypeId]      VARCHAR (3)    NULL,
    [SourceSystemTypeId] VARCHAR (3)    NULL,
    [ContactInfo]        VARCHAR (255)  NULL,
    [SupportGroup]       VARCHAR (255)  NULL,
    [UserName]           NVARCHAR (100) NULL,
    [Operation]          CHAR (6)       NOT NULL,
    CONSTRAINT [PK_Process] PRIMARY KEY CLUSTERED ([LoadDate] ASC, [ProcessId] ASC)
);

