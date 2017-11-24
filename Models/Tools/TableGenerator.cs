using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.IO;
using maintenance.Models;

namespace Omniyat.Models
{
    public class TableGenerator
    {

        public static string GenerateTable(DataTable dt, string tableName)
        {
            StringBuilder resTable = new StringBuilder();

            resTable.Append("<table id='" + tableName + "' width='100%' cellspacing='4'>");

            try
            {

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
                        resTable.Append("<tr index='" + dt.Rows[irow][0].ToString() + "' class='pt' style='font-size:10px;'>");
                        for (int icol = 1; icol < dt.Columns.Count; icol++)
                        {
                            resTable.Append("<td>" + dt.Rows[irow][icol].ToString() + "</td>");
                        }
                        resTable.Append("</tr>");
                    }
                    if (dt.Rows.Count > 0) resTable.Append("</tbody>");
                }
                resTable.Append("</table>");

            }

            catch (Exception ex)
            {
                Configs.Debug(ex, "Omniyat.Models.TableGenerator.GenerateTable", "Echéc de la création de la table d'affichage des données : " + tableName);
            }
            return resTable.ToString();
        }

        

        public static string getCon_Config()
        {
            string res = "";
            try
            {
                string file = HttpContext.Current.Server.MapPath("~/Config") + "/Config.dat";
                StreamReader sr = new StreamReader(file);
                res = Cryptage.Decrypt(sr.ReadLine());
                sr.Close();
            }
            catch (Exception ex) {
                Configs.Debug(ex, "Omniyat.Models.TableGenerator.getCon_Config", "Echéc de chargement de Config/dat");
            }

            return res;
        }

    }
    
}