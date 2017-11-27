<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
        <%


            DataTable dataProp = (DataTable)ViewData["listProp"];
            int _OTNbrCol = dataProp.Columns.Count;
            var _existe = ViewData["existe"].ToString();

         %>


<div style="width:100%;">
    

   

    <fieldset>
    <legend>Liste des magasins</legend>
        <%
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(dataProp, "listProp", "cellspacing='4' width='100%'"));
         %>
     </fieldset>
</div>
 <script type="text/javascript">
     $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>';
        var nbr = $("#listProp tr").length;

        var _existe = '<%: _existe %>';

        if(_existe == "0")
            $("#magChoixx").remove();
            
         if ($("#listProp tr[index]").length > 0) {
             var tabRess = $("#listProp").not('.initialized').addClass('initialized').dataTable({
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
                    $("#listProp tr[index]").each(function () {
                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");

                        if (_tdcount.length == _OTNbrCol - 1) {

                            var afficher = "<td align='center' width='130'><a class='link' allerVersOT='" + _ID + "' style='color:#E50051;cursor:pointer'>Afficher</a></td>";
                            
                            $(this).append(afficher);

                        }
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[allerVersOT]").click(function () {


                        var _OTID = $(this).attr("allerVersOT");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Orders/Afficher", { mode: "modifier", OTID: _OTID },

                             function (htmlResult) {

                                 $("#main").html(htmlResult);

                             }
                           );
                           $("#magChoixx").remove(); 
                    });

                    
                   
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 10,

            });
        }





     });
</script>