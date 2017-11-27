using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Mail;
using System.IO;
using Omniyat.Models;
using System.Text;
using System.Xml;
using System.Data;
using System.Globalization;
using System.Diagnostics;
using Globale_Varriables;
namespace TRC_GS_COMMUNICATION.Models
{
    public class Tools
    {
        public static List<Config> lstConfigs = new List<Config>();


        public static DateTime FirstDateOfWeekISO8601(int year, int weekOfYear)
        {
            DateTime jan1 = new DateTime(year, 1, 1);
            int daysOffset = DayOfWeek.Thursday - jan1.DayOfWeek;

            DateTime firstThursday = jan1.AddDays(daysOffset);
            var cal = CultureInfo.CurrentCulture.Calendar;
            int firstWeek = cal.GetWeekOfYear(firstThursday, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);

            var weekNum = weekOfYear;
            if (firstWeek <= 1)
            {
                weekNum -= 1;
            }
            var result = firstThursday.AddDays(weekNum * 7);
            return result.AddDays(-3);
        }


        public static int WeekOfYearISO8601(DateTime date)
        {
            var day = (int) CultureInfo.CurrentCulture.Calendar.GetDayOfWeek(date);
            return CultureInfo.CurrentCulture.Calendar.GetWeekOfYear(date.AddDays(4 - (day == 0 ? 7 : day)), CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
        }

        public static string getValueFromConfig(string key)
        {
            try
            {
                return Configs._query.executeScalar("select value from Config where name='" + key + "'");
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "TRC_GS_COMMUNICATION.ModelsTools.getValueFromConfig", "Echéc d'impression : " + ex );
                return null;
            }
        }

        public static bool verifyDataTable(DataTable datatable)
        {
            return (datatable != null) ? ((datatable.Rows.Count > 0) ? true : false) : false;
        }

        public static string getHtmlSourceURL(string url)
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
            catch
            {
                return null;
            }
            finally
            {
                if (sr != null)
                    sr.Close();
            }
        }



        public static string parseConfigs(string file)
        {

            StringBuilder sp = new StringBuilder();
            sp.Append(File.ReadAllText(file));
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(sp.ToString());

            XmlNodeList lstAdr = getNodeList(doc, "Configs", "Item");
            foreach (XmlNode adr in lstAdr)
            {
                Config cfg = new Config();
                cfg.Name = getNodeValueText(adr, "Name");
                cfg.Value = getNodeValueText(adr, "Value");

                lstConfigs.Add(cfg);
            }

            return (lstConfigs.Count > 0)? "Ok" : "No";
        }

        public static string getXmlConfig(string name)
        {
            string res = "";

            foreach (Config cfg in lstConfigs)
            {
                if (cfg.Name == name)
                {
                    res = cfg.Value;
                    break;
                }
            }

            return res;
        }

        public static XmlNodeList getNodeList(XmlNode node, string nodeParentName, string nodeChildrenName)
        {
            return (node[nodeParentName] == null) ? node.SelectNodes("nothing") : node[nodeParentName].GetElementsByTagName(nodeChildrenName);
        }

        public static string getNodeValueText(XmlNode node, string name)
        {
            string str = (node[name] == null) ? "" : node[name].InnerText;

            str = str.Replace("'", "''");

            return str;
        }


        public static string GenerateTable(DataTable dt, string tableName, string attributs = "")
        {
            StringBuilder resTable = new StringBuilder();
            resTable.Append("<table id='" + tableName + "' width='100%'>");
            try
            {
                if (dt != null)
                {
                    resTable.Append("<thead><tr>");
                    for (int i = 1; i < dt.Columns.Count; i++)
                    {
                        resTable.Append("<th style='text-align:left;' name='" + dt.Columns[i].ColumnName + "'>" + dt.Columns[i].ColumnName + "</th>");
                    }
                    resTable.Append("</tr></thead>");

                    if (dt.Rows.Count > 0) resTable.Append("<tbody>");

                    for (int irow = 0; irow < dt.Rows.Count; irow++)
                    {
                        resTable.Append("<tr index='" + dt.Rows[irow][0].ToString() + "' class='rowTab' style='font-size:11px;'>");
                        for (int icol = 1; icol < dt.Columns.Count; icol++)
                        {
                            resTable.Append("<td name='" + dt.Columns[icol].ColumnName + "'>" + dt.Rows[irow][icol].ToString() + "</td>");
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
        public static string GenerateTableAJAX(DataTable dt, string tableName, string attributs = "", int startCol = 0)
        {
            StringBuilder resTable = new StringBuilder();

            resTable.Append("<table id='" + tableName + "' " + attributs + " >");

            if (dt != null)
            {
                resTable.Append("<thead><tr>");
                for (int i = startCol; i < dt.Columns.Count; i++)
                {
                    resTable.Append("<th style='text-align:left;' name='" + dt.Columns[i].ColumnName + "'>" + dt.Columns[i].ColumnName + "</th>");
                }
                resTable.Append("</tr></thead>");

                if (dt.Rows.Count > 0) resTable.Append("<tbody>");

                for (int irow = 0; irow < dt.Rows.Count; irow++)
                {
                    resTable.Append("<tr index='" + dt.Rows[irow][startCol].ToString() + "' class='rowTab' style='font-size:11px;'>");
                    for (int icol = startCol; icol < dt.Columns.Count; icol++)
                    {
                        resTable.Append("<td name='" + dt.Columns[icol].ColumnName + "'>" + dt.Rows[irow][icol].ToString() + "</td>");
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
                    resTable.Append("<th style='text-align:left;' name='" + dt.Columns[i].ColumnName + "'>" + columns[i] + "</th>");
                }
                resTable.Append("</tr></thead>");

                if (dt.Rows.Count > 0) resTable.Append("<tbody>");

                for (int irow = 0; irow < dt.Rows.Count; irow++)
                {
                    resTable.Append("<tr index='" + dt.Rows[irow][0].ToString() + "' class='rowTab' style='font-size:11px;'>");
                    for (int icol = 0; icol < columns.Length; icol++)
                    {
                        string col = columns[icol];
                        resTable.Append("<td name='" + dt.Columns[icol].ColumnName + "'>" + dt.Rows[irow][col].ToString() + "</td>");
                    }
                    resTable.Append("</tr>");
                }
                if (dt.Rows.Count > 0) resTable.Append("</tbody>");
            }

            resTable.Append("</table>");
            return resTable.ToString();
        }

        public static string DataTableToJsonObj(DataTable dt, int startCol = 0)
        {
            DataSet ds = new DataSet();
            ds.Merge(dt);
            StringBuilder JsonString = new StringBuilder();
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                JsonString.Append("[");
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    JsonString.Append("{");
                    for (int j = startCol; j < ds.Tables[0].Columns.Count; j++)
                    {
                        if (j < ds.Tables[0].Columns.Count - 1)
                        {
                            JsonString.Append("\"" + ds.Tables[0].Columns[j].ColumnName.ToString() + "\":" + "\"" + ds.Tables[0].Rows[i][j].ToString().Replace(@"\",@"\\") + "\",");
                        }
                        else if (j == ds.Tables[0].Columns.Count - 1)
                        {
                            JsonString.Append("\"" + ds.Tables[0].Columns[j].ColumnName.ToString() + "\":" + "\"" + ds.Tables[0].Rows[i][j].ToString().Replace(@"\", @"\\") + "\"");
                        }
                    }
                    if (i == ds.Tables[0].Rows.Count - 1)
                    {
                        JsonString.Append("}");
                    }
                    else
                    {
                        JsonString.Append("},");
                    }
                }
                JsonString.Append("]");
                return JsonString.ToString();
            }
            else
            {
                return null;
            }
        }
        ///////////////////////////////////////////// TEMPLATE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        public static bool generateImgBareCode(string path, string code)
        {
            try
            {
                iTextSharp.text.pdf.Barcode128 br = new iTextSharp.text.pdf.Barcode128();
                br.Code = code;

                // Configs.Debug(path);

                //iTextSharp.text.Image barcodeImage = iTextSharp.text.Image.GetInstance(br.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White), BaseColor.BLACK);
                //barcodeImage.SetAbsolutePosition(0, 0);
                //barcodeImage.ScalePercent(72f / (float)dpi * 100f);

                System.Drawing.Bitmap bm = new System.Drawing.Bitmap(br.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White));

                /*
                Graphics bmpgraphics = Graphics.FromImage(bm);
                bmpgraphics.Clear(Color.White); // Provide this, else the background will be black by default

                // generate the code128 barcode
                bmpgraphics.DrawImage(br.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White), new Point(0, 0));

                //generate the text below the barcode image. If you want the placement to be dynamic, calculate the point based on size of the image
                bmpgraphics.DrawString(br.Code, new System.Drawing.Font("Arial", 8, FontStyle.Regular), SystemBrushes.WindowText, new Point(50 - (br.Code.Length / 2), 30));
                */
                // Save the output stream as gif. You can also save it to external file
                bm.Save(path, System.Drawing.Imaging.ImageFormat.Gif);
                return true;
            }
            catch (Exception ex)
            {

                Configs.Debug(ex.Message);
                return false;
            }
        }

        public static bool isValidMail(string emailaddress)
        {
            try
            {
                MailAddress m = new MailAddress(emailaddress);

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    
        //////////////////////////////////////////// IP Adress \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        public static string getIPAddress(HttpRequest request)
        {
            string szRemoteAddr = request.UserHostAddress;
            string szXForwardedFor = request.ServerVariables["X_FORWARDED_FOR"];
            string szIP = "";

            if (szXForwardedFor == null)
            {
                szIP = szRemoteAddr;
            }
            else
            {
                szIP = szXForwardedFor;
                if (szIP.IndexOf(",") > 0)
                {
                    string[] arIPs = szIP.Split(',');

                    foreach (string item in arIPs)
                    {
                        if (IsPrivateIP(item))
                        {
                            return item;
                        }
                    }
                }
            }
            return szIP;
        }
        private static bool IsPrivateIP(string ipAddress)
        {
            int[] ipParts = ipAddress.Split(new String[] { "." }, StringSplitOptions.RemoveEmptyEntries)
                                     .Select(s => int.Parse(s)).ToArray();
            // in private ip range
            if (ipParts[0] == 10 ||
                (ipParts[0] == 192 && ipParts[1] == 168) ||
                (ipParts[0] == 172 && (ipParts[1] >= 16 && ipParts[1] <= 31)))
            {
                return true;
            }

            // IP Address is probably public.
            // This doesn't catch some VPN ranges like OpenVPN and Hamachi.
            return false;
        }
        //
        public static string GetIP4Address()
        {
            string IP4Address = String.Empty;

            foreach (IPAddress IPA in Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress))
            {
                if (IPA.AddressFamily.ToString() == "InterNetwork")
                {
                    IP4Address = IPA.ToString();
                    break;
                }
            }

            if (IP4Address != String.Empty)
            {
                return IP4Address;
            }

            foreach (IPAddress IPA in Dns.GetHostAddresses(Dns.GetHostName()))
            {
                if (IPA.AddressFamily.ToString() == "InterNetwork")
                {
                    IP4Address = IPA.ToString();
                    break;
                }
            }

            return IP4Address;
        }
    }
}