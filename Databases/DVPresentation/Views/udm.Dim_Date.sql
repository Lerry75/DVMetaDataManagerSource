CREATE VIEW [udm].[Dim_Date]

AS

SELECT 
  [DateKey]
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
  ,CASE WHEN [Date] = CONVERT(DATE, SYSDATETIME()) THEN 1 ELSE 0 END [IsCurrent]
FROM [$(DV)].[edw].[Ref_Calendar]
