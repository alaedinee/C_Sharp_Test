<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	IndexOT
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    $().ready(function () {

        $('#tableList').dataTable({
            "oLanguage": {
                "sLengthMenu": "Afficher _MENU_ Lignes par page",
                "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
                "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
                "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
                "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
            },

            "sPaginationType": "full_numbers"
        });

        var gCard = $('#tableList tbody').delegate("a", "click", aClick);
        function aClick() {


            if ($(this).attr("otid") != null) {

                $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: "", otid: $(this).attr("otid") },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();
                    }
               );
            }

        }
    });
         

</script>
<div id="container">
    <h2>Liste des ordres</h2>
   
    <% Response.Write(ViewData["listOT"].ToString()); %>
    </div>
</asp:Content>
