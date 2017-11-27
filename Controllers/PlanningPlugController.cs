using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using TRC_GS_COMMUNICATION.Models;
using Omniyat.Models;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class PlanningPlugController : BaseController
    {
        //
        // GET: /PlanningPlug/

        public ActionResult Index()
        {
            return View();
        }

        /*
        public ActionResult addPlan(string datefrom, string dateto)
        {
            string param = "datefrom|date|{0}~dateto|date|{1}";
            param = string.Format(param, datefrom, dateto);
            string res = "0";
            DataTable dt = Param._query.executeProc("PlanningPlug_addPlan", param);
            if (Tools.verifyDataTable(dt)) res = dt.Rows[0][0].ToString();
            var json_res = string.Format("{ id: \"{0}\" }", res);
            return Content(json_res, "application/json");
        }*/

        public ActionResult searchBL(string bl)
        {
            string param = "bl|string|{0}";
            param = string.Format(param, bl);
            DataTable dt = Configs._query.executeProc("PlanningPlug_searchBL", param, false, '|', '~');

            var json_res = "[]";
            if (Tools.verifyDataTable(dt))
            {
                string lines = "";
                string line = "'id': '{0}', 'date': '{1}'".Replace("'", "\"");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    lines += "{" + string.Format(line, r["id"], r["date"]) + "},";
                }

                lines = lines.Substring(0, lines.Length - 1);
                json_res = string.Format(@"[{0}]", lines);
            }

            return Content(json_res, "application/json");
        }

        public string sendPlanJobs(string d, string m)
        {
            return MTools.getURLContent("http://37.187.168.96/TRC_gps_API/Service.asmx/DemoCreateRoute?note=demo&d=" + d + "&m=" + m);
        }

        public ActionResult setMission(string planId, string date, string act)
        {
            string param = "planId|int|{0}~date|date|{1}~action|string|{2}";
            param = string.Format(param, planId, date, act);
            DataTable dt = Configs._query.executeProc("PlanningPlug_setMission", param, false, '|', '~');

            var json_res = "{}";
            if (Tools.verifyDataTable(dt))
            {
                DataRow r = dt.Rows[0];
                json_res = @"{ 'msg' : '{msg}', 'missions':'{missions}' }";
                json_res = json_res.Replace("'", "\"");
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    json_res = json_res.Replace("{" + dt.Columns[i].ColumnName + "}", r[i].ToString());
                }
            }

            return Content(json_res, "application/json");
        }

        public ActionResult showMissionInf(string id, string miss)
        {
            string param = "id|int|{0}~miss|int|{1}";
            param = string.Format(param, id, miss);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getMissInfo", param, false, '|', '~');

            var json_res = "{}";
            if (Tools.verifyDataTable(dt))
            {
                DataRow r = dt.Rows[0];
                json_res = @"{  'weight' : '{weight}', 
                                'volume' : '{volume}', 
                                'palette' : '{palette}'
				             }";

                json_res = json_res.Replace("'", "\"");
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    json_res = json_res.Replace("{" + dt.Columns[i].ColumnName + "}", r[i].ToString());
                }
                
            }
            return Content(json_res, "application/json");
        }


        public ActionResult getPlan(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getPlan", param, false, '|', '~');

            var json_res = "{}";
            if (Tools.verifyDataTable(dt))
            {
                DataRow r = dt.Rows[0];
                json_res = @"{ 'success' : '0', 'failed':'100',
							'plans' : [{'id':'{id}', 'date': '{date}', 'Status':'{Status}', 'linkStatus': '{linkStatus}', 'labelStatus': '{labelStatus}', 'isEdit': '{isEdit}', 
										'vehicule': '{vehicule}', 'driver': '{driver}', 'helpers': '{helpers}',
										'from': '{from}', 'to': '{to}', 'step': {step},
										'weight' : '{weight}', 'volume' : '{volume}', 'score' : '{score}', 'palette' : '{palette}', 'missions':'{missions}', 'note':'{note}'}
									]
				                }";
                json_res = json_res.Replace("'", "\"");
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    json_res = json_res.Replace("{" + dt.Columns[i].ColumnName + "}", r[i].ToString());
                }
                //, r["id"], r["date"], r["vehicule"], r["driver"], r["helpers"], r["from"], r["to"],
                //               r["step"], r["weight"], r["volume"], r["score"], r["palette"]);
            }

            //return json_res; // Content(json_res, "application/json");
            return Content(json_res, "application/json");
        }


        public ActionResult getPlans(string date, string date2)
        {

            Session["Plug_date1"] = date;
            Session["Plug_date2"] = date2;

            string param = "date|date|{0}~date2|date|{1}";
            param = string.Format(param, date, date2);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getPlans", param, false, '|', '~');

            var json_res = "{}";
            if (Tools.verifyDataTable(dt))
            {
                string line = @"'id':'{id}', 'date': '{date}', 'Status':'{Status}', 'linkStatus': '{linkStatus}', 'labelStatus': '{labelStatus}', 'isEdit': '{isEdit}', 
										'vehicule': '{vehicule}', 'driver': '{driver}', 'helpers': '{helpers}',
										'from': '{from}', 'to': '{to}', 'step': {step},
										'weight' : '{weight}', 'volume' : '{volume}', 'score' : '{score}', 'palette' : '{palette}', 'missions':'{missions}', 'note':'{note}' ";
                line = line.Replace("'", "\"");

                string lines = "";
                for (int ri = 0; ri < dt.Rows.Count; ri++)
                {
                    DataRow r = dt.Rows[ri];
                    string tmp = line;
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        tmp = tmp.Replace("{" + dt.Columns[i].ColumnName + "}", r[i].ToString());
                    }

                    lines += "{" + tmp + "},";
                }

                lines = lines.Substring(0, lines.Length - 1);
                json_res = @"{ 'success' : '0', 'failed':'100',
							'plans' : [".Replace("'", "\"") + lines + "]}";

            }

            //return json_res; // Content(json_res, "application/json");
            return Content(json_res, "application/json");
        }

        public ActionResult getChangeDriver(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getChangeDriver", param, false, '|', '~');

            var json_res = "[]";
            if (Tools.verifyDataTable(dt))
            {
                string lines = "";
                string line = "'label': '{0}', 'value': '{1}'".Replace("'", "\"");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    lines += "{" + string.Format(line, r["label"], r["value"]) + "},";
                }

                lines = lines.Substring(0, lines.Length - 1);
                json_res = string.Format(@"[{0}]", lines);
            }

            return Content(json_res, "application/json");
        }


        public ActionResult getChangeVehicule(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getChangeVehicule", param, false, '|', '~');

            var json_res = "[]";
            if (Tools.verifyDataTable(dt))
            {
                string lines = "";
                string line = "'label': '{0}', 'value': '{1}'".Replace("'", "\"");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    lines += "{" + string.Format(line, r["label"], r["value"]) + "},";
                }
                lines = lines.Substring(0, lines.Length - 1);
                json_res = string.Format(@"[{0}]", lines);
            }

            return Content(json_res, "application/json");
        }

        public ActionResult getStatus(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getStatus", param, false, '|', '~');

            var json_res = "[]";
            if (Tools.verifyDataTable(dt))
            {
                string lines = "";
                string line = "'label': '{0}', 'value': '{1}', 'link': '{2}'".Replace("'", "\"");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    lines += "{" + string.Format(line, r["label"], r["value"], r["link"]) + "},";
                }
                lines = lines.Substring(0, lines.Length - 1);
                json_res = string.Format(@"[{0}]", lines);
            }

            return Content(json_res, "application/json");
        }

        public ActionResult getChangeHelpers(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getChangeHelpers", param, false, '|', '~');
            string line = "'label': '{0}', 'value': '{1}'".Replace("'", "\"");
            var json_res = "[]";
            if (Tools.verifyDataTable(dt))
            {
                string lines = "";

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    lines += "{" + string.Format(line, r["label"], r["value"]) + "},";
                }
                lines = lines.Substring(0, lines.Length - 1);
                json_res = string.Format(@"[{0}]", lines);
            }

            return Content(json_res, "application/json");
        }

        public ActionResult getUpdatePlanStatus(string id)
        {
            string param = "id|int|{0}";
            param = string.Format(param, id);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getUpdatePlanStatus", param, false, '|', '~');
            string line = "'label': '{0}', 'value': '{1}'".Replace("'", "\"");
            var json_res = "[]";
            if (Tools.verifyDataTable(dt))
            {
                string lines = "";

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow r = dt.Rows[i];
                    lines += "{" + string.Format(line, r["label"], r["value"]) + "},";
                }
                lines = lines.Substring(0, lines.Length - 1);
                json_res = string.Format(@"[{0}]", lines);
            }

            return Content(json_res, "application/json");
        }

        public ActionResult removeOTfromPlan(string orderId, string planId, string date)
        {
            string param = "id|int|{0}~planId|int|{1}~date|date|{2}";
            param = string.Format(param, orderId, planId, date);
            DataTable dt = Configs._query.executeProc("PlanningPlug_removeOTfromPlan", param, false, '|', '~');
            string res = "0";
            var json_res = "{'msg' : '{0}'}";
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            json_res = json_res.Replace("'", "\"").Replace("{0}", res);


            return Content(json_res, "application/json");
        }


        public ActionResult insertOTToPlan(string planId, string orderId, string datefrom)
        {
            string param = "planId|int|{0}~orderId|int|{1}~date|string|{2}";
            param = string.Format(param, planId, orderId, datefrom);
            DataTable dt = Configs._query.executeProc("PlanningPlug_insertOTToPlan", param, false, '|', '~');
            string res = "0";
            var json_res = "{'msg' : '{0}'}";
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            json_res = json_res.Replace("'", "\"").Replace("{0}", res);


            return Content(json_res, "application/json");
        }


        public ActionResult removePlan(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_removePlan", param, false, '|', '~');
            string res = "0";
            var json_res = "{'msg' : '{0}'}";
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            json_res = json_res.Replace("'", "\"").Replace("{0}", res);


            return Content(json_res, "application/json");
        }

        public ActionResult updatePlan(string planId, string fields)
        {
            string param = "id|int|{0}~fields|string|{1}";
            param = string.Format(param, planId, fields);
            DataTable dt = Configs._query.executeProc("PlanningPlug_updatePlan", param, false, '|', '~');
            string res = "0";
            var json_res = "{'msg' : '{0}'}";
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            json_res = json_res.Replace("'", "\"").Replace("{0}", res);

            return Content(json_res, "application/json");
        }

        public ActionResult updatePropOrder(string orderId, string value)
        {
            string param = "id|int|{0}~value|int|{1}";
            param = string.Format(param, orderId, value);
            DataTable dt = Configs._query.executeProc("PlanningPlug_updatePropOrder", param, false, '|', '~');
            string res = "0";
            var json_res = "{'msg' : '{0}'}";
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
            }

            json_res = json_res.Replace("'", "\"").Replace("{0}", res);

            return Content(json_res, "application/json");
        }

        public ActionResult updatePlanStatus(string id)
        {
            string param = "id|int|{0}";
            param = string.Format(param, id);
            DataTable dt = Configs._query.executeProc("PlanningPlug_updatePlanStatus", param, false, '|', '~');
            //string res = "0";
            //string link = "";
            //string label = "";
            var json_res = "{'msg' : '{msg}', 'status': '{status}', 'label': '{label}', 'isEdit': '{isEdit}', 'id': {id} }";
            if (Tools.verifyDataTable(dt))
            {
                //res = dt.Rows[0][0].ToString();
                //link = dt.Rows[0][1].ToString();
                //label = dt.Rows[0][2].ToString();

                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    json_res = json_res.Replace("{" + dt.Columns[i].ColumnName + "}", dt.Rows[0][i].ToString());
                }
            }

            json_res = json_res.Replace("'", "\""); //.Replace("{0}", res).Replace("{1}", link).Replace("{2}", label);

            return Content(json_res, "application/json");
        }

        public ActionResult getPlanInf(string id)
        {
            string param = "id|int|{0}";
            param = string.Format(param, id);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getPlanInf", param, false, '|', '~');

            var json_res = @"{'id': {id}, 'weight': {weight}, 'volume': {volume}, 'score': {score}, 'palette': {palette}, 'Status':'{Status}', 'linkStatus': '{linkStatus}', 'labelStatus': '{labelStatus}', 'isEdit': '{isEdit}'}";
            if (Tools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    json_res = json_res.Replace("{" + dt.Columns[i].ColumnName + "}", dt.Rows[0][i].ToString().Replace(',', '.'));
                }
            }

            json_res = json_res.Replace("'", "\"");

            return Content(json_res, "application/json");
        }

        public ActionResult addPlan(string datefrom, string dateto)
        {
            string param = "date|date|{0}~date2|date|{1}";
            param = string.Format(param, datefrom, dateto);
            DataTable dt = Configs._query.executeProc("PlanningPlug_addPlan", param, false, '|', '~');
            string res = "0";
            string id = "0";
            var json_res = "{'msg' : '{0}', 'id': {1}}";
            if (Tools.verifyDataTable(dt))
            {
                res = dt.Rows[0][0].ToString();
                id = dt.Rows[0][1].ToString();
            }

            json_res = json_res.Replace("'", "\"").Replace("{0}", res).Replace("{1}", id);

            return Content(json_res, "application/json");
        }

        public ActionResult getPlanOrders(string planId)
        {
            string param = "id|int|{0}";
            param = string.Format(param, planId);
            DataTable dt = Configs._query.executeProc("PlanningPlug_getPlanOrders", param, false, '|', '~');

            var json_res = "{}";
            if (Tools.verifyDataTable(dt))
            {

                string line = @"{'id':{id}, 'label': '{label}', 'Period': {Period}, 'info':{'city': '{city}', 'zip': '{zip}', 'country': '{country}', 'tel': '{tel}', 'livDate': '{livDate}', 'oWeight': '{oWeight}', 'oVolume': '{oVolume}'},
								'plan':{'id': {planId}, 'date': '{date}', 'from': '{from}', 'to': '{to}', 'step': {step}},
								'fromDate': '', 'toDate': '', 'zoom':{zoom}, 'backColor': '{backColor}'},".Replace("'", "\"");

                string lines = "";
                for (int ri = 0; ri < dt.Rows.Count; ri++)
                {
                    DataRow r = dt.Rows[ri];
                    string tmp = line;
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        tmp = tmp.Replace("{" + dt.Columns[i].ColumnName + "}", r[i].ToString());
                    }
                    lines += tmp;
                }

                lines = lines.Substring(0, lines.Length - 1);
                json_res = "{\"orders\" : [" + lines + "]}";

            }

            //return json_res; // Content(json_res, "application/json");
            return Content(json_res, "application/json");
        }


        public string sendPlanGps(string id)
        {
            string res = "Erreur !";
            DataTable dt = Configs._query.executeProc("PRC_GPS_CurrentJobSender_Plan", "ID|int|" + id, false, '|', '~');

            if (MTools.verifyDataTable(dt))
                res = dt.Rows[0][0].ToString();

            return res;
        }

        public ActionResult getPropOrders(string filter)
        {
            string param = "filter|string|{0}";
            param = string.Format(param, filter);

            if (Session["showaOnlyCurrentAgence"] != null)
                param += "~agenceID|int|" + Session["showaOnlyCurrentAgence"].ToString(); 

            DataTable dt = Configs._query.executeProc("PlanningPlug_getPropOrders", param, false, '|', '~');

            var json_res = "{}";
            if (Tools.verifyDataTable(dt))
            {
                string line = @"{'id':{id}, 'label': '{label}', 'Period': {Period}, 'info':{'city': '{city}', 'zip': '{zip}', 'country': '{country}', 'tel': '{tel}', 'livDate': '{livDate}', 'oWeight': '{oWeight}', 'oVolume': '{oVolume}'},
								'fromDate': '', 'toDate': '', 'zoom':{zoom}, 'backColor': '{backColor}'},".Replace("'", "\"");

                string lines = "";
                for (int ri = 0; ri < dt.Rows.Count; ri++)
                {
                    DataRow r = dt.Rows[ri];
                    string tmp = line;
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        tmp = tmp.Replace("{" + dt.Columns[i].ColumnName + "}", r[i].ToString());
                    }
                    lines += tmp;
                }

                lines = lines.Substring(0, lines.Length - 1);
                json_res = "{\"propOrders\" : [" + lines + "]}";
            }

            //return json_res; // Content(json_res, "application/json");
            return Content(json_res, "application/json");
        }

    }
}
