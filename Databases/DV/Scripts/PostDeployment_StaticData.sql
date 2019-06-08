/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/* [edw].[Ref_Calendar] */
IF NOT EXISTS (SELECT * FROM edw.Ref_Calendar)
  INSERT INTO edw.Ref_Calendar (
    [LoadDate]
    ,[RecordSource]
    ,[DateKey]
    ,[Date]
    ,[DayOfWeek] 
    ,[DayOfMonth]
    ,[DayOfYear]
    ,[CalendarYear]
    ,[CalendarQuarter]
    ,[CalendarMonth]
    ,[CalendarWeek]
    ,[CalendarYearQuarter]
    ,[CalendarYearMonth]
    ,[CalendarYearWeek]
  )
  SELECT 
    '0001-01-01'
    ,'SYSTEM'
    ,[DateKey]
    ,[Date]
    ,[DayOfWeek] 
    ,[DayOfMonth]
    ,[DayOfYear]
    ,[CalendarYear]
    ,[CalendarQuarter]
    ,[CalendarMonth]
    ,[CalendarWeek]
    ,[CalendarYearQuarter]
    ,[CalendarYearMonth]
    ,[CalendarYearWeek]
  FROM [edw].[GetDates]
  (
    '2000-01-01'
    ,'2025-12-31'
  )
GO

/* [edw].[Ref_Time] */
IF NOT EXISTS (SELECT * FROM edw.Ref_Time)
  INSERT INTO edw.Ref_Time (
    [LoadDate]
    ,[RecordSource]
    ,[TimeKey]
    ,[Time]
    ,[Hour] 
    ,[Minute]
    ,[PartOfDay]
  )
  SELECT 
    '0001-01-01'
    ,'SYSTEM'
    ,[TimeKey]
    ,[Time]
    ,[Hour] 
    ,[Minute]
    ,[PartOfDay]
  FROM [edw].[GetTime]()
GO

/* Populate ghost records */
EXEC dbo.InsertGhostRecords @Force = 0;
GO