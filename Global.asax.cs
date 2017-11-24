using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Collections;
using Globale_Varriables;

namespace TRC_GS_COMMUNICATION
{
    // Remarque : pour obtenir des instructions sur l'activation du mode classique IIS6 ou IIS7, 
    // visitez http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static string pathNavigate = "";


        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default", // Nom d'itinéraire
                "{controller}/{action}/{id}", // URL avec des paramètres
                new { controller = "User", action = "LogOn", id = UrlParameter.Optional } // Paramètres par défaut

            );
            routes.MapRoute(
                "Default2", // Nom d'itinéraire
                "{controller}/{action}/{id}/{date}", // URL avec des paramètres
                new { controller = "Home", action = "Index", id = 1, date = "" } // Paramètres par défaut

            );


            routes.MapRoute(
            "confirmation", // Nom d'itinéraire
            "{controller}/{action}/{id}/{date}/{OTID}", // URL avec des paramètres
            new { controller = "Home", action = "Index", id = 1, date = "", OTID = 1 } // Paramètres par défaut
            );


            routes.MapRoute(
             "Default3", // Nom d'itinéraire
             "{controller}/{action}/{date}/{code}/{remarque}/{str}", // URL avec des paramètres
             new { controller = "Home", action = "Index", date = UrlParameter.Optional, code = UrlParameter.Optional, remarque = UrlParameter.Optional, str = UrlParameter.Optional } // Paramètres par défaut
             );
       
        }

        protected void Session_Start()
        {
        
        }
        
        protected void Session_End()
        {
            //TRC_GS_COMMUNICATION.Models.MajModeles mjr = new TRC_GS_COMMUNICATION.Models.MajModeles();
            //if (Session["userID"].ToString() != "")
            //{
            //    mjr.deleteSession(Session["userID"].ToString());
            //}
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            Globale_Varriables.VAR.AppLocation = Server.MapPath("/") + Globale_Varriables.VAR.get_URL_HREF();
            Globale_Varriables.VAR.AppPath = Server.MapPath("/");
            // Globale_Varriables.VAR.getAllControllers();

            RegisterRoutes(RouteTable.Routes);
        }

        protected void Application_Error()
        {
            //Response.Redirect("/trcrv/Shared/Error?aspxerrorpath=/");
        }
    }
}