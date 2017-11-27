using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Omniyat.Models;
using System.Data;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class AgenceController : BaseController
    {
        //
        // GET: /Agence/

        public ActionResult Index()
        {
            ViewData["dt_agence"] = Configs._query.executeProc("AgenceGetAgence", "", true);

            return View();
        }

        public ActionResult NPAgence(string AgenceID = null)
        {
            string param = "";
            if (!string.IsNullOrEmpty(AgenceID))
            {
                param = "AgenceID@int@" + AgenceID;
                ViewData["AgenceName"] = AgenceController.getAgenceName(AgenceID);
            }
            DataTable dt = Configs._query.executeProc("AgenceGetNPAgences", param, true);
            ViewData["data"] = dt;
            return View();
        }

        public ActionResult UpdateNPAgence(string id)
        {
            ViewData["data"] = Configs._query.executeProc("AgenceGetNPAgence", "ID@int@" + id, true);
            ViewData["dt_agence"] = Configs._query.executeProc("AgenceGetAgence", "", true);
            ViewData["id"] = id;

            return View();
        }
        public string SaveNPAgence(string id, string AgenceID) {
            string param = "ID@int@" + id + "#AgenceID@int@" + AgenceID;
            DataTable dt = Configs._query.executeProc("AgenceSaveNPAgence", param, true);
            if(MTools.verifyDataTable(dt))
                return dt.Rows[0][0].ToString();
            return "0";
        }

        public static string getAgenceName(string id)
        {
            DataTable dt = Configs._query.executeProc("AgenceGetAgence", "id@int@" + id, true);

            if (MTools.verifyDataTable(dt))
                return dt.Rows[0]["Nom"].ToString();

            return "N/A";
        }
    }
}
