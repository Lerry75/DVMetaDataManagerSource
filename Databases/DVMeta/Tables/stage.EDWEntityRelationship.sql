CREATE TABLE [stage].[EDWEntityRelationship]
(
	[EntityRelationshipId] INT NOT NULL, 
  [HubLnk] INT NOT NULL, 
  [UsedBy] INT NOT NULL, 
  [HashKeySuffix] VARCHAR(50) NULL,
	[LastUpdateTime] DATETIME2 NULL, 
  [LastChangeUserName] NVARCHAR(128) NULL
)
