using System;
using System.Collections.Generic;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Xml;

namespace Omniyat.Models
{

  
    public class Query
    {
        public SqlCommand _command;
        public SqlDataAdapter _dataAdapter;

        public Query(Boolean open = true)
        {
            try
            {
                // if (open == true) Configs._sqlConnection.Open();
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "Omniyat.Models.Query.Query");
            }
        }

        public int updateSql(string sql, Boolean open = false)
        {
            int returnVal = 0;
            
                try
                {
                    using (SqlConnection _sqlConnection = new SqlConnection(Configs._urlServer))
                    {
                        _command = new SqlCommand(sql, _sqlConnection);
                        _sqlConnection.Open();
                        returnVal = _command.ExecuteNonQuery(); 
                    }                    
                }
                catch (Exception ex)
                {
                    Configs.Debug(ex, "Omniyat.Models.Query.updateSql", sql);
                    returnVal = -1;
                }
            
            return returnVal;
        }

        public DataTable executeProc(string name, string parameters = "", Boolean open = false, char spliter = '@', char spliter2 = '#')
        {
            DataTable dt = new DataTable();          

            try
            {
                using (SqlConnection _sqlConnection = new SqlConnection(Configs._urlServer))
                {
                    _command = new SqlCommand();
                    _command.CommandType = CommandType.StoredProcedure;
                    _command.Connection = _sqlConnection;
                    _command.CommandText = name;

                    string[] prm = parameters.Split(spliter2);

                    if (parameters != "")
                    {
                        for (int i = 0; i < prm.Length; i++)
                        {
                            string[] valPrm = prm[i].Split(spliter);
                            if (valPrm[1] == "date")
                            {
                                if (valPrm[2] == "")
                                {
                                    _command.Parameters.Add("@" + valPrm[0], SqlDbType.DateTime).Value = DBNull.Value;
                                }
                                else
                                {
                                    _command.Parameters.Add("@" + valPrm[0], SqlDbType.DateTime).Value = Convert.ToDateTime(valPrm[2]);
                                }
                            }
                            else if (valPrm[1] == "string")
                            {
                                _command.Parameters.Add("@" + valPrm[0], SqlDbType.NVarChar).Value = valPrm[2];
                            }
                            else if (valPrm[1] == "int")
                            {
                                if (valPrm[2].Trim() == "") valPrm[2] = "0";
                                _command.Parameters.Add("@" + valPrm[0], SqlDbType.BigInt).Value = valPrm[2];
                            }
                            else if (valPrm[1] == "double" || valPrm[1] == "float")
                            {
                                if (valPrm[2].Trim() == "") valPrm[2] = "0";
                                _command.Parameters.Add("@" + valPrm[0], SqlDbType.Float).Value = MCV.MyConvert.ToDouble(valPrm[2]);
                            }
                        }
                    }

                    _dataAdapter = new SqlDataAdapter(_command);
                    _dataAdapter.Fill(dt); 

                }
            }
            catch (Exception exx)
            {
                Configs.Debug(exx, "Omniyat.Models.Query.executeProc", name + " => " + parameters);
            }
            
            return dt;
        }

        public DataTable executeProcMail(string name, string parameters = "", Boolean open = false, char spliter = '$', char spliter2 = '#')
        {
            DataTable dt = new DataTable();
           
                try
                {
                    using (SqlConnection _sqlConnection = new SqlConnection(Configs._urlServer))
                    {
                        _command = new SqlCommand();
                        _command.CommandType = CommandType.StoredProcedure;
                        _command.Connection = _sqlConnection;
                        _command.CommandText = name;

                        string[] prm = parameters.Split(spliter2);

                        if (parameters != "")
                        {
                            for (int i = 0; i < prm.Length; i++)
                            {
                                string[] valPrm = prm[i].Split(spliter);
                                if (valPrm[1] == "date")
                                {
                                    if (valPrm[2] == "")
                                    {
                                        _command.Parameters.Add("@" + valPrm[0], SqlDbType.DateTime).Value = DBNull.Value;
                                    }
                                    else
                                    {
                                        _command.Parameters.Add("@" + valPrm[0], SqlDbType.DateTime).Value = Convert.ToDateTime(valPrm[2]);
                                    }
                                }
                                else if (valPrm[1] == "string")
                                {
                                    _command.Parameters.Add("@" + valPrm[0], SqlDbType.NVarChar).Value = valPrm[2];
                                }
                                else if (valPrm[1] == "int")
                                {
                                    if (valPrm[2].Trim() == "") valPrm[2] = "0";
                                    _command.Parameters.Add("@" + valPrm[0], SqlDbType.BigInt).Value = valPrm[2];
                                }
                                else if (valPrm[1] == "double" || valPrm[1] == "float")
                                {
                                    if (valPrm[2].Trim() == "") valPrm[2] = "0";
                                    _command.Parameters.Add("@" + valPrm[0], SqlDbType.Float).Value = valPrm[2];
                                }
                            }
                        }

                        _dataAdapter = new SqlDataAdapter(_command);
                        _dataAdapter.Fill(dt); 
                    }
                }
                catch (Exception exx)
                {
                    Configs.Debug(exx, "Omniyat.Models.Query.executeProc", name + " => " + parameters);
                    //if (open == true) Configs._sqlConnection.Close();
                }
           
            return dt;
        }

        //public bool verifyConnection(bool open)
        //{
        //    bool res = false;
        //    ConnectionState status = Configs._sqlConnection.State;
        //    try
        //    {
        //        if (status == ConnectionState.Broken || status == ConnectionState.Closed) 
        //            Configs._sqlConnection.Open(); //if (open == true || status

        //        if (Configs._sqlConnection.State == ConnectionState.Open)
        //           res = true;
        //    }
        //    catch (Exception ex) {
        //        Configs.Debug(ex, "Omniyat.Models.Query.verifyConnection", "connection avec la BD est impossible");
        //    }
          
        //    return res;
        //}

        public DataTable executeSql(string sql, Boolean open = false)
        {
            DataTable dt = new DataTable();            
            try
            {
                using (SqlConnection _sqlConnection = new SqlConnection(Configs._urlServer))
                {
                    _dataAdapter = new SqlDataAdapter(sql, _sqlConnection);
                    DataSet ds = new DataSet();
                    _dataAdapter.Fill(dt); 
                }
            }
            catch (Exception ex)
            {
                Configs.Debug(ex, "Omniyat.Models.Query.executeSql","impossible d'exécuter cette requette : "+  sql);
            }            

            return dt;
        }

        public String executeScalar(string sql, Boolean open = false)
        {
            string val = "";
            
                try
                {
                    using (SqlConnection _sqlConnection = new SqlConnection(Configs._urlServer))
                    {
                        _command = new SqlCommand(sql, _sqlConnection);
                        _sqlConnection.Open();
                        Object obj = _command.ExecuteScalar();
                        val = (obj == null) ? "" : ((obj.ToString() == null) ? "" : _command.ExecuteScalar().ToString()); 
                    }
                }
                catch (Exception ex)
                {
                    Configs.Debug(ex, "Omniyat.Models.Query.executeScalar", sql);
                }
            
            return val;
        }


        public void Dispose()
        {
           
        }

    }
}