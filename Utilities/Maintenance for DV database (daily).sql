-- *****************************************
-- *** Reorganize ColumnStore partitions ***
-- *****************************************
-- Specific for Sql Server 2016/2017

USE DV;
GO

declare @sql nvarchar(max)
  ,@template nvarchar(max) = '
ALTER INDEX [#indexname#] ON [#schema#].[#tablename#] REORGANIZE PARTITION = #partnum# WITH (COMPRESS_ALL_ROW_GROUPS = ON);';

set @sql = 
(
  select replace(replace(replace(REPLACE(@template, '#schema#', schemaName), '#tablename#', tableName), '#partnum#', partition_number), '#indexname#', indexName)
  from 
  (
    select a.object_id
      ,OBJECT_SCHEMA_NAME(a.object_id) schemaName
      ,OBJECT_NAME(a.object_id) tableName
      ,b.name indexName
      ,a.partition_number
      ,dense_rank() over (partition by a.object_id order by a.partition_number desc) rowNum
    from sys.column_store_row_groups a
      join sys.indexes b on a.object_id = b.object_id
        and a.index_id = b.index_id
    where 
    (
      a.state = 1 -- OPEN RowGroups
      OR a.deleted_rows != 0
    )
      and b.type = 5  -- CLUSTERED COLUMNSTORE type
    group by a.object_id, b.name, a.partition_number
  ) Z
  where rowNum > 1
  order by schemaName, tableName
  for xml path('')
)

set @sql = replace(@sql, '&#x0D;', '');

if @sql is not null
  exec sys.sp_executesql @sql;

GO