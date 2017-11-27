using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Omniyat.Models;
using TRC_GS_COMMUNICATION.Models;
using iTextSharp.text;
using System.IO;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.Text;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class ExportController : Controller
    {
        public ActionResult Index()
        {

            return View();
        }

        public string getRessourceURL(string realpath, string otid, string recepID)
        {
                string res = "Ref documentaire :<br />";

                string path = realpath + otid + @"\";
                if (System.IO.Directory.Exists(path))
                {
                    IEnumerable<string> dirList = System.IO.Directory.EnumerateDirectories(path);
                    foreach (string dir in dirList)
                    {
                        string dpath = dir;
                        string[] type = dpath.Split('\\');
                        IEnumerable<string> fileList = System.IO.Directory.EnumerateFiles(dpath);

                        string[] files = Directory.GetFiles(dpath); //, "*.pdf");
                        foreach (string file in files)
                        {
                            if (Path.GetFileName(file).StartsWith(recepID))
                            {
                                string dirr = file.Substring(file.IndexOf(otid)).Replace(@"\", "/");

                                res += String.Format("<a target='blank' href='" + Globale_Varriables.VAR.PATH_CONSULTATION + "{0}'>{1}</a><br />", dirr, Path.GetFileName(file));
                            }
                        }
                    }

                    string[] _files = Directory.GetFiles(path); //, "*.pdf");
                    foreach (string file in _files)
                    {
                        if (Path.GetFileName(file).StartsWith(recepID))
                            res += String.Format("<a target='blank' href='" + Globale_Varriables.VAR.PATH_CONSULTATION + "{0}/{1}'>{1}</a><br />", otid, Path.GetFileName(file));
                    }
                }
            

            return res;
        }

        public string CluturedReception(string recepID)
        {
            string res = "";
            try
            {
                string content = "";
                string contentMDM = "";

                string _params = "recepID@int@" + recepID;

                DataTable dataClient = Configs._query.executeProc("dev_getCloturedReception", _params);
                DataTable dataClientMDM = Configs._query.executeProc("dev_getCloturedReceptionMDM", _params);

                if (Tools.verifyDataTable(dataClient) || Tools.verifyDataTable(dataClientMDM))
                {
                    string realpath = Globale_Varriables.VAR.PATH_STOCKAGE;
                    content = "";
                    string name = "";
                    string otid = "";
                    string nobl = "";
                    string lines = "";
                    string email = "";
                    string DonName = "";
                    for (int i = 0; i < dataClient.Rows.Count; i++)
                    {
                        if (nobl != "" && nobl != dataClient.Rows[i]["OTNoBL"].ToString())
                        {
                            content += "<table width='90%'>"+
	                                    "<tr>"+
		                                "    <td>"+
			                            "        <b style='font-size:14px'>" + nobl + "</b>"+
			                            "        <br />"+
			                            "        <div style='padding-left:40px;font-size:12px'>";

                            content += lines;
                            content += getRessourceURL(realpath, otid, recepID);
                            content += "        </div>" +
                                       "      </td>" +
                                       "</tr>" +
                                       "</table>" +
                                       "<br />";

                            lines = "";
                        }

                        lines += dataClient.Rows[i]["packageNumber"].ToString() +
				                "<table bgcolor='#e2e4ff' width='90%' style='border:2px solid #eeeeee;font-size:12px'>" + 
					            "    <tr>" +
						        "        <td width='50%'>" + dataClient.Rows[i]["Fournisseur"].ToString() + ";</td>" +
						        "        <td>" + dataClient.Rows[i]["typeReception"].ToString() + ";</td>" +
					            "    </tr>" +
				                "</table>" +
				                "<br />";

                        name = dataClient.Rows[i]["OTDestinNom"] + " " + dataClient.Rows[i]["OTDestPrenom"];
                        nobl = dataClient.Rows[i]["OTNoBL"].ToString();
                        otid = dataClient.Rows[i]["OTID"].ToString();

                        if (i == dataClient.Rows.Count - 1)
                        {
                            content += "<table width='90%'>" +
                                        "<tr>" +
                                        "    <td>" +
                                        "        <b style='font-size:14px'>" + nobl + "</b>" +
                                        "        <br />" +
                                        "        <div style='padding-left:40px;font-size:12px'>";

                            content += lines;
                            content += getRessourceURL(realpath, otid, recepID);
                            content += "        </div>" +
                                       "      </td>" +
                                       "</tr>" +
                                       "</table>" +
                                       "<br />";
                        }

                        if (email == "" && dataClient.Rows[i]["mail"].ToString() != "")
                        {
                            email = dataClient.Rows[i]["mail"].ToString();
                            DonName = dataClient.Rows[i]["Nom"].ToString();
                        }
                        
                        //string emailClient = dataClient.Rows[i]["OTDestMail"].ToString();

                        //if (!emailClients.Keys.Contains(emailClient))
                        //{
                        //    emailClients.Add(emailClient, name);
                        //}

                    }
                    // [A_COURIGER] DEP AGENCE VALABLE UNIQUEMENT CRISSIER 
                    DataTable dataTamplate = Configs._query.executeProc("getTemplate", "name@string@" + "MAIL_FOOTER", true);
                    DataTable dataMailClient = Configs._query.executeProc("getTemplate", "name@string@" + "mail_arrivage_client", true);

                    if (Tools.verifyDataTable(dataTamplate))
                    {
                        if (Tools.verifyDataTable(dataMailClient))
                            contentMDM = dataMailClient.Rows[0]["html"].ToString();

                        content = dataTamplate.Rows[0]["html"].ToString().Replace("{TEMP}", content);
                        contentMDM = dataTamplate.Rows[0]["html"].ToString().Replace("{TEMP}", contentMDM);
                    }
                    string subject = Tools.getValueFromConfig("MAIL_SUBJECT");

                    if (Tools.verifyDataTable(dataClient))
                    {
                        string AgenceName, AgenceEmail;

                        string AgenceID = Session["agenceID"].ToString();
                        DataTable __dt = Configs._query.executeProc("AgenceGetAgence", "id@int@" + AgenceID, true);
                        if (Tools.verifyDataTable(__dt))
                        {
                            AgenceName = __dt.Rows[0]["Nom"].ToString();
                            AgenceEmail = __dt.Rows[0]["Email"].ToString();

                            sendEmail(content, subject, email, DonName, AgenceEmail, AgenceName);  
                        
                        }
                     
                    }

                    /////////////////////////////// MDM

                    //if (Tools.verifyDataTable(dataClientMDM))
                    //{
                    //    foreach (DataRow r in dataClientMDM.Rows)
                    //    {
                    //        name = r["OTDestinNom"] + " " + r["OTDestPrenom"];
                    //        email = r["OTDestMail"].ToString();
                    //        nobl = " : " + r["OTNoBL"].ToString();
                    //        sendEmail(contentMDM, subject + nobl, email, name); 
                    //    }
                    //}

                    //foreach (string key in emailClients.Keys)
                    //    sendEmail(contentClient, subject, key, emailClients[key]);  
                   

                    res = "1";
                }
            }
            catch (Exception ex) {
                res = ex.Message;
            }

            return res;
        }

        public void GeneratedPDF(string path, string contents)
        {
            var document = new Document(PageSize.A4, 50, 50, 25, 25);
            var output = new FileStream(path, FileMode.Create);
            var writer = PdfWriter.GetInstance(document, output);

            document.Open();

            StringReader stred = new StringReader(contents);
            var parsedHtmlElements = HTMLWorker.ParseToList(stred, null);

            foreach (var htmlElement in parsedHtmlElements)
            {
                document.Add(htmlElement as IElement);
            }

            document.Close();
        }

        public List<byte[]> getFileToMerge(string realpath, string otids)
        {
            string[] tab = otids.Split('#');
            List<byte[]> filesByte = new List<byte[]>();

            for (int i = 0; i < tab.Length; i++)
            {
                string path = realpath + tab[i] + @"\";
                if (System.IO.Directory.Exists(path))
                {
                    IEnumerable<string> dirList = System.IO.Directory.EnumerateDirectories(path);
                    foreach (string dir in dirList)
                    {
                        string dpath = dir;
                        string[] type = dpath.Split('\\');
                        IEnumerable<string> fileList = System.IO.Directory.EnumerateFiles(dpath);


                        string[] files = Directory.GetFiles(dpath); //, "*.pdf");
                        foreach (string file in files)
                        {
                            try
                            {
                                //byte[] bt = WriteToPdf(new FileInfo(file), tab[i]);
                                //filesByte.Add(bt);

                                if (file.LastIndexOf(".pdf") >= 0)
                                {
                                    byte[] bt = WriteToPdf(new FileInfo(file), tab[i]);
                                    filesByte.Add(bt);
                                }
                                else
                                {
                                    var document = new Document(PageSize.A4, 50, 50, 25, 25);
                                    var output = new FileStream(realpath + "tmp.pdf", FileMode.Create);
                                    var writer = PdfWriter.GetInstance(document, output);

                                    document.Open();

                                    Image img = Image.GetInstance(new Uri(file));

                                    int indentation = 0;
                                    float scaler = ((document.PageSize.Width - document.LeftMargin
                                                   - document.RightMargin - indentation) / img.Width) * 100;

                                    img.ScalePercent(scaler);
                                    document.Add(img);


                                    document.Close();

                                    byte[] bt = WriteToPdf(new FileInfo(realpath + "tmp.pdf"), tab[i]);
                                    filesByte.Add(bt);
                                }

                            }
                            catch (Exception ex)
                            {
                                Configs.Debug(ex.Message);
                            }
                        }

                    }


                    string[] _files = Directory.GetFiles(path); //, "*.pdf");
                    foreach (string file in _files)
                    {
                        try
                        {
                            if (file.LastIndexOf(".pdf") >= 0)
                            {
                                byte[] bt = WriteToPdf(new FileInfo(file), tab[i]);
                                filesByte.Add(bt);
                            }
                            else
                            {
                                var document = new Document(PageSize.A4, 50, 50, 25, 25);
                                var output = new FileStream(realpath + "tmp.pdf", FileMode.Create);
                                var writer = PdfWriter.GetInstance(document, output);

                                document.Open();

                                Image img = Image.GetInstance(new Uri(file));

                                int indentation = 0;
                                float scaler = ((document.PageSize.Width - document.LeftMargin
                                               - document.RightMargin - indentation) / img.Width) * 100;

                                img.ScalePercent(scaler);
                                document.Add(img);

                                document.Close();

                                byte[] bt = WriteToPdf(new FileInfo(realpath + "tmp.pdf"), tab[i]);
                                filesByte.Add(bt);
                            }
                        }
                        catch(Exception ex) {
                            string msg = ex.Message;
                        }
                    }
                }
            }

            return filesByte;
        }

        public static byte[] WriteToPdf(FileInfo sourceFile, string stringToWriteToPdf)
        {
            PdfReader reader = new PdfReader(sourceFile.FullName);
            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfStamper pdfStamper = new PdfStamper(reader, memoryStream);

                /*
                for (int i = 1; i <= reader.NumberOfPages; i++) // Must start at 1 because 0 is not an actual page.
                {
                    iTextSharp.text.Rectangle pageSize = reader.GetPageSizeWithRotation(i);

                    PdfContentByte pdfPageContents = pdfStamper.GetOverContent(i);
                    pdfPageContents.BeginText(); // Start working with text.


                    BaseFont baseFont = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, Encoding.ASCII.EncodingName, false);
                    int dpi = 100;
                    Barcode39 br = new Barcode39();
                    br.Code = stringToWriteToPdf;

                    iTextSharp.text.Image barcodeImage = iTextSharp.text.Image.GetInstance(br.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White), BaseColor.BLACK);
                    barcodeImage.SetAbsolutePosition((pageSize.Width / 2) + (barcodeImage.Width / 2), pageSize.Height - 20);// pageSize.Height - 150
                    barcodeImage.ScalePercent(72f / (float)dpi * 100f);

                    pdfPageContents.AddImage(barcodeImage, true);
                    pdfPageContents.EndText();

                }
                 * */

                pdfStamper.FormFlattening = true;
                pdfStamper.Close();

                return memoryStream.ToArray();
            }
        }

        public static bool sendEmail(string content, string _subject, string to_email, string to_name,  string mail_adr, string mail_name)
        {            

            //string mail_adr= Tools.getValueFromConfig("MAIL_ADR");
            //string mail_name = Tools.getValueFromConfig("MAIL_NAME");
            

            string fromPassword = Tools.getValueFromConfig("MAIL_PASSWORD");
            string subject = _subject; //Tools.getValueFromConfig("MAIL_SUBJECT");
            string body = content;// Tools.getValueFromConfig("MAIL_BODY");
            string host = Tools.getValueFromConfig("MAIL_HOST");
            string port = Tools.getValueFromConfig("MAIL_PORT");

            try
            {
                var fromAddress = new MailAddress(mail_adr, mail_name);
                var toAddress = new MailAddress(to_email, to_name);
                var smtp = new SmtpClient
                {
                    Host = host,
                    Port = Int32.Parse(port),
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
                };
                using (var message = new MailMessage(fromAddress, toAddress)
                                                    {
                                                        Subject = subject,
                                                        Body = body,
                                                        IsBodyHtml = true,
                                                    })
                {
                    smtp.Send(message);
                    return true;
                }
            }
            catch (Exception ex)
            {
            }
            
            return false;
        }
        public static bool sendEmail(string content, string subject, string to_email, string to_name, string mail_adr, string mail_name, string host, string fromPassword, string port)
        {            
            string body = content;

            try
            {
                var fromAddress = new MailAddress(mail_adr, mail_name);
                var toAddress = new MailAddress(to_email, to_name);
                var smtp = new SmtpClient
                {
                    Host = host,
                    Port = Int32.Parse(port),
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
                };
                using (var message = new MailMessage(fromAddress, toAddress)
                                                    {
                                                        Subject = subject,
                                                        Body = body,
                                                        IsBodyHtml = true,
                                                    })
                {
                    smtp.Send(message);
                    return true;
                }
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "TRC_GS_COMMUNICATION.Controllers.ExportController.sendEmail");

            }
            
            return false;
        }
    }
}