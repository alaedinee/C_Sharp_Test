<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liste Agences
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Liste Agences</h2>
    <div>
        <%
            System.Data.DataTable articleDT = (System.Data.DataTable)ViewData["dt_agence"];
            int _nbrCol = articleDT.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(articleDT, "dt_agence", "cellspacing='4' width='100%'"));
        %> 
    </div>
    <script type="text/javascript">
    $(document).ready(function () {   

        var tabComm = $("#dt_agence").not('.initialized').addClass('initialized').dataTable({
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
                    $("#dt_agence tr[index]").not(".init").addClass("init").each(function () {
                        var _ID = $(this).attr("index");
                        var href =  $.fn.SERVER_HTTP_HOST() + "/Agence/NPAgence/?AgenceID=" + _ID;
                        var modifier = "<td align='center' width='130'><a class='link' href='" + href + "' style='color:#E50051;cursor:pointer'>Liste NP</a></td>";
                        $(this).append(modifier);
                    });
                 },
                 "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                 //"bLengthChange": false,   //disable change values
                  "iDisplayLength": 10, // show only five rows
             });
        });
    </script>
</asp:Content>
