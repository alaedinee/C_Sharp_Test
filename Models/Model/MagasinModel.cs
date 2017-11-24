using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TRC_GS_COMMUNICATION.Models;

namespace Omniyat.Models
{
    public class MagasinModel
    {

        public DataTable getLstMagasin(string magID = "-1")
        {

            DataTable magData = Configs._query.executeProc("magGetList", "magID@int@" + magID);
            return magData;
        }

        public string updateMagasin(string _params)
        {
            string result = "";
            DataTable dt = Configs._query.executeProc("magUpdate", _params);
            if (Tools.verifyDataTable(dt))
            {
                result = dt.Rows[0][0].ToString();
            }

            return result;
        }

        public string addMagasin(string _params)
        {
            string result = "";
            DataTable dt = Configs._query.executeProc("magAdd", _params);
            if (Tools.verifyDataTable(dt))
            {
                result = dt.Rows[0][0].ToString();
            }

            return result;
        }

        public string deleteMagasin(string _params)
        {
            string result = "";
            DataTable dt = Configs._query.executeProc("magDelete", _params);
            if (Tools.verifyDataTable(dt))
            {
                result = dt.Rows[0][0].ToString();
            }

            return result;
        }


    }


    public class ClientModel
    {

        public DataTable getListClientAll(string idClient)
        {
            DataTable cliDataAll = Configs._query.executeProc("magGetCliAll", "cliID@int@" + idClient + "#typeClient@string@");
            return cliDataAll;
        }

        public DataTable getListClientAll(string idClient, string typeClient)
        {
            DataTable cliDataAll = Configs._query.executeProc("magGetCliAll", "cliID@int@" + idClient + "#typeClient@string@" + typeClient);
            return cliDataAll;
        }

        public DataTable getLstClient(string type)
        {
            DataTable cliData = Configs._query.executeProc("magGetCliByType", "type@string@" + type);
            return cliData;
        }

        public DataTable getLstEmplacement(string type)
        {
            DataTable cliData = Configs._query.executeProc("packGetEmplacement", "type@string@" + type);
            return cliData;
        }

        public DataTable getLstClientComplete(string val)
        {
            DataTable cliData = Configs._query.executeProc("magGetCliComplete", "val@string@" + val);
            return cliData;
        }

        public DataTable getLstAdresseComplete(string val)
        {
            DataTable cliData = Configs._query.executeProc("magGetAdresseComplete", "adr@string@" + val);
            return cliData;
        }

        public DataTable getInfosChargement(string cliID)
        {
            DataTable InfosCharg = Configs._query.executeProc("magGetInfosCharg", "cliID@int@" + cliID);
            return InfosCharg;
        }

        public DataTable getInfosLivraison(string cliID)
        {
            DataTable InfosCharg = Configs._query.executeProc("magGetInfosLivr", "cliID@int@" + cliID);
            return InfosCharg;
        }

        public DataTable getInfosDonneur(string cliID)
        {
            DataTable InfosCharg = Configs._query.executeProc("magGetInfosDonn", "cliID@int@" + cliID);
            return InfosCharg;
        }

        public string getClientByCode(string cliFamille, string valChargCode)
        {
            string res = "";
            string _params = "";

            _params = "type@string@" + cliFamille + "#code@string@" + valChargCode;

            DataTable dataClient = Configs._query.executeProc("magGetClientByCode", _params);

            if (Tools.verifyDataTable(dataClient))
            {

                res = dataClient.Rows[0]["ClientID"].ToString() + "*" + dataClient.Rows[0]["Nom"].ToString();
                //+ "*"
                //+ dataClient.Rows[0]["adresse"].ToString() + "*" + dataClient.Rows[0]["Ville"].ToString() + "*"
                //+ dataClient.Rows[0]["NP"].ToString() + "*" + dataClient.Rows[0]["Pays"].ToString() + "*"
                //+ dataClient.Rows[0]["Tel"].ToString() + "*" + dataClient.Rows[0]["Fax"].ToString() + "*";

            }
            return res;
        }


        public string getClientByID(string cliFamille, string valID)
        {
            string res = "";
            string _params = "";

            _params = "type@string@" + cliFamille + "#ID@string@" + valID;

            DataTable dataClient = Configs._query.executeProc("magGetClientByID", _params);

            if (Tools.verifyDataTable(dataClient))
            {

                res = dataClient.Rows[0]["ClientID"].ToString() + "*" + dataClient.Rows[0]["Nom"].ToString() + "*"
                    + dataClient.Rows[0]["CodeClient"].ToString() + "*"
                + dataClient.Rows[0]["adresse"].ToString() + "*" + dataClient.Rows[0]["NP"].ToString() + "*"
                + dataClient.Rows[0]["Ville"].ToString() + "*" + dataClient.Rows[0]["Pays"].ToString() + "*"
                + dataClient.Rows[0]["Tel"].ToString() + "*" + dataClient.Rows[0]["Fax"].ToString() + "*"
                + dataClient.Rows[0]["mail"].ToString() + "*";

            }
            return res;
        }

        public string updateClient(string _params)
        {
            string result = "";
            DataTable dt = Configs._query.executeProcMail("magCliUpdate", _params);
            if (Tools.verifyDataTable(dt))
            {
                result = dt.Rows[0][0].ToString();
            }

            return result;
        }

        public string deleteClient(string _params)
        {
            string result = "";
            DataTable dt = Configs._query.executeProc("magCliDelete", _params);
            if (Tools.verifyDataTable(dt))
            {
                result = dt.Rows[0][0].ToString();
            }

            return result;
        }

        public string addClient(string _params)
        {
            string result = "";
            DataTable dt = Configs._query.executeProcMail("magCliAdd", _params);
            if (Tools.verifyDataTable(dt))
            {
                result = dt.Rows[0][0].ToString();
            }

            return result;
        }

    }
}