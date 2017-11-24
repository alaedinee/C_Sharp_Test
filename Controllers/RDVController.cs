using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Omniyat.Models;
using TRC_GS_COMMUNICATION.Models.Objects.RDV;
using System.Data;
using System.IO;
using TRC_GS_COMMUNICATION.Models;
using System.Text.RegularExpressions;

namespace TRC_GS_COMMUNICATION.Controllers
{
    public class RDVController : Controller
    {
        public MajRdv majRdv = new MajRdv();

        public ActionResult IndexRdv()
        {
            ViewData["plantLibre"] = "";
            ViewData["linkNewPlan"] = "";

            ViewData["fromPeriode"] = MTools.getSqlConfig("fromPeriode");
            ViewData["toPeriode"] = MTools.getSqlConfig("toPeriode");

            ViewData["TypeTournees"] = Configs._query.executeProc("PRC_getList", "name@string@tournées");

            return View();
        }

        [HttpPost]
        public ActionResult IndexRdv(RDVModels rdvM)
        {
            return IndexRdvM(rdvM);
        }

        public ActionResult IndexRdvM(RDVModels rdvM)
        {
            ViewData["fromPeriode"] = MTools.getSqlConfig("fromPeriode");
            ViewData["toPeriode"] = MTools.getSqlConfig("toPeriode");
            ViewData["TypeTournees"] = Configs._query.executeProc("PRC_getList", "name@string@tournées");

            if (rdvM.dateRdv == null) rdvM.dateRdv = "";
            if (rdvM.NoBL == null) rdvM.NoBL = "";
            if (rdvM.client == null) rdvM.client = "";
            if (rdvM.plan == null) rdvM.plan = "";

            rdvM.dateRdv = rdvM.dateRdv.Trim();
            rdvM.NoBL = rdvM.NoBL.Trim();
            rdvM.client = rdvM.client.Trim();

            if (rdvM.NoBL != null && rdvM.NoBL != "")
            {
                DataTable dtOTID = Configs._query.executeProc("TRC_RV_GetOTID", "OTNOBL@string@" + rdvM.NoBL);
                if (MTools.verifyDataTable(dtOTID))
                {
                    if (rdvM.dateRdv == null || rdvM.dateRdv.ToString() == "")
                    {
                        try
                        {
                            //generation de la date de livraison la plus proche si cette date n'est pas mensioné 
                            rdvM.dateRdv = Convert.ToDateTime(majRdv.getBestDate(dtOTID.Rows[0][0].ToString().Substring(1))).ToString("yyyy/MM/dd");
                        }
                        catch
                        {
                            rdvM.dateRdv = "";
                        }
                    }
                }
            }

            if (!ModelState.IsValid)
            {
                ViewData["plantLibre"] = "";
                ViewData["linkNewPlan"] = "";
                return View(rdvM);
            }
            //verifier si l'utilisateur a demander d'ajouter un nouveau plan
            if (rdvM.actionPlan != null && rdvM.actionPlan != "")
            {
                majRdv.addNewPlan(rdvM.dateRdv, rdvM.from, rdvM.to, rdvM.rem, rdvM.type, rdvM.pause_from, rdvM.pause_nbrPeriodes);
                rdvM.actionPlan = "";
            }
            //creation de l'action nouveau plan en fonction du nombre de plan possible par jour
            if (rdvM.dateRdv != null && rdvM.dateRdv != "")
            {
                ViewData["linkNewPlan"] = majRdv.active_new_plan(rdvM.dateRdv.ToString());
            }

            //si l'utilasteur  a saisie que la date
            if ((rdvM.NoBL == null || rdvM.NoBL == "") && (rdvM.client == null || rdvM.client == ""))
            {
                ViewData["plantLibre"] = majRdv.generatePlansDate(rdvM.dateRdv.ToString(), rdvM.plan);

            }

            DataTable dtVerifNoBLClient = new DataTable();
            // si l'utilisateur a saisie que client
            if ((rdvM.NoBL == null || rdvM.NoBL == "") && ((rdvM.client != null && rdvM.client != "") && (rdvM.dateRdv == null || rdvM.dateRdv == "")) || ((rdvM.client != null && rdvM.client != "") && (rdvM.dateRdv != null || rdvM.dateRdv != "")))
            {
                dtVerifNoBLClient = majRdv.getListNobl(rdvM.client);


                if (dtVerifNoBLClient != null && dtVerifNoBLClient.Rows.Count >= 1)
                {
                    ViewData["plantLibre"] = majRdv.generateListNobl(dtVerifNoBLClient);
                }
                else
                {
                    ViewData["plantLibre"] = "<h2>Ce client n'existe pas</h2>";
                }
            }

            // si l utilisateur a saisie le nobl ( est n a pas saisie le client)
            if (rdvM.NoBL != null && rdvM.NoBL != "")
            {
                Int64 val = 0;
                string valReturn = majRdv.generatePlanNoBL(rdvM.dateRdv.ToString(), rdvM.NoBL.ToString());
                try
                {
                    val = Convert.ToInt64(valReturn);
                }
                catch
                { }


                if (val != 0)
                {
                    return RedirectToAction("detailPlan", "RDV", new { id = val, date = "existe" });
                }
                else
                {
                    ViewData["plantLibre"] = valReturn;
                }
            }

            return View("IndexRdv", rdvM);
        }

        public ActionResult RedirectToPost(int id, string date)
        {
            RDVModels rdvMC = new RDVModels();

            rdvMC.dateRdv = date.Replace("-", "/");
            rdvMC.NoBL = "";
            rdvMC.client = "";
            return RedirectToAction("IndexRdvM", "RDV", rdvMC);
        }

        public ActionResult InfosPlan(int id, string date)
        {
            planGeneratore plandGen = new planGeneratore();
            DataTable dt = plandGen.getInfoPlanGenerale(id.ToString());
            PlanInfoModel mode = new PlanInfoModel();
            mode.PlanID = id.ToString();
            mode.PlanDate = date.Replace('-', '/');
            if (dt.Rows.Count > 0)
            {
                mode.PoidTotal = String.Format("{0:0.00}", dt.Rows[0]["TotalPoids"]);
                mode.Somme = String.Format("{0:0.00}", dt.Rows[0]["TotalEncaissement"]);
                mode.remarque = dt.Rows[0]["PlanInstruction"].ToString();
                mode.ChauffeurCode = dt.Rows[0]["Chauffeur_ID"].ToString();
                mode.CammionCode = dt.Rows[0]["Camion_ID"].ToString();
                ViewData["requestAide"] = mode.listItemAideRequest(dt.Rows[0]["AIDES"].ToString());
                mode.TextAidesRequest = dt.Rows[0]["AIDES"].ToString();
                mode.Remorque = dt.Rows[0]["Remorque"].ToString();
                mode.type_tournee = dt.Rows[0]["Type_tournees"].ToString();
            }
            else
            {
                mode.PoidTotal = "-";
                mode.Somme = "-";
                mode.remarque = "-";
                mode.ChauffeurCode = "NULL";
                mode.CammionCode = "NULL";
                ViewData["requestAide"] = new List<SelectListItem>();
                mode.TextAidesRequest = "";
                mode.Remorque = "0";
                mode.type_tournee = "NULL";
            }

            int codeCam = 0;
            try
            {
                codeCam = (mode.CammionCode != null) ? Int32.Parse(mode.CammionCode) : 0;
            }
            catch (Exception ex) { }

            if (codeCam != 0)
            {
                DataTable dtRel = Configs._query.executeProc("getRelations", "ID@int@" + codeCam);
                if (dtRel != null)
                {
                    for (int i = 0; i < dtRel.Rows.Count; i++)
                    {
                        string namee = dtRel.Rows[i]["RessourceFamille"].ToString();
                        ViewData[namee] = dtRel.Rows[i]["RessEnfentID"].ToString();
                    }
                }
            }

            ViewData["lstChauffeur"] = Configs._query.executeProc("PRC_getDefFamiliesList", "ID@int@2");
            ViewData["lstRemorque"] = Configs._query.executeProc("PRC_getDefFamiliesList", "ID@int@4");

            return View(mode);
        }

        [HttpPost]
        public ActionResult InfosPlan(PlanInfoModel model)
        {

            if (model.TextAidesRequest == null)
            {
                model.TextAidesRequest = "";
            }
            if(model.remarque != null)
                model.remarque = model.remarque.Replace("'", "''");

            int result = majRdv.updateInfoPlanGeneral(model);
            return RedirectToAction("InfosPlan", "RDV", new { id = model.PlanID, date = model.PlanDate });
        }

        public ActionResult detailPlan(int id, string date)
        {
            string isOpen = "0";
            DataTable dt = Configs._query.executeProc("TRC_infoPlan", "planId@int@" + id);
            if (Tools.verifyDataTable(dt) && dt.Rows[0]["EtatOpen"].ToString() == dt.Rows[0]["Etat"].ToString())
                isOpen = "1";

            ViewData["titre"] = majRdv.generateTitrePlan(id.ToString());

            if (ViewData["titre"].ToString().Length >= 10)
                ViewData["DatePlan"] = ViewData["titre"].ToString().Substring(0, 10).Replace("/", "-");
            else
                ViewData["DatePlan"] = ViewData["titre"].ToString();


            ViewData["titre"] = ViewData["titre"].ToString();
            if (date != null)
            {
                
                if (date == "0")
                {
                    ViewData["erreur"] = "La plage horraire ou vous voulez programmer ce Bulletin est deja pleinne ";

                }
                else if (date == "-1")
                    
                {ViewData["erreur"] = "Etat plan cloturé !";
                }
                else if (date.Contains("delete"))
                {
                    if (date.Replace("delete", "") == "0")
                        ViewData["erreur"] = "Impossible de retirer cet ordre de ce plan";
                    else if (date.Replace("delete", "") == "-1")
                        ViewData["erreur"] = "Etat plan cloturé !";
                    else
                        ViewData["erreur"] = "Programation de l'ordre annulée";
                }
                else if (date.Contains("existe"))
                {
                    ViewData["erreur"] = "Cet ordre est déja programmé dans ce plan :";
                }
            }

            ViewData["id"] = id.ToString();
            ViewData["isOpen"] = isOpen;
            ViewData["periodePlan"] = majRdv.generatePeriodesPlan(id.ToString(), date, isOpen);
            ViewData["InfoRepture"] = Configs._query.executeProc("RDV_InfoRepture", "idPlan@int@" + id);

            return View();
        }

        public ActionResult deletePeriode(int id, string date)
        {
            string val = majRdv.removeFromPeriode(id.ToString(), date);

            return RedirectToAction("detailPlan", "RDV", new { id = id, date = "delete" + val });
        }

        public ActionResult deletePlan(int id, string date)
        {
            string val = majRdv.deletePlan(id.ToString());
            return RedirectToAction("RedirectToPost", "RDV", new { id = id, date = date });
        }

        public ActionResult ListClientRdv(int id, string date)
        {
            string role = Session["role"].ToString();
            string sp_date = date;

            string[] temp = sp_date.Split('_');
            //string[] tempd = temp[0].Split('-');
            //string j = tempd[0]; tempd[0] = tempd[2]; tempd[2] = j;
            sp_date = string.Join("", temp[0].Split('-')) + " " + string.Join(":", temp[1].Split('-'));

            DataTable dt = Configs._query.executeProc("RDV_GetOtToPlanif", "idPlans@int@" + id + "#role@string@" + role + "#DatePlan@string@" + sp_date);
            ViewData["OTData"] = dt;
            ViewData["idPlans"] = id;
            ViewData["idPeriode"] = date;
            return View();
        }

        public ActionResult BeforInsertToPeriode(string OTID, string PeriodeID, string PlanID)
        {
            DataTable dt = Configs._query.executeProc("OTGetOT", "OTID@int@" + OTID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ViewData["pr"] = dt.Rows[0]["OTPeriodesNonAttribuees"];
                ViewData["OTType"] = dt.Rows[0]["OTType"] == DBNull.Value ? null : dt.Rows[0]["OTType"].ToString();
            }
            else
                ViewData["pr"] = "0";

            DataTable dtg = Configs._query.executeProc("OT_RDVListOTInGroupe", "OTID@int@" + OTID);
            ViewData["dataGroupe"] = dtg;
            //
            ViewData["dataJoin"] = Configs._query.executeProc("aJoindreGroupeList", "OTID@int@" + OTID);

            ViewData["OTID"] = OTID;
            ViewData["idPlans"] = PlanID;
            ViewData["idPeriode"] = PeriodeID;

            return View();
        }

        public string InsertToPeriode(string OTID, string pr, string PeriodeID, string PlanID, string typeGroupe = null, string AvecRemplacementOT = "", string causeRetard = "")
        {
            string userID = Session["userID"].ToString();
            string param =  "OTID@int@" + OTID + "#pr@int@" + pr;
            if(!string.IsNullOrEmpty(typeGroupe))
                param += "#typeGroupe@string@" + typeGroupe;

            DataTable dt = Configs._query.executeProc("RDV_OTUpdatePeriodesNeccessaire", param);
            if (MTools.verifyDataTable(dt) && dt.Rows[0][0].ToString() == "1")
            {
                string[] temp = PeriodeID.Split('_');
                //string [] tempd = temp[0].Split('-');
                //string j = tempd[0]; tempd[0] = tempd[2]; tempd[2] = j;
                PeriodeID = string.Join("", temp[0].Split('-')) + " " + string.Join(":", temp[1].Split('-'));
                //
                param = "OTID@int@{0}#PeriodeID@string@{1}#PlanID@int@{2}#AvecRemplacementOT@string@{3}#causeRetard@string@{4}#userID@int@{5}";
                param = string.Format(param, OTID, PeriodeID, PlanID,  AvecRemplacementOT, causeRetard, userID);

                dt = Configs._query.executeProc("TRC_InsertToPeriode", param);
                if (MTools.verifyDataTable(dt))
                    return dt.Rows[0][0].ToString();
            }
            return "0";
        }

        public ActionResult RemoveFromPeriode(int PlanID, int OTID)
        {
            string param = "OTID@int@{0}#PlanID@int@{1}";
            param = string.Format(param, OTID, PlanID);

            DataTable dt = Configs._query.executeProc("TRC_RemoveFromPeriode", param);

            return RedirectToAction("detailPlan", new { id = PlanID });
        }

        public ActionResult optionPrintPlan(Int64 id, string repture = null)
        {
            string tempName = repture == null ? "PrintPlan" : "PrintPlanRepture";
            DataTable dtDirFiles = Configs._query.executeProc("RDV_GetDirFiles", "tempName@string@" + tempName);
            ViewData["id"] = id;
            ViewData["repture"] = repture;
            ViewData["dtDirFiles"] = dtDirFiles;

            return View();
        }

        public ActionResult displayPlanPDF(Int64 id, string ShowHeader, string IdsJoinFiles, string withDetail = "0", string repture = null)
        {
            string pathSave = "";
            string tempName = repture == null ? "PrintPlan" : "PrintPlanRepture";
            string _fileName = id + "_FEUILLE_DE_ROUTE.pdf";
            pathSave = Globale_Varriables.VAR.PATH_STOCKAGE + "PLAN_" + id + @"\";
            HashSet<string> OTIDs = new HashSet<string>();

            var directory = new DirectoryInfo(pathSave);
            if (!Directory.Exists(pathSave))
                try { Directory.CreateDirectory(pathSave); }
                catch (Exception exp) { Configs.Debug(exp, "maintenance.Controllers.RDVController.displayPlanPDF", "Impossible de créer un dossier Upload, chemin : " + pathSave); }


            pathSave = pathSave + _fileName;

            /********************************************* code generate pdf *********************************************/
            try
            {
                Templates temp = new Templates();
                DataRow rTemplate = temp.getTemplate(tempName);

                string contents = "";
                string articles = "";
                string proc = "";
                string user = "user";
                if (rTemplate != null)
                {
                    contents = rTemplate["html"].ToString();
                    articles = rTemplate["articles"].ToString();
                    proc = rTemplate["proc_datasource"].ToString();
                }

                if (proc != "no")
                {

                    DataTable dt = Configs._query.executeProc(proc, "OTID@int@" + id);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        contents = temp.getGeneratedTemp(dt, contents, user);
                        if (articles.Length > 4)
                        {
                            var match = Regex.Match(contents, @"{FOR ([A-Z][a-z]+)}");
                            var match1 = Regex.Match(contents, @"{/FOR ([A-Z][a-z]+)}");
                            if (match.Success && match1.Success)
                            {
                                if(repture == null)
                                    dt = Configs._query.executeSql(string.Format(articles ,id));
                                else
                                    dt = Configs._query.executeSql(string.Format(articles ,id ,repture));

                                if (dt != null && dt.Rows.Count > 0)
                                {
                                    int bIndex = match.Index;
                                    string _obj = match.Value;
                                    _obj = _obj.Substring(_obj.IndexOf(" ") + 1);
                                    _obj = _obj.Substring(0, _obj.Length - 1);
                                    int blmatch = match.Value.Length;

                                    int eIndex = match1.Index;
                                    int elmatch = match1.Value.Length;

                                    int lStr = eIndex - (bIndex + blmatch);
                                    string fStr = contents.Substring(bIndex + blmatch, lStr);

                                    string lines = "";
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        string line = fStr;
                                        lines += temp.getGeneratedRowTemp(dt.Rows[i], line, user, i, _obj + ".");
                                        string TagOT = dt.Rows[i]["OTID"].ToString() + ","
                                            + (dt.Rows[i]["OTType"] != null ? dt.Rows[i]["OTType"].ToString() : "");
                                        if (!OTIDs.Contains(TagOT))
                                            OTIDs.Add(TagOT);
                                    }

                                    contents = contents.Substring(0, bIndex) +
                                            lines +
                                            contents.Substring(eIndex + elmatch);

                                    contents = contents.Replace("{TAB_Start}", "").Replace("{/TAB_Start}", "");
                                }
                                else
                                {
                                    match = Regex.Match(contents, @"{TAB_Start}");
                                    match1 = Regex.Match(contents, @"{/TAB_Start}");

                                    if (match.Index > 0 && match1.Index > match.Index)
                                    {
                                        contents = contents.Substring(0, match.Index - 1) + contents.Substring(match1.Index + "{/TAB_Start}".Length);
                                    }
                                }
                            }
                        }

                        //temp.GeneratedPDF(pathSave, contents);
                        //return Redirect("http://www.google.com");
                    }
                }
                contents = contents.Replace("{url_server}", Globale_Varriables.VAR.get_URL_HREF());
                temp.GeneratedPDF(pathSave, contents, true);
                /************************************************ PDF MERGER ***************************************************/
                /**/
                List<byte[]> listePdfToMerge = PDFMerger.getFileToMerge(OTIDs, tempName, IdsJoinFiles, (withDetail == "1"));
                if(ShowHeader == "1")
                    listePdfToMerge.Insert(0, System.IO.File.ReadAllBytes(pathSave));
                Random random = new Random();
                int num = random.Next(1000);
                // Session["userID"].ToString()
                System.IO.File.WriteAllBytes(pathSave, PDFMerger.MergeFiles(listePdfToMerge));
                
                /************************************************ PDF MERGER ***************************************************/
                string urlRedirection = Globale_Varriables.VAR.urlFileUpload + "/PLAN_" + id + "/" + _fileName;
                return Redirect(urlRedirection);
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "maintenance.Controllers.RDVController.ajChargerFichier", "Message : " + ex.Message);
            }

            /********************************************* code generate pdf *********************************************/
            return RedirectToAction("Index", "Error", null);
        }

        public ActionResult RdvExport(string date)
        {
            date = date.Replace("/", "");
            string _fileName = "PLANS_" + date + ".csv";
            string pathSave = "";
            pathSave = Globale_Varriables.VAR.PATH_STOCKAGE + @"\" + _fileName;

            string role = Session["role"].ToString();
            DataTable OTData = Configs._query.executeProc("RDV_GetRdvToExport", "date@string@" + date);
            DataSetHelper.CreateWorkbookCSV(pathSave, OTData);

            string urlRedirection = Globale_Varriables.VAR.urlFileUpload + "/" + _fileName;
            return Redirect(urlRedirection);
        }
        public ActionResult RdvExportPalnning(string date)
        {
            date = date.Replace("/", "");
            string _fileName = "PLANNING_" + date + ".csv";
            string pathSave = "";
            pathSave = Globale_Varriables.VAR.PATH_STOCKAGE + @"\" + _fileName;

            string role = Session["role"].ToString();
            DataTable OTData = Configs._query.executeProc("RDV_ExportPlanning", "date@string@" + date);
            DataSetHelper.CreateWorkbookCSV(pathSave, OTData);

            string urlRedirection = Globale_Varriables.VAR.urlFileUpload + "/" + _fileName;
            return Redirect(urlRedirection);
        }

        public string FinPannification(int id)
        {
            DataTable dt = Configs._query.executeProc("RDV_FinPannification", "id@int@" + id);
            if(Tools.verifyDataTable(dt))
                return dt.Rows[0][0].ToString();
            return "0";
        }

        //Repture
        public string addRepture(string idPlan, string periode)
        {
            DataTable dt = Configs._query.executeProc("RDV_addRepture", "idPlan@int@" + idPlan + "#periode@string@" + periode);
            if (MTools.verifyDataTable(dt))
                return dt.Rows[0][0].ToString();
            return "0";
        }
        public string deleteRepture(string idPlan, string ReptureNum)
        {
            DataTable dt = Configs._query.executeProc("RDV_deleteRepture", "idPlan@int@" + idPlan  + "#ReptureNum@int@" + ReptureNum);
            if (MTools.verifyDataTable(dt))
                return dt.Rows[0][0].ToString();
            return "0";
        }
    }

}
