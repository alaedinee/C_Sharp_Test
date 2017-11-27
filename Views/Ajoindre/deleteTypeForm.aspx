<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
        <%
            var _OTID = ViewData["OTID"].ToString();
            DataTable dataLstTypeDoc= (DataTable)ViewData["LstTypeDoc"];
            int _nbrColPacks = dataLstTypeDoc.Columns.Count;
         %>

<div style="width:100%;">
    

   

    <fieldset>
    <legend>Liste des magasins</legend>
        <%
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(dataLstTypeDoc, "LstTypeDoc", "cellspacing='4' width='100%'"));
         %>
     </fieldset>
</div>
 <script type="text/javascript">
     $(document).ready(function () {

      var _nbrColPacks = '<%: _nbrColPacks %>';
      var _OTID = '<%: _OTID %>';


         if ($("#LstTypeDoc tr[index]").length > 0) {
             var tabRess = $("#LstTypeDoc").not('.initialized').addClass('initialized').dataTable({
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
                     $("#LstTypeDoc tr[index]").each(function () {
                         var _index = $(this).attr("index");

                          var _tdcount = $(this).find("td");

                        if (_tdcount.length == _nbrColPacks - 1) {

                            var supprimer = "<td align='center' width='130'><a class='link' deleteTypeDoc='" + _index + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";
                      

                            $(this).append(supprimer);

                        } 
                     });


                     $(this).find("a[deleteTypeDoc]").click(function () {


                        var _IDType = $(this).attr("deleteTypeDoc");

                        var _conf = confirm("Voulez vous confirmer la suppression de ce type ?");
                        if (_conf)  {

                                        $.get($.fn.SERVER_HTTP_HOST() + "/Ajoindre/deleteType", { IDType: _IDType },

                                             function (htmlResult) {

                                             if(htmlResult.toString() != "1"){
                                                // alert("Opération réussie");

                                                        $.post($.fn.SERVER_HTTP_HOST() + "/Ajoindre/ajForm", { OTID: _OTID, facturer: "oui" },

                                                        function (htmlResult) {

                                                            $("#divAjoindre").html(htmlResult);

                                                        });
                                                        $("#DGADDTYPE").remove();
                                             }

                                             else
                                                alert("Echéc d'opération");

                                       });                                      
                                  
                              }
                        });

                 },
                 "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

          
             });
         }






     });
</script>