ALTER ROLE [db_ddladmin] ADD MEMBER [DsaWriter];
GO

ALTER ROLE [db_datawriter] ADD MEMBER [DsaWriter];
GO

ALTER ROLE [db_datareader] ADD MEMBER [DsaWriter];
GO