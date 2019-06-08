CREATE PROCEDURE [etl].[GetProcessType]
  @ProcessId int

AS
BEGIN
  SET NOCOUNT ON;

  SELECT ProcessTypeId
  FROM meta.Process 
  WHERE ProcessId = @ProcessId;

END