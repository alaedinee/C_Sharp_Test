<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string OTIDG = ViewData["OTIDGroup"] == null ? "-1" : ViewData["OTIDGroup"].ToString();     
%>
<div>
    <img id="btn_AddOTToGroupe" otid="<%:OTIDG %>" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
</div>
 <div>

        <p>
            <input type="text" id="txt_SearchOTID" placeholder="Recherche TAG-DOC"/>
        </p>        
        <%
            System.Data.DataTable OTDataCloturee = (System.Data.DataTable)ViewData["data"];
            int _OTNbrCol = OTDataCloturee.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTDataCloturee, "ListOTByGroup", "cellspacing='4' width='100%'"));  
            %>
</div>
<div id="div-modal">
</div>
   <script>
       var OTIDG = '<%:OTIDG %>';
       $(document).ready(function () {

           var ListOTByGroup = $("#ListOTByGroup").DataTable({ //
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
                   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   $("#ListOTByGroup tbody tr[index]").each(function () {


                       var _ID = $(this).attr("index");
                       var _tdcount = $(this).find("td");

                       if (!$(this).hasClass("affected")) {
                           var elem = $(this).find("td:first");
                           var val = elem.html();

                           elem.html("<a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                           var supprimer = "<td align='center' width='130'><a class='link' OTDeleteEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";

                           $(this).addClass("affected");
                           $(this).append(supprimer);
                       }

                   });

                   /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                   $(this).find("a[OTEditEvent]").click(function () {
                       var _OTID = $(this).attr("OTEditEvent");
                       location.href = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _OTID;
                   });
                   $(this).find("a[OTDeleteEvent]").click(function () {
                       if (!confirm("Voulez vous vraiment suprimre ce dossier du groupe ?"))
                           return false;
                       var _OTID = $(this).attr("OTDeleteEvent");
                       $.get($.fn.SERVER_HTTP_HOST() + "/OT/DeleteOTFromGroupe/", { OTGroupe: OTIDG, OTID: _OTID }, function (r) {
                           if (r == '1') {
                               // dossier groupe list
                               $.get($.fn.SERVER_HTTP_HOST() + "/OT/ListOTByGroup/", { OTIDGroup: OTIDG }, function (result) {
                                   $('#div-tab-ot-group').html(result);
                               });
                               // dossier groupe info
                               $.get($.fn.SERVER_HTTP_HOST() + "/OT/InfoGroupe/", { OTIDGroup: OTIDG }, function (result) {
                                   $('#div-tab-ot-info').html(result);
                               });
                           }
                           else
                               alert("Erreur !!");
                       });
                   });


                   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
               },
               "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
               "iDisplayLength": 10,
               "columnDefs": [
                	{
                	    "targets": [1],
                	    "visible": false,
                	    "searchable": true
                	}
                ]

           });
           //////////////////////////////////  RECHERCHE TAG_DOC  //////////////////////////////
           $('#txt_SearchOTID').on('keyup', function () {
               var val = this.value;
               val = val.split("-");
               if (val.length > 1)
                   ListOTByGroup.columns(1).search(val[1]).draw();
               else
                   ListOTByGroup.columns(1).search("").draw();

           });
           // bt Add
           $('#btn_AddOTToGroupe').unbind().click(function () {
               $.get($.fn.SERVER_HTTP_HOST() + "/OT/OTToAddInGroupe", { OTID: OTIDG }, function (r) {
                   // $('#div-modal').html("");
                   $("#div-modal-content").remove();
                   $("#div-modal").html("<div id='div-modal-content' title='Liste des Dossiers'>" + r + "</div>");

                   $("#div-modal").dialog({
                       // height: 150,
                       width: 1200,
                       modal: true
                   });
               });
           });
       });

   </script>
