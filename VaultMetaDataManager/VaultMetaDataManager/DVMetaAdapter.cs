using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using VaultMetaDataManager.DVMeta_EntityTableAdapters;

namespace VaultMetaDataManager
{
    public class DVMetaAdapter
    {
        private ValidateModelTableAdapter _adapter;

        public DVMetaAdapter(ValidateModelTableAdapter adapter)
        {
            _adapter = adapter;
        }

        public string CreateModel(bool printOnly, out string result, out bool error)
        {
            error = false;
            string errorText = string.Empty;
            string output = string.Empty;

            using (SqlConnection conn = new SqlConnection(Helper.GetAdapterConnectionString()))
            using (DVMeta_Entity.ValidateModelDataTable dt = new DVMeta_Entity.ValidateModelDataTable())
            {
                conn.Open();
                conn.InfoMessage += delegate (object sender, SqlInfoMessageEventArgs e)
                {
                    output += e.Message + "\r\n";
                };

                try
                {
                    SqlCommand cmd = new SqlCommand("meta.CreateModel", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@PrintOnly", printOnly));
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            dt.Rows.Add(
                                dr.GetValue(0),
                                dr.GetValue(1),
                                dr.GetValue(2),
                                dr.GetValue(3),
                                dr.GetValue(4),
                                dr.GetValue(5),
                                dr.GetValue(6));
                        }
                    }
                }
                catch (Exception ex)
                {
                    errorText = ex.Message;
                    error = true;
                }

                _adapter.Fill(dt);
                conn.Close();
            }

            if (errorText.Length == 0)
            {
                result = "Completed successfully.";
            }
            else
            {
                output += "\r\n" + errorText;
                result = "Completed with errors.";
            }

            return output;
        }

    }
}
