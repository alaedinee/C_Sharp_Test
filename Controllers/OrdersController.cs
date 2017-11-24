using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using maintenance.Models;
using System.Data;
using Omniyat.Models;
using System.Web.Services;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Routing;
using Globale_Varriables;
using TRC_GS_COMMUNICATION.Models;
using TRC_GS_COMMUNICATION.Controllers;
using System.IO;

namespace maintenance.Controllers
{
    public class OrdersController : BaseController
    {

        //protected override void Initialize(RequestContext rc)
        //{
        //    base.Initialize(rc);
        //    //Globale_Varriables.VAR.myCookie = Request.Cookies["TRCVLog"];
        //    //if (Session["userID"] == null)
        //    //{
        //    //    if (VAR.verifyCookie())
        //    //    {
        //    //        Session["userID"] = VAR.myCookie.Values["userid"].ToString();
        //    //        MajModeles majMod = new MajModeles();
        //    //        Session["login"] = majMod.getUserbyId(Session["userID"].ToString());
        //    //        Configs.login = Session["login"].ToString();
        //    //    }
        //    //    else
        //    //        VAR.Redirect();
        //    //}

        //}



        public ActionResult Index()
        {
            return View();
        }


        public ActionResult Show(string id)
        {
            return View();
        
        }


        public ActionResult Afficher(string mode = "ajouter", string OTID = "0", string valBase = "", string idPackage = "")
        {
            if (valBase != "")
            {
                DataTable dataNOBL = Configs._query.executeProc("packGetNextNOBL", "valBase@int@" + valBase);
                    if(Tools.verifyDataTable(dataNOBL))
                        ViewData["valDataNOBL"] = dataNOBL.Rows[0][0].ToString();
                        ViewData["valDataIdPackage"] = idPackage;

            }

            ViewData["mode"] = mode;
            ViewData["OTID"] = OTID;
            return View();
        }

        public ActionResult test()
        {
     
            return View();
        }

        public ActionResult getLstOT(string OTID = "-1")
        {
            string role = Session["role"].ToString();
            DataTable OTData = Configs._query.executeProc("OTGetList", "OTID@int@" + OTID + "#role@string@" + role);
            ViewData["OTData"] = OTData;
            return View();
        }

        public string SetShowCurrent(string show)
        {
            Session["showaOnlyCurrentAgence"] = show == "1" ? Session["agenceID"].ToString() : null;
            return "OK";
        }

        public ActionResult getLstOT1(string show = "all")
        {
            string role = Session["role"].ToString();
            string param = "DisplayLength@int@0";
            param += "#DisplayStart@int@0";
            param += "#SortCol@int@0";
            param += "#SortDir@string@asc";
            param += "#role@string@" + role;
            param += "#show@string@" + show;
            DataTable OTData = Configs._query.executeProc("spOTGetList", param);
            ViewData["OTData"] = OTData;
            ViewData["show"] = show;
            ViewData["showaOnlyCurrentAgence"] = Session["showaOnlyCurrentAgence"];
            
            return View();
        }
        [HttpPost]
        public ActionResult LoadLstOTData(string show = "all")
        {
            // paging parameters & length display
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            // sorting comumns
            var sortCol = Request.Form.GetValues("columns[" + Request.Form.GetValues("order[0][column]").FirstOrDefault() + "][name]").FirstOrDefault(); 
            var sortDir = Request.Form.GetValues("order[0][dir]").FirstOrDefault();
            sortCol = Request.Form.GetValues("order[0][column]").FirstOrDefault();
            // filter search
            var search = Request.Form.GetValues("search[value]").FirstOrDefault();
            var search_tag_otid = Request.Form.GetValues("columns[1][search][value]").FirstOrDefault();
            
            // data
            string data = "[]";
            int recordsFiltred = 0;
            int recordsTotal = 0;
            // get data from database
            string param = "DisplayLength@int@" + length;
            param += "#DisplayStart@int@" + start;
            param += "#SortCol@int@" + sortCol;
            param += "#SortDir@string@" + sortDir;
            param += "#role@string@" + Session["role"].ToString();
            // filter
            if (!string.IsNullOrEmpty(search))
                param += "#Search@string@" + search;
            if (!string.IsNullOrEmpty(search_tag_otid))
                param += "#Search_tag_otid@string@" + search_tag_otid;
            param += "#show@string@" + show;
            if (Session["showaOnlyCurrentAgence"] != null)
                param += "#AgenceID@string@" + Session["showaOnlyCurrentAgence"].ToString();

            DataTable OTData = Configs._query.executeProc("spOTGetList", param);

            if (Tools.verifyDataTable(OTData))
            {
                recordsFiltred = Int32.Parse(OTData.Rows[0]["filtredCount"].ToString());
                recordsTotal = Int32.Parse(OTData.Rows[0]["TotalCount"].ToString());

                data = Tools.DataTableToJsonObj(OTData, 3);
            }
            string result = "{\"draw\" : \"" + draw + "\",\"iTotalDisplayRecords\" : \"" + recordsFiltred + "\",\"iTotalRecords\" : \"" + recordsTotal + "\",\"aaData\" : " + data + "}";

            return Content(result, "application/json");
        }


        public ActionResult getLstOTRDV(string mode = "RDV", string title = "")
        {
            string role = Session["role"].ToString();
            string param = "mode@string@" + mode + "#role@string@" + role;            
            if (Session["showaOnlyCurrentAgence"] != null)
                param += "#AgenceID@string@" + Session["showaOnlyCurrentAgence"].ToString();

            DataTable OTData = Configs._query.executeProc("OTGetListByMode", param);
            ViewData["OTData"] = OTData;
            ViewData["title"] = title;
            ViewData["mode"] = mode;
            ViewData["showaOnlyCurrentAgence"] = Session["showaOnlyCurrentAgence"];
            return View();
        }
        /***************************************** Export LST RDV *************************************************/

        public ActionResult exportLstOT(string mode)
        {
            string _fileName = mode + "_lst.csv";
            string pathSave = "";
            pathSave = Globale_Varriables.VAR.PATH_STOCKAGE + @"\" + _fileName;

            string role = Session["role"].ToString();
            DataTable OTData = Configs._query.executeProc("OTGetListExpByMode", "mode@string@" + mode + "#role@string@" + role);
            DataSetHelper.CreateWorkbookCSV(pathSave, OTData);
            
            string urlRedirection = Globale_Varriables.VAR.urlFileUpload + "/" + _fileName;
            return Redirect(urlRedirection);

            // return View();
        }

        public ActionResult getLstOTcloture()
        {
            string role = Session["role"].ToString();
            string param = "DisplayLength@int@0";
            param += "#DisplayStart@int@0";
            param += "#SortCol@int@0";
            param += "#SortDir@string@asc";
            param += "#role@string@" + role;
            DataTable OTData = Configs._query.executeProc("spOTGetListCloture", param);
            ViewData["OTData"] = OTData;
            ViewData["showaOnlyCurrentAgence"] = Session["showaOnlyCurrentAgence"];

            return View();
        }
        [HttpPost]
        public ActionResult LoadLstOTDataCloture()
        {
            // paging parameters & length display
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            // sorting comumns
            var sortCol = Request.Form.GetValues("columns[" + Request.Form.GetValues("order[0][column]").FirstOrDefault() + "][name]").FirstOrDefault();
            var sortDir = Request.Form.GetValues("order[0][dir]").FirstOrDefault();
            sortCol = Request.Form.GetValues("order[0][column]").FirstOrDefault();
            // filter search
            var search = Request.Form.GetValues("search[value]").FirstOrDefault();
            var search_tag_otid = Request.Form.GetValues("columns[1][search][value]").FirstOrDefault();

            // data
            string data = "[]";
            int recordsFiltred = 0;
            int recordsTotal = 0;
            // get data from database
            string param = "DisplayLength@int@" + length;
            param += "#DisplayStart@int@" + start;
            param += "#SortCol@int@" + sortCol;
            param += "#SortDir@string@" + sortDir;
            param += "#role@string@" + Session["role"].ToString();
            // filter
            if (!string.IsNullOrEmpty(search))
                param += "#Search@string@" + search;
            if (!string.IsNullOrEmpty(search_tag_otid))
                param += "#Search_tag_otid@string@" + search_tag_otid;

            if (Session["showaOnlyCurrentAgence"] != null)
                param += "#AgenceID@string@" + Session["showaOnlyCurrentAgence"].ToString();

            DataTable OTData = Configs._query.executeProc("spOTGetListCloture", param);

            if (Tools.verifyDataTable(OTData))
            {
                recordsFiltred = Int32.Parse(OTData.Rows[0]["filtredCount"].ToString());
                recordsTotal = Int32.Parse(OTData.Rows[0]["TotalCount"].ToString());

                data = Tools.DataTableToJsonObj(OTData, 3);
            }
            string result = "{\"draw\" : \"" + draw + "\",\"iTotalDisplayRecords\" : \"" + recordsFiltred + "\",\"iTotalRecords\" : \"" + recordsTotal + "\",\"aaData\" : " + data + "}";

            return Content(result, "application/json");
        }
        
        public ActionResult getLst(string OTID = "-1")
        {
            string role = Session["role"].ToString();
            DataTable OTData = Configs._query.executeProc("OTGetList", "OTID@int@" + OTID + "#role@string@" + role);
            ViewData["OTData"] = OTData;
            return View();
        }

        public ViewResult FormRessource(string RessourceCode = "OT", string DetailID = "0", string mode = "List", string isOpen = "1", string isPalannifToPast = "1", string callFromGroup = "0")
        {
            ViewData["DetailID"] = DetailID;
            ViewData["RessourceCode"] = RessourceCode;
            ViewData["mode"] = mode;
            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;
            ViewData["step"] = "1";

            var dt = Configs._query.executeProc("OTGetList", "OTID@int@" + DetailID);
            int OTPeriodesNonAttribuees = -1;
            if (Tools.verifyDataTable(dt) && dt.Rows[0]["OTPeriodesNonAttribuees"] != DBNull.Value && Int32.TryParse(dt.Rows[0]["OTPeriodesNonAttribuees"].ToString(), out OTPeriodesNonAttribuees))
            {
                ViewData["OTPeriodesNonAttribuees"] = OTPeriodesNonAttribuees; 
            }
            ViewData["OTPeriodesNonAttribuees"] = OTPeriodesNonAttribuees;
            ViewData["callFromGroup"] = callFromGroup; 
            return View();
        }

        /*
        public string getFormRessourceColumns(string RessourceCode, string DetailID)
        {
            return RessourceGenerator.generateForm(RessourceCode, DetailID);
        }
        */

        public string getFormRessourceColumns(string ID, string ObjID)
        {
            return RessourceGenerator.generateForm(ID, ObjID);
        }

        public string getForm(string RessourceCode)
        {
            return RessourceGenerator.getForm(RessourceCode);
        }

        public string getSteps(string RessourceCode)
        {
            return RessourceGenerator.getSteps(RessourceCode);
        }

        public string saveRessource(string RessourceCode, string DetailID, string json)
        {
            string res = "0";

            System.Web.Script.Serialization.JavaScriptSerializer objJSSerializer = new
                System.Web.Script.Serialization.JavaScriptSerializer();

            List<RessourceColumn> lst = objJSSerializer.Deserialize<List<RessourceColumn>>(json);
            var elements = from col in lst
                           where col.Code == "Code"
                           select col;

            if (elements.Count() > 0)
            {
                string param = "";
                foreach (RessourceColumn col in lst)
                    param += col.Code + "@" + RessourceGenerator.getProcType(col.Value.ToString()) + "@" + col.Type + "#";

                param += "ID@int@" + DetailID + "#" + "name@string@" + RessourceCode;

                DataTable dt = Configs._query.executeProc("_saveObject", param);
                if (Tools.verifyDataTable(dt))
                    res = dt.Rows[0][0].ToString();
            }

            return res;
        }

        public string saveRessourceFigee(string  datLivr, string NOBL, string cStock, string typeDoss, string chargNom, string chargLieu , string  chargNP , string chargPays, string chargVille ,
                    string livrNom, string livrLieu , string livrNP , string livrPays , string livrVille , string livrTel, string livrCont, string livrCourr,
                    string donnNom, string donnLieu , string donnNP , string donnPays , string  donnVille, string donnTel, string donnCourr,
                    string OTMagID, string DetailID = "-1", string packID = "0", string OTNoteInterne = "", string OTMontObligatoire = "0", string typeGDoss = "", string OTCommunication = "",
                    string OTChargementContact = "", string OTTelChargement = "", string OTChargementEmail = "", string livrTel2 = "")
        {
            string param = ""; float temp;
            string res = "";

            param += "datLivr$string$" + datLivr +
                "~" + "NOBL$string$" + NOBL +
                "~" + "cStock$string$" + cStock +
                "~" + "typeDoss$string$" + typeDoss +

                "~" + "chargNom$string$" + chargNom +
                "~" + "chargLieu$string$" + chargLieu +
                "~" + "chargNP$string$" + chargNP +
                "~" + "chargPays$string$" + chargPays +
                "~" + "chargVille$string$" + chargVille +

                "~" + "donnNom$string$" + donnNom +
                "~" + "donnLieu$string$" + donnLieu +
                "~" + "donnNP$string$" + donnNP +
                "~" + "donnPays$string$" + donnPays +
                "~" + "donnVille$string$" + donnVille +
                "~" + "donnTel$string$" + donnTel +
                "~" + "donnCourr$string$" + donnCourr +

                "~" + "livrNom$string$" + livrNom +
                "~" + "livrLieu$string$" + livrLieu +
                "~" + "livrNP$string$" + livrNP +
                "~" + "livrPays$string$" + livrPays +
                "~" + "livrVille$string$" + livrVille +
                "~" + "livrTel$string$" + livrTel +
                "~" + "livrCont$string$" + livrCont +
                "~" + "livrCourr$string$" + livrCourr +

                "~" + "OTMagID$int$" + OTMagID +
                "~" + "DetailID$int$" + DetailID +
                "~" + "packID$int$" + packID +
                "~" + "OTNoteInterne$string$" + OTNoteInterne +
                "~" + "OTCommunication$string$" + OTCommunication +
                "~" + "OTChargementContact$string$" + OTChargementContact +
                "~" + "OTTelChargement$string$" + OTTelChargement +
                "~" + "OTChargementEmail$string$" + OTChargementEmail+
                "~" + "livrTel2$string$" + livrTel2;
            if (float.TryParse(OTMontObligatoire, out temp))
                param += "~" + "OTMontObligatoire$string$" + OTMontObligatoire;
            if (!string.IsNullOrWhiteSpace(typeGDoss))
                param += "~" + "typeGDoss$string$" + typeGDoss;


            DataTable dt = Configs._query.executeProcMail("OTsaveOTFigee", param, false, '$', '~');
                if (Tools.verifyDataTable(dt))
                    res = dt.Rows[0][0].ToString();
          

            return res;
        }

        public ActionResult getRefListMagasin(string magID = "-1", string input = "", string txtID = "")
        {
            DataTable dataListMagasin = Configs._query.executeProc("OTGetMagasinList", "magID@int@" + magID);
            ViewData["dataListMagasin"] = dataListMagasin;


            ViewData["lbl"] = input;
            ViewData["txt"] = txtID;
           
            return View();
        }
        public string getMagasinID(string magCode)
        {
            DataTable dt = Configs._query.executeProc("OTGetMagasinByCode", "code@string@" + magCode);
            if (Tools.verifyDataTable(dt))
            { 
                return dt.Rows[0][0].ToString();
            }
            return "-1";
        }

        public string OTGetInfos(string magValID = "")
        {
            string infos = "";
            string donnID = "", chargID = "", LivrID = "";

            DataTable dataInfosOT = Configs._query.executeProc("OTGetMagasinList", "magID@int@" + magValID);
            if (Tools.verifyDataTable(dataInfosOT))
            {
                donnID = dataInfosOT.Rows[0]["donneurID"].ToString();
                chargID = dataInfosOT.Rows[0]["chargementID"].ToString();
                LivrID = dataInfosOT.Rows[0]["livraisonID"].ToString();
            }

            DataTable dataInfosDonneur = Configs._query.executeProc("OTGetInfosClient", "ClientID@int@" + donnID);
            if (Tools.verifyDataTable(dataInfosDonneur))
            {
                infos += donnID + "*";
                infos += dataInfosDonneur.Rows[0]["Nom"].ToString() + "*";
                infos += dataInfosDonneur.Rows[0]["Lieu"].ToString() + "*";
                infos += dataInfosDonneur.Rows[0]["NP"].ToString() + "*";
                infos += dataInfosDonneur.Rows[0]["Ville"].ToString() + "*";
                infos += dataInfosDonneur.Rows[0]["Pays"].ToString() + "*";
                infos += dataInfosDonneur.Rows[0]["Tel"].ToString() + "|";
            }
            else
            {
                infos += "******|";
            }

            DataTable dataInfosChargement = Configs._query.executeProc("OTGetInfosClient", "ClientID@int@" + chargID);
            if (Tools.verifyDataTable(dataInfosChargement))
            {
                infos += chargID + "*";
                infos += dataInfosChargement.Rows[0]["Nom"].ToString() + "*";
                infos += dataInfosChargement.Rows[0]["Lieu"].ToString() + "*";
                infos += dataInfosChargement.Rows[0]["NP"].ToString() + "*";
                infos += dataInfosChargement.Rows[0]["Ville"].ToString() + "*";
                infos += dataInfosChargement.Rows[0]["Pays"].ToString() + "*";
                infos += dataInfosDonneur.Rows[0]["Tel"].ToString() + "|";
            }
            else
            {
                infos += "******|";
            }

            DataTable dataInfosLivraison = Configs._query.executeProc("OTGetInfosClient", "ClientID@int@" + LivrID);
            if (Tools.verifyDataTable(dataInfosLivraison))
            {
                infos += LivrID + "*";
                infos += dataInfosLivraison.Rows[0]["Nom"].ToString() + "*";
                infos += dataInfosLivraison.Rows[0]["Lieu"].ToString() + "*";
                infos += dataInfosLivraison.Rows[0]["NP"].ToString() + "*";
                infos += dataInfosLivraison.Rows[0]["Ville"].ToString() + "*";
                infos += dataInfosLivraison.Rows[0]["Pays"].ToString() + "*" ;
                infos += dataInfosDonneur.Rows[0]["Tel"].ToString() ;
            }
            else
            {
                infos += "******";
            }


            return infos;

        }


        [WebMethod]
        public JsonResult getAdresseComplete(string val, string ClientID)
        {
            DataTable dtClient = null;
            StringBuilder sb = new StringBuilder();

            dtClient = Configs._query.executeProc("OTGetAdressComplete", "adr@string@" + val + "#ID@int@" + ClientID);

            if (Tools.verifyDataTable(dtClient))
            {
                sb.Append("[");
                for (int i = 0; i < dtClient.Rows.Count; i++)
                {
                    sb.Append("{\"key\":" + dtClient.Rows[i]["ClientID"].ToString() + ", \"value\":\"" + dtClient.Rows[i]["Adresse"].ToString().Trim() + "*" + dtClient.Rows[i]["NP"].ToString().Trim() + "*" + dtClient.Rows[i]["Ville"].ToString().Trim() + "\"}");

                    if (i < dtClient.Rows.Count - 1)
                        sb.Append(",");
                }

                sb.Append("]");
            }

            var jsag = new JavaScriptSerializer();

            dynamic dataag = jsag.Deserialize<dynamic>(sb.ToString());

            return Json(dataag, JsonRequestBehavior.AllowGet);
        }


        [WebMethod]
        public JsonResult getPaysComplete(string val)
        {
            DataTable dtClient = null;
            StringBuilder sb = new StringBuilder();

            dtClient = Configs._query.executeProc("OTGetPaysComplete", "adr@string@" + val );

            if (Tools.verifyDataTable(dtClient))
            {
                sb.Append("[");
                for (int i = 0; i < dtClient.Rows.Count; i++)
                {
                    sb.Append("{\"key\":" + dtClient.Rows[i]["IDPays"].ToString() + ", \"value\":\"" + dtClient.Rows[i]["Name"].ToString().Trim() + "\"}");

                    if (i < dtClient.Rows.Count - 1)
                        sb.Append(",");
                }

                sb.Append("]");
            }

            var jsag = new JavaScriptSerializer();

            dynamic dataag = jsag.Deserialize<dynamic>(sb.ToString());

            return Json(dataag, JsonRequestBehavior.AllowGet);
        }

        public ActionResult OTGetRessources(string cliFamille, string lbl, string txt)
        {
            DataTable clientDT = null;

            clientDT = Configs._query.executeProc("OTGetCliByType", "type@string@" + cliFamille);


            ViewData["_RessourceContents"] = clientDT;
            ViewData["_RessourceFamille"] = cliFamille;

            ViewData["lbl"] = lbl;
            ViewData["txt"] = txt;

            return View();
        }

        public string OTGetRessourceClientByID(string cliFamille, string valID)
        {
            string res = "";
            string _params = "";

            _params = "type@string@" + cliFamille + "#ID@string@" + valID;

            DataTable dataClient = Configs._query.executeProc("OTGetClientByID", _params);

            if (Tools.verifyDataTable(dataClient))
            {

                res = dataClient.Rows[0]["Nom"].ToString() + "*"
                + dataClient.Rows[0]["adresse"].ToString() + "*"
                + dataClient.Rows[0]["NP"].ToString() + "*"
                + dataClient.Rows[0]["Ville"].ToString() + "*"
                + dataClient.Rows[0]["Pays"].ToString() + "*"
                + dataClient.Rows[0]["Tel"].ToString();

            }
            return res;
        }

        public string GetInfoMagByOTID(string OTID)
        {

            string _params = "", res = "";

            _params = "OTID@int@" + OTID ;

            DataTable dataMag = Configs._query.executeProc("OTGetInfoMagByOTID", _params);

            if (Tools.verifyDataTable(dataMag))
            {

                res = dataMag.Rows[0]["NOBL"].ToString() + "*"
                + ((DateTime)dataMag.Rows[0]["Date"]).ToString("yyyy/MM/dd HH:mm") + "*"

                + dataMag.Rows[0]["chargNom"].ToString() + "*"
                + dataMag.Rows[0]["chargLieu"].ToString() + "*"
                + dataMag.Rows[0]["chargNP"].ToString() + "*"
                + dataMag.Rows[0]["chargVille"].ToString() + "*"
                + dataMag.Rows[0]["chargPays"].ToString() + "*"

                + dataMag.Rows[0]["LivrNom"].ToString() + "*"
                + dataMag.Rows[0]["LivrLieu"].ToString() + "*"
                + dataMag.Rows[0]["LivrNP"].ToString() + "*"
                + dataMag.Rows[0]["LivrVille"].ToString() + "*"
                + dataMag.Rows[0]["LivrPays"].ToString() + "*"

                + dataMag.Rows[0]["donnNom"].ToString() + "*"
                + dataMag.Rows[0]["donnLieu"].ToString() + "*"
                + dataMag.Rows[0]["donnNP"].ToString() + "*"
                + dataMag.Rows[0]["donnVille"].ToString() + "*"
                + dataMag.Rows[0]["donnPays"].ToString() + "*"

                + dataMag.Rows[0]["codestock"].ToString() + "*"
                + dataMag.Rows[0]["OTPoids"].ToString() + "*"
                + ((DateTime) dataMag.Rows[0]["dateCre"]).ToString("yyyy/MM/dd HH:mm") + "*"
                + dataMag.Rows[0]["OTVolume"].ToString() + "*"
                + dataMag.Rows[0]["TelD"].ToString() + "*"
                + dataMag.Rows[0]["TelL"].ToString() + "*"
                + dataMag.Rows[0]["Contact"].ToString() + "*"
                + dataMag.Rows[0]["emailD"].ToString() + "*"
                + dataMag.Rows[0]["emailL"].ToString() + "*"
                + dataMag.Rows[0]["typeDoss"].ToString() + "*"
                + dataMag.Rows[0]["OTNoteInterne"].ToString() + "*"
                + dataMag.Rows[0]["OTMontObligatoire"].ToString() + "*"
                + dataMag.Rows[0]["OTCommunication"].ToString() + "*"

                + dataMag.Rows[0]["OTChargementContact"].ToString() + "*"
                + dataMag.Rows[0]["OTTelChargement"].ToString() + "*"
                + dataMag.Rows[0]["OTChargementEmail"].ToString() + "*"
                //
                + dataMag.Rows[0]["TelL2"].ToString() + "*"
                + dataMag.Rows[0]["nom_agence"].ToString() + "*";

            }
            else
                res = "**************************";
            return res;

        }

        //public string printPackages(string values)
        //{
        //    int nbr = -1;
        //    string[] tab = values.Split(';');

        //    string template = "";
        //    DataTable dt = Configs._query.executeProc("getTemplate", "name@string@ticket_Art");
        //    if (Tools.verifyDataTable(dt))
        //    {
        //        template = dt.Rows[0]["html"].ToString();
        //        string printName = dt.Rows[0]["printer"].ToString();

        //        foreach (string id in tab)
        //        {
        //            string param = "ID@int@" + id;
        //            dt = Configs._query.executeProc("PRC_getArticleInfo", param);
        //            if (Tools.verifyDataTable(dt))
        //            {
        //                string tmp = template;
        //                for (int i = 0; i < dt.Columns.Count; i++)
        //                {
        //                    string colName = dt.Columns[i].ColumnName;
        //                    tmp = tmp.Replace("{" + colName + "}", dt.Rows[0][colName].ToString());
        //                }

        //                if (Print.printTicket(tmp, printName) == "Printed")  // Ancienne
        //                    //if (RawPrinterHelper.SendStringToPrinter(printName, template)) 
        //                    nbr = 1;
        //            }
        //        }
        //    }

        //    return nbr.ToString(); // (nbr == tab.Length) ? "0" : "-1";
        //}

        public string CloturerOT(string OTID)
        {
            string res = "";
            DataTable dt = Configs._query.executeProc("OTCloturerOT", "OTID@int@" + OTID);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }
        public string RelivrerOT(string OTID)
        {
            string res = "";
            DataTable dt = Configs._query.executeProc("OTRelivrerOT", "OTID@int@" + OTID);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }


        public ActionResult propositionOT(string valDonn, string valChoix )
        {
            string res = "0";
            DataTable dtOT = Configs._query.executeProc("OTverifierNOBL", "valDonn@string@" + valDonn + "#valChoix@string@" + valChoix);
            if (Tools.verifyDataTable(dtOT))
            {
                res = dtOT.Rows[0][0].ToString();
            }
            ViewData["existe"] = res;
            ViewData["listProp"] = dtOT;
            return View();
        }

        public string verifierOTexiste(string valDonn, string valChoix)
        {
            string res = "0";
            DataTable dtOT = Configs._query.executeProc("OTverifierNOBL", "valDonn@string@" + valDonn + "#valChoix@string@" + valChoix);
            if (Tools.verifyDataTable(dtOT))
            {
                res = dtOT.Rows[0][0].ToString();
            }
            return res;
        }

        public string getVilleByNP(string np)
        {
            string res = "0";
            DataTable dtOT = Configs._query.executeProc("getVilleByNP", "np@string@" + np);
            if (Tools.verifyDataTable(dtOT))
            {
                res = dtOT.Rows[0][0].ToString();
            }
            return res;
        }

    }
}
