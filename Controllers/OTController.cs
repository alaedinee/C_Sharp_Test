using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Globale_Varriables;
using TRC_GS_COMMUNICATION.Models;
using Omniyat.Models;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class OTController : BaseController
    {

        public int test = 1;
        //
        // GET: /OT/

       
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


        public ActionResult Index()
        {
            return RedirectToAction("getLstOT1", "Orders");
        }


        public ActionResult editReception(string recepID = "0")
        {
            ViewData["recDonneur"] = Configs._query.executeProc("dev_getRecDonneur", "");

            ViewData["recFournisseur"] = Configs._query.executeProc("recListFournisseur", "IDList@int@10");
           
            ViewData["recType"] = Configs._query.executeProc("recListType", "IDList@int@9");


            ViewData["recDt"] = Configs._query.executeProc("dev_getReception", "recepID@int@" + recepID);

            ViewData["recepID"] = recepID;
            return View();
        }



        public string saveRecepDonn(string recepID, string donneur, 
                                 string valrecep, string dateRecep,  string recType, string recPoid, 
                                 string recVolume, string recCamio, string recChauffeur )
        {
            string param = "recepID@int@" + recepID + "#donneur@string@" + donneur 
                           + "#user@int@" + Session["userID"]

                           + "#valrecep@string@" + valrecep
                           + "#dateRecep@date@" + dateRecep
                           + "#recType@string@" + recType
                           + "#recPoid@float@" + recPoid
                           + "#recVolume@float@" + recVolume
                           + "#recCamio@string@" + recCamio
                           + "#recChauffeur@string@" + recChauffeur ;

            DataTable dt = Configs._query.executeProc("dev_saveRecDonneur", param);
            string res = "0";

            if (Tools.verifyDataTable(dt)) res = dt.Rows[0][0].ToString();

            return res;
        }

        public ActionResult receptionForm(string login = "")
        {

            //string res = "";
            login = Session["login"].ToString();
            string loginID =  Session["userID"].ToString();
            string AgenceID = Session["agenceID"].ToString();

            DataTable dt = Configs._query.executeProc("recVerifyReception", "AgenceID@int@" + AgenceID);
            
            if (Tools.verifyDataTable(dt))
            {
                ViewData["reception"] = dt;
            }

            ViewData["recFournisseur"] = Configs._query.executeProc("recListFournisseur", "IDList@int@10");
            ViewData["recDonneur"] = Configs._query.executeProc("dev_getRecDonneur", "");

            ViewData["recType"] = Configs._query.executeProc("recListType", "IDList@int@9");

            ViewData["login"] = login;
            ViewData["loginID"] = loginID;
            return View();
        }

        public string genererRec(string login, string etatRecep, string OTID, string valrecep = "", string dateRecep = "", string recType = "", string recPoid = "", string recVolume = "", string recCamio = "", string recChauffeur = "", string recepID = "", string recepCODE = "", string recDonn="")
        {

            string receptionCode = "";
            string receptionID= "";
            string receptionDate = "";
            string receptionType= "";
            string receptionPoid = "";
            string receptionVolume = "";
            string receptionCamio= "";
            string receptionChauffeur = "";

            if (valrecep != "")
            {

                DataTable dt = Configs._query.executeProc("recCreateReception", "valrecep@string@" + valrecep + "#login@string@" + login + "#etatRecept@int@" + etatRecep + "#dateRecep@date@" + dateRecep + "#recType@string@" + recType +
                    "#recPoid@float@" + recPoid + "#recVolume@float@" + recVolume + "#recCamio@string@" + recCamio + "#recChauffeur@string@" + recChauffeur + "#recDonn@string@" + recDonn);

                if (Tools.verifyDataTable(dt))
                {
                    receptionCode = dt.Rows[0]["receptionNumber"].ToString();
                    receptionID = dt.Rows[0]["receptionID"].ToString();
                    receptionDate = dt.Rows[0]["dateReception"].ToString();
                    receptionType = dt.Rows[0]["typeReception"].ToString();
                    receptionPoid = dt.Rows[0]["poid"].ToString();
                    receptionVolume = dt.Rows[0]["volume"].ToString();
                    receptionCamio = dt.Rows[0]["camio"].ToString();
                    receptionChauffeur = dt.Rows[0]["chauffeur"].ToString();
                }

            }
            else if (recepID != "" && recepCODE != "")
            {
                receptionCode = recepCODE;
                receptionID = recepID;
                receptionDate = dateRecep;
                receptionType = recType;
                receptionPoid = recPoid;
                receptionVolume = recVolume;
                receptionCamio = recCamio;
                receptionChauffeur = recChauffeur;
            }


            if (receptionCode != "")
            {
                Session["loginReception"] = receptionCode;
                Session["loginReceptionID"] = receptionID;
                Session["loginReceptionDate"] = receptionDate;
                Session["loginReceptionType"] = receptionType;
                Session["loginReceptionPoid"] = receptionPoid;
                Session["loginReceptionVolume"] = receptionVolume;
                Session["loginReceptionCamio"] = receptionCamio;
                Session["loginReceptionChauffeur"] = receptionChauffeur;
                Session["color"] = "red";
                Session["visible"] = "visible";
            }

            return receptionCode + "*" + receptionDate + "*" + receptionType + "*" + receptionPoid + "*" + receptionVolume + "*" + receptionCamio + "*" + receptionChauffeur;
        }

        public string destroyReception(string recepID = "")
        {

            string result = "";

            try
            {
                DataTable dataRecp = Configs._query.executeProc("recFermerReception", "recepID@int@" + recepID);
                if (Tools.verifyDataTable(dataRecp))
                {
                    result = dataRecp.Rows[0][0].ToString();
                }
                System.Web.HttpContext.Current.Session["loginReception"] = "";
                System.Web.HttpContext.Current.Session["loginReceptionID"] = "";
                System.Web.HttpContext.Current.Session["loginReceptionDate"] = "";
                System.Web.HttpContext.Current.Session["loginReceptionType"] = "";
                System.Web.HttpContext.Current.Session["loginReceptionPoid"] = "";
                System.Web.HttpContext.Current.Session["loginReceptionVolume"] = "";
                System.Web.HttpContext.Current.Session["color"] = "black";
                System.Web.HttpContext.Current.Session["visible"] = "hidden";

            }
            catch (Exception exp)
            {
                Configs.Debug(exp, "maintenance.Controllers.OTController.destroyReception", "Erreur de suppresion de la session ");
            }

            return result;

        }

        public ActionResult addPackToRecepForm(string recepID, string recepCode)
        {
            ViewData["recepID"] = recepID;
            ViewData["recepCode"] = recepCode;


            DataTable DataPackage = Configs._query.executeProc("packGetPacks", "otid@int@-1");

            if (Tools.verifyDataTable(DataPackage))
            {
                ViewData["ListPackages"] = DataPackage;
            }

            return View();
        }

        public string addPackToReception(string IDPackage = "", string IDRecep = "")
        {

            string result="0";
            if (IDPackage != "" && IDRecep != "")
            {
                string _params = "IDPackage@int@" + IDPackage + "#IDRecep@int@" + IDRecep;
                DataTable dataRes = Configs._query.executeProc("recAddPackToRecep", _params);
                if(Tools.verifyDataTable(dataRes))
                    result = dataRes.Rows[0][0].ToString();
            }
            else 
                result = "0";

            return result;

        }


        public ActionResult ListAllReception(string IDRecep = "")
        {
            ViewData["ListAllReception"] = Configs._query.executeProc("recGetAllReception", "IDRecep@int@" + IDRecep);
            return View();
        }

        public ActionResult ListPackParReception(string IDRecep = "")
        {
            ViewData["ListPackParReception"] = Configs._query.executeProc("recGetPackParRecep", "IDRecep@int@" + IDRecep);
            return View();
        }

        public ActionResult afficherOT(string mode = "ajouter", string OTID = "0", string valBase = "", string idPackage = "", string callFromGroup = "0")
        {
            if (valBase != "")
            {
                DataTable dataNOBL = Configs._query.executeProc("packGetNextNOBL", "valBase@int@" + valBase);
                if (Tools.verifyDataTable(dataNOBL))
                    ViewData["valDataNOBL"] = dataNOBL.Rows[0][0].ToString();
                ViewData["valDataIdPackage"] = idPackage;

            }
            string isOpen = "1";
            bool _isGroup = false; 
            DataTable dtOT = Configs._query.executeProc("OTGetOT", "OTID@int@" + OTID);
            if (dtOT != null && dtOT.Rows.Count > 0)
            {
                isOpen = dtOT.Rows[0]["OTEtat"] == DBNull.Value || dtOT.Rows[0]["OTEtat"].ToString() == "50" ? "0" : "1";
                _isGroup = dtOT.Rows[0]["OTType"] != DBNull.Value;
            }
            //
            string isPalannifToPast = "1";
            dtOT = Configs._query.executeProc("OTisPalannifToPast", "OTID@int@" + OTID);
            if (dtOT != null && dtOT.Rows.Count > 0)
                isPalannifToPast = dtOT.Rows[0][0].ToString();

            ViewData["mode"] = mode;
            ViewData["OTID"] = OTID;

            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;
            ViewData["callFromGroup"] = callFromGroup;

            if (!_isGroup || callFromGroup == "1")
                return View();
            else
                return RedirectToAction("AfficherOTGroupe", new { OTID = OTID });

        }

        public ActionResult lstReception()
        {
            DataTable dt = Configs._query.executeProc("recVerifyReception", "");

            ViewData["dt"] = dt;
            return View();

        }

        /******* GROUPE *******/
        public ActionResult AfficherOTGroupe(string OTID)
        {
            ViewData["OTID"] = OTID;

            return View();
        }

        public string getOTGroupeType(string OTID = "-1")
        {
            string res = "";

            DataTable dt = Configs._query.executeProc("OT_GetOTGroupe", "otid@int@"+OTID);

            if (Tools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                    res += (i == 0 ? "" : ",") + dt.Rows[i]["code"].ToString() + "|" + dt.Rows[i]["name"].ToString() + "|" + dt.Rows[i]["selected"].ToString();
            }

            return res;
        }

        public ActionResult ListOTByGroup(string OTIDGroup)
        {
            DataTable dt = Configs._query.executeProc("OT_GetOTByGroup", "OTIDGroup@int@" + OTIDGroup);
            ViewData["data"] = dt;
            ViewData["OTIDGroup"] = OTIDGroup;

            return View();
        }
        // Add To Acls

        public ActionResult OTToAddInGroupe( string OTID )
        {
            string role = Session["role"].ToString();
            string param = "DisplayLength@int@0";
            param += "#DisplayStart@int@0";
            param += "#SortCol@int@0";
            param += "#SortDir@string@asc";
            param += "#role@string@" + role;
            param += "#OTID@int@" + OTID;
            DataTable OTData = Configs._query.executeProc("spOTToAddInGroupe", param);
            ViewData["OTData"] = OTData;
            ViewData["OTID"] = OTID;

            return View();
        }
        [HttpPost]
        public ActionResult LoadLstOTData_OTToAddInGroupe(string OTID)
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
            param += "#OTID@int@" + OTID;

            DataTable OTData = Configs._query.executeProc("spOTToAddInGroupe", param);

            if (Tools.verifyDataTable(OTData))
            {
                recordsFiltred = Int32.Parse(OTData.Rows[0]["filtredCount"].ToString());
                recordsTotal = Int32.Parse(OTData.Rows[0]["TotalCount"].ToString());

                data = Tools.DataTableToJsonObj(OTData, 3);
            }
            string result = "{\"draw\" : \"" + draw + "\",\"iTotalDisplayRecords\" : \"" + recordsFiltred + "\",\"iTotalRecords\" : \"" + recordsTotal + "\",\"aaData\" : " + data + "}";

            return Content(result, "application/json");
        }

        public string AddOTTOGroupe(string OTGroupe, string OTID)
        {
            DataTable dt = Configs._query.executeProc("OT_AddOTToGroupe", "OTGroupe@int@" + OTGroupe + "#OTID@int@" + OTID);
            if (Tools.verifyDataTable(dt))
                return dt.Rows[0][0].ToString();
            return "0";
        }
        public string DeleteOTFromGroupe(string OTGroupe, string OTID)
        {
            DataTable dt = Configs._query.executeProc("OT_DeleteOTFromGroupe", "OTGroupe@int@" + OTGroupe + "#OTID@int@" + OTID);
            if (Tools.verifyDataTable(dt))
                return dt.Rows[0][0].ToString();
            return "0";
        }

        public ActionResult InfoGroupe(string OTIDGroup)
        {
            DataTable dt = Configs._query.executeProc("OT_GetInfoOTGroupe", "OTID@int@" + OTIDGroup);

            string Poids = "0", Volume = "0", NbrOT = "0", PoidsMax = "0";

            if (Tools.verifyDataTable(dt))
            {
                Poids   = dt.Rows[0]["Poids"].ToString();
                Volume  = dt.Rows[0]["Volume"].ToString();
                NbrOT   = dt.Rows[0]["NbrOT"].ToString();
                PoidsMax = dt.Rows[0]["PoidsMax"].ToString();
            }
            ViewData["OTIDGroup"] = OTIDGroup;
            ViewData["Poids"] = Poids;
            ViewData["Volume"] = Volume;
            ViewData["NbrOT"] = NbrOT;
            ViewData["PoidsMax"] = PoidsMax;
            return View();
        }
        public ActionResult EnterPoidsMax(string OTID)
        {
            ViewData["OTID"] = OTID;
            DataTable dt = Configs._query.executeProc("OT_GetInfoOTGroupe", "OTID@int@" + OTID);
            string PoidsMax = "0";

            if (Tools.verifyDataTable(dt))
            {
                PoidsMax = dt.Rows[0]["PoidsMax"].ToString();
            }
            ViewData["PoidsMax"] = PoidsMax;

            return View();
        }
        public string UpdatePoidsMax(string OTID, string poids)
        {
            DataTable dt = Configs._query.executeProc("OT_UpdatePoidsMaxe", "OTID@int@" + OTID + "#poids@double@" + poids);

            if (Tools.verifyDataTable(dt))
            {
                return dt.Rows[0][0].ToString();
            }
            return "0";
        }

        // OT GROUPE STATUER
        /* updated by: karime
         * func name : SelectPrestAStatuer , GetStatuAStatuer , GetPrestOrderedByStatus ,GetPrestOrderedByStatus_DestStatu ,setPerstationStatu
         * parameters: add newvar is group and change the type of OTidGroup to string
         * date      : 20/11/2017
         */
        public ActionResult SelectPrestAStatuer(string OTIDGroup,int isGroup=0)
        {
            DataTable dt = Configs._query.executeProc("OT_GetPrestAStatuer", "OTID@string@" + OTIDGroup + "#SiGroup@int@" + isGroup);

            ViewData["PrestAStatuer"] = dt;
            ViewData["OTIDGroup"] = OTIDGroup;
            ViewData["isGroup"] = isGroup;
            
            return View();
        }
        public string GetStatuAStatuer(string Prestation)
        {
            DataTable dt = Configs._query.executeProc("OT_GetStatuAStatuer");
            string data = "";

            if (MTools.verifyDataTable(dt))
            {
                foreach (DataRow r in dt.Rows)
                    data += (data == "" ? "" : "#") + r[0].ToString() + "@" + r[1].ToString();
            }

            return data;
        }
        public string GetPrestOrderedByStatus(string OTIDGroup, string Prestation, string Statu, string IsGroup)
        {
            int isgroup = 0;
            Int32.TryParse(IsGroup, out isgroup);
            string param = string.Format("OTIDGroup@string@{0}#Prestation@string@{1}#Statu@int@{2}#IsGroup@int@{3}", OTIDGroup, Prestation, Statu, isgroup);
            DataTable dt = Configs._query.executeProc("OT_GetPrestOrderedByStatus", param);
            string data = "";

            if (MTools.verifyDataTable(dt))
            {
                foreach (DataRow r in dt.Rows)
                    data += (data == "" ? "" : "#") 
                        + r[0].ToString() +
                        "@" + r[1].ToString() +
                        "@" + r[2].ToString() +
                        "@" + r[3].ToString() +
                        "@" + r[4].ToString();
            }

            return data;
        }
        public ActionResult GetPrestOrderedByStatus_DestStatu(string OTIDGroup, string Prestation, string Statu, string DestStatu, string enabled ,string IsGroup)
        {
            int isgroup = 0;
            Int32.TryParse(IsGroup, out isgroup);
            string param = string.Format("OTIDGroup@string@{0}#Prestation@string@{1}#Statu@int@{2}#IsGroup@int@{3}", OTIDGroup, Prestation, Statu, isgroup);
            DataTable dt = Configs._query.executeProc("OT_GetPrestOrderedByStatus_DestStatu", param);

            ViewData["data"] = dt;
            ViewData["DestStatu"] = DestStatu;
            ViewData["Statu"] = Statu;
            ViewData["enabled"] = enabled;
            ViewData["OTIDGroup"] = OTIDGroup;
            ViewData["isGroup"] = IsGroup;
            return View();
        }
        public string setPerstationStatu(string ids, string etat, string OTIDGroup , string IsGroup)
        {
            string res = "1";
            string user = Session["login"].ToString();
            string currentAgenceID = Session["agenceID"].ToString();

            string param = "OTID@string@" + OTIDGroup //changer otid type to string 
                + "#ids@string@" + ids 
                + "#etat@int@" + etat
                + "#user@string@" + user
                + "#currentAgenceID@int@" + currentAgenceID
                + "#IsGroup@int@" + IsGroup;
            DataTable dt = Configs._query.executeProc("OT_setPerstationStatu", param);
            if (MTools.verifyDataTable(dt))
            { 
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }


        /* add by    : karime
         * func name : SelectStatuerOt
         * func role : open the view SelectStatuerOt
         * parameters: aucun
         * date      : 16/11/2017
         */

        public ActionResult SelectStatuerOt()
        {
            return View();
        }



        //JsonMethode 
        public List<Dictionary<string, object>> GetTableRows(DataTable dtData)
        {
            List<Dictionary<string, object>>
            lstRows = new List<Dictionary<string, object>>();
            Dictionary<string, object> dictRow = null;

            foreach (DataRow dr in dtData.Rows)
            {
                dictRow = new Dictionary<string, object>();
                foreach (DataColumn col in dtData.Columns)
                {
                    dictRow.Add(col.ColumnName, dr[col]);
                }
                lstRows.Add(dictRow);
            }
            return lstRows;
        }

        /* add by    : karime
         * func name : GetAllOtStatuer2
         * func role : get all dossier by OTNoBL le resultat sous forme de JSON
         * parameters: OTNoBL
         * date      : 16/11/2017
         */
        public JsonResult GetAllOtStatuer2(string OTNOBL)
        {
            DataTable dt = Configs._query.executeProc("getallotbynobl", "OTNoBL@string@" + OTNOBL, true);
            List<Dictionary<string, object>> lstPersons = GetTableRows(dt);
            return Json(lstPersons, JsonRequestBehavior.AllowGet);
        }




        
    }
}
