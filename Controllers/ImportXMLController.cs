using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using TRC_GS_COMMUNICATION.Models;
using System.Xml;
using System.IO;


namespace TRC_GS_COMMUNICATION.Controllers
{
    public class ImportXMLController : Controller
    {
        //
        // GET: /ImportXML/

        public ActionResult ImportCommande(string res = "")
        {
            ViewData["res"] = res;

            return View();
        }

        [HttpPost]
        public ActionResult ImportCommande(HttpPostedFileBase file, string res = "")
        {

            ///////////////////////// A supp
            string _paramsBL = "";
            string _paramsLG = "";
            string _paramsCB = "";
            string attribute = "";
            /////////////////////////

            /////////////////////////
            if (file != null && file.ContentLength > 0)
            {
                var fileName = Path.GetFileName(file.FileName);
                string str = DateTime.Now.ToString().Replace("/", "_").Replace(":", "_").Replace(" ", "_").Replace(".", "_") + "_";
                var path = Path.Combine(Server.MapPath("~/File"), str + fileName);
                file.SaveAs(path);

                if (System.IO.File.Exists(path))
                {



                    ///////////// A supprimer ////////////////@"C:\Users\Omniyat\Desktop\TAMMARO\Config\testxml.xml"
                    FileStream fs = new FileStream(path, FileMode.OpenOrCreate,
                                                                            FileAccess.Read, FileShare.Read);

                    using (XmlReader reader = XmlReader.Create(fs))
                    {
                        while (reader.Read())
                        {
                            if (reader.IsStartElement())
                            {
                                switch (reader.Name)
                                {
                                    case "BL": // si node est un BL
                                        attribute = reader["name"];
                                        if (attribute != null)
                                        {
                                            _paramsBL += attribute + "@string@";
                                        }
                                        if (reader.Read() && attribute != null)
                                        {
                                            _paramsBL += reader.Value + "#";
                                        }
                                        break;

                                    case "LIGNE": // si node est une ligne
                                        attribute = reader["name"];
                                        if (attribute != null)
                                        {
                                            _paramsLG += attribute + "@string@";
                                        }
                                        if (reader.Read() && attribute != null)
                                        {
                                            _paramsLG += reader.Value + "#";
                                        }
                                        break;

                                    case "CODEBARRE": // si node est une ligne
                                        attribute = reader["name"];
                                        if (attribute != null)
                                        {
                                            _paramsCB += attribute + "@string@";
                                        }
                                        if (reader.Read() && attribute != null)
                                        {
                                            _paramsCB += reader.Value + "#";
                                        }
                                        break;
                                }
                            }
                        }
                        if (_paramsBL != "")
                        {
                            _paramsBL = _paramsBL.Substring(0, _paramsBL.Length - 1);
                            res = "1";
                        }
                        if (_paramsLG != "")
                        {
                            _paramsLG = _paramsLG.Substring(0, _paramsLG.Length - 1);
                            res = "1";
                        }
                        if (_paramsCB != "")
                        {
                            _paramsCB = _paramsCB.Substring(0, _paramsCB.Length - 1);
                            res = "1";
                        }
                    }

                    /////////////////////////
                    
                }
            }
            ///////////////////

            ViewData["res"] = res;
            return View();
        }

        public string ValiderImportCommande()
        {

            return null;
        }

    }
}
