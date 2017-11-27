<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<div>
                <%
                    System.Data.DataTable OTlist = (System.Data.DataTable)ViewData["LstOt"];
                    int _nbrCol = OTlist.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTlist, "LstOt", "cellspacing='4' width='100%'"));
                %>
 </div> 


  
<script type="text/javascript">

    $(document).ready(function () {

        var _nbrCol = "<%:_nbrCol %>";

        //*******************
        var tabPrest = $("#LstOt").not('.initialized').addClass('initialized').dataTable({
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
                $("#LstOt tr[index]").each(function () {
                    var _ID = $(this).attr("index");
                    var _tdcount = $(this).find("td");
                    var _TDEtat = $(this).find("td").eq(4);
                    $(_TDEtat).html("<a class='link' style='color:#E50051;cursor:pointer'>" + $(_TDEtat).html() + "</a>");

                    if (_tdcount.length == _nbrCol - 1) {

                        var effuectuer = "<td align='center' width='130'><a class='link' RetirerEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Retirer</a></td>";
                        $(this).append(effuectuer);
                    }
                });

            }
        });
        // FIN TABLLE

        // evenement effectuer
        $("#LstOt").find("a[RetirerEvent]").unbind('click').click(function () {


            var _OTID = $(this).attr("RetirerEvent");

            var _conf = confirm("Voulez-vous retirer ce dossier ?" + _OTID);
            tabPrest.DataTable().row($(this).parents('tr')).remove().draw();


        });
        // end

    });

</script>
