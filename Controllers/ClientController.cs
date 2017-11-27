using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Omniyat.Models;
using System.Data;
using System.Web.Services;
using System.Text;
using System.Web.Script.Serialization;
using TRC_GS_COMMUNICATION.Models;
using Globale_Varriables;
using System.Web.Routing;
using TRC_GS_COMMUNICATION.Controllers;

namespace maintenance.Controllers
{
    public class ClientController : BaseController
    {
        //
        // GET: /Client/

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


        #region "Chargement"


        public ActionResult getInfosChargement(string chargID, string mode = "")
        {
            string CliChargID = "", CliChargNom = "", CliChargCode = "", CliChargAdr = "", CliChargNP = "", CliChargVille = "", CliChargPays = "", CliChargTel = "";
            //string CliChargDateCharg = "";

            if (mode == "detail" || mode == "modifier")
            {
                ClientModel cliModel = new ClientModel();
                DataTable dataInfosLivr = cliModel.getInfosChargement(chargID);
                if (Tools.verifyDataTable(dataInfosLivr))
                {
                    //Mapping
                    CliChargID = dataInfosLivr.Rows[0]["ClientID"].ToString();
                    CliChargNom = dataInfosLivr.Rows[0]["Nom"].ToString();
                    CliChargCode = dataInfosLivr.Rows[0]["CodeClient"].ToString();
                    CliChargAdr = dataInfosLivr.Rows[0]["adresse"].ToString();
                    CliChargNP = dataInfosLivr.Rows[0]["NP"].ToString();
                    CliChargVille = dataInfosLivr.Rows[0]["Ville"].ToString();
                    CliChargPays = dataInfosLivr.Rows[0]["Pays"].ToString();
                    CliChargTel = dataInfosLivr.Rows[0]["Tel"].ToString();
                    //CliChargDateCharg = dataInfosCharg.Rows[0]["MagasinMere"].ToString();
                }
                ViewData["dataInfosCharg"] = dataInfosLivr;
            }

            //Passage vers view

            ViewData["ChargID"] = chargID;


            ViewData["CliChargID"] = CliChargID;
            ViewData["CliChargNom"] = CliChargNom;
            ViewData["CliChargCode"] = CliChargCode;
            ViewData["CliChargAdr"] = CliChargAdr;
            ViewData["CliChargNp"] = CliChargNP;
            ViewData["CliChargVille"] = CliChargVille;
            ViewData["CliChargPays"] = CliChargPays;
            ViewData["CliChargTel"] = CliChargTel;
            //ViewBag.CliChargDateCharg = CliChargDateCharg;
            ViewData["CliChargMode"] = mode;


            return View();
        }

        #endregion

        #region "Livraison"

        public ActionResult getInfosLivraison(string livrID, string mode = "")
        {
            string cliLivID = "", cliLivNom = "", cliLivCode = "", cliLivAdr = "", cliLivNp = "", cliLivVille = "", cliLivPays = "", cliLivTel = "", cliLivFax = "", cliLivMail = "";

            //string cliLivHeurLiv = "", cliLivDateMon = "", cliLivDateLiv = "";
            if (mode == "detail" || mode == "modifier")
            {
                ClientModel cliModel = new ClientModel();
                DataTable dataInfosLivr = cliModel.getInfosLivraison(livrID);
                if (Tools.verifyDataTable(dataInfosLivr))
                {
                    //Mapping
                    cliLivID = dataInfosLivr.Rows[0]["ClientID"].ToString();
                    cliLivNom = dataInfosLivr.Rows[0]["Nom"].ToString();
                    cliLivCode = dataInfosLivr.Rows[0]["CodeClient"].ToString();
                    cliLivAdr = dataInfosLivr.Rows[0]["adresse"].ToString();
                    cliLivNp = dataInfosLivr.Rows[0]["NP"].ToString();
                    cliLivVille = dataInfosLivr.Rows[0]["Ville"].ToString();
                    cliLivPays = dataInfosLivr.Rows[0]["Pays"].ToString();
                    cliLivTel = dataInfosLivr.Rows[0]["Tel"].ToString();
                    cliLivFax = dataInfosLivr.Rows[0]["Fax"].ToString();
                    cliLivMail = dataInfosLivr.Rows[0]["mail"].ToString();
                    //cliLivDateLiv = dataInfosCharg.Rows[0]["MagasinMere"].ToString();
                    //cliLivHeurLiv = dataInfosCharg.Rows[0]["MagasinMere"].ToString();
                    //cliLivDateMon = dataInfosCharg.Rows[0]["MagasinMere"].ToString();
                }
                ViewData["dataInfosCharg"] = dataInfosLivr;

            }


            //Passage vers view

            ViewData["LivrID"] = livrID;


            ViewData["cliLivID"] = cliLivID;
            ViewData["cliLivNom"] = cliLivNom;
            ViewData["cliLivCode"] = cliLivCode;
            ViewData["cliLivAdr"] = cliLivAdr;
            ViewData["cliLivNp"] = cliLivNp;
            ViewData["cliLivVille"] = cliLivVille;
            ViewData["cliLivPays"] = cliLivPays;
            ViewData["cliLivTel"] = cliLivTel;
            ViewData["cliLivFax"] = cliLivFax;
            ViewData["cliLivMail"] = cliLivMail;
            //ViewBag.cliLivDateLiv = cliLivDateLiv;
            //ViewBag.cliLivHeurLiv = cliLivHeurLiv;
            //ViewBag.cliLivDateMon = cliLivDateMon;
            ViewData["CliLivMode"] = mode;


            return View();
        }

        #endregion

        #region "Donneur"

        public ActionResult getInfosDonneur(string donnID, string mode)
        {
            string cliDonneurID = "", cliDonneurNom = "", cliDonneurCode = "", cliDonneurAdr = "", cliDonneurNp = "", cliDonneurVille = "", cliDonneurPays = "", cliDonneurTel = "", cliDonneurFax = "", cliDonneurMail = "";
            if (mode == "detail" || mode == "modifier")
            {
                ClientModel cliModel = new ClientModel();
                DataTable dataInfosDonn = cliModel.getInfosDonneur(donnID);
                if (Tools.verifyDataTable(dataInfosDonn))
                {
                    //Mapping
                    cliDonneurID = dataInfosDonn.Rows[0]["ClientID"].ToString();
                    cliDonneurNom = dataInfosDonn.Rows[0]["Nom"].ToString();
                    cliDonneurCode = dataInfosDonn.Rows[0]["CodeClient"].ToString();
                    cliDonneurAdr = dataInfosDonn.Rows[0]["adresse"].ToString();
                    cliDonneurNp = dataInfosDonn.Rows[0]["NP"].ToString();
                    cliDonneurVille = dataInfosDonn.Rows[0]["Ville"].ToString();
                    cliDonneurPays = dataInfosDonn.Rows[0]["Pays"].ToString();
                    cliDonneurTel = dataInfosDonn.Rows[0]["Tel"].ToString();
                    cliDonneurFax = dataInfosDonn.Rows[0]["Fax"].ToString();
                    cliDonneurMail = dataInfosDonn.Rows[0]["Fax"].ToString();
                    cliDonneurMail = dataInfosDonn.Rows[0]["mail"].ToString();

                }
                //Passage vers view
                ViewData["dataInfosCharg"] = dataInfosDonn;
            }

            ViewData["DonnID"] = donnID;

            ViewData["cliDonneurID"] = cliDonneurID;
            ViewData["CliDonneurNom"] = cliDonneurNom;
            ViewData["CliDonneurCode"] = cliDonneurCode;
            ViewData["cliDonneurAdr"] = cliDonneurAdr;
            ViewData["cliDonneurNp"] = cliDonneurNp;
            ViewData["cliDonneurVille"] = cliDonneurVille;
            ViewData["cliDonneurPays"] = cliDonneurPays;
            ViewData["cliDonneurTel"] = cliDonneurTel;
            ViewData["cliDonneurFax"] = cliDonneurFax;
            ViewData["cliDonneurMail"] = cliDonneurMail;

            ViewData["CliDonnMode"] = mode;

            return View();

        }

        #endregion


        public ActionResult clientGetRessources(string cliFamille, string lbl, string txt)
        {
            DataTable clientDT = null;


            ClientModel cliModel = new ClientModel();

            clientDT = cliModel.getLstClient(cliFamille);


            ViewData["_RessourceContents"] = clientDT;
            ViewData["_RessourceFamille"] = cliFamille;

            ViewData["lbl"] = lbl;
            ViewData["txt"] = txt;

            return View();
        }

        public string clientGetRessourceByCode(string cliFamille, string valChargCode)
        {
            string result = "";
            ClientModel cliModel = new ClientModel();

            result = cliModel.getClientByCode(cliFamille, valChargCode);

            return result;
        }

        public string clientGetRessourceByID(string cliFamille, string valID)
        {
            string result = "";
            ClientModel cliModel = new ClientModel();

            result = cliModel.getClientByID(cliFamille, valID);

            return result;
        }


        #region "Client"

        public ActionResult listeClient(string cliID = "-1", string typeClient = "")
        {
            ClientModel magModel = new ClientModel();
            DataTable dataListClient = magModel.getListClientAll(cliID, typeClient);
            ViewData["dataListClient"] = dataListClient;
            return View();

        }

        public ActionResult list(string cliID = "-1", string typeClient = "")
        {
            ClientModel magModel = new ClientModel();
            DataTable dataListClient = magModel.getListClientAll(cliID, typeClient);
            ViewData["type"] = typeClient;
            ViewData["List"] = dataListClient;
            return View();
        }


        public ActionResult addClient(string mode = "", string cliID = "")
        {
            string CliType = "", CliNom = "", CliCode = "", CliAdresse = "", CliPays = "", CliNp = "", CliVille = "", CliFax = "", CliTel = "", CliMail = "";
            if (mode == "modifier")
            {
                var cliModel = new ClientModel();
                DataTable dataCli = cliModel.getListClientAll(cliID);
                if (Tools.verifyDataTable(dataCli))
                {
                    //if (dtN.Rows[0][1].ToString() == "0")fix it
                    CliNom = dataCli.Rows[0]["Nom"].ToString();
                    CliCode = dataCli.Rows[0]["CodeClient"].ToString();
                    CliAdresse = dataCli.Rows[0]["adresse"].ToString();
                    CliNp = dataCli.Rows[0]["NP"].ToString();
                    CliVille = dataCli.Rows[0]["Ville"].ToString();
                    CliPays = dataCli.Rows[0]["Pays"].ToString();
                    CliTel = dataCli.Rows[0]["Tel"].ToString();
                    CliFax = dataCli.Rows[0]["Fax"].ToString();
                    CliType = dataCli.Rows[0]["type"].ToString();
                    CliMail = dataCli.Rows[0]["mail"].ToString();
                }

                if (CliType.Contains("c") == true)
                    ViewData["cheakCharg"] = "true";
                if (CliType.Contains("l") == true)
                    ViewData["cheakLivr"] = "true";
                if (CliType.Contains("d") == true)
                    ViewData["cheakDonn"] = "true";

            }
            ViewData["CliID"] = cliID;

            ViewData["CliType"] = CliType;
            ViewData["CliNom"] = CliNom;
            ViewData["CliCode"] = CliCode;
            ViewData["CliAdresse"] = CliAdresse;
            ViewData["CliPays"] = CliPays;
            ViewData["CliNp"] = CliNp;
            ViewData["CliVille"] = CliVille;
            ViewData["CliFax"] = CliFax;
            ViewData["CliTel"] = CliTel;
            ViewData["CliMail"] = CliMail;

            ViewData["mode"] = mode;

            return View();
        }

        public string MAJClient(string mode, string cliID, string cliNom, string cliCode, string cliAdresse, string cliNp, string cliVille, string cliPays, string cliTel, string cliFax, string cliMail, string cliType)
        {

            ClientModel cliModel = new ClientModel();
            string result = "";

            if (mode == "Ajouter")
            {
                string _params = "cliName$string$" + cliNom + "#cliCode$string$" + cliCode + "#cliAdresse$string$" + cliAdresse + "#cliPays$string$" + cliPays +
                "#cliNp$string$" + cliNp + "#cliVille$string$" + cliVille + "#cliTel$string$" + cliTel + "#cliFax$string$" + cliFax + "#cliMail$string$" + cliMail + "#cliType$string$" + cliType;

                result = cliModel.addClient(_params);

            }
            else if (mode == "Modifier")
            {
                string _params = "cliID$int$" + cliID + "#cliName$string$" + cliNom + "#cliCode$string$" + cliCode + "#cliAdresse$string$" + cliAdresse + "#cliPays$string$" + cliPays +
                "#cliNp$string$" + cliNp + "#cliVille$string$" + cliVille + "#cliTel$string$" + cliTel + "#cliFax$string$" + cliFax + "#cliMail$string$" + cliMail + "#cliType$string$" + cliType;

                result = cliModel.updateClient(_params);

            }

            return result;
        }


        public string deleteClient(string clientID)
        {

            ClientModel cliModel = new ClientModel();
            string result = "";
            string _params = "clientID@string@" + clientID;

            result = cliModel.deleteClient(_params);

            return result;
        }

        [WebMethod]
        public JsonResult getClientComplete(string type)
        {
            DataTable dtClient = null;
            StringBuilder sb = new StringBuilder();
            ClientModel cliModel = new ClientModel();

            dtClient = cliModel.getLstClient(type);

            if (Tools.verifyDataTable(dtClient))
            {
                sb.Append("[");
                for (int i = 0; i < dtClient.Rows.Count; i++)
                {
                    sb.Append("{\"key\":" + dtClient.Rows[i]["ClientID"].ToString() + ", \"value\":\"" + dtClient.Rows[i]["Nom"].ToString().Trim() + "\"}");

                    if (i < dtClient.Rows.Count - 1)
                        sb.Append(",");
                }

                sb.Append("]");
            }

            var jsag = new JavaScriptSerializer();

            dynamic dataag = jsag.Deserialize<dynamic>(sb.ToString());

            return Json(dataag, JsonRequestBehavior.AllowGet);
        }

        #endregion


        #region 'Fournisseur'

        public ActionResult listeFournisseur(string IDListe = "10")
        {

            DataTable dtListeFournisseur = Configs._query.executeProc("recListFournisseur", "IDList@int@10");
            ViewData["dataListFournisseur"] = dtListeFournisseur;
            return View();

        }

        public ActionResult listeFourniss(string IDListe = "10")
        {

            DataTable dtListeFournisseur = Configs._query.executeProc("recListFournisseur", "IDList@int@10");
            ViewData["dataListFournisseur"] = dtListeFournisseur;
            return View();

        }

        public ActionResult addFournisseur(string mode = "", string fourniID = "" , string IDListe = "")
        {
            string fourniName = "";
            if (mode == "modifier")
            {
                DataTable dataFourni = Configs._query.executeProc("fourniGetElement", "fourniID@int@" + fourniID + "#IDListe@int@" + IDListe);
                if (Tools.verifyDataTable(dataFourni))
                {
                    fourniName = dataFourni.Rows[0]["name"].ToString();  
                }
            }
            ViewData["fourniID"] = fourniID;
            ViewData["fourniName"] = fourniName;
           
            ViewData["mode"] = mode;

            return View();
        }

        public string deleteFournisseur(string fourniID)
        {
            string result = "";
            string _params = "fourniID@int@" + fourniID;

            DataTable dataFourni = Configs._query.executeProc("fourniDeleteElement", "fourniID@int@" + fourniID);
            if (Tools.verifyDataTable(dataFourni))
            {
                //if (dtN.Rows[0][1].ToString() == "0")fix it
                result = dataFourni.Rows[0][0].ToString();
            }

            return result;
        }

        public string MAJFournisseur(string mode, string fourniID, string fourniName, string IDListe = "10")
        {

            string result = "";

            if (mode == "Ajouter")
            {
                string _params = "fourniName@string@" + fourniName + "@IDListe@int@" + IDListe;
                DataTable dtFourniAdd = Configs._query.executeProc("fourniAddElement", _params);
                if (Tools.verifyDataTable(dtFourniAdd))
                {
                    result = dtFourniAdd.Rows[0][0].ToString();
                }

            }
            else if (mode == "Modifier")
            {
                string _params = "fourniID@int@" + fourniID + "#fourniName@string@" + fourniName + "@IDListe@int@" + IDListe;
                DataTable dtFourniUpdate = Configs._query.executeProc("fourniUpdateElement", _params);
                if (Tools.verifyDataTable(dtFourniUpdate))
                {
                    result = dtFourniUpdate.Rows[0][0].ToString();
                }

            }

            return result;
        }

        #endregion

    }
}
