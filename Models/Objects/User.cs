using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Omniyat.Models;
using System.Data;

namespace Omni_TTM.Objects
{
    public class User
    {
        public string id;
        public string username;

        public string fname;
        public string lname;

        public string role;
        public string RessourceId;

        public User(string username)
        {
            this.username = username;
        }

        public bool verifyUser(string password)
        {
            bool res = false;
            string sql = String.Format("SELECT * FROM tbl_users WHERE username='{0}' and visible='y'", username);
            DataTable _dtUser = Configs._query.executeSql(sql);
            if (MTools.verifyDataTable(_dtUser))
            {
                DataRow row = _dtUser.Rows[0];
                if (row["password"].ToString() == password)
                {
                    id = row["id"].ToString();
                    fname = row["fname"].ToString();
                    lname = row["lname"].ToString();
                    role = row["role"].ToString();
                    RessourceId = row["RessourceId"].ToString();

                    HttpCookie myCookie = new HttpCookie("TRCVLog");
                    myCookie["UserId"] = id;
                    myCookie.Expires = DateTime.Now.AddHours(24);
                    HttpContext.Current.Response.Cookies.Add(myCookie);
                    res = true;
                }
            }
            return res;
        }
    }
}