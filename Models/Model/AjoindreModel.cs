using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml.Serialization;
using Omniyat.Models;
using System.IO;
using TRC_GS_COMMUNICATION.Models;
using System.Text.RegularExpressions;

namespace maintenance.Models
{
    public class Ajoindre {
        public static string ImprimBL(string OTID, string DetailID, bool ReplaceOnly = false)
        {
            string pathSave = "";
            pathSave = Globale_Varriables.VAR.PATH_STOCKAGE + OTID + @"\BL\";

            var directory = new DirectoryInfo(pathSave);
            if (!Directory.Exists(pathSave))
                try { Directory.CreateDirectory(pathSave); }
                catch (Exception exp) { Configs.Debug(exp, "maintenance.Controllers.AjoindreController.ajChargerFichier", "Impossible de créer un dossier Upload, chemin : " + pathSave); }

            /********************************************* code generate pdf *********************************************/
            try
            {
                Templates temp = new Templates();
                DataRow rTemplate = temp.getTemplateService(DetailID);

                string contents = "";
                string articles = "";
                string proc = "";
                string user = "user";
                string _fileName = DetailID + "_BON_LIVRAISON.pdf";
                if (rTemplate != null)
                {
                    contents = rTemplate["html"].ToString();
                    articles = rTemplate["articles"].ToString();
                    proc = rTemplate["proc_datasource"].ToString();
                }
                
                if (proc != "no")
                {
                    pathSave = pathSave + _fileName;

                    DataTable dt = Configs._query.executeProc(proc, "OTID@int@" + OTID + "#DetailID@int@"+DetailID);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        contents = temp.getGeneratedTemp(dt, contents, user);
                        if (articles.Length > 4)
                        {
                            var match = Regex.Match(contents, @"{FOR ([A-Z][a-z]+)}");
                            var match1 = Regex.Match(contents, @"{/FOR ([A-Z][a-z]+)}");
                            if (match.Success && match1.Success)
                            {
                                dt = Configs._query.executeSql(articles.Replace("SID", DetailID));
                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    int bIndex = match.Index;
                                    string _obj = match.Value;
                                    _obj = _obj.Substring(_obj.IndexOf(" ") + 1);
                                    _obj = _obj.Substring(0, _obj.Length - 1);
                                    int blmatch = match.Value.Length;

                                    int eIndex = match1.Index;
                                    int elmatch = match1.Value.Length;

                                    int lStr = eIndex - (bIndex + blmatch);
                                    string fStr = contents.Substring(bIndex + blmatch, lStr);

                                    string lines = "";
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        string line = fStr;
                                        lines += temp.getGeneratedRowTemp(dt.Rows[i], line, user, i, _obj + ".");
                                    }

                                    contents = contents.Substring(0, bIndex) +
                                            lines +
                                            contents.Substring(eIndex + elmatch);

                                    contents = contents.Replace("{TAB_Start}", "").Replace("{/TAB_Start}", "");
                                }
                                else
                                {
                                    match = Regex.Match(contents, @"{TAB_Start}");
                                    match1 = Regex.Match(contents, @"{/TAB_Start}");

                                    if (match.Index > 0 && match1.Index > match.Index)
                                    {
                                        contents = contents.Substring(0, match.Index - 1) + contents.Substring(match1.Index + "{/TAB_Start}".Length);
                                    }
                                }
                            }
                        }
                    }
                }
                contents = contents.Replace("{url_server}", Globale_Varriables.VAR.get_URL_HREF());
                if(ReplaceOnly && !File.Exists(pathSave))
                    return null;
                temp.GeneratedPDF(pathSave, contents);

                string urlRedirection = Globale_Varriables.VAR.urlFileUpload + "/" + OTID + "/BL/" + _fileName;
                return urlRedirection;
            }
            catch (Exception)
            {
            }            
            /********************************************* code generate pdf *********************************************/

            return null;
        }
    }

    [Serializable]
    [XmlRoot("root"), XmlType("root")]
    public class TypeFichier
    {
        public string Value { get; set; }
        public string TypeValue { get; set; }
    }


    public class XMLReader
    {
        /// <summary>  
        /// Return list of products from XML.  
        /// </summary>  
        /// <returns>List of products</returns>  
        public List<TypeFichier> RetrunListOfTypes()
        {
            string xmlData = HttpContext.Current.Server.MapPath("~/Config/TypeFichier.xml");//Path of the xml script  
            DataSet ds = new DataSet();//Using dataset to read xml file
            try
            {
                ds.ReadXml(xmlData);
            }
            catch (Exception exp)
            {
                Configs.Debug(exp, "maintenance.Models.XMLReader.RetrunListOfTypes", "impossible de charger la liste des types fichier, chemin: ~/Config/TypeFichier.xml");
            }
            var types = new List<TypeFichier>();
            types = (from rows in ds.Tables[0].AsEnumerable()
                        select new TypeFichier
                        {
                            Value = rows[0].ToString(),
                            TypeValue = rows[1].ToString(),
                        }).ToList();
            return types;
        }

        public DataTable ConvertToDataTable<T>(IList<T> data)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            try
            {
                foreach (PropertyDescriptor prop in properties)
                    table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
                foreach (T item in data)
                {
                    DataRow row = table.NewRow();
                    foreach (PropertyDescriptor prop in properties)
                        row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                    table.Rows.Add(row);
                }
            }

            catch (Exception exp)
            {
                Configs.Debug(exp, "maintenance.Models.XMLReader.ConvertToDataTable", "converstion d'une liste vers DT");
            }
            return table;

        }
    }
}