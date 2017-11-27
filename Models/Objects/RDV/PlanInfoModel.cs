using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Omniyat.Models;
using System.Web.Mvc;

namespace TRC_GS_COMMUNICATION.Models.Objects.RDV
{
    public class PlanInfoModel
    {
        public string PlanID { get; set; }
        public string PlanDate { get; set; }
        public string PoidTotal { get; set; }
        public string Somme { get; set; }
        public string CammionCode { get; set; }
        public string ChauffeurCode { get; set; }
        public string[] Aides { get; set; }
        public string remarque { get; set; }
        public string[] AidesRequest { get; set; }
        public string TextAidesRequest { get; set; }
        public string Remorque { get; set; }
        public string type_tournee { get; set; }

        public IEnumerable<SelectListItem> listItemCamion
        {
            get
            {
                //MAJ.MAJ maj = new MAJ.MAJ();
                DataTable dt = Configs._query.executeProc("TRC_GET_FREE_CAMION", "date@string@" + this.PlanDate + "#planID@int@" + this.PlanID);

                List<SelectListItem> li = new List<SelectListItem>();
                Boolean selected = true;
                li.Add(new SelectListItem
                {
                    Text = "-",
                    Value = "NULL",
                    Selected = selected
                });
                if (dt != null)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0) selected = false;

                        li.Add(new SelectListItem
                        {
                            Text = dt.Rows[i]["RessourceCode"].ToString(),
                            Value = dt.Rows[i]["RessourceID"].ToString(),
                            Selected = selected
                        });
                    }
                }

                return li;
            }

        }


        public IEnumerable<SelectListItem> listItemChauffeur
        {
            get
            {
                //MAJ.MAJ maj = new MAJ.MAJ();
                DataTable dt = Configs._query.executeProc("TRC_GET_FREE_CHAUFFEUR", "date@string@" + this.PlanDate + "#planID@int@" + this.PlanID);

                List<SelectListItem> li = new List<SelectListItem>();
                Boolean selected = true;
                li.Add(new SelectListItem
                {
                    Text = "-",
                    Value = "NULL",
                    Selected = selected
                });
                if (dt != null)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0) selected = false;

                        li.Add(new SelectListItem
                        {
                            Text = dt.Rows[i]["RessourceCode"].ToString(),
                            Value = dt.Rows[i]["RessourceID"].ToString(),
                            Selected = selected
                        });
                    }
                }
                return li;
            }
        }

        public IEnumerable<SelectListItem> listItemTypeTournees
        {
            get
            {
                //MAJ.MAJ maj = new MAJ.MAJ();
                DataTable dt = Configs._query.executeProc("PRC_getList", "name@string@tournées");

                List<SelectListItem> li = new List<SelectListItem>();
                Boolean selected = true;
                li.Add(new SelectListItem
                {
                    Text = "-",
                    Value = "NULL",
                    Selected = selected
                });
                if (dt != null)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0) selected = false;

                        li.Add(new SelectListItem
                        {
                            Text = dt.Rows[i]["name"].ToString(),
                            Value = dt.Rows[i]["name"].ToString(),
                            Selected = selected
                        });
                    }
                }
                return li;
            }
        }


        public IEnumerable<SelectListItem> listItemAide
        {
            get
            {
                //MAJ.MAJ maj = new MAJ.MAJ();
                DataTable dt = Configs._query.executeProc("TRC_GET_FREE_AIDE", "date@string@" + this.PlanDate + "#planID@int@" + this.PlanID);

                List<SelectListItem> li = new List<SelectListItem>();
                Boolean selected = true;


                if (dt != null)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (i > 0) selected = false;

                        li.Add(new SelectListItem
                        {
                            Text = dt.Rows[i]["RessourceCode"].ToString(),
                            Value = dt.Rows[i]["RessourceCode"].ToString(),
                            Selected = selected
                        });
                    }
                }

                return li;
            }

        }


        public IEnumerable<SelectListItem> listItemAideRequest(string listAide)
        {
            List<SelectListItem> li = new List<SelectListItem>();
            if (listAide == null || listAide == "")
            {
                return li;
            }
            if (listAide != null && listAide != "" && listAide.Contains("@") == false)
            {
                li.Add(new SelectListItem
                {
                    Text = listAide,
                    Value = listAide
                });
                return li;
            }

            string[] value = listAide.Split('@');

            for (int i = 0; i < value.Length; i++)
            {
                li.Add(new SelectListItem
                {
                    Text = value[i],
                    Value = value[i]
                });
            }
            return li;
        }
    }
}