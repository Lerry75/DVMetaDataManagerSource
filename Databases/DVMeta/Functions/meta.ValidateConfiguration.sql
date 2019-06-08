CREATE FUNCTION [meta].[ValidateConfiguration]()
RETURNS @BrokenRule TABLE
(
  [RuleId] int
  ,[RuleCategory] varchar(50)
  ,[RuleName] varchar(50)
  ,[Reason] varchar(255)
  ,[ConfigurationId] varchar(50)
  ,[ConfigurationValue] varchar(255)
)
AS
BEGIN
  DECLARE @RuleId int
    ,@RuleCategory varchar(50)
    ,@RuleName varchar(50)
    ,@Reason varchar(255);

  -- Rule 1001
  SET @RuleId = 1001;
  SET @RuleCategory = 'Configuration';
  SET @RuleName = 'Different Collations';
  SET @Reason = 'Collations for raw vault and staging databases must be the same.';

  INSERT INTO @BrokenRule
  SELECT
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,[Id]
    ,[Value]
  FROM 
  (
    SELECT 
      [Id] = 'N/A'
      ,[Value] = CONCAT(edw.name, ': ', edw.collation_name, ' / ', stg.name, ': ', stg.collation_name)
    FROM [sys].[databases] edw
      JOIN [sys].[databases] stg ON edw.[database_id] = DB_ID(REPLACE(REPLACE([meta].[WarehouseDbName](), '[', ''), ']', ''))
        AND stg.[database_id] = DB_ID(REPLACE(REPLACE([meta].[StagingDbName](), '[', ''), ']', ''))
    WHERE edw.[collation_name] != stg.[collation_name]
  ) R;

  -- Rule 1002
  SET @RuleId = 1002;
  SET @RuleCategory = 'Configuration';
  SET @RuleName = 'Invalid Hash Delimiter';
  SET @Reason = 'Hash Delimiter cannot contain single quote.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,[Id]
    ,[Value]
  FROM 
  (
    SELECT 
      [Id]
      ,[Value] 
    FROM [meta].[Configuration] 
    WHERE [Id] = 'HashDelimiter'
      AND [Value] LIKE '%''%'
  ) R;

  -- Rule 1003
  SET @RuleId = 1003;
  SET @RuleCategory = 'Configuration';
  SET @RuleName = 'Invalid Configuration Value';
  SET @Reason = 'Configuration value must be set to true/false.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,[Id]
    ,[Value]
  FROM 
  (
    SELECT 
      [Id]
      ,[Value]
    FROM [meta].[Configuration] 
    WHERE [Id] IN ('VirtualizedLoadEndDate', 'DisabledForeignKey', 'CompressRowStore', 'LegacyNonUnicodeInputForHash')
      AND TRY_CONVERT(BIT, LTRIM([Value])) IS NULL
  ) R;

  -- Rule 1004
  SET @RuleId = 1004;
  SET @RuleCategory = 'Configuration';
  SET @RuleName = 'Unsupported Hash Algorithm';
  SET @Reason = 'Supported Hash algorithms are: MD5, SHA, SHA1, SHA2_256, SHA2_512.';

  INSERT INTO @BrokenRule
  SELECT 
    @RuleId
    ,@RuleCategory
    ,@RuleName
    ,@Reason
    ,[Id]
    ,[Value]
  FROM 
  (
    SELECT 
      [Id]
      ,[Value]
    FROM [meta].[Configuration] 
    WHERE [Id] = 'HashAlgorithm'
      AND [Value] NOT IN ('MD5', 'SHA', 'SHA1', 'SHA2_256', 'SHA2_512')
  ) R;

  RETURN;
END
