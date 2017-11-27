using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Globale_Varriables;
using maintenance.Models;
using Omniyat.Models;
using System.Data;
using TRC_GS_COMMUNICATION.Models;

namespace maintenance.Controllers
{
    public class PrestationController : Controller
    {
        //
        // GET: /Prestation/

        MAJ mj;

        public ActionResult getLstPrestation(string prestOTID = "", string isOpen = "1", string isPalannifToPast = "1")
        {
            bool _isGroup = false;
            DataTable dtOT = Configs._query.executeProc("OTGetOT", "OTID@int@" + prestOTID);
            if (dtOT != null && dtOT.Rows.Count > 0)
            {
                _isGroup = dtOT.Rows[0]["OTType"] != DBNull.Value;
            }

            DataTable prestDT;
            prestDT = Configs._query.executeProc("prestGetLstPrestation", "otid@int@" + prestOTID + "#type@string@0");


            ViewData["prestList"] = prestDT;
            ViewData["prestOTID"] = prestOTID;
            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;

            if (!_isGroup)
                return View();
            else
                return View("getLstPrestationGroupe");
        }
        
        public ActionResult detailPrest(string prestOTID, string mode, string prestDetailID = "")
        {


            mj = new MAJ();

            var prestModel = new PrestationModel();

            var prestType = "";
            var prestEtat = "";
            var IsPrestGroupe = false;

            var prestProduit = "";
            var prestPrix = "";
            var prestRefCmdClient = "";
            var prestNbrPeriode = "0";

            if (mode == "Ajouter")
            {
                prestEtat = "00";

                DataTable dtN = Configs._query.executeProc("prestGetPrestationNbr", "OTID@int@" + prestOTID);
                if (Tools.verifyDataTable(dtN))
                {
                    //if (dtN.Rows[0][1].ToString() == "0")fix it
                        prestRefCmdClient = dtN.Rows[0][0].ToString();
                }


            }

            else if (mode == "Modifier")
            {
                DataTable dtPrest = Configs._query.executeProc("prestGetDetailPrest", "otid@int@" + prestOTID + "#type@string@0" + "#detailID@int@" + prestDetailID, true);

                if (dtPrest != null)
                {
                    prestProduit = dtPrest.Rows[0]["Produit"].ToString();
                    prestPrix = dtPrest.Rows[0]["Prix"].ToString();
                    prestEtat = dtPrest.Rows[0]["Etat"].ToString();
                    prestType = dtPrest.Rows[0]["type"].ToString();
                    prestRefCmdClient = dtPrest.Rows[0]["RefCmdClient"].ToString();
                    prestNbrPeriode = dtPrest.Rows[0]["ProduitPeriodes"].ToString();
                    IsPrestGroupe = dtPrest.Rows[0]["PDG"] != DBNull.Value;
                }

            }

            ViewData["prestListPrestation"] = prestModel.listDTPrestation(prestType, prestOTID, prestProduit);
            if(!string.IsNullOrEmpty(prestDetailID) && prestDetailID != "-1")
                ViewData["prestListPrestation"] = Configs._query.executeProc("prestGetpresMemeFamille", "id@int@" + prestDetailID);

            ViewData["presStatus"] = Configs._query.executeProc("prestGetPropStatusPack", "etat@int@" + prestEtat);


            ViewData["RefCmdClient"]  = prestRefCmdClient;
            ViewData["Etat"]          = prestEtat;
            ViewData["Type"]          = prestType;
            ViewData["Produit"]       = prestProduit;
            ViewData["Prix"]          = prestPrix;

            ViewData["mode"] = mode;
            ViewData["OTID"] = prestOTID;
            ViewData["prestDetailID"] = prestDetailID;
            ViewData["prestNbrPeriode"] = prestNbrPeriode;
            ViewData["IsPrestGroupe"] = IsPrestGroupe;

            return View();
        }
        
        public string operationPrestation(string prestOtID, string prestMode, string prestPrix, string prestRefClient, string prestValList
            , string prestValStatut, string prestEtat, string prestID, string prestOldServ = "",string prestHeur = "", string prestMin = "")
        {
            string res = "";
            PrestationModel prestModele = new PrestationModel();

            int nbrPeriode = 0;
            int h,m;
            if (Int32.TryParse(prestHeur, out h) && Int32.TryParse(prestMin, out m))
                nbrPeriode = (h * 2) + (m / 30);

            if (prestMode == "Ajouter")
            {

                res = prestModele.addPrestation(prestOtID, prestValList, prestPrix, prestRefClient, prestValStatut, nbrPeriode.ToString());
                if (res != "")
                    res = "Prestation ajoutée";
                else
                    res = "";

            }

            else if (prestMode == "Modifier")
            {     
                //string otid, string prestation, string prix, string oldPrestation, string refClient, string status, string idServ
                string user = Session["login"].ToString();
                string CurrentAgenceID = Session["agenceID"] != null ? Session["agenceID"].ToString() : null;
                prestModele.updatePrestation(prestOtID, prestValList, prestPrix, prestOldServ, prestRefClient, prestValStatut, prestID, nbrPeriode.ToString(), user, CurrentAgenceID);
                res = "Prestation modifiée";

            }

            else if (prestMode == "Supprimer")
            {    
                //string otid, string prestation
                res = prestModele.deletePrestation(prestID, prestValList);
                if (res == "1")
                    res = "Prestation supprimée";
                else
                    res = "";

            }

            else if (prestMode == "Annuler")
            {     
                // string otid, string prestation, string etat, string code, string planID
                prestModele.annulerPrestation(prestOtID, prestValList, "30", " update OT set codestock = '' where OTID = 0 ", "-1");
                res = "Prestation annulée";

            }

            else if (prestMode == "Activer")
            {

                prestModele.annulerPrestation(prestOtID, prestValList, "00", " update OT set codestock = '' where OTID = 0 ", "-1");
                res = "Prestation activée";

            }
           


            return res;

        }


        public ActionResult prestDetailHisStatus(string prestID)
        {
            ViewData["dtStatus"] = Configs._query.executeProc("prestGetDetailHisStatus", "ID@int@" + prestID);
            ViewData["id"] = prestID;
            return View();
        }


        public string prestDeleteDetailHis(string id)
        {
            string res = "-1";

            string param = "id@int@" + id;
            DataTable dt = Configs._query.executeProc("prestDeleteDetailHis", param);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;
        }


        public String prestVerifyOTEtat(string etat1, string etat2)
        {
            string res = "";
            DataTable dt = Configs._query.executeProc("prestVerifyOTEtat", "etat1@int@" + etat1 + "#etat2@int@" + etat2);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }


        public ActionResult prestGetFormStatus(string id, string etat1, string etat2, string date1, string date2, string type)
        {
            ViewData["etat1"] = etat1;
            ViewData["etat2"] = etat2;
            ViewData["date1"] = date1;
            ViewData["date2"] = date2;
            ViewData["type"] = type;

            ViewData["dtStatus"] = Configs._query.executeProc("prestGetPropEtats", "etat1@int@" + etat1 + "#etat2@int@" + etat2); //PRC_getEtat");
            ViewData["id"] = id;
            return View();
        }


        public string prestAddStatus(string id, string etat, string date, string qui, string type)
        {
            string res = "1";
            string _params = "id@int@" + id
                               + "#etat@int@" + etat
                               + "#date@string@" + date
                               + "#user@int@" + "1"
                               + "#qui@string@" + qui
                               + "#type@string@" + type;
            ;

            DataTable dt = Configs._query.executeProc("prestAddHisStatus", _params);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;
        }


        //public string prestSendService(string id)
        //{
        //    string res = "";

        //    ServiceUpdate.shipementURL = Tools.getSqlConfig("SHIPMENT_SERVICE_URL");
        //    ServiceUpdate.sendServiceURL = Tools.getSqlConfig("UPDATE_SERVICE_URL");
        //    ServiceUpdate.OrderNumberSource = Tools.getSqlConfig("ORDER_NUMBER_SOURCE");

        //    DataTable dt = Configs._query.executeProc("PRC_getSendListByService", "ID@int@" + id);

        //    Object[] resServices = ServiceUpdate.SendServices(dt);
        //    int NbServices = (int)resServices[0];
        //    int nbrSucc = (int)resServices[1];

        //    String msgError = "";
        //    if (nbrSucc != NbServices)
        //    {
        //        String _Xml = "";
        //        List<ShipmentError> lstError = (List<ShipmentError>)resServices[2];
        //        for (int i = 0; i < lstError.Count; i++)
        //        {
        //            ShipmentError error = lstError[i];

        //            string xmlError = "<ServiceError>"
        //                            + "<ID>" + error.id + "</ID>"
        //                            + "<Message>" + error.Message + "</Message>"
        //                            + "</ServiceError>";

        //            _Xml += xmlError;
        //        }
        //        msgError = "Opération faite, il y a des erreurs !";
        //        //Importation.Debug(_Xml, "ServiceErrors");
        //    }
        //    else
        //        msgError = "Opération réussite !";

        //    res = "Services : \n" + msgError + "\n" + nbrSucc + "/" + NbServices;

        //    return res;
        //}


        public string prestgetIcons(string prestIDDetail = "")
        {
            string prestPathIcons = "";

            //cherche icon convenable depent du prestIDDetail

            prestPathIcons = "/Images/in_stock.png"; //return path

            return prestPathIcons;
        }

       //////////////////////////////////////// Add Prestation Rendez Vous \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        public string addPrestationRDV(string OTID, string date_rdv, string choixClient = null)
        {
            string res = "-1";
            string user = Session["login"].ToString();
            string CurrentAgenceID = Session["agenceID"] != null ? Session["agenceID"].ToString() : null;

            string param = "OTID@int@" + OTID + "#date_rdv@string@" + date_rdv;
            param += "#user@string@" + user;
            if (!string.IsNullOrEmpty(CurrentAgenceID))
                param += "#CurrentAgenceID@int@" + CurrentAgenceID;
            if (!string.IsNullOrEmpty(choixClient))
                param += "#choixClient@string@" + choixClient;

            DataTable dt = Configs._query.executeProc("prestAddPrestationRDV", param);
            if (dt != null && dt.Rows.Count > 0)
            {
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }

        public string isPrinted(string DetailID)
        {
            string res = "NO";
            DataTable dt = Configs._query.executeProc("prestIsPrinted", "DetailID@int@" + DetailID);
            if (dt != null && dt.Rows.Count > 0)
            {
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }

        public ActionResult historyPrestation(string DetailID)
        {
            DataTable dt = Configs._query.executeProc("prestGetHistory", "DetailID@int@" + DetailID);
            ViewData["data"] = dt;
            return View();
        }
    }
}
