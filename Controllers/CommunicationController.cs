using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Omniyat.Models;
using System.Web.Routing;
using Globale_Varriables;
using TRC_GS_COMMUNICATION.Models;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class CommunicationController : BaseController
    {
        //
        // GET: /Communication/

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


        public ActionResult getlstCom(string RessourceID, string Ressource, string isOpen = "1")
        {

            DataTable dt = Configs._query.executeProc("commGetLstCommByIDRess", "RessourceID@int@" + RessourceID + "#Ressource@string@" + Ressource, true);

            //if (dt != null)
            //{
            //    var sujet = 
            //}

            ViewData["ListComm"] = dt;
            ViewData["RessourceID"] = RessourceID;
            ViewData["Ressource"] = Ressource;
            ViewData["isOpen"] = isOpen;

            return View();
        }


        public ActionResult getLstComm(string RessourceID, string Ressource)
        {

            DataTable dt = Configs._query.executeProc("commGetLstCommByIDRess", "RessourceID@int@" + RessourceID + "#Ressource@string@" + Ressource, true);

            //if (dt != null)
            //{
            //    var sujet = 
            //}

            ViewData["ListComm"] = dt;
            ViewData["RessourceID"] = RessourceID;
            ViewData["Ressource"] = Ressource;

            return View();
        }

        //[AcceptAjax]
        public ViewResult majCommunication(string mode, string otid, string Ressource)
        {
            DataTable prestDT = Configs._query.executeProc("prestGetLstPrestation", "otid@int@" + otid + "#type@string@0");
            DataTable eventDT = Configs._query.executeProc("recListType", "IDList@int@11");
            ViewData["prestList"] = prestDT;
            ViewData["eventList"] = eventDT;

            ViewData["Ressource"] = Ressource;
            ViewData["typeComm"] = mode;
            ViewData["otid"] = otid;

            return View();

        }

        public ActionResult eventType(string produit)
        {
            var res = new List<object>();
            DataTable eventDT = Configs._query.executeProc("recListType", "IDList@int@11#produit@string@" + produit);
            
            foreach(DataRow r in eventDT.Rows)
                res.Add(new { code = r["code"].ToString(), name = r["name"].ToString() });

            return Json(res, JsonRequestBehavior.AllowGet);
        }

        public string AjouterCommunication(string OtID, string Sujet, string Msg,/* string Date,*/ string Ressource
            , string TypeComm, string usern, string PrestationID = "", string TypeEvent = "", string articles_id = "")
        {

            string val = "0";
            string user = Session["login"].ToString();

            string trans = "1"; // proc existe 
            if (TypeComm == "SMS") trans = "0";

            string param = "OtID@int@" + OtID
                           + "#TypeComm@string@" + TypeComm
                           + "#Sujet@string@" + Sujet
                           + "#Message@string@" + Msg
                           + "#RessourceID@int@" + OtID
                           + "#Trans@int@" + trans
                //+ "#Date@string@" + Date
                           + "#Ressource@string@" + Ressource
                           + "#User@string@" + usern;
            if ("MDM_COM".Equals(TypeComm))
                param += "#PrestationID@int@" + PrestationID + "#CodeEvent@string@" + TypeEvent;


            DataTable dt = Configs._query.executeProc("commAjouterCommunication", param, true);
            if (dt != null && dt.Rows.Count > 0 && dt.Rows[0][0] != DBNull.Value)
            {
                Int64 IDCom;
                if (Int64.TryParse(dt.Rows[0][0].ToString(), out IDCom) && IDCom > 0)
                {
                    val = "1";
                    if (!string.IsNullOrEmpty(articles_id))
                    {
                        param = "ItemIDs@string@" + articles_id;
                        param += "#ComID@int@" + IDCom;
                        param += "#AuteurAction@string@" + user;
                        dt = Configs._query.executeProc("ComAddArticleAvarie", param, true);
                        
                    }
                }

            }
            //res = "1";

            return val;

            //string req = "exec _AjouterCommunication //proc exist

        }

        public ActionResult detailComm(string IDComm)
        {

            DataTable dtComm = Configs._query.executeProc("commGetDetailComm", "IDComm@int@" + IDComm, true);

            if (dtComm != null)
            { 
                ViewData["Sujet"] = dtComm.Rows[0]["Sujet"].ToString();
                ViewData["Type"] = dtComm.Rows[0]["ComType"].ToString();
                ViewData["Date"] = dtComm.Rows[0]["ComDate"].ToString();
                ViewData["Msg"] = dtComm.Rows[0]["ComMessage"].ToString();
                ViewData["User"] = dtComm.Rows[0]["User"].ToString();
                ViewData["Prestation"] = dtComm.Rows[0]["Prestation"] != DBNull.Value ? dtComm.Rows[0]["Prestation"].ToString() : "";
                ViewData["NameEvent"] = dtComm.Rows[0]["NameEvent"] != DBNull.Value ? dtComm.Rows[0]["NameEvent"].ToString() : "";
            }

            return View();
        }

        public ActionResult articlesComm(string IDComm)
        {
            DataTable dtComm = Configs._query.executeProc("CommGetArticlesLinked", "IDComm@int@" + IDComm, true);
            ViewData["data"] = dtComm;

            return View();
        }

    }
}
