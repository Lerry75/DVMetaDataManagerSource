CREATE TABLE [log].[FlowExecutionError]
(
	[Id] BIGINT NOT NULL IDENTITY (1, 1), 
	[ExecutionId] UNIQUEIDENTIFIER NOT NULL, 
	[ErrorCode] INT NOT NULL,
    [ErrorDescription] VARCHAR(MAX) NOT NULL, 
    CONSTRAINT [PK_FlowExecutionError] PRIMARY KEY CLUSTERED ([Id]) 
)
