CREATE VIEW [log].[vFlowExecutionError]

AS

SELECT [Id]
  ,[ExecutionId]
  ,[ErrorCode]
  ,[ErrorDescription]
FROM [log].[FlowExecutionError]
WHERE [ErrorCode] != 0
