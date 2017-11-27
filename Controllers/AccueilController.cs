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
    public class AccueilController : BaseController
    {
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

        //
        // GET: /Accueil/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult getNBRCommande_Mag()
        {
            //MAJ.MAJ maj = new MAJ.MAJ();
            DataTable dt = Configs._query.executeProc("getNBRCommande_Mag", "");
            ViewData["getNBRCommande_Mag"] = dt;
            return View();
        }

        public ActionResult getRdv_user_Mag()
        {
            //MAJ.MAJ maj = new MAJ.MAJ();
            DataTable dt = Configs._query.executeProc("getRdv_user_Mag", "");
            ViewData["getRdv_user_Mag"] = dt;
            return View();
        }

        public ActionResult getComUsers()
        {
            //MAJ.MAJ maj = new MAJ.MAJ();
            DataTable dt = Configs._query.executeProc("getCom_Users", "");
            ViewData["getCom_Users"] = dt;
            return View();
        }

    }
}
