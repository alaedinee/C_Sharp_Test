<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"  %>

<% 

    TRC_GS_COMMUNICATION.Models.MajOT majOT = new TRC_GS_COMMUNICATION.Models.MajOT();
    System.Data.DataTable dt = majOT.getVilles();

  
    for (int i = 0; i < dt.Rows.Count; i++)
    {
        Response.Write(dt.Rows[i]["VilleNP"].ToString()  + "," + dt.Rows[i]["ville"].ToString() + "\n");
    }

%>
