using Omniyat.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace maintenance.Models
{
    public class PrestationModel
    {

        public DataTable listDTPrestation(string type, string OTID, string prestation)
        {
           
                //MAJ.MAJ maj = new MAJ.MAJ();
                DataTable dt;
                if (type == "base")
                {
                    dt = Configs._query.executeProc("prestGetPrestationBase", "prestation@string@" + prestation);
                }
                else
                {
                    dt = Configs._query.executeProc("prestGetLstPrestation", "otid@int@" + OTID + "#type@string@1");
                }
                
                return dt;
           

        }



        public string addPrestation(string otid, string prestation, string prix, string refClient, string status, string ProduitPeriodes)
        {
            //maj = new MAJ.MAJ();
            string returnValue = "";
            if (prix == "") prix = "0";
            string param = "OTID@int@" + otid + "#prestation@string@" + prestation + "#prix@double@" + prix + "#refClient@string@" + refClient + "#status@int@" + status;

            param += "#ProduitPeriodes@int@" + ProduitPeriodes;

            DataTable dt = Configs._query.executeProc("prestInsertPrestation", param);
            if (dt.Rows.Count > 0)
            {
                returnValue = dt.Rows[0][0].ToString();
            }

            return returnValue;
        }

        public void updatePrestation(string otid, string prestation, string prix, string oldPrestation, string refClient, string status, string idServ, string ProduitPeriodes, string user = "sys", string CurrentAgenceID = null)
        {
            //maj = new MAJ.MAJ();

            if (prix == "") prix = "0";
            string param = "OTID@int@" + otid + "#OldProduit@string@" + oldPrestation + "#produit@string@" + prestation + "#Prix@double@" + prix + "#refClient@string@" + refClient + "#Etat@int@" + status + "#idServ@int@" + idServ;
            param += "#ProduitPeriodes@int@" + ProduitPeriodes;
            param += "#user@string@" + user;
            if (!string.IsNullOrEmpty(CurrentAgenceID))
                param += "#CurrentAgenceID@int@" + CurrentAgenceID;

            Configs._query.executeProc("prestUpdatePrestation", param);

            OTDetailStatutTracker(otid);

        }

        public string deletePrestation(string prestID, string prestation)
        {
            //maj = new MAJ.MAJ();
            string res = "";
            DataTable dtDelete = Configs._query.executeProc("prestDeletePrestation", "prestID@int@" + prestID);
            if (dtDelete.Rows.Count > 0)
            {
                res = dtDelete.Rows[0][0].ToString();
            }
            return res;
        }



        public void annulerPrestation(string otid, string prestation, string etat, string code, string planID)
        {
            ///maj = new MAJ.MAJ();
            Configs._query.executeProc("prestUpdateEtatPrestation", "OTID@int@" + otid + "#produit@string@" + prestation + "#etat@int@" + etat + "#codeQuery@string@" + code + "#planID@int@" + planID);
        }

        public void OTDetailStatutTracker(string OTID)
        {
            DataTable dtDetail = Configs._query.executeProc("__STracker_GETDETAIL", "OTID@int@" + OTID);
            if (dtDetail == null || dtDetail.Rows.Count == 0) return;

            foreach (DataRow r in dtDetail.Rows)
            {
                string ID_DEST = r["ID_DEST"].ToString();
                string ETAT_DEST = r["ETAT_DEST"].ToString();

                Configs._query.executeProc("InsertOTDetail_SAT", "serviceID@int@" + ID_DEST + "#Statut@int@" + ETAT_DEST + "#sendStatus@int@0");
            }

            OTDetailStatutTracker(OTID);
        }
    }
}