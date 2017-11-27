using System;
using System.Collections.Generic;
//using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Xml;
//using Franson.DAO;
using CONNECTIONSQL;
using TRC_GS_COMMUNICATION.Models;

/// <summary>
/// Description résumée de MaClasse
/// </summary>
/// 

namespace Omniyat.Models
{
    public class MAJ /*: DAOReaderBase*/
    {
        public SqlCommand CMD;
        public SqlDataAdapter Da;
        string sql = "";

        //Exécution d'une requete SQL.
        /// <summary>
        /// Exécute une requete sql et retourne le nombre de lignes affectées.
        /// </summary>
        /// <param name="requette">La requete à effectuer</param>
        /// <param name="openCon">true si la connexion est ouverte et false dans le cas contraire.</param>
        /// <returns>int : est le nombre de lignes retournées.</returns>
        public int ExceSqlQuery(string requette, Boolean openCon)
        {

            int returnVal = 0;
            try
            {
                CMD = new SqlCommand(requette, Connection.Conn);
                if (openCon == true) Connection.Conn.Open();
                returnVal = CMD.ExecuteNonQuery();
                if (openCon == true) Connection.Conn.Close();
                return returnVal;
            }
            catch (Exception ex)
            {
                if (openCon == true) Connection.Conn.Close();
                //Tools.Debug(ex, "MAJ->ExceSqlQuery", requette);
                return -1;
            }
        }

        /// <summary>
        /// Charge une procédure stockée de la base de données et l'exécute.
        /// </summary>
        /// <param name="storedProcedur">Le nom de la procédure stockée à charger.</param>
        /// <param name="parametres">Les paramètres ainsi que les valeurs de la procédure stockée. NB : Les types des paramètres sont mis entre @ et
        /// les différents paramètres sont separés par un #. Exemple : "paramètre1@int@"+ valeur_paramètre1+ "#paramètre2@string@" +valeur_paramètre2+ etc...</param>
        /// <param name="openCon">True pour ouvrir la connexion à la base de données. NB : Toujours affecter à openCon la valeur true.</param>
        public DataTable chargerStoredProcedur(string nameStoredProcedur, string parametres, Boolean openCon)
        {
            DataTable dt = new DataTable();

            int j;

            try
            {
                CMD = new SqlCommand();
                CMD.CommandType = CommandType.StoredProcedure;
                CMD.Connection = Connection.Conn;
                CMD.CommandText = nameStoredProcedur;

                string[] prm = parametres.Split('#');

                if (parametres != "")
                {
                    for (int i = 0; i < prm.Length; i++)
                    {
                        string[] valPrm = prm[i].Split('@');
                        if (valPrm[1] == "date")
                        {
                            CMD.Parameters.Add("@" + valPrm[0], SqlDbType.Date).Value = Convert.ToDateTime(valPrm[2]);
                        }
                        else if (valPrm[1] == "string")
                        {
                            CMD.Parameters.Add("@" + valPrm[0], SqlDbType.NVarChar).Value = valPrm[2];
                        }
                        else if (valPrm[1] == "int")
                        {
                            if (valPrm[2].Trim() == "") valPrm[2] = "0";
                            CMD.Parameters.Add("@" + valPrm[0], SqlDbType.BigInt).Value = valPrm[2];
                        }
                        else if (valPrm[1] == "float")
                        {
                            if (valPrm[2].Trim() == "") valPrm[2] = "0";
                            CMD.Parameters.Add("@" + valPrm[0], SqlDbType.Float).Value = valPrm[2];
                        }
                    }
                }

                Da = new SqlDataAdapter(CMD);

                if (openCon == true) Connection.Conn.Open();
                Da.Fill(dt);
                //j = CMD.ExecuteNonQuery();
                //xmlReader = CMD.ExecuteXmlReader();
                if (openCon == true) Connection.Conn.Close();
                //return xmlReader;
                return dt;
            }
            catch (Exception ex)
            {
                //Console.WriteLine(ex.Message);
                if (openCon == true) Connection.Conn.Close();
               // Tools.Debug(ex, "MAJ->chargerStoredProcedur", nameStoredProcedur + " :: " + parametres);
                return null;
            }
        }

        //Chargement de SQL Query dans une datatable.
        public DataTable ChargerSqlQuery(string requette, Boolean openCon)
        {
            System.Diagnostics.Debug.WriteLine("SQL : " + requette);
            DataTable dt = new DataTable();
            try
            {
                Da = new SqlDataAdapter(requette, Connection.Conn);
                if (openCon == true) Connection.Conn.Open();
                DataSet ds = new DataSet();

                Da.Fill(dt);

                if (openCon == true) Connection.Conn.Close();
                return dt;
            }
            catch (Exception ex)
            {
                if (openCon == true) Connection.Conn.Close();

                //Tools.Debug(ex, "MAJ->ChargerSqlQuery", requette);

                return dt;
            }

        }

        public String ExecSqlScalarQuery(string requette, Boolean openCon)
        {

            try
            {
                string val = "";
                CMD = new SqlCommand(requette, Connection.Conn);
                if (openCon == true) Connection.Conn.Open();
                val = CMD.ExecuteScalar().ToString();
                if (openCon == true) Connection.Conn.Close();
                return val;
            }
            catch (Exception ex)
            {
                if (openCon == true) Connection.Conn.Close();

                //Tools.Debug(ex, "MAJ->ExecSqlScalarQuery", requette);

                return "";
            }

        }

    }
}