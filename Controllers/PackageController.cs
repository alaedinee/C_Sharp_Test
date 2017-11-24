using Omniyat.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Text;
using TRC_GS_COMMUNICATION.Models;
using System.Web.Script.Serialization;

namespace maintenance.Controllers
{
    public class PackageController : Controller
    {
        //
        // GET: /Package/

        public ActionResult packGetLst(string OTID = "-1", string OTPrest = "", string isOpen = "1", string isPalannifToPast = "1")
        {
            ViewData["OTId"] = OTID;
            ViewData["OTPrest"] = OTPrest;
            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;
            return View();
        }

        public ActionResult packGetPacks(string OTID, string isOpen = "1", string isPalannifToPast = "1")
        {

            DataTable dt = Configs._query.executeProc("packGetPacks", "otid@int@" + OTID);
            ViewData["DTPacks"] = dt;
            ViewData["OTID"] = OTID;
            ViewData["isOpen"] = isOpen;
            ViewData["isPalannifToPast"] = isPalannifToPast;
            return View();
        }

        public ActionResult packGetArticles(string OTID, string OTPrest = "")
        {
            //string _type = "";
            //DataTable dt = Configs._query.executeProc("_getOTType", "id@int@" + OTPrest);
            //if (dt != null && dt.Rows.Count > 0)
            //{
            //    _type = dt.Rows[0]["name"].ToString();
            //    if (_type == "Transport")
            DataTable dt = Configs._query.executeProc("packGetOrderLines", "otid@int@" + OTID);
            ViewData["DTArticles"] = dt;
            //    else
            //        ViewData["dtStatus"] = Configs._query.executeProc("_getTRCStockAricles", "otid@int@" + id + "#mode@string@" + mode); //_getStockOrderLines _getAllStockOrderLines
            //}

            ViewData["OTID"] = OTID;
            //ViewData["type"] = _type;
            //ViewData["mode"] = mode;
            return View();
        }


        public ActionResult addPackage(string id, string otid)
        {
            String _status = "00";

            if (id != "0")
            {
                DataTable dt = Configs._query.executeProc("packGetPackage", "id@int@" + id);

                if (MTools.verifyDataTable(dt)) _status = dt.Rows[0]["statut"].ToString();

                ViewData["dtPack"] = dt;
  
            }

            ViewData["Emp"] = Configs._query.executeProc("packGetEmplacement");

            ViewData["Status"] = Configs._query.executeProc("packGetPropStatusPack", "etat@int@" + _status);

            string prestations = "";

            DataTable dtPres = Configs._query.executeProc("packGetOTDetailPackageLines", "ID@int@" + id);
            if (MTools.verifyDataTable(dtPres))
            {
                for (int i = 0; i < dtPres.Rows.Count; i++)
                    prestations += dtPres.Rows[i]["ServiceID"].ToString() + "|";

                if (prestations.Length > 0) prestations = prestations.Substring(0, prestations.Length - 1);
            }

            ViewData["prestations"] = prestations;
            ViewData["Details"] = Configs._query.executeProc("packGetOTDetails", "otid@int@" + otid);

            ViewData["ID"] = id;
            ViewData["otid"] = otid;

            return View();
        }


        public string getEmplacement()
        {
            string emps = "";
            string agenceID = Session["agenceID"] == null ? "" : Session["agenceID"].ToString();
            string param = string.IsNullOrEmpty(agenceID) ? "" : "agenceID@int@" + agenceID;

            DataTable dt = Configs._query.executeProc("packGetEmplacement" , param, true);
            if (MTools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    Response.Write(dt.Rows[i]["CABEmplacement"].ToString() + "\n");
                }
            }

            return emps;
        }

        [WebMethod]
        public JsonResult getEmplacementComplete(string val)
        {
            DataTable dtClient = null;
            StringBuilder sb = new StringBuilder();
            ClientModel cliModel = new ClientModel();

            dtClient = cliModel.getLstEmplacement(val);

            if (Tools.verifyDataTable(dtClient))
            {
                sb.Append("[");
                for (int i = 0; i < dtClient.Rows.Count; i++)
                {
                    sb.Append("{\"key\":" + dtClient.Rows[i]["idEmplacement"].ToString() + ", \"value\":\"" + dtClient.Rows[i]["CABEmplacement"].ToString().Trim() + "\"}");

                    if (i < dtClient.Rows.Count - 1)
                        sb.Append(",");
                }

                sb.Append("]");
            }

            var jsag = new JavaScriptSerializer();

            dynamic dataag = jsag.Deserialize<dynamic>(sb.ToString());

            return Json(dataag, JsonRequestBehavior.AllowGet);
        }


        public string savePackage(string id, string otid, string numero, string ddc, string weight, string volume, string status, string emp, string lstPrest, string optional, string numPalette, string RecepID = "0")
        {
            string res = "-1";

            //if (id == "0")
            //{
            //    DataTable dtVerify = Configs._query.executeProc("PRC_verifyPack", "numero@string@" + numero);
            //    if (MTools.verifyDataTable(dtVerify))
            //        res = "-2";
            //    return res;
            //}

            string[] tabs = lstPrest != "" ? lstPrest.Split('|') : new string[] { };
            string ReceptionID = Session["loginReceptionID"] == null ? null : Session["loginReceptionID"].ToString();
            string auteurAction = Session["userID"].ToString();
            string CurrentUAgenceID = Session["agenceID"].ToString();
            DataTable dtVerify = Configs._query.executeProc("packGetOTDetailPackageLines", "ID@int@" + id);

            string param = "id@int@" + id
                         + "#otid@int@" + otid
                         + "#numero@string@" + numero
                         + "#weight@float@" + weight
                         + "#volume@float@" + volume
                         + "#ddc@string@" + ddc
                         + "#status@string@" + status
                         + (string.IsNullOrEmpty(emp) ? "" : "#emp@int@" + emp)
                         + "#optional@int@" + optional
                         + "#numPalette@string@" + numPalette
                         + (ReceptionID == null ? "" : "#RecepID@int@" + ReceptionID)
                         + "#auteurAction@int@" + auteurAction
                         + "#RecepIDMod@int@" + RecepID
                         + "#CurrentUAgenceID@int@" + CurrentUAgenceID;

            DataTable dt = Configs._query.executeProc("packSavePackge", param);
            if (MTools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
                
                lstPrest = lstPrest.Replace('|', ',');
                Configs._query.executeProc("packDeleteDetailPackageRelation", "PackageID@int@" + res + "#DetailIDs@string@" + lstPrest);

                for (int i = 0; i < tabs.Length; i++)
                    Configs._query.executeProc("packInsertDetailPackageRelation", "PackageID@int@" + res + "#DetailID@int@" + tabs[i]);
                
            }

            if (Int64.Parse(res) > 0)
                res = "0";

            return res;
        }

        public string addMarchandiseReception(string IDPackage, string OTID)
        {
            string res = "";
            string ReceptionID = Session["loginReceptionID"].ToString();
            string param = "IDPackage@int@" + IDPackage
                        + "#OTID@int@" + OTID
                        + "#ReceptionID@int@" + ReceptionID;
            DataTable dt = Configs._query.executeProc("packAddMarchandise", param);
            if (MTools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }
            return res;
        }

        public string deletePackage(string id)
        {

            string param = "id@int@" + id;
            string res = "";

            DataTable dt = Configs._query.executeProc("packDeletePackage", param);

            if (MTools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;

        }

        public ActionResult sendPackage(string idPackage, string otid)
        {

            string param = "otid@int@" + otid;
            //string res = "";

            ViewData["idPackage"] = idPackage;
            ViewData["otid"] = otid;
            ViewData["OTPossible"] = Configs._query.executeProc("packGetOTAvailable", param);

            return View();

        }

        public string verifyPackServRelation(string id)
        { 
            string res = "0";
            DataTable data = Configs._query.executeProc("pack_verifyPackServRelation", "id@int@" + id);
            if (Tools.verifyDataTable(data))
                return data.Rows[0][0].ToString();
            return res;
        }

        public string ValiderOTChoix(string IDChoix, string idPackage)
        {
            string res = "";
            string _params = "IDChoix@int@" + IDChoix + "#idPackage@int@" + idPackage ;
            DataTable data = Configs._query.executeProc("packInsertOT", _params);
            if (Tools.verifyDataTable(data))
            {
                res = "insert";
            }
            else
                res = "0";
            
            return res;
        }

        public string deleteMultiplesPack(string IDS)
        {
            string[] tabIDS = IDS.Split(';');
            string res = "";
            for (int i = 0; i < tabIDS.Length; i++)
            {
                DataTable dt = Configs._query.executeProc("packDeletePackage", "id@int@" + tabIDS[i]);

                 if (MTools.verifyDataTable(dt))
                 {
                     res = dt.Rows[0][0].ToString();
                 }
            }

            return res;
        }

        public ActionResult LstPackageInconnu(string otid)
        {
            ViewData["PackInconnu"] = Configs._query.executeProc("packListInconnu", "");
            ViewData["otid"] = otid;
            return View();
        }

        public string updatePackInconnu(string IDPack = "", string OTID = "")
        {
            string res = "";

            DataTable dt = Configs._query.executeProc("packAffectePackage", "IDPack@int@" + IDPack + "#OTID@int@" + OTID);

            if (MTools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;
        }

        public string scannPackInconnu(string OTID = "", string valCode = "")
        {
            string res = "";

            DataTable dt = Configs._query.executeProc("packScannePackage", "valCode@string@" + valCode + "#OTID@int@" + OTID);

            if (MTools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;
        }

        public string printPackage(string values, string AgenceID = null)
        {
            int nbr = 0;
            string[] tab = values.Split(';');
            if (string.IsNullOrEmpty(AgenceID))
            {
                // DEFAULT_AGENCE_ID
                AgenceID = MTools.getSqlConfig("DEFAULT_AGENCE_ID");
            }
            
            string temp_name = "ticket_PACK";
            DataTable dt = Configs._query.executeProc("AgenceGetAgence", "id@int@" + AgenceID, true);
            if (Tools.verifyDataTable(dt))
            {
                temp_name += "_" + dt.Rows[0]["Code"].ToString();
            }
            else
                return "-1";

            string template = "";
            dt = Configs._query.executeProc("getTemplate", "name@string@" + temp_name, true);
            if (Tools.verifyDataTable(dt))
            {
                template = dt.Rows[0]["html"].ToString();
                string printName = dt.Rows[0]["printer"].ToString();
                string proc = dt.Rows[0]["proc_dataSource"].ToString();
                foreach (string id in tab)
                {
                    string tmp = template;

                    DataTable dtV = Configs._query.executeProc(proc, "packID@int@" + id, true);
                    if (Tools.verifyDataTable(dtV))
                    {
                        tmp = tmp.Replace("{CODE}", dtV.Rows[0]["CODE"].ToString());
                        tmp = tmp.Replace("{POIDS}", dtV.Rows[0]["POIDS"].ToString());
                        tmp = tmp.Replace("{VOLUME}", dtV.Rows[0]["VOLUME"].ToString());

                        tmp = tmp.Replace("{OTNoBL}", dtV.Rows[0]["OTNoBL"].ToString());

                        try
                        {
                            if (Print.printTicket(tmp, printName) == "Printed")
                                nbr++;
                        }
                        catch (Exception exp)
                        {
                            Configs.Debug(exp, "maintenance.Controllers.EmplacementController.printEmplacements", "Echéc d'impression : " + tmp + " Name imp " + printName);
                        }

                    }
                }
            }

            return (nbr == tab.Length) ? "1" : "-1";
        }

        //////////////////////////// get historique package \\\\\\\\\\\\\\\\\\\\\\\\\\
        public ActionResult getHistoryPackage(string idPackage)
        {
            DataTable dt = Configs._query.executeProc("packGetPackHistory", "ID@int@" + idPackage);
            ViewData["PackHistory"] = dt;            
            return View();
        }
        //////////////////////////// get articles package \\\\\\\\\\\\\\\\\\\\\\\\\\
        public ActionResult packArticles(string idPackage)
        {
            DataTable dt = Configs._query.executeProc("packGetPackArticles", "ID@int@" + idPackage);
            ViewData["packArticles"] = dt;            
            return View();
        }
    }
}
