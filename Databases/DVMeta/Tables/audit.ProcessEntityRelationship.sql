CREATE TABLE [audit].[ProcessEntityRelationship] (
    [LoadDate]                    DATETIME2 (7)  NOT NULL,
    [ProcessEntityRelationshipId] INT            NOT NULL,
    [ProcessId]                   INT            NULL,
    [EntityId]                    INT            NULL,
    [UserName]                    NVARCHAR (128) NULL,
    [Operation]                   CHAR (6)       NOT NULL,
    CONSTRAINT [PK_ProcessEntityRelationship] PRIMARY KEY CLUSTERED ([LoadDate] ASC, [ProcessEntityRelationshipId] ASC)
);

