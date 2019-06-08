CREATE FUNCTION [meta].[TemplateText]
(
  @TemplateId VARCHAR(50)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN (SELECT [TemplateText] FROM [meta].[Template] WHERE [TemplateId] = @TemplateId);
END
