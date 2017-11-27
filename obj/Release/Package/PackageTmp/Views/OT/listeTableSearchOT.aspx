<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<script type="text/javascript">

    $().ready(function () {
        $("#tableResult tr").mouseover(function () { $(this).addClass("trover"); });
        $("#tableResult tr").mouseout(function () { $(this).removeClass("trover"); });



        
            
        

        $("img").click(function () {

            if (($(this).attr("otid") != null) && ($(this).attr("op") == null)) {

                var td = $(this).parent();
                var tr = $(td).parent();

                $.post(SERVER_HTTP_HOST() + '/OT/addGetJoinOT',
               { otid: document.getElementById("otidT").value, joinOtid: $(this).attr("otid") ,op:"add"},
               function (htmlResult) {

                   //$("#tableSelectedElement").remove();
                   $("#selectedElement").html(htmlResult);
                   $(tr).remove(); 
  
               });
       
                //$('#tableSelectedElement').append('<tr><td>' + $(this).attr("nobl") + '</td><td><img src="' + SERVER_HTTP_HOST() + '/Images/delete_file.png" /></td></tr>');
                
            }
            
        });
    });
</script>

<%
    
    
    try
    {
        
        System.Data.DataTable dt = Omniyat.Models.Configs._query.executeProc("TRC_Get_NoBL_TO_Join", "val@string@" + ViewData["value"].ToString() + "%");
        string returnHtml = "";
        
        if (dt.Rows.Count != 0)
        {
             returnHtml = "<table style='width:90%;margin-left:5%;' id='tableResult'>";

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                returnHtml = returnHtml + "<tr><td>" + dt.Rows[i]["OTNoBL"].ToString() + "</td>"
                                        + "<td width='20px'><img id='imgJoinOT" + i + "' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/add_file16.png' otid='" + dt.Rows[i]["OTID"].ToString() + "'  nobl='" + dt.Rows[i]["OTNoBL"].ToString() + "'  /></td></tr>";
            }

            returnHtml = returnHtml + "</table>";
        }
        Response.Write( returnHtml);
    }
    catch
    {
        Response.Write("");
    }
    
     %>