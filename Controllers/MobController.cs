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
    public class MobController : Controller
    {
        //
        // GET: /Mob/

        public ActionResult GetFromPrint(string OTID)
        {
            ViewData["OTID"] = OTID;
            return View();
        }

        public string GetExternalIP()
        {
            return TRC_GS_COMMUNICATION.Models.Tools.GetIP4Address();
        }

        // [A_COURIGER] DEP AGENCE VALABLE UNIQUEMENT CRISSIER 
        public string printTag(string OTID, string nbr, string name, string recepID, string AgenceID = null)
        {
            int nbrPrint = Convert.ToInt16(nbr);
            int nb = 0;

            if (string.IsNullOrEmpty(AgenceID))
            {
                // DEFAULT_AGENCE_ID
                AgenceID = MTools.getSqlConfig("DEFAULT_AGENCE_ID");
            }

            DataTable dt = Configs._query.executeProc("AgenceGetAgence", "id@int@" + AgenceID, true);
            if (Tools.verifyDataTable(dt))
            {
                name += "_" + dt.Rows[0]["Code"].ToString();
            }
            else
                return "-1";

            string template = "";

            DataTable dataTamplate = Configs._query.executeProc("getTemplate", "name@string@" + name, true);
            if (Tools.verifyDataTable(dataTamplate))
            {
                template         = dataTamplate.Rows[0]["html"].ToString();
                string printName = dataTamplate.Rows[0]["printer"].ToString();
                string proc      = dataTamplate.Rows[0]["proc_dataSource"].ToString();

                DataTable dataOT = Configs._query.executeProc(proc, "OTID@int@" + OTID + "#RecepID@int@" + recepID, true);

                if (Tools.verifyDataTable(dataOT))
                {

                    for (int i = 0; i < nbrPrint; i++ )
                    {
                        string tmp = template;

                        ///string[] tabNOBL = dataOT.Rows[0][0].ToString().Split('-');

                        for(int col = 0 ; col < dataOT.Columns.Count;col++)
                            tmp = tmp.Replace("{" + dataOT.Columns[col].ColumnName + "}", dataOT.Rows[0][dataOT.Columns[col].ColumnName].ToString());

                        try
                        {
                            if (Print.printTicket(tmp, printName) == "Printed")
                                nb++;
                        }
                        catch (Exception exp)
                        {
                            Configs.Debug(exp, "maintenance.Controllers.EmplacementController.printEmplacements", "Echéc d'impression : " + tmp + " Name imp " + printName);
                        }
                     }
                 }
            }

            return (nb == nbrPrint) ? "1" : "-1";
        }

        public string sendMailToClient(string subject, string to_email, string to_name, string mail_adr, string mail_name, string host, string fromPassword, string port)
        {
            try
            {
                string fname = Globale_Varriables.VAR.MailPath + "ArrivageMDM.html";

                if (System.IO.File.Exists(fname) && Tools.isValidMail(to_email) && Tools.isValidMail(mail_adr))
                {
                    string content = System.IO.File.ReadAllText(fname);
                    if (ExportController.sendEmail(content, subject, to_email, to_name, mail_adr, mail_name, host, fromPassword, port))
                        return "1";

                }
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "TRC_GS_COMMUNICATION.Controllers.MOBController.sendMailToClient");
            }

            return "-1";
        }
    }
}
