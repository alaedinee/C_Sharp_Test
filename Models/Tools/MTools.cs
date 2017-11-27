using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.IO;
using System.Net;
using System.Text;

namespace Omniyat.Models
{
    public class MTools
    {
        public static string getSqlConfig(string key)
        {
            return Configs._query.executeScalar("SELECT value FROM Config WHERE name='" + key + "'");
        }
        
        public static void DataTableToCSV(String filePath, DataTable dataTable)
        {
            try
            {
                if (File.Exists(filePath)) File.Delete(filePath);

                StreamWriter sr = new StreamWriter(filePath, false, System.Text.Encoding.GetEncoding("iso-8859-1"));
                string values = "";
                for (int i = 0; i < dataTable.Columns.Count; i++)
                {
                    values += dataTable.Columns[i].ColumnName + ";";
                }

                if (values.Length > 0) values = values.Substring(0, values.Length - 1);
                sr.WriteLine(values);
                sr.Flush();

                for (int i = 0; i < dataTable.Rows.Count; i++)
                {
                    values = "";

                    for (int j = 0; j < dataTable.Columns.Count; j++)
                    {
                        values += dataTable.Rows[i][j].ToString() + ";";
                    }

                    if (values.Length > 0) values = values.Substring(0, values.Length - 1);
                    sr.WriteLine(values);
                    sr.Flush();
                }

                sr.Close();
            }
            catch (Exception ex)
            {
                Configs.Debug(ex);
            }
        }

        public static string getURLContent(string url)
        {
            Uri uri = new Uri(url);
            WebRequest request = WebRequest.Create(uri);
            WebResponse response = request.GetResponse();
            StreamReader sr = null;
            try
            {
                sr = new StreamReader(response.GetResponseStream());
                return sr.ReadToEnd();
            }
            catch (Exception ex)
            {
                Configs.Debug(ex);
                return null;
            }
            finally
            {
                if (sr != null)
                    sr.Close();
            }
        }

        public static string GenerateTable(DataTable dt, string tableName, string attributs = "")
        {
            StringBuilder resTable = new StringBuilder();

            resTable.Append("<table id='" + tableName + "' " + attributs + " >");

            if (dt != null)
            {
                resTable.Append("<thead><tr>");
                for (int i = 1; i < dt.Columns.Count; i++)
                {
                    resTable.Append("<th style='text-align:center;'>" + dt.Columns[i].ColumnName + "</th>");
                }
                resTable.Append("</tr></thead>");

                if (dt.Rows.Count > 0) resTable.Append("<tbody>");

                for (int irow = 0; irow < dt.Rows.Count; irow++)
                {
                    resTable.Append("<tr index='" + dt.Rows[irow][0].ToString() + "' class='rowTab' style='font-size:10px;'>");
                    for (int icol = 1; icol < dt.Columns.Count; icol++)
                    {
                        resTable.Append("<td>" + dt.Rows[irow][icol].ToString() + "</td>");
                    }
                    resTable.Append("</tr>");
                }
                if (dt.Rows.Count > 0) resTable.Append("</tbody>");
            }

            resTable.Append("</table>");
            return resTable.ToString();
        }

        public static string GenerateTable(DataTable dt, string tableName, string[] columns, string attributs = "")
        {
            StringBuilder resTable = new StringBuilder();

            resTable.Append("<table id='" + tableName + "' " + attributs + " >");

            if (dt != null)
            {
                resTable.Append("<thead><tr>");
                for (int i = 0; i < columns.Length; i++)
                {
                    resTable.Append("<th style='text-align:center;'>" + columns[i] + "</th>");
                }
                resTable.Append("</tr></thead>");

                if (dt.Rows.Count > 0) resTable.Append("<tbody>");

                for (int irow = 0; irow < dt.Rows.Count; irow++)
                {
                    resTable.Append("<tr index='" + dt.Rows[irow][0].ToString() + "' class='rowTab' style='font-size:10px;'>");
                    for (int icol = 0; icol < columns.Length; icol++)
                    {
                        string col = columns[icol];
                        resTable.Append("<td>" + dt.Rows[irow][col].ToString() + "</td>");
                    }
                    resTable.Append("</tr>");
                }
                if (dt.Rows.Count > 0) resTable.Append("</tbody>");
            }

            resTable.Append("</table>");
            return resTable.ToString();
        }

        public static bool verifyDataTable(DataTable datatable)
        {
            return (datatable != null) ? ((datatable.Rows.Count > 0) ? true : false) : false;
        }

        public static string GetJson(DataTable datatable)
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new

            System.Web.Script.Serialization.JavaScriptSerializer();
            List<Dictionary<string, object>> rows =
              new List<Dictionary<string, object>>();
            Dictionary<string, object> row = null;

            if (MTools.verifyDataTable(datatable))
            {
                foreach (DataRow dr in datatable.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in datatable.Columns)
                    {
                        row.Add(col.ColumnName.Trim(), dr[col]);
                    }
                    rows.Add(row);
                }
            }
            return serializer.Serialize(rows);
        }
    }
}