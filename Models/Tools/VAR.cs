using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using Omniyat.Models;

namespace Globale_Varriables
{
    public class VAR : System.Web.UI.Page
    {
        public static string AppLocation = "";
        public static string AppPath = "";

        public static string DebPath = HttpContext.Current.Server.MapPath("~/Config") + "/Debug";
        public static string MailPath = HttpContext.Current.Server.MapPath("~/Config") + "/MailContent/";
        public static string PathCont = HttpContext.Current.Server.MapPath("~/Content");

        public static string LogPath = HttpContext.Current.Server.MapPath("~/Config/Debug/Debug");

        public static string testXmlConfig = TRC_GS_COMMUNICATION.Models.Tools.parseConfigs(HttpContext.Current.Server.MapPath("~/Config") + "/Configs.xml");

        public static string pathFileUpload = TRC_GS_COMMUNICATION.Models.Tools.getXmlConfig("PathPreuves"); //TRC_GS_COMMUNICATION.Models.Tools.getValueFromConfig("PathPreuves"); // FIX IT
        public static string urlFileUpload = TRC_GS_COMMUNICATION.Models.Tools.getXmlConfig("URLConsult"); //TRC_GS_COMMUNICATION.Models.Tools.getValueFromConfig("URLConsult");   //FIX IT
        public static string pathApplication = TRC_GS_COMMUNICATION.Models.Tools.getXmlConfig("PathApplicationTest"); //TRC_GS_COMMUNICATION.Models.Tools.getValueFromConfig("PathApplicationTest");

        public static string PATH_STOCKAGE = TRC_GS_COMMUNICATION.Models.Tools.getXmlConfig("PATH_STOCKAGE");
        public static string PATH_CONSULTATION = TRC_GS_COMMUNICATION.Models.Tools.getXmlConfig("PATH_CONSULTATION");

        public static string SERVER_URL_HREF = TRC_GS_COMMUNICATION.Models.Tools.getXmlConfig("SERVER_URL_HREF"); //"http://localhost:55659/"; //TRC_GS_COMMUNICATION.Models.Tools.getValueFromConfig("SERVER_URL_HREF");

        public static string ConfigPath = HttpContext.Current.Server.MapPath("~/Config");
        public static string FilePath = HttpContext.Current.Server.MapPath("~/File");
        public static string importPath = HttpContext.Current.Server.MapPath("~/Import") + @"\";

        public static HttpCookie myCookie;

        public static TRC_GS_COMMUNICATION.Models.ACL acl = new TRC_GS_COMMUNICATION.Models.ACL();
        public static string isLoadAcl = acl.init();


        public static void setCookie(string id)
        {
            try
            {
                myCookie = new HttpCookie("TRCVLog");
                myCookie["UserId"] = id;
                myCookie.Expires = DateTime.Now.AddHours(24);
                HttpContext.Current.Response.Cookies.Add(myCookie);
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "Omniyat.Models.VAR.setCookie", "création cookies");
            }
        }

        public static bool verifyCookie()
        {
            return (VAR.myCookie != null) ? ((!string.IsNullOrEmpty(VAR.myCookie.Values["userid"])) ? true : false) : false;
        }

        public static void removeCookie()
        {
            try
            {
                myCookie = new HttpCookie("TRCVLog");
                myCookie.Expires = DateTime.Now.AddDays(-1);
                HttpContext.Current.Response.Cookies.Add(myCookie);
            }
            catch (Exception e) {
                Configs.Debug(e, "Omniyat.Models.VAR.setCookie", "suppression cookies");
            }
        }

        public static void Redirect(string url = null)
        {
            if(string.IsNullOrEmpty(url))
                HttpContext.Current.Response.Redirect("../User/LogOn");

            HttpContext.Current.Response.Redirect(get_URL_HREF() + "/" + url);
        }

        public static string ToAbsoluteUrl()
        {
            var appUrl = VirtualPathUtility.ToAbsolute("~/");

            return HttpContext.Current.Request.Url.AbsolutePath.Remove(0, appUrl.Length - 1);

        }

        public static string get_URL_HREF()
        {
            return SERVER_URL_HREF;
        }

        public static void getAllControllers()
        {
            System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();

            var Controllers = asm.GetTypes() // .Where(type => type.Name.EndsWith("Controller"));
                .Where(type => typeof(System.Web.Mvc.Controller).IsAssignableFrom(type));//filter controllers
                //.SelectMany(type => type.GetMethods())
                //.Where(method => method.IsPublic /*&& !method.IsDefined(typeof(System.Web.Mvc.NonActionAttribute))*/);

            string str = "";
            Controllers.ToList().ForEach(c => {
                string name = c.Name;
                str += name + "\n";
                c.GetMethods().AsEnumerable().Where(m => m.IsPublic && !m.IsDefined(typeof(System.Web.Mvc.NonActionAttribute), true)).ToList().ForEach(m =>
                {
                    str += "\t\t" + name + "/" + m.Name + "\n";
                });
            });
            System.IO.File.WriteAllText(ConfigPath + "/ControllersActions.txt", str);
        }

    }
}