CREATE FUNCTION [meta].[CleanSuffix]
(
	@Suffix varchar(50)
)
RETURNS varchar(51)
AS
BEGIN
	RETURN CASE WHEN LTRIM(RTRIM(ISNULL(@Suffix, ''))) != '' THEN CONCAT('_', @Suffix) ELSE '' END;
END
