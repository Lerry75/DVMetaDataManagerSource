using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

public static class MetaAdapter
{
    public static int ProcessId;
    public static string ServerName;
    public static string MetaCatalog;

    public static string GetRawSchema()
    {
        string ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "select meta.WarehouseRawSchema();";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                ret = (string)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }

    public static string GetBusinessSchema()
    {
        string ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "select meta.WarehouseBusinessSchema();";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                ret = (string)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }


    public static string GetErrorSchema()
    {
        string ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "select meta.WarehouseErrorSchema();";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                ret = (string)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }

    
    public static bool GetVirtualizedLoadEndDate()
    {
        bool ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "select meta.VirtualizedLoadEndDate();";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                ret = (bool)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }


    public static string GetDateRangeEnd()
    {
        string ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "select meta.DateRangeEnd();";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                ret = (string)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }


    public static string GetProcessType()
    {
        string ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "etl.GetProcessType";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                //cmd.CommandTimeout = 60;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ProcessId", SqlDbType.Int).Value = ProcessId;
                ret = (string)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }

    
    public static string EntityTableNameLookupError(int EntityId, int ReferencedEntityId, string HashKeySuffix)
    {
        string ret;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "select meta.EntityTableNameLookupError(@HubLnk, @UsedBy, @HashKeySuffix)";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                //cmd.CommandTimeout = 60;
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.Add("@HubLnk", SqlDbType.Int).Value = ReferencedEntityId;
                cmd.Parameters.Add("@UsedBy", SqlDbType.Int).Value = EntityId;
                cmd.Parameters.Add("@HashKeySuffix", SqlDbType.VarChar, 50).Value = HashKeySuffix;
                ret = (string)cmd.ExecuteScalar();
            }

            conn.Close();
        }

        return ret;
    }
    
    
        


    public static List<EntityInfo> GetEntities()
    {
        List<EntityInfo> ret = new List<EntityInfo>();

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "etl.GetEntities";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                //cmd.CommandTimeout = 60;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ProcessId", SqlDbType.Int).Value = ProcessId;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                            ret.Add(GetEntityInfo((int)reader[0]));
                    }
                }
            }

            conn.Close();
        }

        return ret;
    }

    public static EntityInfo GetEntityInfo(int EntityId)
    {
        EntityInfo ret = new EntityInfo();
        ret.EntityId = EntityId;

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "etl.GetEntityInfo";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                //cmd.CommandTimeout = 60;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@EntityId", SqlDbType.Int).Value = EntityId;
                cmd.Parameters.Add("@ProcessId", SqlDbType.Int).Value = ProcessId;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            ret.EntityName = (string)reader[0];
                            ret.EntityType = (string)reader[1];
                            ret.EntityTableName = (string)reader[2];
                            ret.EntityNameStaging = (string)reader[3];
                            ret.EntityViewNameStaging = (string)reader[4];
                            ret.IsTLnk = (bool)reader[5];
                            ret.CreateEntity = (bool)reader[6];
                            ret.ParentEntityId = (int)reader[7];
                        }
                    }
                }
            }

            conn.Close();
        }

        return ret;
    }

    public static List<Column> GetColumns(int EntityId, bool LookupOnly)
    {
        List<Column> ret = new List<Column>();

        SqlConnectionStringBuilder connString = new SqlConnectionStringBuilder();
        connString.DataSource = ServerName;
        connString.InitialCatalog = MetaCatalog;
        connString.IntegratedSecurity = true;

        using (SqlConnection conn = new SqlConnection(connString.ConnectionString))
        {
            conn.Open();

            string sql = "etl.GetColumns";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                //cmd.CommandTimeout = 60;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@EntityId", SqlDbType.Int).Value = EntityId;

                if (LookupOnly)
                    cmd.Parameters.Add("@LookupOnly", SqlDbType.Bit).Value = 1;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            Column col = new Column();
                            col.ColumnName = (string)reader[0];
                            col.ColumnNameBraket = (string)reader[1];
                            col.SqlDataType = (string)reader[2];
                            col.DataTypeSize = (int)reader[3];
                            col.IsHashKey = (bool)reader[4];
                            col.ReferencedEntityId = (int)reader[5];
                            col.HashKeySuffix = (string)reader[6];

                            ret.Add(col);
                        }
                    }
                }
            }

            conn.Close();
        }

        return ret;
    }

    public static string GetStringColumnList(List<Column> Columns, bool UpperCaseString)
    {
        string ret = string.Empty;

        foreach (Column item in Columns)
        {
            if (UpperCaseString)
            {
                if (item.SqlDataType.ToLower().Contains("char"))
                    ret += item.ColumnNameBraket + " = UPPER(" + item.ColumnNameBraket + "), ";
                else
                    ret += item.ColumnNameBraket + ", ";
            }
            else
                ret += item.ColumnNameBraket + ", ";

            ret += Environment.NewLine;
        }

        if (ret.Length != 0)
            ret = ret.Substring(0, ret.Length - 4);

        return ret;
    }

}

public struct EntityInfo
{
    public int EntityId;
    public string EntityName;
    public string EntityType;
    public string EntityTableName;
    public string EntityNameStaging;
    public string EntityViewNameStaging;
    public bool IsTLnk;
    public bool CreateEntity;
    public int ParentEntityId;
}

public struct Column
{
    public string ColumnName;
    public string ColumnNameBraket;
    public string SqlDataType;
    public int DataTypeSize;
    public bool IsHashKey;
    public int ReferencedEntityId;
    public string HashKeySuffix;
}