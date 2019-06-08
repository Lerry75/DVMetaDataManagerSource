CREATE FUNCTION [meta].[ColumnForHash]
(
  @ColumnName varchar(255)
	,@DataTypeId int
)
RETURNS varchar(500)
AS
BEGIN
  SET @ColumnName = LTRIM(RTRIM(@ColumnName));

  IF NOT 
     (
      LEFT(@ColumnName, 1) = '@'
        OR 
        (
          LEFT(@ColumnName, 1) = '['
            AND RIGHT(@ColumnName, 1) = ']'
        )
      )
    SET @ColumnName = CONCAT('[', @ColumnName, ']');

	RETURN
    CASE 
      WHEN @DataTypeId IN (13, 14, 22) THEN CONCAT('FORMAT(', @ColumnName, ', ''G'', ''', meta.HashCulture(), ''')')
      WHEN @DataTypeId IN (15, 16, 17, 18) THEN CONCAT('FORMAT(', @ColumnName, ', ''O'')')
      WHEN @DataTypeId IN (19) THEN CONCAT('FORMAT(', @ColumnName, ', ''hh\:mm\:ss\.fffffff'')')
      ELSE @ColumnName
    END;
END
