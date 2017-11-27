using Omniyat.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TRC_GS_COMMUNICATION.Models;

namespace maintenance.Controllers
{
    public class EmplacementController : Controller
    {
        //
        // GET: /Emplacement/


       // MAJ mj = new MAJ();
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult getEmplacements(string OTID = "-1", String codeStock = "")
        {
       
                ViewData["dt"] = Configs._query.executeProc("empGetEmplacements", "OTID@int@" + OTID, true);

            ViewData["stockID"] = OTID;
           ViewData["codeStock"] = codeStock;
            return View();
        }

        public ActionResult addEmplacement(string id, string idStock = "", string codeStock = "")
        {
            if (id != "0")
            {
                ViewData["dt"] = Configs._query.executeProc("empGetEmp", "id@int@" + id, true);
            }

            ViewData["dt_agence"] = Configs._query.executeProc("AgenceGetAgence", "", true);

            ViewData["ID"] = id;
            ViewData["idStock"] = idStock;
            ViewData["codeStock"] = codeStock;

            return View();
        }

        public string saveEmplacement(string id, string Aller, string Niveau, string Adresse, string numero, string agence, string stockID = "")
        {
            string res = "-1";

            if (id == "0")
            {
                DataTable dtVerify = Configs._query.executeProc("empVerifyEmplacement", "numero@string@" + numero, true);
                if (Tools.verifyDataTable(dtVerify))
                {
                    res = "-2";
                    return res;
                }
            }

            string param = "id@int@" + id
                         + "#aller@string@" + Aller
                         + "#niveau@string@" + Niveau
                         + "#adresse@string@" + Adresse
                         + "#numero@string@" + numero
                         + "#agence@string@" + agence;

            DataTable dt = Configs._query.executeProc("empSaveEmplacement", param, true);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;
        }

        public string deleteEmplacement(string id)
        {
            string res = "-1";

            string param = "id@int@" + id;
            DataTable dt = Configs._query.executeProc("empDeleteEmplacement", param, true);
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            return res;
        }

        public string getEmplacement()
        {
            string emps = "";

            DataTable dt = Configs._query.executeProc("empGetEmplacement", "", true);
            if (Tools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    Response.Write(dt.Rows[i]["CABEmplacement"].ToString() + "\n");
                }
            }

            return emps;
        }


        public string printEmplacements(string values)
        {
            int nbr = 0;
            string[] tab = values.Split(';');
            string agenceID = Session["agenceID"].ToString();
            string temp_name = "ticket_Emp";
            DataTable dt = Configs._query.executeProc("AgenceGetAgence", "id@int@" + agenceID, true);
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

                foreach (string id in tab)
                {
                    string tmp = template;

                    DataTable dtV = Configs._query.executeSql("select CABEmplacement from Emplacement where idEmplacement=" + id, true);
                    if (Tools.verifyDataTable(dtV))
                    {
                        tmp = tmp.Replace("{BCODE}", dtV.Rows[0][0].ToString());

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


    }
}
