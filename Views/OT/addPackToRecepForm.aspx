<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
        <%
            var _receptionID = ViewData["recepID"].ToString();
            var _receptionCode = ViewData["recepCode"].ToString();
            DataTable dataPackRecep = (DataTable)ViewData["ListPackages"];
            int _nbrColPacks = dataPackRecep.Columns.Count;
         %>

<div style="width:100%;">
    

   

    <fieldset>
    <legend>Liste des magasins</legend>
        <%
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(dataPackRecep, "ListPackRecep", "cellspacing='4' width='100%'"));
         %>
     </fieldset>
</div>
 <script type="text/javascript">
     $(document).ready(function () {

      var _nbrColPacks = '<%: _nbrColPacks %>';
       var _receptionID = '<%: _receptionID %>';
       var _receptionCode = '<%: _receptionCode %>';

         if ($("#ListPackRecep tr[index]").length > 0) {
             var tabRess = $("#ListPackRecep").not('.initialized').addClass('initialized').dataTable({
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
                     $("#ListPackRecep tr[index]").each(function () {
                         var _index = $(this).attr("index");

                          var _tdcount = $(this).find("td");

                        if (_tdcount.length == _nbrColPacks - 1) {

                            var confirmer = "<td align='center' width='130'><a class='link' packAddToReception='" + _index + "' style='color:#E50051;cursor:pointer'>Confirmer</a></td>";
                      

                            $(this).append(confirmer);

                        } 
                     });


                     $(this).find("a[packAddToReception]").click(function () {


                        var _IDPackage = $(this).attr("packAddToReception");

                        var _conf = confirm("Voulez vous ajouter ce package dans la récéption : "+ _receptionCode +" ?");
                        if (_conf)  {

                                    //alert("works fine");

                                        $.get($.fn.SERVER_HTTP_HOST() + "/OT/addPackToReception", { IDPackage: _IDPackage, IDRecep : _receptionID },

                                             function (htmlResult) {

                                             if(htmlResult.toString() != "1"){
                                                // alert("Opération réussie");
                                                $("#addPackRecDG").remove();
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