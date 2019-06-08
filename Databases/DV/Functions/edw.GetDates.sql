CREATE FUNCTION [edw].[GetDates] 
(	
	@StartDate date
	,@EndDate date
)
RETURNS @Dates TABLE 
(
  [DateKey] int
  ,[Date] date
  ,[DayOfWeek] int
  ,[DayOfMonth] int
  ,[DayOfYear] int
  ,[CalendarYear] int
  ,[CalendarQuarter] int
  ,[CalendarMonth] int
  ,[CalendarWeek] int
  ,[CalendarYearQuarter] char(6)
  ,[CalendarYearMonth] char(7)
  ,[CalendarYearWeek] char(7)
  ,[IsCurrent] bit
)
AS
BEGIN
  DECLARE @Date date = @StartDate
  
  WHILE @Date <= @EndDate
  BEGIN
    INSERT INTO @Dates
	SELECT year(@Date) * 10000 + month(@Date) * 100 + day(@Date)
	  ,@Date
	  ,datepart(dw, @Date)
	  ,DAY(@Date)
	  ,datename(dy, @Date)
	  ,year(@Date)
	  ,DATENAME(qq, @Date)
	  ,month(@Date)
	  ,datepart(week, @Date)
	  ,CAST(YEAR(@Date) AS CHAR(4)) + 'Q' + DATENAME(qq, @Date)
	  ,CAST(YEAR(@Date) AS CHAR(4)) + '-' + RIGHT('00' + RTRIM(CAST(DATEPART(mm, @Date) AS CHAR(2))), 2)
	  ,CAST(YEAR(@Date) AS CHAR(4)) + 'w' + RIGHT('00' + RTRIM(CAST(DATEPART(week, @Date) AS CHAR(2))), 2)
	  ,CASE WHEN @Date = convert(date, getdate()) THEN 1 ELSE 0 END

    SET @Date = DATEADD(d, 1, @Date);
  END

  RETURN 
END