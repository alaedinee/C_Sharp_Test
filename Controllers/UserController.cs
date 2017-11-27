using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using TRC_GS_COMMUNICATION.Models;
using System.Web.Routing;
using Globale_Varriables;
using System.Data;
using Omniyat.Models;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class UserController : Controller
    {
        protected override void Initialize(RequestContext rc)
        {
            base.Initialize(rc);

            //DataTable dt = Configs._query.executeSql("SELECT GETDATE()");
            //string s = Configs._query.executeScalar("SELECT GETDATE()");
            //int s1 = Configs._query.updateSql("SELECT GETDATE()");

            if (Session["login"] == null)
            {
                HttpCookie myCookie = Request.Cookies["TRCVLog"];
                if (myCookie == null)
                {
                    try
                    {
                        RedirectToAction("LogOn", "User");
                    }
                    catch (Exception exp)
                    {
                        Configs.Debug(exp, "TRC_GS_COMMUNICATION.Controllers.UserController.Initialize", "probleme Cookies");
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(myCookie.Values["userid"]))
                    {
                        Session["login"] = myCookie.Values["userid"].ToString();
                        Session["role"] = majMod.getRolebyId(myCookie.Values["userid"].ToString());
                        Session["agenceID"] = majMod.getUserAgenceById(myCookie.Values["userid"].ToString());
                    }
                    else
                        RedirectToAction("LogOn", "User");
                }
            }
        }

        //
        // GET: /User/

        MajModeles majMod = new MajModeles();

        public ActionResult LogOn()
        {
            //Session["UserAuthentifier"] = "true";
            ViewData["url"] = Request.Url.AbsoluteUri; 
            return View();
        }

        public ActionResult LogOut()
        {
            //if (Session["userID"] != "")
            //{
            //    majMod.deleteSession(Session["userID"].ToString());
            //}
            
            Session["UserAuthentifier"] = "false";
            Session["userID"] = null;
            Session["login"] = null;
            Session["agenceID"] = null;
            Session["loginReception"] = null;
            Session["loginReceptionID"] = null;
            Session["loginReceptionDate"] = null;
            Session["loginReceptionType"] = null;
            Session["loginReceptionPoid"] = null;
            Session["loginReceptionVolume"] = null;
            Session["loginReceptionCamio"] = null;
            Session["loginReceptionChauffeur"] = null;
            Session["color"] = null;
            Session["visible"] = null;
            ViewData["erreur"] = "";

            VAR.removeCookie();
            
            return RedirectToAction("LogOn", "User");
        }

        [HttpPost]
        public ActionResult LogOn(UserModel logModel)
        {
           
            if (!ModelState.IsValid)
            {
                return View(logModel);
            }
            //Session["UserAuthentifier"] = "true";
            ViewData["erreur"] = "";

            string result = majMod.getUser(logModel);
            ViewData["user"] = result;
            
            if(result == "0")
            {
                ViewData["Debug"] = "s1";
                Session["UserAuthentifier"] = "false";
                Session["userID"] = null;
                Session["login"] = null;
                Session["agenceID"] = null;
                Session["loginReception"] = null;
                Session["loginReceptionID"] = null;
                Session["loginReceptionDate"] = null;
                Session["loginReceptionType"] = null;
                Session["loginReceptionPoid"] = null;
                Session["loginReceptionVolume"] = null;
                Session["loginReceptionCamio"] = null;
                Session["loginReceptionChauffeur"] = null;
                Session["color"] = null;
                Session["visible"] = null;
                Session["RessourceID"] = "";
                ViewData["erreur"] = "Nom d'utilisateur / Mot de passe  incorrecte";
                return View();
            }
            else
            {
                string[] tab = result.Split('$');
                
                if (majMod.verifySession(tab[0]) == true)
                {
                    ViewData["Debug"] = "s2";
                    Session["UserAuthentifier"] = "false";
                    Session["userID"] = null;
                    Session["login"] = null;
                    Session["agenceID"] = null;
                    Session["loginReception"] = null;
                    Session["loginReceptionID"] = null;
                    Session["loginReceptionDate"] = null;
                    Session["loginReceptionType"] = null;
                    Session["loginReceptionPoid"] = null;
                    Session["loginReceptionVolume"] = null;
                    Session["loginReceptionCamio"] = null;
                    Session["loginReceptionChauffeur"] = null;
                    Session["color"] = null;
                    Session["visible"] = null;
                    ViewData["erreur"] = "Cette session est déjà ouverte !";
                    return View();
                }
                else
                {
                    if (majMod.addSession(tab[0]) == 1)
                    {
                        ViewData["Debug"] = "s3";
                        Session["userID"] = tab[0];
                        Session["login"] = tab[1];
                        Session["role"] = majMod.getRolebyId(Session["userID"].ToString());
                        Session["agenceID"] = majMod.getUserAgenceById(Session["userID"].ToString());
                        Session["RessourceID"] = tab[2];
                        Session["loginReception"] = "";
                        Session["loginReceptionID"] = "";
                        Session["loginReceptionDate"] = "";
                        Session["loginReceptionType"] = "";
                        Session["loginReceptionPoid"] = "";
                        Session["loginReceptionVolume"] = "";
                        Session["loginReceptionCamio"] = "";
                        Session["loginReceptionChauffeur"] = "";
                        Session["color"] = "red";
                        Session["visible"] = "hidden";

                        VAR.setCookie(tab[0]);

                        Session["UserAuthentifier"] = "true";

                        string param = "type@string@Page" +
                                    "#filter@string@home" +
                                    "#User@string@" + tab[1];
                        // Globale_Varriables.VAR.acl.init();
                        return RedirectToAction("getLstOT1", "Orders");

                        /*
                        string page = Configs.getDefPage(tab[1]);
                        if (page != "")
                        {
                            string[] inf = page.Split('/');
                            return RedirectToAction(inf[1], inf[0]);
                        }
                        else
                            return View();
                         * */
                         
                    }
                    else
                    {
                        ViewData["Debug"] = "s4";
                        Session["UserAuthentifier"] = "false";
                        Session["userID"] = "";
                        Session["login"] = "";
                        Session["agenceID"] = "";
                        Session["loginReception"] = "";
                        Session["loginReceptionID"] = "";
                        Session["loginReceptionDate"] = "";
                        Session["loginReceptionType"] = "";
                        Session["loginReceptionPoid"] = "";
                        Session["loginReceptionVolume"] = "";
                        Session["loginReceptionCamio"] = "";
                        Session["loginReceptionChauffeur"] = "";
                        Session["color"] = "black";
                        Session["visible"] = "hidden";
                        Session["RessourceID"] = "";
                        ViewData["erreur"] = "Une erreur se produite lors de l'ouverture de session !";
                        return View();
                    }
                }
            }
        }

        public string KAlive()
        {
            return (Session["userID"] != null)? Session["userID"].ToString() : "";
        }
        
        public string getMenu()
        {
            string html = "<nav><ul>";
            string user = (Session["userID"] != null) ? Session["login"].ToString() : "";
            string param = "type@string@Menu" +
                           "#filter@string@home" +
                          "#User@string@" + user;

            DataTable dt = Configs._query.executeProc("_getControlByType", param );
            if (MTools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];

                    html += "<li><a href='" + Globale_Varriables.VAR.get_URL_HREF() + row["Link"] + "' class='spMenu'>" + row["Text"] + "</a>";

                    param = "parent@int@" + row["ID"] +
                          "#filter@string@home";

                    DataTable dtChildren = Configs._query.executeProc("_getControlByParent", param);
                    if (MTools.verifyDataTable(dtChildren))
                    {
                        html += "<ul>";

                        for (int j = 0; j < dtChildren.Rows.Count; j++)
                        {
                            DataRow SubRow = dtChildren.Rows[j];
                            html += "<li><a href='" + Globale_Varriables.VAR.get_URL_HREF() + SubRow["Link"] + "' class='spMenu'>" + SubRow["Text"] + "</a></li>";
                        }

                        html += "</ul>";
                    }
                    else
                        html += "</li>";

                }
            }

            html += "</nav></ul>";

            return html;
        }

    }
}
