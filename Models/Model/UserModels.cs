using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using System.Data;
using Omniyat.Models;
namespace TRC_GS_COMMUNICATION.Models
{



    #region modeles

    public class UserModel
    {
        [Required(ErrorMessage = "Veuillez saisir l'identifiant")]
        public string LogIn { get; set; }

        [Required(ErrorMessage = "Veuillez saisir le mot de passe")]
        public string Password { get; set; }

        public string userID { get; set; }

    }
    #endregion

    #region MajModele

    public class MajModeles
    {
        //public MAJ.MAJ maj = new MAJ.MAJ();

        public int addSession(string userID)
        {
            //string query = "insert into tbl_Sessions values('" + userID + "')";
            //return maj.ExceSqlQuery(query, true);
            return 1;
        }

        public int deleteSession(string userID)
        {
            string query = "delete from tbl_Sessions where userID='" + userID + "'";
            return Configs._query.updateSql(query);
        }


        public bool verifySession(string userID)
        {
            //string query = "select * from tbl_Sessions where userID='" + userID + "'";
            //DataTable dtUser = Configs._query.executeSql(query);
            //if (dtUser == null)
            //    return false;
            //else
            //{
            //    if (dtUser.Rows.Count > 0)
            //        return true;
            //    else
            //        return false;
            //}

            return false;
        }

        public string getUser(UserModel usrModel)
        {
            // string IP = Tools.getIPAddress(HttpContext.Current.Request);
            string IP = Tools.GetIP4Address();

            string param = string.Format("login@string@{0}#pwd@string@{1}#ip@string@{2}", usrModel.LogIn, usrModel.Password, IP);
            
            DataTable dtUser = Configs._query.executeProc("UserConnect", param);


            if (MTools.verifyDataTable(dtUser))
            {
                return dtUser.Rows[0]["UserID"].ToString() + '$' + dtUser.Rows[0]["Login"].ToString() + '$' + dtUser.Rows[0]["MagasinID"].ToString();
            }
            else
            {
                return "0";
            }
        }

        public string getUserbyId(string id)
        {
            string query = "select * from USERS where UserID=" + id + "";
            DataTable dtUser = Configs._query.executeSql(query);
            if (MTools.verifyDataTable(dtUser))
            {
                return dtUser.Rows[0]["Login"].ToString();
            }
            else
            {
                return "0";
            }
        }
        public string getRolebyId(string id)
        {
            string query = "SELECT NomRole FROM [Role] INNER JOIN USERS ON [Role].idRole = USERS.idRole WHERE  USERS.UserID = " + id + "";
            DataTable dtUser = Configs._query.executeSql(query);
            if (MTools.verifyDataTable(dtUser))
            {
                return dtUser.Rows[0]["NomRole"].ToString();
            }
            else
            {
                return "0";
            }
        }
        public string getUserAgenceById(string id)
        {
            string IP = Tools.GetIP4Address();
            string query = @"select c.AgenceID AgenceIDConnexion, u.AgenceID AgenceIDUser 
                            from USERS u left join ConnexionUser cu on cu.idUser = u.UserID
			                             left join Connexion c on c.ConnexionID = cu.idConnexion and c.IPAdresse = '" + IP + @"'
                            where u.UserID = " + id + " ";
            DataTable dt = Configs._query.executeSql(query);
            if (MTools.verifyDataTable(dt))
            {
                if(dt.Rows[0]["AgenceIDConnexion"] != DBNull.Value)
                    return dt.Rows[0]["AgenceIDConnexion"].ToString();
                else if (dt.Rows[0]["AgenceIDUser"] != DBNull.Value)
                    return dt.Rows[0]["AgenceIDUser"].ToString();
            }
            return "";
        }
    }

    #endregion

}