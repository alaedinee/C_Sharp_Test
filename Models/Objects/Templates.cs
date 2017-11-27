using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Omniyat.Models;
using iTextSharp.text;
using System.IO;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;

namespace TRC_GS_COMMUNICATION.Models
{
    public class Templates
    {

        public DataRow getTemplate(string name)
        {
            DataRow obj = null;
            DataTable dt_temp = Configs._query.executeProc("getTemplate", "name@string@" + name);
            if (dt_temp != null && dt_temp.Rows.Count > 0)
                obj = dt_temp.Rows[0];

            return obj;
        }

        public string getArticle(string TemplateName, string ArtName)
        {
            string art = null;
            DataTable dt_temp = Configs._query.executeProc("getTemplateArticle", "TemplateName@string@" + TemplateName + "#ArtName@string@" + ArtName);
            if (dt_temp != null && dt_temp.Rows.Count > 0)
                art = dt_temp.Rows[0][0].ToString();

            return art;
        }

        public DataRow getTemplateService(string DetailID)
        {
            DataRow obj = null;
            DataTable dt_temp = Configs._query.executeProc("getTemplateService", "DetailID@int@" + DetailID);
            if (dt_temp != null && dt_temp.Rows.Count > 0)
                obj = dt_temp.Rows[0];

            return obj;
        }
        // remplir templete
        public string getGeneratedTemp(DataTable dt, string contents, string user)
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    string _column = dt.Columns[i].ColumnName;
                    string _value = dt.Rows[0][_column].ToString();
                    if (_column.Contains("codebarre_"))
                    {
                        string pdfFilePath = @"c:\temps\codebar_" + _column + ".gif";// emplacement de code barre générer

                        if (Tools.generateImgBareCode(pdfFilePath, _value))
                            contents = contents.Replace("{" + _column + "}", pdfFilePath);

                    }
                    else
                    {
                        string _type = dt.Columns[i].DataType.ToString();
                        contents = contents.Replace("{" + _column + "}", _value);
                    }
                }

                contents = contents.Replace("{now}", DateTime.Now.ToString("dd/MM/yyyy HH:mm"));
                contents = contents.Replace("{now_date}", DateTime.Now.ToString("dd/MM/yyyy"));
                contents = contents.Replace("{now_hour}", DateTime.Now.ToString("HH:mm"));
            }

            return contents;
        }

        public string getGeneratedRowTemp(DataRow row, string contents, string user, int j, string prefix = "")
        {
            if (row != null)
            {
                for (int i = 0; i < row.Table.Columns.Count; i++)
                {
                    string _column = row.Table.Columns[i].ColumnName;
                    string _value = row[_column].ToString();
                    string _type = row.Table.Columns[i].DataType.ToString();
                    string temp = "{" + prefix + _column + "}"; // "{Articles." + _column + "}"; 
                    if (_column.Contains("codebarre"))
                    {
                        string pdfFilePath = @"c:\temps\codebar_" + _column + ".gif";

                        if (Tools.generateImgBareCode(pdfFilePath, _value))
                            contents = contents.Replace(temp, pdfFilePath);

                    }
                    else
                    {
                        contents = contents.Replace(temp, _value.ToString());
                    }
                }

                contents = contents.Replace("{Now}", DateTime.Now.ToString("dd/MM/yyyy HH:mm"));
            }

            return contents;
        }

        public void GeneratedPDF(string path, string contents, bool rotate = false)
        {
            Document document;
            if(!rotate)
                document = new Document(PageSize.A4, 50, 50, 25, 25);
            else
                document = new Document(PageSize.A4.Rotate(), 50, 50, 25, 25);
            try
            {
                var output = new FileStream(path, FileMode.Create);
                var writer = PdfWriter.GetInstance(document, output);

                document.Open();
                //ajouter par Karim pour que html peut lir les font face
                //FontFactory.Register("C:\\Windows\\Fonts\\en13.ttf", "Code EAN13");
                //fin ajout
                StringReader stred = new StringReader(contents);
                var parsedHtmlElements = HTMLWorker.ParseToList(stred, null);

                foreach (var htmlElement in parsedHtmlElements)
                {
                    document.Add(htmlElement as IElement);
                }

            }
            catch (Exception)
            { 
            
            }
            finally
            {
                document.Close();

            }
        }

    }
}