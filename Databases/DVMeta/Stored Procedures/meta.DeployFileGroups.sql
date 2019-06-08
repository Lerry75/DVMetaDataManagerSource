CREATE PROCEDURE [meta].[DeployFileGroups]
  @PrintOnly bit = 0

AS

BEGIN
  SET NOCOUNT ON;

  -- Check if Environment is set to Develoment
  EXEC meta.CheckEnvironment;

  -- Valid for on-premises instances only
  IF dbo.SqlInstanceOnPrem() = 0
    RETURN;

  DECLARE 
    @Template nvarchar(MAX) = (SELECT meta.TemplateText('FileGroups'))
	  ,@Sql nvarchar(MAX)
    ,@Database NVARCHAR(50)
    ,@LogicalFileNameStagingData varchar(60) = dbo.NewLogicalFileName(meta.FileGroupData())
    ,@LogicalFileNameStagingIndex varchar(60) = dbo.NewLogicalFileName(meta.FileGroupIndex())
    ,@LogicalFileNameEdwData varchar(60) = dbo.NewLogicalFileName(meta.FileGroupData())
    ,@LogicalFileNameEdwIndex varchar(60) = dbo.NewLogicalFileName(meta.FileGroupIndex());

  -- Replace Placeholders
  SET @Sql = REPLACE(@Template, '#staging_db#', meta.StagingDbName());
  SET @Sql = REPLACE(@Sql, '#edw_db#', meta.WarehouseDbName());
  SET @Sql = REPLACE(@Sql, '#filegroup_data#', meta.FileGroupData());
  SET @Sql = REPLACE(@Sql, '#filegroup_index#', meta.FileGroupIndex());
  SET @Sql = REPLACE(@Sql, '#filegroup_data_no_brackets#', REPLACE(REPLACE(meta.FileGroupData(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#filegroup_index_no_brackets#', REPLACE(REPLACE(meta.FileGroupIndex(), '[', ''), ']', ''));
  SET @Sql = REPLACE(@Sql, '#logical_filename_staging_data#', @LogicalFileNameStagingData);
  SET @Sql = REPLACE(@Sql, '#physical_filename_staging_data#', dbo.PhysicalFileName(meta.StagingDbName(), @LogicalFileNameStagingData));
  SET @Sql = REPLACE(@Sql, '#logical_filename_staging_index#', @LogicalFileNameStagingIndex);
  SET @Sql = REPLACE(@Sql, '#physical_filename_staging_index#', dbo.PhysicalFileName(meta.StagingDbName(), @LogicalFileNameStagingIndex));
  SET @Sql = REPLACE(@Sql, '#logical_filename_edw_data#', @LogicalFileNameEdwData);
  SET @Sql = REPLACE(@Sql, '#physical_filename_edw_data#', dbo.PhysicalFileName(meta.WarehouseDbName(), @LogicalFileNameEdwData));
  SET @Sql = REPLACE(@Sql, '#logical_filename_edw_index#', @LogicalFileNameEdwIndex);
  SET @Sql = REPLACE(@Sql, '#physical_filename_edw_index#', dbo.PhysicalFileName(meta.WarehouseDbName(), @LogicalFileNameEdwIndex));
  SET @Sql = REPLACE(@Sql, '#printonly#', @PrintOnly);

  SET @Database = '[master]';
  EXEC dbo.ExecuteOrPrint
    @Database
	  ,@Sql
	  ,@PrintOnly;

END
