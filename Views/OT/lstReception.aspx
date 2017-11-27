<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<div>
    <%
        System.Data.DataTable _Reception = (System.Data.DataTable)ViewData["dt"];
        string recepHTML = "<table style='width:100%;' border='0' id='tableResultDoc'> <thead><tr align='left' bgcolor='orange' style=\"color:#fff\" height='35'><th>Num Reception</th><th>Fournisseur</th> <th>Marchandise</th>  <th>Donneur d'ordre</th> <th>Date récéption</th> <th>Etat de récéption</th><th>Action</th></tr></thead><tbody>";

        if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_Reception))
        {
            for (int i = 0; i < _Reception.Rows.Count; i++)
            {
                System.Data.DataRow row = _Reception.Rows[i];

                recepHTML = recepHTML + "<tr> "
                    + "<td>" + _Reception.Rows[i]["receptionNumber"] + "</td>"
                    + " <td>" + _Reception.Rows[i]["Fournisseur"] + "</td>"
                    + "<td>" + _Reception.Rows[i]["typeReception"] + "</td>"

                    + "<td>" + _Reception.Rows[i]["Donneur"] + "</td>"
                    + "<td>" + _Reception.Rows[i]["dateReception"] + "</td>"
                    + "<td>" + _Reception.Rows[i]["etatReception"] + "</td>"
                    + "<td >" +
                    "<a href='#' receptionID='" + _Reception.Rows[i]["receptionID"] + "' receptionNumber='" + _Reception.Rows[i]["receptionNumber"] + "' >Séléctionner</a> </td> </tr> ";
            }
        }

        recepHTML = recepHTML + "</tbody></table>";
        Response.Write(recepHTML);
    %>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var nbr = $("#tableResultDoc tr").length;
        var tabPacksRec = null;
        if (nbr > 1) {
            tabPacksRec = $("#tableResultDoc").not('.initialized').addClass('initialized').dataTable({
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
                    $("#tableResultDoc tr td a[receptionID]").not('.initialized').addClass('initialized').click(function () {
                        $("#PKRecepID").val($(this).attr("receptionID"));
                        $("#bPKRecepID").html($(this).attr("receptionNumber"));

                        $("#DGpacK1").dialog('close');

                        return false;
                    });
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                "iDisplayLength": 10
            });
        }

    });
</script>