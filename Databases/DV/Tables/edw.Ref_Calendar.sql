CREATE TABLE [edw].[Ref_Calendar]
(
	[DateKey] INT NOT NULL , 
    [LoadDate] DATETIME2 NOT NULL, 
    [RecordSource] VARCHAR(50) NOT NULL,
    [Date] DATE NOT NULL, 
    [DayOfWeek] INT NOT NULL, 
	[DayOfMonth] INT NOT NULL,
	[DayOfYear] INT NOT NULL,
	[CalendarYear] INT NOT NULL,
	[CalendarQuarter] INT NOT NULL,
	[CalendarMonth] INT NOT NULL,
	[CalendarWeek] INT NOT NULL,
	[CalendarYearQuarter] CHAR(6) NOT NULL,
	[CalendarYearMonth] CHAR(7) NOT NULL,
    [CalendarYearWeek] CHAR(7) NOT NULL, 
    CONSTRAINT [PK_Ref_Calendar] PRIMARY KEY NONCLUSTERED ([DateKey]) WITH (DATA_COMPRESSION = ROW) ON [INDEX]
) WITH (DATA_COMPRESSION = ROW);

GO

CREATE CLUSTERED INDEX [IX_Ref_Calendar_LoadDate] ON [edw].[Ref_Calendar] ([LoadDate]) WITH (DATA_COMPRESSION = ROW) ON [DATA];

GO

CREATE UNIQUE INDEX [IX_Ref_Calendar_Key] ON [edw].[Ref_Calendar] ([Date]) WITH (DATA_COMPRESSION = ROW) ON [INDEX];

GO