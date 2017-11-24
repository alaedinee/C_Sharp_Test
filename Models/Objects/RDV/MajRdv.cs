using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Omniyat.Models;
using System.IO;

namespace TRC_GS_COMMUNICATION.Models.Objects.RDV
{
    public class MajRdv : System.Web.UI.Page
    {

        public string active_new_plan(string date)
        {
            string returnValue = "";
            DataTable dtPeriodeExist = Configs._query.executeProc("TRC_get_plan_par_date_nbr", "date@date@" + date);
            DataTable dtNbrCamion = Configs._query.executeProc("TRC_nombreCamionJour", "date@date@" + date);
            if (MTools.verifyDataTable(dtNbrCamion))
            {
                string dateTimeNow = DateTime.Now.ToString("dd/MM/yyyy");
                if (Convert.ToInt32(dtNbrCamion.Rows[0][0].ToString()) >= dtPeriodeExist.Rows.Count && Convert.ToDateTime(date) >= Convert.ToDateTime(dateTimeNow))
                {
                    returnValue = "<a href=\"newPlan/" + date.Replace("/", "-").Replace(".", "-") + "\">Nouveau Plan</a>";
                }
                else
                {
                    returnValue = "";
                }
            }
            return returnValue;
        }


        public string generatePlansDate(string date, string np)
        {
            string htmlReturn = "";

            DataTable dt = Configs._query.executeProc("TRC_get_plan_par_date_libre", "date@string@" + date.Replace("/", "") + "#np@string@" + np);
            // string nbrCamionJour = this.getValueFromConfig("NombreCamionJour");
            DataTable dtNbrCamion = Configs._query.executeProc("TRC_nombreCamionJour", "date@string@" + date.Replace("/", ""));

            if (dtNbrCamion != null && dtNbrCamion.Rows.Count > 0)
            {
                //if (nbrCamionJour != "")
                //{
                htmlReturn = htmlReturn + ((date == "") ? "" : "<h4>Nombre Plan : " + dt.Rows.Count + "/" + dtNbrCamion.Rows[0][0].ToString() + "</h4>");
                //}
            }
            htmlReturn = htmlReturn + "<table id=\"tableList\"><th>#</th><th>N° du Plan</th>" + ((date == "") ? "<th>Date Liv</th>" : "") + "<th>Camion</th><th>Remarque</th><th>Périodes libres</th><th>Poids</th><th>Etat</th><th></th><th></th><th></th><th></th><tbody>";

            if (MTools.verifyDataTable(dt))
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    string dd = (date == "") ? dt.Rows[i]["PlanDate"].ToString() : date;
                    string chauff = "";
                    DataTable dt_chf = Configs._query.executeProc("TRC_GETPLAN_BILAN", "PLANID@int@" + dt.Rows[i]["PlanID"].ToString());


                    //if (dt_chf != null && dt_chf.Rows.Count > 0)
                    //{
                    //    chauff = dt_chf.Rows[0]["CODECHAUFFEUR"].ToString() + ((dt_chf.Rows[0]["AIDES"].ToString().Length < 1) ? "" : " (<small>" + dt_chf.Rows[0]["AIDES"].ToString().Replace("@", " + ") + "</small>)");
                    //}

                    Int64 camion = 0;
                    try
                    {
                        camion = Int64.Parse(dt.Rows[i]["FournisseurID"].ToString());
                    }
                    catch (Exception ex) { }

                    string stylBold = ((camion > 0) ? " style='font-weight:bold; font-size:14px'" : "");

                    //string[] dist = DistanceModel.getPlandistance(dt.Rows[i]["PlanID"].ToString()).Split('|');

                    string type_tour = dt.Rows[i]["Type_tournees"].ToString();
                    type_tour = (type_tour.IndexOf(":") > 0) ? (type_tour.Split(':')[0]) + dt.Rows[i]["Position"].ToString() : "";
                    string background = "";

                    double ppoids =7;
                    try
                    {
                        ppoids = Double.Parse(dt.Rows[i]["PPoids"].ToString());
                        ppoids = Math.Round(ppoids, 2);
                    }
                    catch { }

                    if (dt.Rows[i]["ot_annule"].ToString() != "0")
                        background = "background:#fabe60;color:#fff";

                    htmlReturn = htmlReturn + "<tr index='" + dt.Rows[i]["PlanID"].ToString() + "' style='" + background + "'>" +
                        "<td><h3>" + type_tour + "</h3></td>" +
                        "<td>" + dt.Rows[i]["PlanID"].ToString() + "</td>"
                        + ((date == "") ? "<td " + stylBold + ">" + Convert.ToDateTime(dd).ToString("yyyy/MM/dd") + "</td>" : "")
                        + "<td " + stylBold + ">" + dt.Rows[i]["RessourceCode"].ToString() + "</td>"
                        // + "<td " + stylBold + ">" + chauff + "</td>"
                        + "<td " + stylBold + ">" + dt.Rows[i]["AccessPlan"].ToString() + "</td>"
                        + "<td " + stylBold + ">" + dt.Rows[i]["NbrPeriodeLibre"].ToString() + "</td>"
                        // + "<td>&nbsp;</td><td>&nbsp;</td>"
                        + "<td " + ((ppoids > 3000) ? "style='background:red'" : "") + ">" + ppoids + "</td>"
                        + "<td " + stylBold + ">" + dt.Rows[i]["Description"].ToString() + "</td>"

                        //+ "<td><a sendGps='" + dt.Rows[i]["PlanID"].ToString() + "' style='cursor:pointer;color:blue' >Envoyer</a></td>"

                        // + "<td><a cOpen='" + dt.Rows[i]["PlanID"].ToString() + "' cOpenType='" + dt.Rows[i]["CodeEtat"].ToString() + "' style='cursor:pointer;color:blue'><img src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/" + dt.Rows[i]["CodeEtat"].ToString() + ".png' /></a></td>"

                        // + "<td><a evaluer='" + dt.Rows[i]["PlanID"].ToString() + "' style='cursor:pointer;color:blue' >Evaluer</a></td>"

                        // + "<td><a gps='" + dt.Rows[i]["PlanID"].ToString() + "' style='cursor:pointer;color:blue' >Voir</a></td>"
                        + "<td><a href='detailPlan/" + dt.Rows[i]["PlanID"].ToString() + "/" + Convert.ToDateTime(dd).ToString("yyyy/MM/dd").Replace("/", "-").Replace(".", "-") + "'>Entrer</a></td>"

                        // + "<td><a  target=\"_blank\" href='displayPlanPDF/" + dt.Rows[i]["PlanID"].ToString() + "'>PDF</a> </td>"
                        + "<td><a style='margin-left:10px;' href='#' data-target='" + dt.Rows[i]["PlanID"].ToString() + "' class='print-plan-pdf'>PDF</a></td>"
                        + "<td><a  href='InfosPlan/" + dt.Rows[i]["PlanID"].ToString() + "/" + Convert.ToDateTime(dd).ToString("yyyy/MM/dd").Replace("/", "-").Replace(".", "-") + "'>Infos Plan</a></td>"
                        + "<td><a  type='delPlan' href='deletePlan/" + dt.Rows[i]["PlanID"].ToString() + "/" + Convert.ToDateTime(dd).ToString("yyyy/MM/dd").Replace("/", "-").Replace(".", "-") + "'>Supprimer</a></td></tr>";
                }
            }
            // htmlReturn = htmlReturn +"<tr><td>"+ this.active_new_plan(Convert.ToDateTime(date).ToString("yyyy/MM/dd")) +"</td><td></td><td></td></tr>";


            htmlReturn = htmlReturn + "</tbody></table>";
            return htmlReturn;
        }

        public DataTable getListNobl(string client)
        {
            MajOT majO = new MajOT();

            DataTable dt = majO.selectListeOt(" where (OT.OTDestinNom like '%" + client.Replace("'", "''") + "%' "
                + " Or OT.OTDestPrenom like '%" + client.Replace("'", "''") + "%'"
                + " Or OT.OTDestNP like '%" + client.Replace("'", "''") + "%')"
                + " and OTPeriodesNonAttribuees>0 ");
            return dt;
        }


        public string generateListNobl(DataTable dt)
        {

            string htmlRturn = "<div><table id =\"tableList\"><thead><tr><th></th> <th>Magasin</th><th>N°Bulettin</th> <th>Client</th><th>Téléphone</th><th>NP</th><th>Dernière comm</th><th>Date Récéption</th><th>Action</th><th></th><th>Remarques</th></tr></thead><tbody>";


            for (int i = 0; i < dt.Rows.Count; i++)
            {


                string vise = "";
                string dateComme = "-";

                string dateLiv = "-";
                try
                {
                    dateLiv = Convert.ToDateTime(dt.Rows[i]["DateReception"].ToString()).ToString("dd/MM/yyyy");
                }
                catch { dateLiv = "-"; }
                try
                {
                    dateComme = Convert.ToDateTime(dt.Rows[i]["DerniereDateCommunication"].ToString()).ToString("dd/MM/yyyy hh:mm");
                }
                catch { dateComme = "-"; }
                if (dt.Rows[i]["OTSuiteEtat"].ToString() == "10")
                {
                    vise = "<img  class='immage-fix' src='../Images/TRC_client_avise32.png' />";
                }
                else
                {
                    vise = "";
                }

                string remarques = dt.Rows[i]["Remarques"].ToString();
                string[] tRem;

                if (remarques.Contains('$'))
                {
                    tRem = remarques.Split('$');
                    remarques = tRem[tRem.Length - 2];
                    if (remarques.Length > 60) remarques = remarques.Substring(0, 57) + "...";
                }
                else
                {
                    remarques = "Ajouter";
                }



                htmlRturn = htmlRturn + "<tr>"
                   + "<td>" + vise + "</td>"
               + "<td>" + dt.Rows[i]["Magasin"].ToString() + "</td>"
               + "<td>" + dt.Rows[i]["NBulletin"].ToString() + "</td>"
               + "<td>" + dt.Rows[i]["Client"].ToString() + "</td>"
               + "<td>" + dt.Rows[i]["Telephone"].ToString() + "</td>"
               + "<td>" + dt.Rows[i]["OTDESTNP"].ToString() + "</td>"
               + "<td>" + dateComme + "</td>"
               + "<td>" + dateLiv + "</td>"
               + "<td ><a class='lienHyper' otid='" + dt.Rows[i]["OTID"].ToString() + "' id=\"lnkNewCom\" >Ajouter communication</a></td>"
               + "<td><a  class='lienHyper' onclick=\"chargerSelect('" + dt.Rows[i]["NBulletin"].ToString() + "');\"  id =\"selectNobl" + (i + 1) + "\" >Selectionner</a>"
                    //<%: Html.ActionLink("Voir les détail", "detailOrdreTransport", new { id = dt.Rows[i]["OTID"].ToString() })%> 
               + "<td ><a class='lienHyper' otid='" + dt.Rows[i]["OTID"].ToString() + "' id=\"lnkNewRemarques\" >" + remarques + "</a></td>"
               + "</tr>";


            }

            htmlRturn = htmlRturn + "</tbody></table></div>";
            return htmlRturn;
        }

        public string generatePlanNoBL(string date, string NoBl)
        {

            string htmlReturn = "";
            string otid = "";
            DataTable dtOTID = Configs._query.executeProc("TRC_RV_GetOTID", "OTNOBL@string@" + NoBl);
            if (dtOTID.Rows.Count > 0)
            {
                if (dtOTID.Rows[0][0].ToString().Contains('O'))
                {
                    otid = dtOTID.Rows[0][0].ToString().Substring(1);
                }
                else if (dtOTID.Rows[0][0].ToString() == "0")
                {
                    return "<center><h2>Ce Numéro de bulletin n'existe pas</h2></center>";
                }
                else
                {
                    if (dtOTID.Rows[0][0].ToString().Length == 1)
                        return "<center><h2>Cet ordre est annulé</h2></center>";
                    else
                        return dtOTID.Rows[0][0].ToString().Substring(1);

                }
            }
            DataTable dt = Configs._query.executeProc("TRC_getFreePeriodes", "datePlan@date@" + date + "#NOBL@string@" + NoBl);
            HashSet<string> hs = this.getPlanIdFromDT(dt, "PlanID");
            string htmlPlan = "";
            for (int i = 0; i < hs.Count; i++)
            {
                string htmlPlanTable = "";
                string planID = "Plan N° : " + hs.ElementAt(i);
                htmlPlanTable = "<br><table id=\"tableList\">"
                    + "<tr><a class='href_link' href='" + Globale_Varriables.VAR.get_URL_HREF() + "/RDV/detailPlan/" + hs.ElementAt(i) + "/" + date.Replace("/", "-").Replace(".", "-") + "'>" + planID + "</a></tr>"
                    + "<tr><th>Heure</th><th>Action</th><tbody></tr>";
                for (int j = 0; j < dt.Rows.Count; j++)
                {

                    if (hs.ElementAt(i) == dt.Rows[j]["PlanID"].ToString())
                    {
                        htmlPlanTable = htmlPlanTable
                            + "<tr>"
                            + "<td>" + Convert.ToDateTime(dt.Rows[j]["PeriodeID"].ToString()).ToString("HH:mm") + "</td>"
                            + "<td><a href=\"addRdv/" + dt.Rows[j]["PlanID"].ToString() + "/" + Convert.ToDateTime(dt.Rows[j]["PeriodeID"].ToString()).ToString("dd-MM-yyyy_HH-mm-ss") + "$" + otid + "\">Prendre ce Rendez-vous</a></td>"
                            + "</tr>";
                    }
                }
                htmlPlanTable = htmlPlanTable + "</tbody></table>";
                htmlPlan = htmlPlan + htmlPlanTable;
            }

            htmlReturn = htmlReturn + htmlPlan;


            return htmlReturn;
        }

        private HashSet<string> getPlanIdFromDT(DataTable dt, string p)
        {
            HashSet<string> lst = new HashSet<string>();

            try
            {
                foreach(DataRow r in dt.Rows)
                    lst.Add(r[p].ToString());
            }
            catch (Exception)
            {
                
                throw;
            }

            return lst;
        }

        public string getBestDate(string otid)
        {
            if (otid == "") otid = "0";
            string returnValue = "";
            DataTable dt = Configs._query.executeProc("TRC_getBestDate", "otid@int@" + otid);
            if (dt.Rows.Count > 0)
            {
                returnValue = dt.Rows[0][0].ToString();
            }
            return returnValue;
        }

        public void addNewPlan(string date, string from = "7:30:00", string to = "16:30:00", string rem = "PLANIFICATION RENDEZ VOUS", string type = "", string pause_from = "12", string pause_nbrPeriodes = "2")
        {
            //date = date.Replace("-", "/").Replace(".", "/");
            //string[] splitDate = date.Split('/');

            //for (int i = 0; i < 2; i++){
            //    if (splitDate[i].Length < 2) { 

            //    }
            //}
            int _pause;

            string par = "datePlan@string@" + date.Replace("-", "").Replace("/", "").Replace(".", "") +
                "#rem@string@" + rem +
                "#from@string@" + from +
                "#to@string@" + to +
                "#type@string@" + type +
                "#pause@string@" + pause_from;
            if (Int32.TryParse(pause_nbrPeriodes, out _pause))
                par += "#pauseNbr@int@" + pause_nbrPeriodes;

            DataTable dt = Configs._query.executeProc("TRC_Add_New_Plan", par);

            // Configs.Debug("TRC_Add_New_Plan ( " + par + " ) " + Tools.verifyDataTable(dt).ToString());
        }

        public string generateTitrePlan(string planID)
        {
            string returnValue = "";
            string dateValue = "";
            DataTable dt = Configs._query.executeProc("TRC_infoPlan", "planId@int@" + planID);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    double ppoids = 0;
                    try
                    {
                        ppoids = Double.Parse(dt.Rows[0]["PPoids"].ToString());
                        ppoids = Math.Round(ppoids, 2);
                    }
                    catch (Exception exp) { }

                    string type_tour = dt.Rows[0]["Type_tournees"].ToString();
                    type_tour = (type_tour.IndexOf(":") > 0) ? (type_tour.Split(':')[0]) + dt.Rows[0]["Position"].ToString() : "";

                    returnValue = "<table style='float:left'><tr><td><b>- N°Plan  </b> </td><td>: " + dt.Rows[0]["PlanID"].ToString() + "</td>"
                                 + "<td><b>- Camion : </b>  </b></td><td>: " + dt.Rows[0]["CodeCamion"].ToString() + "</td></tr>"

                                 //+ "<tr><td><b>- Access </b></td><td>: " + dt.Rows[0]["AccessPlan"].ToString() + "</td>"
                                 //+ "<td><b>- Chauffeur  </b></td><td>: " + dt.Rows[0]["CodeChauffeur"].ToString() + "</td>"
                                 
                                 +"</tr>"

                                 + "<tr valign='top'><td><b>- Date  </b></td><td>: " + dt.Rows[0]["PlanDate"].ToString().Substring(0, 10) + "</td>"
                                 //+ "<td><b>- Aides  </b> </td><td>: " + dt.Rows[0]["AIDES"].ToString().Replace("@", "/") + "</td>"
                                + "</tr></table>"
                                 + "<table style='float:left;margin-left:160px'><tr>"
                                 + "<td> <h2 >" + type_tour + "</h2> </td> <td><h2 style='margin-left:20px;" + ((ppoids > 3000) ? "background:red;color:#fff" : "") + "'>Poids : " + ppoids + "</h2></td>"
                                 + "</tr></table><br clear='both' />"
                                 ;


                    // returnValue = "N° Plan [" + dt.Rows[0]["PlanID"].ToString() + "] / Date [" + Convert.ToDateTime(dt.Rows[0]["PlanDate"].ToString()).ToString("dd/MM/yyyy") + "] "
                    //   + "";
                }

                try
                {
                    dateValue = ((DateTime)dt.Rows[0]["PlanDate"]).ToString("yyyy/MM/dd").Substring(0, 10);
                }
                catch (Exception e)
                {
                    dateValue = "-";
                }
            }

            return dateValue + "<br clear='both' />" + returnValue;
        }


        public string generatePeriodesPlan(string planID, string date, string isOpen = "1")
        {
            string htmlReturn = "";

            DataTable dt = Configs._query.executeProc("TRC_getPlan", "where@string@" + " where PlanID=" + planID);

            string htmlLien = Globale_Varriables.VAR.get_URL_HREF();

            if (date == null || date.Contains("delete") || date == "existe" || date == "0" || date == "1")
            {
                htmlLien = "../../";
            }
            else
            {
                htmlLien = "../../../";
            }

            htmlLien = Globale_Varriables.VAR.get_URL_HREF();

            htmlReturn = "<table id=\"tableList\"><th>Heure</th><th>N° Bulletin</th><th>Client</th><th>Chargement</th><th>Livraison</th><th>Somme Obligatoire</th><th></th><th></th><th></th><tbody>";
            string periode = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string au = dt.Rows[i]["toHour"].ToString();

                au = (!DBNull.Value.Equals(au) && au.Length > 1) ? "Lim. " + au : "";

                DateTime dtc = (DateTime)dt.Rows[i]["PeriodeID"];
                string periodDate = dtc.ToString("yyyy-MM-dd HH:mm:ss"); 
                string tr_style = "";
                if (dt.Rows[i]["HasChanged"].ToString() == "1")
                    tr_style = "background:#fabe60;color:#fff";
                else if (dt.Rows[i]["OTType"] != DBNull.Value)
                    tr_style = "background:#FFFF00;color:#000";

                periode = "";
                if (isOpen == "1" && (dt.Rows[i]["PeriodeOTID"] == null || dt.Rows[i]["PeriodeOTID"].ToString() == null || dt.Rows[i]["PeriodeOTID"].ToString() == "" || dt.Rows[i]["PeriodeOTID"].ToString() == "0"))
                {
                    periode = "<a PlanID='" + dt.Rows[i]["PlanID"].ToString() + "' Periode='" + ((DateTime)dt.Rows[i]["PeriodeID"]).ToString("yyyy/MM/dd HH:mm") + "' href='" + htmlLien + "/RDV/ListClientRdv/" + dt.Rows[i]["PlanID"].ToString() + "/" + ((DateTime)dt.Rows[i]["PeriodeID"]).ToString("yyyy/MM/dd HH:mm").Replace("/", "-").Replace(":", "-").Replace(" ", "_").Replace(".", "-") + "'>" + Convert.ToDateTime(dt.Rows[i]["PeriodeID"].ToString()).ToString("HH:mm") + "</a>";
                }
                else if (dt.Rows[i]["PeriodeOTID"].ToString() == "-1")
                {
                    periode = "<h4 class='erreur-small'>" + Convert.ToDateTime(dt.Rows[i]["PeriodeID"].ToString()).ToString("HH:mm") + "(Pause)</h4>";
                }
                else
                {
                    periode = Convert.ToDateTime(dt.Rows[i]["PeriodeID"].ToString()).ToString("HH:mm");
                }

                htmlReturn = htmlReturn + "<tr PlanID='" + dt.Rows[i]["PlanID"].ToString() + "' Periode='" + periodDate + "' index='" + dt.Rows[i]["PeriodeOTID"].ToString() + "' style='" + tr_style + "'>"
                      + "<td>" + periode + "</td>"
                      + "<td><a href='" + Globale_Varriables.VAR.get_URL_HREF() + "/OT/afficherOT?mode=modifier&OTID=" + dt.Rows[i]["PeriodeOTID"].ToString() + "'>" + dt.Rows[i]["OTNoBL"].ToString() + "</a><br />" + au + "</td>"
                      + "<td>" + dt.Rows[i]["client"].ToString() + "</td>"
                      + "<td>" + dt.Rows[i]["np_chargement"].ToString() + " " + dt.Rows[i]["ville_chargement"].ToString() + "</td>"
                      + "<td>" + dt.Rows[i]["OTDESTNP"].ToString() + " " + dt.Rows[i]["OTDestVille"].ToString() + "</td>"
                      + "<td>" + dt.Rows[i]["OTMontObligatoire"].ToString() + "</td>";


                if (isOpen != "1" || dt.Rows[i]["PeriodeOTID"].ToString() == "0" || dt.Rows[i]["PeriodeOTID"].ToString() == "-1")
                    htmlReturn = htmlReturn + "<td></td>";
                else
                {
                    htmlReturn = htmlReturn + "<td><a type='delPeriode' href=\"" + htmlLien + "/RDV/RemoveFromPeriode/?PlanID=" + dt.Rows[i]["PlanID"].ToString() + "&OTID=" + dt.Rows[i]["PeriodeOTID"].ToString() + "\">Annuler</a></td>";
                }

                htmlReturn = htmlReturn + "<td></td>";
                htmlReturn = htmlReturn + "<td repture='" + dt.Rows[i]["Repture"].ToString() + "'></td>";
            }

            htmlReturn = htmlReturn + "</tbody></table>";

            return htmlReturn;
        }

        public int updateInfoPlanGeneral(PlanInfoModel model)
        {
            string req = "exec TRC_UpdatePlanRessource  @PlanID =" + model.PlanID;
            if (!string.IsNullOrWhiteSpace(model.remarque))
                req += ", @PlanInstruction  ='" + model.remarque + "'";
            if (!string.IsNullOrWhiteSpace(model.ChauffeurCode))
                req += ", @PlanChauffeurID =" + model.ChauffeurCode;
            if (!string.IsNullOrWhiteSpace(model.CammionCode))
                req += ", @PlanCamionID =" + model.CammionCode;
            if (!string.IsNullOrWhiteSpace(model.TextAidesRequest))
                req += ",@AIDES='" + model.TextAidesRequest + "'";
            if (!string.IsNullOrWhiteSpace(model.type_tournee))
                req += ", @Type_tournees ='" + model.type_tournee + "'";
            if (!string.IsNullOrWhiteSpace(model.Remorque))
                req += ((model.Remorque == "") ? ",@Remorque=" + model.Remorque + "" : "");
            return Configs._query.updateSql(req);
        }

        public string getToDoList(string interval, string client, string prestation)
        {
            //maj = new MAJ.MAJ();

            List<string> directory = new List<string>();
            if (File.Exists(Globale_Varriables.VAR.urlFileUpload + @"\File\"))
                directory = Directory.GetDirectories(Globale_Varriables.VAR.urlFileUpload + @"\File\").ToList<string>();

            DataTable dt = Configs._query.executeProc("TRC_get_ToDoList", "TypeInterval@int@" + interval + "#magasin@string@" + client + "#prestation@string@" + prestation);
            string htmlRturn = "";
            if (dt != null)
            {
                htmlRturn = "<div><table id =\"tableList\"><thead><tr><th></th><th>Magasin</th><th>N°Bulettin</th> <th>Client</th><th>Téléphone</th><th>NP</th><th>Dernéire Comm</th><th>Date Récéption</th><th>LeadTIME</th><th>Related</th><th></th><th></th><th>Remarques</th><th></th></tr></thead><tbody>";
                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    string joinDOC = "";
                    string vise = "";


                    if (directory.Contains(Globale_Varriables.VAR.urlFileUpload + @"\File\" + dt.Rows[i]["OTID"].ToString()))
                    {
                        if (Directory.GetFiles(Globale_Varriables.VAR.urlFileUpload + @"\File\" + dt.Rows[i]["OTID"].ToString()).Length > 0)
                        {
                            joinDOC = "<img src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/Document_Attach_16.png'>";
                        }
                    }

                    string joinOTID = "";
                    string dateLiv = "-";
                    try
                    {
                        dateLiv = Convert.ToDateTime(dt.Rows[i]["DateReception"].ToString()).ToString("yyyy/MM/dd");
                    }
                    catch { dateLiv = "-"; }

                    try
                    {
                        joinOTID = Convert.ToString(dt.Rows[i]["joinOTID"].ToString());
                        if (joinOTID != "")
                        {
                            joinOTID = "<img src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/Attachment_16.png'>";
                        }
                    }
                    catch { joinOTID = ""; }


                    if (dt.Rows[i]["OTSuiteEtat"].ToString() == "10")
                    {
                        vise = "<img  class='immage-fix' src='../Images/TRC_client_avise32.png' />";
                    }
                    else
                    {
                        vise = "";
                    }

                    string remarques = dt.Rows[i]["Remarques"].ToString();

                    string[] tRem;

                    if (remarques.Contains('$'))
                    {
                        tRem = remarques.Split('$');
                        remarques = tRem[tRem.Length - 2];
                        if (remarques.Length > 60) remarques = remarques.Substring(0, 57) + "...";
                    }
                    else
                    {
                        remarques = "Ajouter";
                    }



                    htmlRturn = htmlRturn + "<tr>"
                   + "<td>" + vise + "</td>"
                   + "<td>" + dt.Rows[i]["Magasin"].ToString() + "</td>"
                   + "<td><a href='" + Globale_Varriables.VAR.get_URL_HREF() + "/Ajout/AfficherOT/" + dt.Rows[i]["OTID"].ToString() + "'>" + dt.Rows[i]["NBulletin"].ToString() + "</a></td>"
                   + "<td>" + dt.Rows[i]["Client"].ToString() + "</td>"
                   + "<td>" + dt.Rows[i]["Telephone"].ToString() + "</td>"
                   + "<td>" + dt.Rows[i]["OTDESTNP"].ToString() + "</td>"
                   + "<td>" + dt.Rows[i]["DerniereDateCommunication"].ToString() + "</td>"
                   + "<td>" + dateLiv + "</td>"
                   + "<td>" + dt.Rows[i]["leadTimeActuel"].ToString() + "</td>"
                   + "<td>" + dt.Rows[i]["NoBL_REF2"].ToString() + "</td>"
                   + "<td ><a class='lienHyper' otid='" + dt.Rows[i]["OTID"].ToString() + "' id=\"lnkNewCom\" >Ajouter communication</a></td>"
                  + "<td><a href=\"../RDV/IndexRdvGet/" + dt.Rows[i]["OTID"].ToString() + "/" + dt.Rows[i]["OTDateLivraison"].ToString().Replace("/", "-").Replace(".", "-").Replace(" ", "_").Replace(":", "-") + "\">Rendez-vous</a></td>"
                   + "<td ><a class='lienHyper' otid='" + dt.Rows[i]["OTID"].ToString() + "' id=\"lnkNewRemarque\" >" + remarques + "</a></td>"
                   + "<td >"
                            + "<a class='lienHyper' otid='" + dt.Rows[i]["OTID"].ToString() + "' id=\"lnkJoinOT\" >" + joinOTID + "</a>"
                            + "<a class='lienHyper' otid='" + dt.Rows[i]["OTID"].ToString() + "' id=\"lnkJoinDOC\" >" + joinDOC + "</a>"
                   + "</td>"
                        //<%: Html.ActionLink("Voir les détail", "detailOrdreTransport", new { id = dt.Rows[i]["OTID"].ToString() })%> 
                   + "</td></tr>";


                }
            }
            htmlRturn = htmlRturn + "</tbody></table></div>";
            return htmlRturn;
        }

        public string removeFromPeriode(string planID, string OTID)
        {

            string returnValue = "";
            DataTable dt = Configs._query.executeProc("TRC_RemoveFromPeriode", "OTID@int@" + OTID + "#planID@int@" + planID);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    returnValue = dt.Rows[0][0].ToString();
                }
            }
            return returnValue;
        }



        public string deletePlan(string idPlan)
        {
            return Configs._query.executeScalar("exec TRC_DELETE_PLAN " + idPlan);
        }
    }
}