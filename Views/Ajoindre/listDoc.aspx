<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<style type="text/css">

.trover
{
	background-color: #0099CC;
}
</style>

<div>


<%
    string OTID = (ViewData["OTID"] != null) ? ViewData["OTID"].ToString() : "";
    string _isOpen = (ViewData["isOpen"] != null) ? ViewData["isOpen"].ToString() : "1";
    string _isPalannifToPast = (ViewData["isPalannifToPast"] != null) ? ViewData["isPalannifToPast"].ToString() : "1";
      
    try
    {
       
       
 
        string returnHtml = "<table style='width:90%;margin-left:5%;' border='0' cellspacing='0' id='tableResultDoc'>";
        string uriHrf = Globale_Varriables.VAR.urlFileUpload + "/" + ViewData["otid"].ToString() + "/";

        string path = Globale_Varriables.VAR.PATH_STOCKAGE + "/" + OTID;

        IEnumerable<string> dirList = System.IO.Directory.EnumerateDirectories(path);
        int i = 0;
        string old = "";
         foreach (string dir in dirList)
        {
            string dpath =  dir ;
            string[] type= dpath.Split('\\');
            IEnumerable<string> fileList = System.IO.Directory.EnumerateFiles(dpath);
             
            if (old != type[type.Length - 1] && fileList.Count() > 0)
                returnHtml = returnHtml + "<tr style='cursor:pointer;' spp='" + type[type.Length - 1] + "'><td  style='cursor:pointer;width:20px'>+</td><td>" + type[type.Length - 1] + "</td><td></td></tr>";
             
            
            foreach (string file in fileList)
            {
                string[] fileName = file.Split('\\');
                
                
               returnHtml = returnHtml + "<tr index='" + type[type.Length - 1] + "'><td>&nbsp;</td><td><a target='_blank' href='" + uriHrf + type[type.Length - 1] + "/" + fileName[fileName.Length - 1] + "' >" + fileName[fileName.Length - 1] + "</a></td>";
               if (_isOpen.ToString() != "0" && _isPalannifToPast.ToString() != "0")
                   returnHtml = returnHtml + "<td width='20px'><img doc='yes' id='imgDelDoc" + i + "' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/delete_file.png' otid='" + ViewData["otid"].ToString() + "' fileName='" + OTID + @"\" + type[type.Length - 1] + @"\" + fileName[fileName.Length - 1] + "' /></td>";
               
               returnHtml = returnHtml +  "</tr>";
                
                
                i++;    
            }

            old = type[type.Length - 1];
        }

         returnHtml = returnHtml + "</table><br />";

         returnHtml += "<table style='width:90%;margin-left:5%;' border='0' cellspacing='0'>";
         IEnumerable<string> fileList1 = System.IO.Directory.EnumerateFiles(path);
         foreach (string file in fileList1)
         {
             string[] fileName = file.Split('\\');


             returnHtml += "<tr><td></td><td><a target='_blank' href='" + uriHrf + "/" + fileName[fileName.Length - 1] + "' >" + fileName[fileName.Length - 1] + "</a></td>";
             if (_isOpen.ToString() != "0" && _isPalannifToPast.ToString() != "0")
                 returnHtml += "<td width='20px'><img doc='yes' id='imgDelDoc" + i + "' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/delete_file.png' otid='" + ViewData["otid"].ToString() + "' fileName='" + @"\" + OTID + @"\" + fileName[fileName.Length - 1] + "' /></td>";
             
             returnHtml += "</tr>";
             
         
             i++;
         }
        
        returnHtml = returnHtml + "</table>";
        Response.Write(returnHtml);
    }
    catch
    {
        Response.Write("");
    }
    
     %>

</div>

<br />

     <script type="text/javascript">
         var otid = "<%:  OTID  %>";
         $(document).ready(function () {

             $("#tableResultDoc tr").mouseover(function () { $(this).addClass("trover"); });
             $("#tableResultDoc tr").mouseout(function () { $(this).removeClass("trover"); });

             
             $("img[doc]").click(function () {

                 //alert($(this).attr("path"));

                 var _conf = confirm("Voulez vous supprimer ce document?");
                 if (_conf) {

                     var td = $(this).parent();
                     var tr = $(td).parent();

                     $.post($.fn.SERVER_HTTP_HOST() + '/Ajoindre/deleteDoc', { path: $(this).attr("fileName") },
                           function (htmlResult) {

                               if (htmlResult == "1") {
                                   document.location.href = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + otid;
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