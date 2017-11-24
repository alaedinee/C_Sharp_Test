using Omniyat.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Globale_Varriables;
using TRC_GS_COMMUNICATION.Models;
using TRC_GS_COMMUNICATION.Controllers;

namespace maintenance.Controllers
{
    public class MagasinController : BaseController
    {
        //
        // GET: /Magasin/

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


        public ActionResult listeMagasin()
        {
            MagasinModel magModel = new MagasinModel();
            DataTable dataListMagasin = magModel.getLstMagasin("-1");
            ViewData["dataListMagasin"] = dataListMagasin;
            return View();
        }

        public ActionResult getMagsinForm(string mode = "ajouter", string magID = "")
        {
            var magModel = new MagasinModel();

            string Magasin = "", MagasinCode = "", MagasinMere = "";
            string ClientID = "", ChargementID = "", LivraisonID = "", DonneurID = "";

            if (mode == "ajouter")
            {
                Magasin = "";
                MagasinCode = "";
                MagasinMere = "0";

            }
            else if (mode == "modifier" || mode == "detail")
            {

                DataTable dataMag = magModel.getLstMagasin(magID);
                if (Tools.verifyDataTable(dataMag))
                {
                    //if (dtN.Rows[0][1].ToString() == "0")fix it
                    Magasin = dataMag.Rows[0]["Magasin"].ToString();
                    MagasinCode = dataMag.Rows[0]["MagasinCode"].ToString();
                    MagasinMere = dataMag.Rows[0]["MagasinMere"].ToString();
                    ClientID = dataMag.Rows[0]["ClientID"].ToString();
                    DonneurID = dataMag.Rows[0]["donneurID"].ToString();
                    ChargementID = dataMag.Rows[0]["chargementID"].ToString();
                    LivraisonID = dataMag.Rows[0]["livraisonID"].ToString();
                }

            }

            ViewData["ListMagasin"] = magModel.getLstMagasin("-1");
            ViewData["mode"] = mode;

            ViewData["ID"] = magID;
            ViewData["Magasin"] = Magasin;
            ViewData["MagasinCode"] = MagasinCode;
            ViewData["MagasinMere"] = MagasinMere;

            ViewData["ClientID"] = ClientID;
            ViewData["DonneurID"] = DonneurID;
            ViewData["ChargementID"] = ChargementID;
            ViewData["LivraisonID"] = LivraisonID;

            return View();
        }

        public string MAJMagasin(string mode, string magID, string magName, string magCode, string magMere, string magChargID, string magLivID, string magDonnID)
        {

            MagasinModel magModel = new MagasinModel();
            string result = "";

            if (mode == "Ajouter")
            {
                string _params = "magName@string@" + magName + "#magCode@string@" + magCode + "#magMere@int@" + magMere + "#magChargID@int@" + magChargID +
                "#magLivID@int@" + magLivID + "#magDonnID@int@" + magDonnID;

                result = magModel.addMagasin(_params);

            }
            else if (mode == "Modifier")
            {
                string _params = "magID@int@" + magID + "#magName@string@" + magName + "#magCode@string@" + magCode + "#magMere@int@" + magMere + "#magChargID@int@" + magChargID +
                "#magLivID@int@" + magLivID + "#magDonnID@int@" + magDonnID;

                result = magModel.updateMagasin(_params);

            }

            return result;
        }

        public string deleteMagasin(string magID)
        {

            MagasinModel magModel = new MagasinModel();
            string result = "";
            string _params = "magID@string@" + magID;

            result = magModel.deleteMagasin(_params);

            return result;
        }



    }
}
