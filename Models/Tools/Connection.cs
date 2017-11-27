using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using TRC_GS_COMMUNICATION.Properties;
using System.Configuration;
namespace CONNECTIONSQL
{
    public  class Connection
    {
        //public static SqlConnection Conn = new SqlConnection(ConfigurationManager.ConnectionStrings["TRICOLISDBConnectionString"].ToString());

        public static string _sqlUrl = Omniyat.Models.TableGenerator.getCon_Config();
        public static SqlConnection Conn = new SqlConnection(_sqlUrl);
    }
}
