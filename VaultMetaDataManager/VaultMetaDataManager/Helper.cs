using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Security;
using System.Runtime.InteropServices;
using VaultMetaDataManager.Properties;

namespace VaultMetaDataManager
{
    public static class Helper
    {
        public static string GetServerName()
        {
            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder(Settings.Default.DVMetaConnectionString);

            return connstring.DataSource;
        }

        public static string GetDatabaseName()
        {
            return Settings.Default.DVMetaDatabaseName;
        }

        public static bool IsIntegratedSecurityConnection()
        {
            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder(Settings.Default.DVMetaConnectionString);

            return connstring.IntegratedSecurity;
        }

        public static string GetUserName()
        {
            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder(Settings.Default.DVMetaConnectionString);

            return connstring.UserID;
        }

        public static string GetPassword()
        {
            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder(Settings.Default.DVMetaConnectionString);

            return connstring.Password;
        }

        public static DataTable Connect(string servername)
        {
            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder();
            connstring.DataSource = servername;
            connstring.IntegratedSecurity = true;

            Settings.Default.DVMetaConnectionString = connstring.ConnectionString;
            Settings.Default.Save();

            return ConnectToServer();
        }

        public static DataTable Connect(string servername, string username, string password)
        {
            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder();
            connstring.DataSource = servername;
            connstring.IntegratedSecurity = false;
            connstring.UserID = username;
            connstring.Password = password;

            Settings.Default.DVMetaConnectionString = connstring.ConnectionString;
            Settings.Default.Save();

            return ConnectToServer();
        }

        public static string GetAdapterConnectionString()
        {
            return GetAdapterConnectionString(Settings.Default.DVMetaDatabaseName);
        }

        public static string GetAdapterConnectionString(string database)
        {
            string ret = null;

            Settings.Default.DVMetaDatabaseName = database;
            Settings.Default.Save();

            SqlConnectionStringBuilder connstring = new SqlConnectionStringBuilder(Settings.Default.DVMetaConnectionString);
            connstring.InitialCatalog = database;

            using (SqlConnection conn = new SqlConnection(connstring.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("select meta.CurrentSchemaVersion()", conn))
            {
                conn.Open();
                string currentversion = (string)cmd.ExecuteScalar();
                conn.Close();

                // Lookup current version against supported versions
                try
                {
                    SchemaVersionMap versionmatch = new SchemaVersion().Versions.Single(item => item.schemaversion == currentversion);

                    if (versionmatch.status == SchemaVersionStatus.Unsupported)
                        throw new Exception("Schema version not supported.\nPlease update database schema.");

                }
                catch (InvalidOperationException ex)
                {
                    throw new Exception("Schema version not supported.", ex);
                }

                ret = connstring.ConnectionString;
            }

            return ret;
        }

        private static DataTable ConnectToServer()
        {
            DataTable dbs;

            using (SqlConnection conn = new SqlConnection(Settings.Default.DVMetaConnectionString))
            {
                conn.Open();
                dbs = conn.GetSchema("Databases");
                conn.Close();
            }

            EnumerableRowCollection<DataRow> sysdbs = dbs.AsEnumerable().Where(r => (r.Field<string>("database_name").Trim().Equals("master")) || 
            (r.Field<string>("database_name").Trim().Equals("msdb")) || 
            (r.Field<string>("database_name").Trim().Equals("tempdb")) || 
            (r.Field<string>("database_name").Trim().Equals("model")));

            foreach (DataRow row in sysdbs.ToList())
                dbs.Rows.Remove(row);

            return dbs;
        }

        private static string GetClearPassword(SecureString password)
        {
            string res;
            int length = password.Length;
            IntPtr pointer = IntPtr.Zero;
            char[] chars = new char[length];

            try
            {
                pointer = Marshal.SecureStringToBSTR(password);
                Marshal.Copy(pointer, chars, 0, length);

                res = string.Join(string.Empty, chars);
            }
            finally
            {
                if (pointer != IntPtr.Zero)
                    Marshal.ZeroFreeBSTR(pointer);
            }

            return res;
        }

    }
}
