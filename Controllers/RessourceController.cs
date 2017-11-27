using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Tricolis.Models.Fonctionnalities;
using System.Data;
using ProfaSys.Library;
using Tricolis.Models;
using System.IO;
using Tricolis.Models.Params;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class RessourceController : Controller
    {
        public ActionResult Index(string Name, string Label, string Type = "", string Mode = "")
        {
            ViewData["Name"] = Name;
            ViewData["Label"] = Label;
            ViewData["Type"] = Type;
            ViewData["Mode"] = Mode;

            return View();
        }

        public ActionResult List(string Name, string Label, string Type = "", string Where = "")
        {
            string param = String.Format("Name|string|{0}~Type|string|{1}~Where|string|{2}", Name, Type, Where);
            ViewData["dtList"] = Param._query.executeProc("PRC_getRessList", param);

            ViewData["Name"] = Name;
            ViewData["Label"] = Label;
            ViewData["Type"] = Type;

            Session["ViewMode"] = "";

            // Actions
            /*
            List<CMenu> lst = (List<CMenu>)Session["Menus"];
            if (lst == null)
                lst = new List<CMenu>();
            else
                lst = lst.Where(x => x.Type == "Action" && x.visible == "1" && x.parentID == Name).OrderBy(x => x.position).ToList();
            */

            //ViewData["Actions"] = lst;

            return View();
        }

        public ActionResult ListVignette(string Name, string Label, string Type = "", string Cond = "")
        {
            Session["ViewMode"] = "Vignette";

            string param = String.Format("Name|string|{0}~Type|string|{1}~Where|string|{2}", Name, Type, Cond);
            ViewData["dtList"] = Param._query.executeProc("PRC_getRessList", param);

            /*
            List<Status> lstStatus = new List<Status>();
            param = String.Format("ID|int|{0}~Type|string|{1}", Name, Type);
            DataTable dtStatList = Param._query.executeProc("WEB_getRessourceStatusStatistics", param);
            for (int i = 0; i < dtStatList.Rows.Count; i++)
            {
                Status st = new Status();
                DataRow row = dtStatList.Rows[i];

                st.ID = row["ID"].ToString();
                st.Name = row["Name"].ToString();
                st.Label = row["Label"].ToString();
                st.ParentID = row["ParentID"].ToString();
                st.Icon = row["Icon"].ToString();
                st.ForeColor = row["ForeColor"].ToString();
                st.Nbr = Int32.Parse(row["Nbr"].ToString());
                st.Field = row["Field"].ToString();

                if (st.ParentID == "0")
                {
                    lstStatus.Add(st);

                    if (lstStatus.Where(x => x.ID == st.ID).Count() > 0)
                    {
                        lstStatus.Where(x => x.ID == st.ID).First().lst.Add(st);
                    }
                }
                else
                {
                    if (lstStatus.Where(x => x.ID == st.ParentID).Count() > 0)
                    {
                        Status parent = lstStatus.Where(x => x.ID == st.ParentID).First();
                        if (parent != null)
                        {
                            //parent.Nbr += st.Nbr;
                            parent.lst.Add(st);
                        }
                    }
                }
            }
            */
            /*
            ViewBag.Name = Name;
            ViewBag.Label = Label;
            ViewBag.Type = Type;
            ViewBag.lstStatus = lstStatus;

            // Actions
            List<CMenu> lst = (List<CMenu>)Session["Menus"];
            if (lst == null)
                lst = new List<CMenu>();
            else
                lst = lst.Where(x => x.Type == "Action" && x.visible == "1" && x.parentID == Name).OrderBy(x => x.position).ToList();
            ViewBag.Actions = lst;
            */
            return View("ListV");
        }

        public ActionResult Link(string Link, string Label, string Where = "", string parentID = "0")
        {
            string[] linkParam = Link.Split('#');
            string userID = System.Web.HttpContext.Current.Session["userID"].ToString();

            int pID;
            bool isNumeric = int.TryParse(parentID, out pID);
            if (!isNumeric)
                parentID = "0";
            else
                parentID = pID.ToString();

            string param = String.Format("Name|string|{0}~userID|int|{1}~Where|string|{2}~parentID|int|{3}", linkParam[0], userID, Where, parentID);



            DataTable dt = Param._query.executeProc("PRC_getLink", param);
            ViewData["dtList"] = dt;
            //if (linkParam[0].IndexOf("-SP") > 0)
            //    ViewBag.Object = linkParam[0].Substring(0, linkParam[0].IndexOf("-SP") - 1);
            //else

            ViewData["Object"] = linkParam[0];

            ViewData["srcObject"] = linkParam[1];
            ViewData["Name"] = linkParam[2];
            ViewData["Code"] = linkParam[3];
            ViewData["Label"] = Label;

            return View();
        }

        public string verifyPhoto(string code, string id)
        {
            string res = "false";

            string dir = Configs.getXmlConfig("FILE_WRITE_URL") + id + @"\" + code + @"\" + id + ".jpg";
            if (System.IO.File.Exists(dir))
                res = "true";

            return res;
        }

        public JsonResult getFiles(string code)
        {
            string dirPath = Configs.getXmlConfig("FILE_WRITE_URL") + @"{0}\";
            dirPath = string.Format(dirPath, code);

            List<string> files = new List<string>();

            if (Directory.Exists(dirPath))
            {
                DirectoryInfo dirInfo = new DirectoryInfo(dirPath);
                foreach (FileInfo fInfo in dirInfo.GetFiles())
                {
                    files.Add(fInfo.Name);
                }
            }
            return Json(files, JsonRequestBehavior.AllowGet);
        }

        public string Parent(string Link, string type = "")
        {
            string code = "";
            string label = "";
            string _ID = "";
            string[] linkParam = Link.Split('#');
            string[] Columns = linkParam[1].Split('|');

            //if (linkParam[0].IndexOf("-SP") > 0)
            //    linkParam[0] = linkParam[0].Substring(0, linkParam[0].IndexOf("-SP"));
            //else

            linkParam[0] = linkParam[0];

            string userID = System.Web.HttpContext.Current.Session["userID"].ToString();

            string where = string.Format(" {0} like '{1}'", Columns[0], linkParam[4]);
            string param = String.Format("Name|string|{0}~Where|string|{1}~Type|string|{2}~userID|int|{3}", linkParam[0], where, type, userID);

            DataTable dtInf = Param._query.executeProc("PRC_getLink", param);
            if (Tools.verifyDataTable(dtInf))
            {
                code = dtInf.Rows[0][Columns[0]].ToString();
                _ID = dtInf.Rows[0]["ID"].ToString();
                if (Columns.Length > 1)
                {
                    for (int i = 1; i < Columns.Length; i++)
                    {
                        label += dtInf.Rows[0][Columns[i]].ToString() + " ";
                    }
                    if (label.Length > 1) label = label.Substring(0, label.Length - 1);
                }
            }
            return linkParam[2] + '|' + linkParam[3] + '|' + code + '|' + label + "|" + _ID;
        }

        public string Auto(string Object, string srcObject)
        {
            string res = "";

            string param = String.Format("Name|string|{0}", Object);

            DataTable dtList = Param._query.executeProc("PRC_getLink", param);
            if (Tools.verifyDataTable(dtList))
            {
                string[] colInf = srcObject.Split('|');
                for (int i = 0; i < dtList.Rows.Count; i++)
                {
                    DataRow row = dtList.Rows[i];

                    res += row[colInf[0]].ToString() + "~";
                    for (int col = 1; col < colInf.Length; col++)
                    {
                        res += row[colInf[col]].ToString() + " ";
                    }
                    if (res.Length > 1) res = res.Substring(0, res.Length - 1);

                    res += "\n";
                }

                if (res.Length > 1) res = res.Substring(0, res.Length - 1);
            }

            return res;
        }


        public string InitPass(string id)
        {
            string res = "";

            string param = String.Format("id|int|{0}", id);

            DataTable dtList = Param._query.executeProc("PRC_InitPassWord", param);
            if (Tools.verifyDataTable(dtList))
                res = dtList.Rows[0][0].ToString();


            return res;
        }

        [HttpPost]
        public ContentResult UploadFiles(string Code, string Object, string type)
        {
            var r = new List<UploadFilesResult>();
            foreach (string file in Request.Files)
            {
                HttpPostedFileBase hpf = Request.Files[file] as HttpPostedFileBase;
                if (hpf.ContentLength == 0)
                    continue;

                string dir = Configs.getXmlConfig("FILE_WRITE_URL") + Object + @"\" + Code;

                string filename = Path.GetFileName(hpf.FileName);
                if (type == "Photo") filename = Object + ".jpg";

                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
                string savedFileName = Path.Combine(dir, filename);
                hpf.SaveAs(savedFileName);

                r.Add(new UploadFilesResult()
                {
                    Name = hpf.FileName,
                    Length = hpf.ContentLength,
                    Type = hpf.ContentType
                });
            }
            return Content("{\"name\":\"" + r[0].Name + "\",\"type\":\"" + r[0].Type + "\",\"size\":\"" + string.Format("{0} bytes", r[0].Length) + "\"}", "application/json");
        }

        public ActionResult Form(string Name, string ID, string Label, string Type = "", string Mode = "")
        {
            ViewData["ID"] = ID;
            ViewData["Name"] = Name;
            ViewData["Label"] = Label;
            ViewData["Type"] = Type;
            ViewData["Mode"] = Mode;

            return View();
        }

        public string getColumns(string Name, Int64 ID, string Type = "")
        {
            string columns = "";
            columns = Ressource.getColumns(Name, ID, Type);

            return columns;
        }

        public string Save(string Name, Int64 ID, string jsonData, string Type = "")
        {
            string s = Ressource.Save(Name, ID, Type, jsonData);
            return s;
        }

        public string Delete(string id, string Type = "")
        {
            string res = "";
            string userID = System.Web.HttpContext.Current.Session["userID"].ToString();
            string param = "userID|int|{0}~ID|int|{1}";

            if (Type != "")
                param += "~Type|string|{2}";

            param = String.Format(param, userID, id, Type);
            DataTable dt = Param._query.executeProc("PRC_deleteRessource", param);
            if (Tools.verifyDataTable(dt)) res = dt.Rows[0][0].ToString();

            return res;
        }


        public string setActivate(string id, string value, string Type = "")
        {
            string res = "";

            string userID = System.Web.HttpContext.Current.Session["userID"].ToString();
            string param = "userID|int|{0}~ID|int|{1}~value|int|" + value;

            if (Type != "")
                param += "~Type|string|{2}";

            param = String.Format(param, userID, id, Type);
            DataTable dt = Param._query.executeProc("PRC_Ressource_setActivate", param);
            if (Tools.verifyDataTable(dt)) res = dt.Rows[0][0].ToString();

            return res;
        }


        public ActionResult SearchLink(string Name, string Type, string obj, string filter = "")
        {
            string userID = System.Web.HttpContext.Current.Session["userID"].ToString();
            string param = "Name|string|{0}~Type|string|{1}~userID|int|{2}~where|string|{3}";

            ViewData["dtList"] = Param._query.executeProc("PRC_getSearchLink", string.Format(param, Name, Type, userID, filter));
            ViewData["obj"] = obj;
            ViewData["ID"] = Name;
            ViewData["Type"] = Type;

            return View();
        }

        public ActionResult GeoLocation()
        {
            return View();
        }

    }
}
