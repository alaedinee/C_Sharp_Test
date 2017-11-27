using Omniyat.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Globale_Varriables;
using TRC_GS_COMMUNICATION.Models;
using maintenance.Models;
using System.Text.RegularExpressions;
using TRC_GS_COMMUNICATION.Controllers;

namespace maintenance.Controllers
{
    public class AjoindreController : BaseController
    {
        //
        // GET: /Ajoindre/


        //protected override void Initialize(RequestContext rc)
        //{
        //    base.Initialize(rc);
        //    Globale_Varriables.VAR.myCookie = Request.Cookies["TRCVLog"];
        //    if (Session["userID"] == null)
        //    {
        //        if (VAR.verifyCookie())
        //        {
        //            Session["userID"] = VAR.myCookie.Values["userid"].ToString();
        //            MajModeles majMod = new MajModeles();
        //            Session["login"] = majMod.getUserbyId(Session["userID"].ToString());
        //            Session["role"] = majMod.getRolebyId(Session["userID"].ToString());
        //            Configs.login = Session["login"].ToString();
        //        }
        //        else
        //            VAR.Redirect();
        //    }

        //}

        public ActionResult ajForm(string OTID = "6", string facturer = "", string isOpen = "1", string  isPalannifToPast = "1")
        {
            ViewData["Factuer"] = facturer;
            ViewData["OTID"] = OTID;
            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;
            string listID = "8";
            //XMLReader readXML = new XMLReader();

            try
            {
                //var ListType = readXML.RetrunListOfTypes();
                ViewData["ListType"] = Configs._query.executeProc("aJoindreListType", "IDList@int@" + listID);
                ViewData["groupeList"] = Configs._query.executeProc("aJoindreGroupeList", "OTID@int@" + OTID);

            }
            catch (Exception exp)
            {
                Configs.Debug(exp, "maintenance.Controllers.AjoindreController.ajForm", "Impossible de charger les types de fichier");
            }

            ViewData["listID"] = listID;

            return View();
        }

        public ActionResult addTypeForm(string ListID, string OTID)
        {
            
            ViewData["IDList"] = ListID;
            ViewData["OTID"] = OTID;
            return View();
        }

        public string saveTypeDoc(string idList, string type)
        {
            string res = "2";
            DataTable data = Configs._query.executeProc("aJoindreAddType", "idList@int@" + idList + "#type@string@" + type);

            if (Tools.verifyDataTable(data))
            {
                if (data.Rows[0][0].ToString() == "0")
                    res = "0";

                else if (data.Rows[0][0].ToString() == "1")
                    res = "1";

                else if (data.Rows[0][0].ToString() == "2")
                    res = "2";

            }

            return res ;
        }

        public ActionResult deleteTypeForm(string OTID)
        {
            ViewData["OTID"] = OTID;
            ViewData["LstTypeDoc"] = Configs._query.executeProc("aJoindreGetType");
            return View();
        }

        public string deleteType(string IDType)
        {
            string res = "1";
            try
            {
                DataTable dataDelete = Configs._query.executeProc("aJoindreDeleteType", "IDType@int@" + IDType);
                //if (Tools.verifyDataTable(dataDelete))
                    res = "delete";

            }
            catch (Exception exp)
            {
                Configs.Debug(exp, "maintenance.Controllers.AjoindreController.deleteType", "Impossible de créer un dossier Upload, chemin ");
            }
            return res;
        }


        [HttpPost]
        public JsonResult ajChargerFichier(string OTID, string type)
        {
            //mj = new MAJ();
            string res = "-1";
            string fileName = "";
            string pathSave = "";
            string fileNamePath = "";

            for (int i = 0; i < Request.Files.Count; i++)
            {
                HttpPostedFileBase file = Request.Files[i];
                var pathStockag = Globale_Varriables.VAR.PATH_STOCKAGE;
                int fileSize = file.ContentLength;
                fileName = file.FileName;
                string mimeType = file.ContentType;
                System.IO.Stream fileContent = file.InputStream;

                string pathDB = OTID + "/" + type + "/" + fileName;


                if (type == "-1") 
                {
                    pathSave = pathStockag + @"\" + OTID + @"\";
                }
                else
                {
                    pathSave =pathStockag +  @"\" + OTID +  @"\" + type +  @"\" ;
                }
                var directory = new DirectoryInfo(pathSave);
                if (directory.Exists == false)
                {
                    try
                    {
                        directory.Create();
                    }
                    catch (Exception exp)
                    {
                        Configs.Debug(exp, "maintenance.Controllers.AjoindreController.ajChargerFichier", "Impossible de créer un dossier Upload, chemin : " + pathSave);
                    }

                }
                fileNamePath = pathSave + fileName;

                try
                {
                    file.SaveAs(pathSave + fileName);

                    res = "0";
                }
                catch (Exception exp)
                {
                    Configs.Debug(exp, "maintenance.Controllers.AjoindreController.ajChargerFichier", "Impossible de sauvegarder le fichier, chemin : " + fileNamePath);
                }

               /*
                DataTable dt = Configs._query.executeProc("aJoindreAddPiece", "OTID@int@" + OTID + "#Type@string@" + type + "#nomFichier@string@" + fileName + "#Path@string@" + pathDB, true);
                if (Tools.verifyDataTable(dt))
                {
                    res = dt.Rows[0][0].ToString();
                }*/
                
            }

            if(res =="0")
                return Json("chargement effectué : " + fileName);
            else
                return Json("chargement erroné : " + fileName);
        }

        public ActionResult listDoc(string OTID, string Ressource = "OT", string isOpen = "1", string isPalannifToPast = "1")
        {

            ViewData["OTID"] = OTID;
            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;

            return View();
        }

        public string deleteDoc(string path)
        
        {
            string res = "0";

            path = path.Replace(@"/", @"\");
            path = VAR.PATH_STOCKAGE + path;
            if (System.IO.File.Exists(path))
            {
                 try
                {
                    System.IO.File.Delete(path);
                    res = "1";
                }
                 catch (System.IO.IOException e)
                 {
                     Configs.Debug(e, "maintenance.Controllers.AjoindreController.ajChargerFichier", "Impossible de supprimer le fichier, chemin : " + path);
                 }
            }
            else
                res = "0";

            return res;
        }

        public ActionResult ImprimeBL(string OTID, string DetailID, string temp_name = "BL")
        {
            var urlRedirection = Ajoindre.ImprimBL(OTID, DetailID);

            if (!string.IsNullOrEmpty(urlRedirection))
                return Redirect(urlRedirection);

            return View();
        }

        public ActionResult Imprime_BL_MULTI(string OTID, string temp_name = "BL_GLOBAL")
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
                DataRow rTemplate = temp.getTemplate(temp_name);

                string contents = "";
                string articles = "";
                string proc = "";
                string user = "user";
                string _fileName = OTID + "_GLOBAL_BL.pdf";
                if (rTemplate != null)
                {
                    contents = rTemplate["html"].ToString();
                    // articles = rTemplate["articles"].ToString();
                    proc = rTemplate["proc_datasource"].ToString();
                }
                
                if (proc != "no")
                {
                    // string fileServ = Regex.Replace(service, "[^a-zA-Z0-9_]+", "");


                    pathSave = pathSave + _fileName;

                    DataTable dt = Configs._query.executeProc(proc, "OTID@int@" + OTID );

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        contents = temp.getGeneratedTemp(dt, contents, user);
                       
                        /////////////////////////////////////////////////////////////////////////////////////////////
                        var match   = Regex.Match(contents, @"{FOR ([A-Z][a-z]+)}");
                        var match1  = Regex.Match(contents, @"{/FOR ([A-Z][a-z]+)}");
                        while (match.Success && match1.Success)
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

                            articles = temp.getArticle(temp_name, _obj);

                            dt = Configs._query.executeSql(articles.Replace("SID", OTID)); //.Replace("SERNAME", service).Replace("SERNUB", servNumber));
                            if (dt != null && dt.Rows.Count > 0)
                            {        
                                string lines = "";
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    string line = fStr;
                                    lines += temp.getGeneratedRowTemp(dt.Rows[i], line, user, i, _obj + ".");
                                }

                                contents = contents.Substring(0, bIndex) +
                                        lines +
                                        contents.Substring(eIndex + elmatch);

                                contents = contents.Replace("{TAB_Start_" + _obj + "}", "").Replace("{/TAB_Start_" + _obj + "}", "");
                            }
                            else
                            {
                                match = Regex.Match(contents, @"{TAB_Start_" + _obj + "}");
                                match1 = Regex.Match(contents, @"{/TAB_Start_" + _obj + "}");

                                if (match.Index > 0 && match1.Index > match.Index)
                                {
                                    contents = contents.Substring(0, match.Index - 1) + contents.Substring(match1.Index + ("{/TAB_Start_" + _obj + "}").Length);
                                }
                            }
                            match = Regex.Match(contents, @"{FOR ([A-Z][a-z]+)}");
                            match1 = Regex.Match(contents, @"{/FOR ([A-Z][a-z]+)}");
                        }
                        /////////////////////////////////////////////////////////////////////////////////////////////
                    }
                }
                contents = contents.Replace("{url_server}", VAR.get_URL_HREF());
                temp.GeneratedPDF(pathSave, contents);

                string urlRedirection = Globale_Varriables.VAR.urlFileUpload + "/" + OTID + "/BL/" + _fileName;
                return Redirect(urlRedirection);
            }
            catch (Exception)
            {
            }
            
            /********************************************* code generate pdf *********************************************/

            return View("ImprimeBL");
        }


    }
}
