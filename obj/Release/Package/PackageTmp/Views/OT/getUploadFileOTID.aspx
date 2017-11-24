<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<script type="text/javascript">

    $().ready(function () {

        $("#tableResultDoc tr").mouseover(function () { $(this).addClass("trover"); });
        $("#tableResultDoc tr").mouseout(function () { $(this).removeClass("trover"); });

        $("img").click(function () {

            if (($(this).attr("otid") != null) && ($(this).attr("doc") == "yes")) {

                var td = $(this).parent();
                var tr = $(td).parent();

                $.post(SERVER_HTTP_HOST() + '/OT/deleteUploadFileOTID',
               { otid: $(this).attr("otid"), fileName: $(this).attr("fileName") },
               function (htmlResult) {

                   if (htmlResult == "OK") {
                       $(tr).remove();
                   }
                   else {
                       alert("Opération echouée");
                   }



               });

                //$('#tableSelectedElement').append('<tr><td>' + $(this).attr("nobl") + '</td><td><img src="' + SERVER_HTTP_HOST() + '/Images/delete_file.png" /></td></tr>');

            }

        });
    });

</script>
<style type="text/css">

.trover
{
	background-color: #0099CC;
}
</style>
<%
    
      
    try
    {
        
        GSD.gsDirectory gsD = new GSD.gsDirectory(ViewData["otid"].ToString());
       TRC_GS_COMMUNICATION.Models.MajOT majOT = new TRC_GS_COMMUNICATION.Models.MajOT();
        string facturer = majOT.OtFacturer(ViewData["otid"].ToString());
        string[] tab = gsD.getContentDirectory();
        string returnHtml = "<table style='width:90%;margin-left:5%;' id='tableResultDoc'>";
        string uriHrf = Globale_Varriables.VAR.urlFileUpload + "/File/" + ViewData["otid"].ToString() + "/";
            //Globale_Varriables.VAR.urlFileUpload + "
        for (int i = 0; i < tab.Length; i++)
        {
            string[] fileName = tab[i].Split('\\');

            if (facturer == "")
            {
                returnHtml = returnHtml + "<tr><td><a target='_blank' href='" + uriHrf + fileName[fileName.Length - 1] + "' >" + fileName[fileName.Length - 1] + "</a></td>"
                                         + "<td width='20px'><img doc='yes' id='imgDelDoc" + i + "' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/delete_file.png' otid='" + ViewData["otid"].ToString() + "' fileName='" + fileName[fileName.Length - 1] + "' /></td></tr>";
            }
            else
            {
                returnHtml = returnHtml + "<tr><td><a target='_blank' href='" + uriHrf + fileName[fileName.Length - 1] + "' >" + fileName[fileName.Length - 1] + "</a></td>"
                                     + "<td width='20px'></td></tr>";
            
            }
                
        }
        returnHtml = returnHtml + "</table>";
        Response.Write(returnHtml);
    }
    catch
    {
        Response.Write("");
    }
    
     %>