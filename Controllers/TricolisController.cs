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

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class TricolisController : Controller
    {
        protected override void Initialize(RequestContext rc)
        {
            base.Initialize(rc);
            Globale_Varriables.VAR.myCookie = Request.Cookies["TRCVLog"];
            if (Session["userID"] == null)
            {
                if (VAR.verifyCookie())
                {
                    Session["userID"] = VAR.myCookie.Values["userid"].ToString();
                    MajModeles majMod = new MajModeles();
                    Session["login"] = majMod.getUserbyId(Session["userID"].ToString());
                    Session["role"] = majMod.getRolebyId(Session["userID"].ToString());
                    Session["agenceID"] = majMod.getUserAgenceById(Session["userID"].ToString());
                    Configs.login = Session["login"].ToString();
                }
                else
                    VAR.Redirect();
            }
             
        }


    }
}
