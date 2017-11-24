using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Omniyat.Models;

namespace TRC_GS_COMMUNICATION.Models
{
    public class RessourceGenerator
    {
        /*
        public static string generateForm(string code, string detailID = "0")
        {
            DataTable dt = null;

            if (detailID != "0")
                dt = Configs._query.executeProc("_getRessourceData", "DetailID@int@" + detailID); // FIX IT EDIT
            else
                dt = Configs._query.executeProc("Dev_getTableColumns", "name@string@" + code);

            List<RessourceColumn> lst = getListColumns(dt);


            System.Web.Script.Serialization.JavaScriptSerializer objJSSerializer = new
                System.Web.Script.Serialization.JavaScriptSerializer();

            return objJSSerializer.Serialize(lst);
        }*/


        public static string generateForm(string ID, string detailID = "0")
        {
            DataTable dt = null;
            try
            {
                if (detailID != "0")
                    dt = Configs._query.executeProc("_getRessourceData", "DetailID@int@" + detailID); // FIX IT EDIT
                else
                    dt = Configs._query.executeProc("Dev_getTableColumns", "ID@string@" + ID);
            }

            catch (Exception exp)
            {
                Configs.Debug(exp, "TRC_GS_COMMUNICATION.Models.RessourceGenerator.generateForm", "Impossible de charger la liste des collones a partire de la DB");
            }


                List<RessourceColumn> lst = getListColumns(dt);


                System.Web.Script.Serialization.JavaScriptSerializer objJSSerializer = new
                    System.Web.Script.Serialization.JavaScriptSerializer();
            

            

            return objJSSerializer.Serialize(lst);
        }


        public static string getForm(string code)
        {
            DataTable dt = dt = Configs._query.executeProc("Dev_getForm", "name@string@" + code);

            List<RessourceColumn> lst = new List<RessourceColumn>();
            if (Tools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];
                    RessourceColumn col = new RessourceColumn();
                    col.ID = row["ID"].ToString();
                    col.Code = row["Code"].ToString();
                    col.Label = row["Label"].ToString();
                    col.Value = row["Link"].ToString();
                    lst.Add(col);
                }
            }


            System.Web.Script.Serialization.JavaScriptSerializer objJSSerializer = new
                System.Web.Script.Serialization.JavaScriptSerializer();

            return objJSSerializer.Serialize(lst);
        }

        public static string getSteps(string code)
        {
            DataTable dt = dt = Configs._query.executeProc("Dev_getSteps", "name@string@" + code);

            List<RessourceColumn> lst = new List<RessourceColumn>();
            if (Tools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];
                    RessourceColumn col = new RessourceColumn();
                    col.ID = row["ID"].ToString();
                    col.Code = row["Code"].ToString();
                    col.Label = row["Label"].ToString();
                    lst.Add(col);
                }
            }

            System.Web.Script.Serialization.JavaScriptSerializer objJSSerializer = new
                System.Web.Script.Serialization.JavaScriptSerializer();

            return objJSSerializer.Serialize(lst);
        }


        public static string getType(string type, string input = "text")
        {
            if ((type == "nvarchar" || type == "varchar") && input == "textarea")
                type = "TEXTAREA";
            if (type == "nvarchar" || type == "varchar")
                type = "TEXT";
            else if (type == "real")
                type = "TEXT";
            else if (type == "money")
                type = "TEXT";
            else if (type == "datetime")
                type = "DATE";

            return type;
        }

        public static string getProcType(string type)
        {
            if (type == "TEXT")
                type = "string";
            if (type == "real")
                type = "TEXT";
            else if (type == "DATE")
                type = "date";

            return type;
        }

        public static List<RessourceColumn> getListColumns(DataTable dt)
        {
            List<RessourceColumn> lst = new List<RessourceColumn>();
            if (Tools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];
                    RessourceColumn col = new RessourceColumn();
                    col.ID = row["ID"].ToString();
                    col.Input = row["Input"].ToString();
                    col.Type = getType(row["Type"].ToString(), col.Input);
                    col.Code = row["Code"].ToString();
                    col.Label = row["Label"].ToString();
                    col.Editable = row["Editable"].ToString();
                    col.Required = row["Required"].ToString();
                    col.Searchable = row["Searchable"].ToString();
                    col.Value = row["Value"].ToString();
                    col.auto = row["auto"].ToString();
                    col.Source = row["Source"].ToString();
                    col.RegEx = row["RegEx"].ToString();

                    lst.Add(col);
                }
            }

            return lst;
        }

        public static string saveRessource(string RessourceCode, string DetailID, string json)
        {
            string res = "0";

            System.Web.Script.Serialization.JavaScriptSerializer objJSSerializer = new
                System.Web.Script.Serialization.JavaScriptSerializer();

            List<RessourceColumn> lst = objJSSerializer.Deserialize<List<RessourceColumn>>(json);

            var elements = from col in lst
                           where col.Code == "Code"
                           select col;

            if (elements.Count() > 0)
            {
                RessourceColumn rCode = elements.ElementAt(0);

                if (DetailID == "0")
                {
                    DataTable dt = Configs._query.executeProc("_saveRessource", "RessourceCode@string@" + RessourceCode + "#Code@string@" + rCode.Value);
                    if (Tools.verifyDataTable(dt))
                        DetailID = dt.Rows[0][0].ToString();
                }

                if (DetailID != "0")
                {
                    foreach (RessourceColumn col in lst)
                        Configs._query.executeProc("_saveRessourceColumn", "DetailID@int@" + DetailID + "#ID@int@" + col.ID + "#Value@string@" + col.Value);

                    res = "1";
                }
            }

            return res;
        }
    }
}