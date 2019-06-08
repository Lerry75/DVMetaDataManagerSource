CREATE PROCEDURE [meta].[CheckEnvironment]

AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  DECLARE @Environment varchar(20) = (SELECT meta.CurrentEnvironment())
    ,@Msg nvarchar(1024) = 'Operation is not allowed on ''%s'' environment. It must run on Development only.';

  IF UPPER(@Environment) NOT IN ('DEV', 'DEVELOPMENT')
  BEGIN
    SET @Msg = FORMATMESSAGE(@Msg, @Environment);
    THROW 60000, @Msg, 1;
  END
END