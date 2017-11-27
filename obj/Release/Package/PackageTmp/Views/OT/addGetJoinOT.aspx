<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>



<script type="text/javascript">

    $("img").click(function () {

        if ($(this).attr("op") != null) {
            var op = $(this).attr("op");
            var td = $(this).parent();
            var tr = $(td).parent();

            $.post(SERVER_HTTP_HOST() + '/OT/deleteJoinOT',
                           { otid: $(this).attr("otid") },
                           function (htmlResult) {

                               if ((htmlResult == "OK") && (op == "listOT")) {
                                   $(tr).remove();
                               }
                               else if (htmlResult == "OK") {
                                   $(tr).remove();
                               }
                               else {
                                   alert("Opération echouée");
                               }

                           });

        }

        if ($(this).attr("opp") != null) {
            var op = $(this).attr("opp");
            var td = $(this).parent();
            var tr = $(td).parent();

            var votid = $(this).attr("otid");
            
            $.post(SERVER_HTTP_HOST() + '/OT/deleteJoinOTNBL',
                           { otid: votid },
                           function (htmlResult) {
                               if ((htmlResult == "OK") && (op == "listOT")) {
                                   $(tr).remove();
                               }
                               else if (htmlResult == "OK") {
                                   $(tr).remove();
                               }
                               else {
                                   alert("Opération echouée");
                               }

                           });

        }

    });

</script>
<%Response.Write("<script type='text/javascript'>"

    + "$().ready(function () { "
    + "     $(\"#tableSelectedElement" + ViewData["op"].ToString() + " tr\").mouseover(function () { $(this).addClass(\"trover\"); });"

    + "    $(\"#tableSelectedElement" + ViewData["op"].ToString() + " tr\").mouseout(function () { $(this).removeClass(\"trover\"); });"
    + "});</script>");%>


<%
    
    try
    {



        System.Data.DataTable dt;

        string otid = ViewData["otid"].ToString();
        string joinOtid = ViewData["joinOtid"].ToString();
        TRC_GS_COMMUNICATION.Models.MajOT majOT = new TRC_GS_COMMUNICATION.Models.MajOT();
        string facturer = majOT.OtFacturer(ViewData["otid"].ToString());
        string videString = "";
                
        if (ViewData["op"].ToString() == "add")
        {

            dt = Omniyat.Models.Configs._query.executeProc("TRC_add_join_OT", "otid@int@" + otid + "#joinOtid@int@" + joinOtid);
            
        }
        else if(ViewData["op"].ToString() == "listOTConfirmation")
        {
            dt = Omniyat.Models.Configs._query.executeProc("TRC_Display_List_Join_OT_Confirmation", "otid@int@" + otid);
            videString = "#@#VIDE#@#";
        }
        else
        {
            dt = Omniyat.Models.Configs._query.executeProc("TRC_Display_List_Join_OT", "otid@int@" + otid);
        }


        string returnHtml = "";
                
       
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (facturer == "")
            {
                returnHtml = returnHtml + "<tr ><td>" + dt.Rows[i]["OTNoBL"].ToString() + "</td>"
                                        + "<td width='20px'><img op='" + ViewData["op"].ToString() + "' id='imgJoinOT" + i + "' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/delete_file.png' otid='" + dt.Rows[i]["OTID"].ToString() + "'  nobl='" + dt.Rows[i]["OTNoBL"].ToString() + "'  /></td></tr>";
            }
            else
            {
                returnHtml = returnHtml + "<tr ><td>" + dt.Rows[i]["OTNoBL"].ToString() + "</td>"
                                       + "<td width='20px'></td></tr>";
            }
        }

        System.Data.DataTable dtt = Omniyat.Models.Configs._query.executeSql("Select * from TRC_Join_Group_Detail where OTID is null and Group_ID=(select Group_ID from TRC_Join_Group_Detail where OTID='" + otid + "')");
        //returnHtml = returnHtml + "Nbr : " + dtt.Rows.Count.ToString();
        for (int i = 0; i < dtt.Rows.Count; i++)
        {
            returnHtml = returnHtml + "<tr ><td>" + dtt.Rows[i]["OTNoBL"].ToString() + "</td>"
                                        + "<td width='20px'><img opp='del' id='imgJoinOTNBL" + ID + "' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/delete_file.png'  otid='" + dtt.Rows[i]["ID"].ToString() + "'  /></td></tr>";
        }

        if(dt.Rows.Count > 0 || dtt.Rows.Count > 0)
        {
            returnHtml = "<table at='okTaleb' style='width:90%;margin-left:5%;' id='tableSelectedElement" + ViewData["op"].ToString() + "'>" + returnHtml;
            returnHtml = returnHtml + "</table>";
            Response.Write(returnHtml);
        }
        else
        {
            Response.Write(videString);
        }
    }
    catch
    {
        Response.Write("");
    }
    
    
    
     %>
