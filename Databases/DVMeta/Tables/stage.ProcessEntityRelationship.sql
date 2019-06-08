CREATE TABLE [stage].[ProcessEntityRelationship]
(
	[ProcessEntityRelationshipId] INT NOT NULL, 
  [ProcessId] INT NOT NULL, 
  [EntityId] INT NOT NULL, 
	[LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
)
