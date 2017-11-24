<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>   

<div>

    <%
            DataTable prestdtStatus = (DataTable)ViewData["dtStatus"];
            var _prestID = ViewData["id"];
            int _nbrCol = prestdtStatus.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(prestdtStatus, "prestdtStatus", "cellspacing='4' width='100%'"));
         %>

</div>

     <script type="text/javascript">
         $(document).ready(function () {

             var old = "";
             var oldDateExp = "";

             var _nbrCol = "<%: _nbrCol %>";

             var _prestID = "<%: _prestID %>";
             


             var prestdtStatus = $("#prestdtStatus").not('.initialized').addClass('initialized').dataTable({
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

                     $("#prestdtStatus tr[index]").each(function () {
                         var _ID = $(this).attr("index");

                        // $(this).find("td[action]").html("<a del='" + ID + "'>Supprimer</a>");

                         var _tdcount = $(this).find("td");

                         if (_tdcount.length == _nbrCol - 1) {

                             $(this).append("<td action='' align='center' width='130'><a class='link' suppEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>");
                         }
                     });

                 }
             });

             $(this).find("td a[suppEvent]").click(function () {
                 var elems = $(this);
                 var _conf = confirm("Voulez vous supprimer cette ligne ?");
                 if (_conf) {
                     var _ID = $(this).attr("suppEvent");     
                     $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/prestDeleteDetailHis", { id: _ID }, function (htmlResult) {
                         if (htmlResult == "0") {
                             $(elems).closest("tr").remove();
                             alert("supprimé avec succès !");
                         }
                         else
                             alert("Erreur de suppression !");
                     });
                     //alert("oui");
                 }
             });


             $("#prestdtStatus tr[index]").each(function () {

                 var _elem = $(this);
                 var _id = _prestID;  // fix it   doit etre id de service et pas id de la ligne historique
                 var _etat = _elem.find("td:eq(1)").html();
                 var _Date = _elem.find("td:eq(0)").html();

                 old = _elem.prev().find("td:eq(1)").html();
                 oldDateExp = _elem.prev().find("td:eq(0)").html();
                 //alert(_etat + " " + old);

                 if (old != "" && old != undefined && old != _etat) {
                     //                //prestVerifyOTEtat
                     
                     $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/prestVerifyOTEtat", { etat1: old, etat2: _etat }, function (htmlResult) {
                             if (htmlResult == 'false') {


                                 var etat1 = _elem.prev().find("td:eq(1)").html();
                                 _elem.css({ "background": "red", "color": "#fff" });
                                 _elem.find("td[action]").html(" <a correction='' style='cursor:pointer;color:#fff' oldEtat='" + etat1 + "' Etat='" + _etat + "' otid='" + _id + "' DateBeg='" + oldDateExp + "' DateBeg='" + _Date + "'> Corriger </a> ");

                                 $(_elem).find("a[correction]").click(function () {
                                     $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/prestGetFormStatus", { id: _id, etat1: etat1, etat2: _etat, date1: oldDateExp, date2: _Date, type: 'Detail' }, function (data) {
                                         $("#contrDgPrest").remove();
                                         $("#contrDgPr").html("<div id='contrDgPrest' title='Changement de statut'>" + data + "</div>");
                                         $("#contrDgPrest").dialog();
                                     });
                                     //alert("gooood");
                                 });
                             }
                         });           
                    
                 }
                 //old = _etat;
                 //oldDateExp = _Date;
             });

         });
    </script>