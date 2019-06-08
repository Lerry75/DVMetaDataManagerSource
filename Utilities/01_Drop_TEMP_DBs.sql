USE [DVMeta];

-- *****************************************
-- *****************************************
-- *** PLEASE, INSERT YOUR USERNAME HERE ***
-- *****************************************
-- *****************************************
DECLARE @User nvarchar(10) = 'Francesco'

  ,@Instance nvarchar(MAX) = @@SERVICENAME
  ,@Dwh_db nvarchar(255) = (SELECT meta.WarehouseDbName())
  ,@Dwh_db_no_brackets nvarchar(255) = (SELECT REPLACE(REPLACE(meta.WarehouseDbName(), '[', ''), ']', ''))
  ,@Staging_db nvarchar(255) = (SELECT meta.StagingDbName())
  ,@Staging_db_no_brackets nvarchar(255) = (SELECT REPLACE(REPLACE(meta.StagingDbName(), '[', ''), ']', ''))
  ,@Filegroup_data nvarchar(255) = (SELECT meta.FileGroupData())
  ,@Filegroup_data_no_brackets nvarchar(255) = (SELECT REPLACE(REPLACE(meta.FileGroupData(), '[', ''), ']', ''))
  ,@Filegroup_index nvarchar(255) = (SELECT meta.FileGroupIndex())
  ,@Filegroup_index_no_brackets nvarchar(255) = (SELECT REPLACE(REPLACE(meta.FileGroupIndex(), '[', ''), ']', ''))
  ,@Sql nvarchar(MAX);

SET @Sql = '
USE [master];

IF db_id(''#edw_db_no_brackets#'') IS NOT NULL
BEGIN
  ALTER DATABASE #edw_db# SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE #edw_db#;
END

IF db_id(''#staging_db_no_brackets#'') IS NOT NULL
BEGIN
  ALTER DATABASE #staging_db# SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE #staging_db#;
END
';
SET @Sql = REPLACE(REPLACE(REPLACE(REPLACE(@Sql, '#edw_db_no_brackets#', @Dwh_db_no_brackets), '#edw_db#', @Dwh_db), '#staging_db_no_brackets#', @Staging_db_no_brackets), '#staging_db#', @Staging_db);
EXEC sys.sp_executesql @Sql;

SET @Sql = '
CREATE DATABASE #edw_db#
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N''#edw_db_no_brackets#'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##edw_db_no_brackets#_Primary.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP #filegroup_data#  DEFAULT
( NAME = N''#filegroup_data_no_brackets#_1C9BF37F'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##edw_db_no_brackets#_#filegroup_data_no_brackets#_1C9BF37F.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP #filegroup_index# 
( NAME = N''#filegroup_index_no_brackets#_737CCF85'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##edw_db_no_brackets#_#filegroup_index_no_brackets#_737CCF85.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N''#edw_db_no_brackets#_log'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##edw_db_no_brackets#_Primary.ldf'' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
';
SET @Sql = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Sql, '#user#', @User), '#instance#', @Instance), '#edw_db#', @Dwh_db), '#edw_db_no_brackets#', @Dwh_db_no_brackets), '#filegroup_data#', @Filegroup_data), '#filegroup_data_no_brackets#', @Filegroup_data_no_brackets), '#filegroup_index#', @Filegroup_index), '#filegroup_index_no_brackets#', @Filegroup_index_no_brackets);
EXEC sys.sp_executesql @Sql;

SET @Sql = '
IF db_id(''#staging_db_no_brackets#'') IS NULL
  CREATE DATABASE #staging_db#
   CONTAINMENT = NONE
   ON  PRIMARY 
  ( NAME = N''#staging_db_no_brackets#'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##staging_db_no_brackets#_Primary.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
   FILEGROUP #filegroup_data#  DEFAULT
  ( NAME = N''#filegroup_data_no_brackets#_6E3F24A6'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##staging_db_no_brackets#_#filegroup_data_no_brackets#_6E3F24A6.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
   FILEGROUP #filegroup_index# 
  ( NAME = N''#filegroup_index_no_brackets#_737CCF86'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##staging_db_no_brackets#_#filegroup_index_no_brackets#_737CCF86.mdf'' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
   LOG ON 
  ( NAME = N''#staging_db_no_brackets#_log'', FILENAME = N''C:\Users\#user#\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\#instance##staging_db_no_brackets#_Primary.ldf'' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
';
SET @Sql = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Sql, '#user#', @User), '#instance#', @Instance), '#staging_db#', @Staging_db), '#staging_db_no_brackets#', @Staging_db_no_brackets), '#filegroup_data#', @Filegroup_data), '#filegroup_data_no_brackets#', @Filegroup_data_no_brackets), '#filegroup_index#', @Filegroup_index), '#filegroup_index_no_brackets#', @Filegroup_index_no_brackets);
EXEC sys.sp_executesql @Sql;

SET @Sql = '
ALTER DATABASE #edw_db# SET ANSI_NULL_DEFAULT ON;
ALTER DATABASE #edw_db# SET ANSI_NULLS ON;
ALTER DATABASE #edw_db# SET ANSI_PADDING ON;
ALTER DATABASE #edw_db# SET ANSI_WARNINGS ON;
ALTER DATABASE #edw_db# SET ARITHABORT ON;
ALTER DATABASE #edw_db# SET AUTO_CLOSE OFF;
ALTER DATABASE #edw_db# SET AUTO_SHRINK OFF;
ALTER DATABASE #edw_db# SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE #edw_db# SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE #edw_db# SET CURSOR_DEFAULT  LOCAL;
ALTER DATABASE #edw_db# SET CONCAT_NULL_YIELDS_NULL ON;
ALTER DATABASE #edw_db# SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE #edw_db# SET QUOTED_IDENTIFIER ON;
ALTER DATABASE #edw_db# SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE #edw_db# SET DISABLE_BROKER;
ALTER DATABASE #edw_db# SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
ALTER DATABASE #edw_db# SET DATE_CORRELATION_OPTIMIZATION OFF;
ALTER DATABASE #edw_db# SET TRUSTWORTHY ON;
ALTER DATABASE #edw_db# SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE #edw_db# SET PARAMETERIZATION SIMPLE;
ALTER DATABASE #edw_db# SET READ_COMMITTED_SNAPSHOT ON;
ALTER DATABASE #edw_db# SET HONOR_BROKER_PRIORITY OFF;
ALTER DATABASE #edw_db# SET RECOVERY SIMPLE;
ALTER DATABASE #edw_db# SET MULTI_USER;
ALTER DATABASE #edw_db# SET PAGE_VERIFY NONE;
ALTER DATABASE #edw_db# SET DB_CHAINING OFF;
ALTER DATABASE #edw_db# SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF );
ALTER DATABASE #edw_db# SET TARGET_RECOVERY_TIME = 0 SECONDS;
';

-- NO 2012
IF CONVERT(INT, @@MICROSOFTVERSION / 0x01000000) > 11
  SET @Sql += 'ALTER DATABASE #edw_db# SET DELAYED_DURABILITY = DISABLED;';

 -- NO 2012, 2014
IF CONVERT(INT, @@MICROSOFTVERSION / 0x01000000) > 12
  SET @Sql += 'ALTER DATABASE #edw_db# SET QUERY_STORE = OFF;';

SET @Sql = REPLACE(@Sql, '#edw_db#', @Dwh_db);
EXEC sys.sp_executesql @Sql;


SET @Sql = '
USE #edw_db#;
';
-- NO 2012, 2014
IF CONVERT(INT, @@MICROSOFTVERSION / 0x01000000) > 12
  SET @Sql += '
  ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
  ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
  ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
  ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
';

SET @Sql += '
ALTER DATABASE #edw_db# SET READ_WRITE;
';
SET @Sql = REPLACE(@Sql, '#edw_db#', @Dwh_db);
EXEC sys.sp_executesql @Sql;


SET @Sql = '
USE [master];
ALTER DATABASE #staging_db# SET ANSI_NULL_DEFAULT ON;
ALTER DATABASE #staging_db# SET ANSI_NULLS ON;
ALTER DATABASE #staging_db# SET ANSI_PADDING ON;
ALTER DATABASE #staging_db# SET ANSI_WARNINGS ON;
ALTER DATABASE #staging_db# SET ARITHABORT ON;
ALTER DATABASE #staging_db# SET AUTO_CLOSE OFF;
ALTER DATABASE #staging_db# SET AUTO_SHRINK OFF;
ALTER DATABASE #staging_db# SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE #staging_db# SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE #staging_db# SET CURSOR_DEFAULT  LOCAL;
ALTER DATABASE #staging_db# SET CONCAT_NULL_YIELDS_NULL ON;
ALTER DATABASE #staging_db# SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE #staging_db# SET QUOTED_IDENTIFIER ON;
ALTER DATABASE #staging_db# SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE #staging_db# SET DISABLE_BROKER;
ALTER DATABASE #staging_db# SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
ALTER DATABASE #staging_db# SET DATE_CORRELATION_OPTIMIZATION OFF;
ALTER DATABASE #staging_db# SET TRUSTWORTHY ON;
ALTER DATABASE #staging_db# SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE #staging_db# SET PARAMETERIZATION SIMPLE;
ALTER DATABASE #staging_db# SET READ_COMMITTED_SNAPSHOT ON;
ALTER DATABASE #staging_db# SET HONOR_BROKER_PRIORITY OFF;
ALTER DATABASE #staging_db# SET RECOVERY SIMPLE;
ALTER DATABASE #staging_db# SET MULTI_USER;
ALTER DATABASE #staging_db# SET PAGE_VERIFY NONE; 
ALTER DATABASE #staging_db# SET DB_CHAINING OFF;
ALTER DATABASE #staging_db# SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF );
ALTER DATABASE #staging_db# SET TARGET_RECOVERY_TIME = 0 SECONDS;
';

-- NO 2012
IF dbo.SqlInstanceMajorVersion() > 11
  SET @Sql += 'ALTER DATABASE #staging_db# SET DELAYED_DURABILITY = DISABLED;';

-- NO 2012, 2014
IF dbo.SqlInstanceMajorVersion() > 12
  SET @Sql += 'ALTER DATABASE #staging_db# SET QUERY_STORE = OFF;';

SET @Sql = REPLACE(@Sql, '#staging_db#', @Staging_db);
EXEC sys.sp_executesql @Sql;


SET @Sql = '
USE #staging_db#;
';

-- NO 2012, 2014
IF CONVERT(INT, @@MICROSOFTVERSION / 0x01000000) > 12
  SET @Sql += '
  ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
  ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
  ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
  ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
  ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
';

SET @Sql += '
ALTER DATABASE #staging_db# SET READ_WRITE;
';
SET @Sql = REPLACE(@Sql, '#staging_db#', @Staging_db);
EXEC sys.sp_executesql @Sql;