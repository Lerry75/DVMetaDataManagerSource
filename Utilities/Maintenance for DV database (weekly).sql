-- **************************************
-- *** Rebuild ColumnStore partitions ***
-- **************************************

USE DV;
GO

declare @sql nvarchar(max)
  ,@template nvarchar(max) = '
ALTER TABLE [#schema#].[#tablename#] REBUILD PARTITION = #partnum#;';

set @sql = 
(
  select replace(replace(REPLACE(@template, '#schema#', schemaName), '#tablename#', tableName), '#partnum#', partition_number)
  from 
  (
    select object_id
      ,OBJECT_SCHEMA_NAME(object_id) schemaName
      ,OBJECT_NAME(object_id) tableName
      ,partition_number
      ,dense_rank() over (partition by object_id order by partition_number desc) rowNum
    from sys.column_store_row_groups 
    group by object_id, partition_number
  ) Z
  where rowNum between 2 and 8
  order by schemaName, tableName
  for xml path('')
)

set @sql = replace(@sql, '&#x0D;', '');

if @sql is not null
  exec sys.sp_executesql @sql;

GO