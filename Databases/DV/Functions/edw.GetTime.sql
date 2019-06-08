CREATE FUNCTION [edw].[GetTime] ()
RETURNS @Time TABLE 
(
  [TimeKey] int
  ,[Time] time
  ,[Hour] smallint
  ,[Minute] smallint
  ,[PartOfDay] char(2)
)
AS
BEGIN
  DECLARE @Hour smallint = 0
    ,@Minute smallint = 0

  WHILE @Hour < 24
  BEGIN
    WHILE @Minute < 60
	BEGIN
      INSERT INTO @Time
	  SELECT @Hour * 100 + @Minute
	    ,TIMEFROMPARTS(@Hour, @Minute, 0, 0, 0)
		,@Hour
		,@Minute
	    ,CASE WHEN @Hour < 12 THEN 'AM' ELSE 'PM' END

      SET @Minute = @Minute + 1;
	END

	SET @Minute = 0;
	SET @Hour = @Hour + 1;
  END

  RETURN
END
