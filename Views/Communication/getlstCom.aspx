<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>

<%
    var _RessourceID = ViewData["RessourceID"];
    var _Ressource = ViewData["Ressource"];
    string _isOpen = (ViewData["isOpen"] != null) ? ViewData["isOpen"].ToString() : "1";
%>


<style type="text/css">
    #menuCommunication{
        margin-right:auto;
        text-align:right;
    }

    .imgMenu{
        cursor:pointer;
    }
    .ulCommunication
    {
        list-style-type: none;
        list-style-type: none;
        padding-left: 15px;
        margin-top: 20px;
        font-size: 12px;
        font-weight: bold;
    }
    .ulCommunication img
    {
        vertical-align: middle;
        margin-right: 5px;
    }
</style>


        <div id="tabsCommunication" style="width:100%; min-height: 300px">
              <ul>
                <li><a href="#tabs-comm-1">Communication</a></li>
              <%--  <li><a href="#tabs-4">Chargement</a></li>--%>
              </ul>


              <div id="tabs-comm-1" style="width:95%">

              <%if (_isOpen.ToString() != "0"){ %>
                   <div id="menuCommunication" >            
                
                            <%--<img  mode='TEL' id="img1" class="imgMenu" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/phone-blue-icon_32.png" width="20" />
                            <img  mode='EMAIL' id="imgemail" class="imgMenu" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/email_32.png" width="20"  />
                            <img  mode='SMS' id="imgsms" class="imgMenu" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/SMS_32.png" width="20"  /> --%>   
                            <img  mode='MDM_COM' id="imgMDM_COM" class="imgMenu" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/MDM_COM.png" width="20" />
                                                    
                        </div>
                <% } %>
                    <%
                        DataTable dtC = (DataTable)ViewData["ListComm"];
                        Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(dtC, "lstComm", "cellspacing='4' width='100%'"));
                     %>

              </div>
               <div>
                   <ul class="ulCommunication">
                        <li> <img src="<%: Globale_Varriables.VAR.get_URL_HREF() %>/Images/ALERT_ANY_32.png"  width='20'/>     : Modification effectuée aucune action utilisateur n'ai requise.</li>
                        <li> <img src="<%: Globale_Varriables.VAR.get_URL_HREF() %>/Images/ALERT_WARNING_32.png"  width='20'/> : Modification incompatible avec la logique système.</li>
                        <li> <img src="<%: Globale_Varriables.VAR.get_URL_HREF() %>/Images/ALERT_DANGER_32.png"  width='20'/>  : Action utilisateur requise (Modification apporté au dossier).</li>
                        <li> <img src="<%: Globale_Varriables.VAR.get_URL_HREF() %>/Images/MDM_COM.png"  width='20'/>          : Communication MDM.</li>
                        <li> <img src="<%: Globale_Varriables.VAR.get_URL_HREF() %>/Images/email_32.png"  width='20'/>         : Email envoyé.</li>
                   </ul>
               </div>


       </div>

   




<div id="contrDgComm" title="">

</div>

 <script type="text/javascript">
     $(document).ready(function () {

     $(function () {
            $("#tabsCommunication").tabs();
        });

         var _RessourceID = '<%: _RessourceID %>'
         var _Ressource = '<%: _Ressource %>'
         var data = '<%: dtC %>'
         var wt = 600;
         var ht = 400;

         //if ($("#lstComm tr[index]").length > 0) {
             var tabComm = $("#lstComm").not('.initialized').addClass('initialized').dataTable({
                 sPaginationType: "full_numbers"
                    , "oLanguage": {
                        "sProcessing": "Traitement en cours...",
                        "sLengthMenu": "Afficher _MENU_ éléments",
                        "sZeroRecords": "Aucun élément à afficher",
                        "sInfo": "Affichage de l'élement _START_ à _END_ sur _TOTAL_ éléments",
                        "sInfoEmpty": "Affichage de l'élement 0 à 0 sur 0 éléments",
                        "sInfoFiltered": "(filtré de _MAX_ éléments au total)",
                        "sInfoPostFix": "",
                        "sSearch": "Rechercher:",
                        
                        "sUrl": "",
                        
                         
                        "oPaginate": {
                            "sFirst": "<<",
                            "sPrevious": "<",
                            "sNext": ">",
                            "sLast": ">>"
                        }

                    },
                 "fnDrawCallback": function (oSettings) {
                     $("#lstComm tr[index]").each(function () {

                         var _ID = $(this).attr("index");
                         if (!$(this).hasClass("affected")) {
                             var elem = $(this).find("td:first");
                             var _TypeCommunication = elem.html();

                             if (_TypeCommunication == "TEL")
                                 elem.html("<img  class='imgMenu' detailCommEvent='" + _ID + "' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/phone-blue-icon_32.png' width='20' border='0' />");

                             else if (_TypeCommunication == "EMAIL")
                                 elem.html("<img  class='imgMenu' detailCommEvent='" + _ID + "' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/email_32.png' width='20' border='0' />");

                             else if (_TypeCommunication == "SMS")
                                 elem.html("<img  class='imgMenu' detailCommEvent='" + _ID + "' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/SMS_32.png' width='20' border='0' />");

                             else if (_TypeCommunication == "MDM_COM")
                                 elem.html("<img  class='imgMenu' detailCommEvent='" + _ID + "' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/MDM_COM.png' width='20' border='0' />");

                             else if (_TypeCommunication.startsWith("ALERT_"))
                                 elem.html("<img  class='imgMenu' detailCommEvent='" + _ID + "' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/" + _TypeCommunication + "_32.png' width='20' border='0' />");

								 else 
                                 elem.html("<img  class='imgMenu' detailCommEvent='" + _ID + "' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/email_icon_32.png' width='20' border='0' />");


                             $(this).addClass("affected");
                             //elem.attr('tr th=xxx');
                         }


                         var _tdcount = $(this).find("td");

                         //alert("count TD :" + _tdcount.length);

                         if (_tdcount.length == 4) {
                             //if (_etat != "32") {
                             $(this).append("<td align='center' width='130'><a class='link' detailCommEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Détails</a></td>");
                             $(this).append("<td align='center' width='130'><a class='link' articleCommEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Articles</a></td>");

                         }
                         

         $(this).find("a[detailCommEvent], img[detailCommEvent]").unbind().click(function () {
             var _IDComm = $(this).attr("detailCommEvent");

             $.get($.fn.SERVER_HTTP_HOST() + "/Communication/detailComm", { IDComm: _IDComm },

                  function (htmlResult) {

                      $("#contrDgCom").remove();
                      $("#contrDgComm").html("<div id='contrDgCom' title='Détail communication'>" + htmlResult + "</div>");
                      $("#contrDgCom").dialog({
                          width: wt,
                          height: ht,
                          modal: true,
                         // position: 'top',

                      });
                  }
                );
         });

         $(this).find("a[articleCommEvent]").unbind().click(function () {
             var _IDComm = $(this).attr("articleCommEvent");

             $.get($.fn.SERVER_HTTP_HOST() + "/Communication/articlesComm", { IDComm: _IDComm },

                  function (htmlResult) {

                      $("#contrDgCom").remove();
                      $("#contrDgComm").html("<div id='contrDgCom' title='Détail communication'>" + htmlResult + "</div>");
                      $("#contrDgCom").dialog({
                          width: wt,
                          height: ht,
                          modal: true,
                         // position: 'top',

                      });
                  }
                );
         });

                     });
                    
                 },
                 "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                 //"bLengthChange": false,   //disable change values
                  "iDisplayLength": 5, // show only five rows
                  


             });

            
         //}
         //else
         //    $("#lstComm tr:last").after('<tr><td>Aucune résultat</td></tr>');

         
         $("img[mode]").unbind().click(function () {
             //alert('email');
             var _mode = $(this).attr('mode');
             $.post($.fn.SERVER_HTTP_HOST() + "/Communication/majCommunication",
                    { mode: _mode, otid: _RessourceID, Ressource: _Ressource },

                     function (htmlResult) {

                         $("#contrDgCom").remove();
                         $("#contrDgComm").html("<div id='contrDgCom' title='Ajouter communication'>" + htmlResult + "</div>");
                         $("#contrDgCom").dialog({
                             width: wt,
                             height: ht,
                             modal: true,
                             // position: 'top',

                         });
                     });
         });
         




     });

</script>
