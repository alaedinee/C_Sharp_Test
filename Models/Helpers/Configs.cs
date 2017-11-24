using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Diagnostics;
using System.Data.SqlClient;
using Omni_TTM.Objects;
using maintenance.Models;
using Globale_Varriables;
using System.Data;

namespace Omniyat.Models
{
    public class Configs : System.Web.UI.Page
    {
        public static string _urlServer = getUrlServer();
        // public static SqlConnection _sqlConnection = new SqlConnection(_urlServer);
        public static Query _query = new Query();

        public static User _user;
        public static string login = "noOne";

        public static string getUrlServer()
        {
            string res = "";
            try
            {
                string file = HttpContext.Current.Server.MapPath("~/Config") + "/Config.dat";
                StreamReader sr = new StreamReader(file);
                res = Cryptage.Decrypt(sr.ReadLine());
                sr.Close();
            }
            catch(Exception ex)
            {
                Debug(ex);
            }
            ////res = @"Data Source=37.187.168.96\NEWSERVER;initial Catalog=TAM_LOG;Uid=softuser;Password=12345";  // SERVEUR
            ////res = @"Data Source=37.187.168.96\NEWSERVER;initial Catalog=TAM_DEV;Uid=softuser;Password=12345"; 
            //// res = @"Data Source=OMNIYAT-PC;Initial Catalog=TRDB_TAM;Password=softpass;User Id=softuser";//local
            //res = @"Data Source=192.168.0.21;Initial Catalog=TRDB_TAM;Password=softpass;User Id=softuser";

            return res;
        }

        public static void Debug(Exception ex, string msg = "", string sql = "")
        {
            var st = new StackTrace(ex, true);
            var frame = st.GetFrame(0);

            string _login = (System.Web.HttpContext.Current.Session["login"]==null)? "noUser" : System.Web.HttpContext.Current.Session["login"].ToString();

            string _date = DateTime.Now.ToShortDateString().Replace('/', '.');


            string pathDebug = VAR.DebPath + "__" + _login + "_" + _date +  ".html";
            bool ok = File.Exists(pathDebug);
            StreamWriter sw = new StreamWriter(pathDebug, true);
            if (!ok)
                sw.WriteLine("<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>");

            sw.WriteLine("<table border='1'><tr><td>" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:s") + "</td><td><h2>" + msg + "</h2><br />" + ex.ToString().Replace("à", "<br />") + "<br /><p style='background-color:yellow'>" + sql + "</p></td></tr></table><br />");
            sw.Flush();
            sw.Close();
        }

        public static void Debug(String msg)
        {
            string _login = (System.Web.HttpContext.Current.Session["login"] == null) ? "noUser" : System.Web.HttpContext.Current.Session["login"].ToString();

            string pathDebug = VAR.DebPath + "__" + _login + ".html";
            bool ok = File.Exists(pathDebug);
            StreamWriter sw = new StreamWriter(pathDebug, true);
            if (!ok)
                sw.WriteLine("<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>");

            sw.WriteLine("<table border='1'><tr><td>" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:s") + "</td><td>" +msg + "</td></tr></table><br />");
            sw.Flush();
            sw.Close();
        }

        public static bool verifyPage(string page, string user)
        {
            string param = "name@string@" + page +
                          "#User@string@" + user;
            DataTable dt = Configs._query.executeProc("_getControlByName", param);
            return MTools.verifyDataTable(dt);
        }

        public static string getDefPage(string user)
        {
            string page = "";

            string param = "type@string@Page" +
                                                "#filter@string@home" +
                                                "#User@string@" + user;
            DataTable dt = Configs._query.executeProc("_getControlByType", param);
            if (MTools.verifyDataTable(dt))            
                page = dt.Rows[0]["Link"].ToString();
               
           
            return page;
        }
    }
}