CREATE TABLE [log].[FlowExecution]
(
	[Id] BIGINT NOT NULL IDENTITY (1, 1), 
    [LoadDate] DATETIME2 NOT NULL, 
    [FlowName] VARCHAR(100) NOT NULL, 
    [ExecutionId] UNIQUEIDENTIFIER NOT NULL, 
	[ServerExecutionId] INT NOT NULL, 
    [PackageName] VARCHAR(100) NOT NULL, 
    [PackageId] UNIQUEIDENTIFIER NOT NULL, 
    [VersionBuild] INT NOT NULL, 
    [FlowEventId] INT NOT NULL, 
    [FlowEventDate] DATETIME2 NOT NULL, 
    CONSTRAINT [PK_FlowExecution] PRIMARY KEY CLUSTERED ([Id]) 
)
