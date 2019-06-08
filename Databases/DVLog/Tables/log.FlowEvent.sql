CREATE TABLE [log].[FlowEvent]
(
	[FlowEventId] INT NOT NULL, 
    [FlowEventName] VARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_FlowEvent] PRIMARY KEY CLUSTERED ([FlowEventId]) 
)
