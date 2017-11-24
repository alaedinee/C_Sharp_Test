using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Omniyat.Models;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class ArticleController : BaseController
    {
        //
        // GET: /Article/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult getLstArticles(string OTID, string isOpen)
        {
            DataTable dt = Configs._query.executeProc("getLstArticlesByOTID", "OTID@int@" + OTID, true);
            ViewData["LstArticles"] = dt;
            ViewData["isOpen"] = isOpen;
            ViewData["OTID"] = OTID;
            return View();
        }
        //
        public ActionResult getComArticles(string DetailID)
        {
            DataTable dt = Configs._query.executeProc("getLstComArticlesByDetailID", "DetailID@int@" + DetailID, true);
            ViewData["LstArticles"] = dt;

            return View();
        }

        public ActionResult addArticleForm(string OTID, string mode, string articleID = "-1")
        {
            ViewData["OTID"]        = OTID;
            ViewData["mode"]        = mode;
            ViewData["articleID"]   = articleID;
            ViewData["data"]        = null;

            if(mode == "modifier")
                ViewData["data"] = Configs._query.executeProc("getArticleByID", "articleID@int@" + articleID, true);

            return View();
        }

        public ActionResult VerifyAddArticle(string OTID, string articleNumber)
        {
            List<object> lst = new List<object>();
            DataTable dt = Configs._query.executeProc("getArticleByNumber", "OTID@int@" + OTID + "#articleNumber@int@" + articleNumber, true);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];

                lst.Add(new
                {
                    Result = r["Result"].ToString(),
                    ArticleNumber = r["articleNumber"].ToString(),
                    Description = r["description"].ToString(),
                    Quantity = r["quantity"].ToString(),
                    Volume = r["volume"].ToString(),
                    Weight = r["weight"].ToString(),
                    NbrColis = r["NbrColis"].ToString()
                });
            }
            else
            {
                lst.Add(new
                {
                    Result = "0",
                    ArticleNumber = articleNumber,
                    Description = "",
                    Quantity = "0",
                    Volume = "0",
                    Weight = "0",
                    NbrColis = "0"
                });
            }
            return Json(lst, JsonRequestBehavior.AllowGet);
        }

        public string AddArticle(string OTID, string ArticleNumber, string Description, string Quantity, string Volume, string Weight, string NbrColis, string mode = "Ajouter")
        {
            string param = "OTID@int@{0}#ArticleNumber@int@{1}#Description@string@{2}#Quantity@int@{3}#Volume@double@{4}#Weight@double@{5}#NbrColis@double@{6}#mode@string@{7}";
            param = string.Format(param, OTID, ArticleNumber, Description, Quantity, Volume, Weight, NbrColis, mode);

            DataTable dt = Configs._query.executeProc("ArticleAddArticle", param, true);
            if (dt != null && dt.Rows.Count > 0)
            {
                return dt.Rows[0][0].ToString();
            }

            return "0";
        }

        public ActionResult getServiceArticle(string DetailID)
        {
            DataTable dt = Configs._query.executeProc("getLstArticlesByDetailID", "DetailID@int@" + DetailID, true);
            ViewData["LstArticles"] = dt;
            ViewData["DetailID"] = DetailID;

            return View();
        }

        public ActionResult getServiceArticleToChoise(string DetailID)
        {
            DataTable dt = Configs._query.executeProc("getLstArticlesByDetailID_toChoise", "DetailID@int@" + DetailID, true);
            ViewData["LstArticles"] = dt;
            ViewData["DetailID"] = DetailID;

            return View();
        }

        public ActionResult showChildsArticle(string OrderLineID)
        {
            DataTable dt = Configs._query.executeProc("getLstChildsArticle", "OrderLineID@int@" + OrderLineID, true);
            ViewData["LstArticles"] = dt;
            ViewData["OrderLineID"] = OrderLineID;

            return View();
        }
        public ActionResult historyArticle(string OrderLineID, string mode = "RECEPTION")
        {
            DataTable dt = Configs._query.executeProc("getHistoryArticle", "OrderLineID@int@" + OrderLineID + "#mode@string@" + mode, true);
            ViewData["data"] = dt;
            ViewData["OrderLineID"] = OrderLineID;

            return View();
        }

        public string AddArticleService(string DetailID, string Articles)
        {
            string res = "OK";

            string[] Arts = Articles.Split(',');

            foreach (string e in Arts)
            {
                string[] tab = e.Split('#');
                int qte;
                if (tab.Length < 2)
                    continue;
                if (!Int32.TryParse(tab[1], out qte))
                    continue;
                DataTable dt = Configs._query.executeProc("AddArticleService", "DetailID@int@" + DetailID + "#ArticleID@int@" + tab[0] + "#qte@int@" + qte, true);
                if(dt == null || dt.Rows.Count == 0 || dt.Rows[0][0].ToString() != "1")
                {
                    res = "Erreur";
                }
                else
                    maintenance.Models.Ajoindre.ImprimBL(dt.Rows[0][1].ToString(), DetailID, true);
            }    
            return res;
        }

        public string DeleteArticleService(string DetailID, string Articles)
        {
            string res = "Erreur";
            DataTable dt = Configs._query.executeProc("DeleteArticleService", "DetailID@int@" + DetailID + "#Articles@string@" + Articles, true);
            if (dt != null && dt.Rows.Count > 0 && dt.Rows[0][0].ToString() == "1")
            {
                res = "OK";
                maintenance.Models.Ajoindre.ImprimBL(dt.Rows[0][1].ToString(), DetailID, true);
            }
            return res;
        }


    }
}
