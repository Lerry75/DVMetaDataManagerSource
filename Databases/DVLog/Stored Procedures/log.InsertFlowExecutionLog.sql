CREATE PROCEDURE [log].[InsertFlowExecutionLog]
	@LoadDate datetime2
	,@FlowName varchar(100)
	,@ExecutionId uniqueidentifier
    ,@PackageName varchar(100)
    ,@PackageId uniqueidentifier
    ,@VersionBuild int
    ,@FlowEventId int
	,@ServerExecutionId int
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO log.FlowExecution
  (
    LoadDate
    ,FlowName
    ,ExecutionId
	,ServerExecutionId
    ,PackageName
    ,PackageId
    ,VersionBuild
    ,FlowEventId
    ,FlowEventDate
  )
  VALUES
  (
    @LoadDate
	,@FlowName
	,@ExecutionId
	,@ServerExecutionId
    ,@PackageName
    ,@PackageId
    ,@VersionBuild
    ,@FlowEventId
    ,SYSDATETIME()
  );
END

GO
GRANT EXECUTE
    ON OBJECT::[log].[InsertFlowExecutionLog] TO [LogWriter]
    AS [dbo];

