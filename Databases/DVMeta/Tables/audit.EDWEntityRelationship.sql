CREATE TABLE [audit].[EDWEntityRelationship] (
    [LoadDate]             DATETIME2 (7)  NOT NULL,
    [EntityRelationshipId] INT            NOT NULL,
    [HubLnk]               INT            NULL,
    [UsedBy]               INT            NULL,
    [HashKeySuffix]        VARCHAR (50)   NULL,
    [UserName]             NVARCHAR (128) NULL,
    [Operation]            CHAR (6)       NOT NULL,
    CONSTRAINT [PK_EDWEntityRelationship] PRIMARY KEY CLUSTERED ([LoadDate] ASC, [EntityRelationshipId] ASC)
);

