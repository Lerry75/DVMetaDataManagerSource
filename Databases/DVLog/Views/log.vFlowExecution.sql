CREATE VIEW [log].[vFlowExecution]

AS 

SELECT ExecStart.[Id]
  ,ExecStart.[LoadDate]
  ,ExecStart.[FlowName]
  ,ExecStart.[ExecutionId]
  ,ExecStart.[ServerExecutionId]
  ,ExecStart.[PackageName]
  ,ExecStart.[PackageId]
  ,ExecStart.[VersionBuild]
  ,[FlowEventId] = ISNULL(ExecEnd.[FlowEventId], ExecStart.[FlowEventId])
  ,[FlowEventStartDate] = ExecStart.[FlowEventDate]
  ,[FlowEventEndDate] = ExecEnd.[FlowEventDate]
FROM [log].[FlowExecution] ExecStart 
  LEFT JOIN [log].[FlowExecution] ExecEnd ON ExecStart.ExecutionId = ExecEnd.ExecutionId
    AND ISNULL(ExecEnd.FlowEventId, 1) != 0
WHERE ExecStart.FlowEventId = 0
