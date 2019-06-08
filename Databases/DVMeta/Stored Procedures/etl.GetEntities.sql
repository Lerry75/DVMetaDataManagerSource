CREATE PROCEDURE [etl].[GetEntities]
  @ProcessId int

AS
BEGIN
  SET NOCOUNT ON;

  SELECT EntityId
  FROM meta.ProcessEntityRelationship 
  WHERE ProcessId = @ProcessId;

END