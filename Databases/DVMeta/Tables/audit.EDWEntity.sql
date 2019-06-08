CREATE TABLE [audit].[EDWEntity] (
    [LoadDate]           DATETIME2 (7)  NOT NULL,
    [EntityId]           INT            NOT NULL,
    [EntityName]         VARCHAR (50)   NULL,
    [EntityDescription]  VARCHAR (255)  NULL,
    [EntityTypeId]       VARCHAR (4)    NULL,
    [StorageTypeId]      VARCHAR (3)    NULL,
    [PartitioningTypeId] CHAR (1)       NULL,
    [CreateEntity]       BIT            NULL,
    [UserName]           NVARCHAR (128) NULL,
    [Operation]          CHAR (6)       NOT NULL,
    CONSTRAINT [PK_EDWEntity] PRIMARY KEY CLUSTERED ([LoadDate] ASC, [EntityId] ASC)
);

