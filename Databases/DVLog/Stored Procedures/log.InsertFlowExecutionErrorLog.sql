CREATE PROCEDURE [log].[InsertFlowExecutionErrorLog]
	@ExecutionId uniqueidentifier
	,@ErrorCode int
    ,@ErrorDescription varchar(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO log.FlowExecutionError
  (
    ExecutionId
    ,ErrorCode
    ,ErrorDescription
  )
  VALUES
  (
    @ExecutionId
    ,@ErrorCode
    ,@ErrorDescription
  );
END

GO
GRANT EXECUTE
    ON OBJECT::[log].[InsertFlowExecutionErrorLog] TO [LogWriter]
    AS [dbo];

