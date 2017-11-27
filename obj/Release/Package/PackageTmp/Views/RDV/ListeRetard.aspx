<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.OrderTransportModelsListeRetard>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liste des dossier en retard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


<div id="container">
  
<script type="text/javascript">

    function chargerSelect(val) {
        // $(this).attr("nobl");
        // alert('ok');
        document.getElementById('NoBL').value = val;
        document.getElementById('submitBtn').form.submit();
    }

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


            if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewCom") {

                $.post(
                    "../OT/PopUpMAJViewMAJ",
                    { mode: "", otid: $(this).attr("otid") },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();

                    }
               );

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewRemarque") {

                $.post(
                    "../OT/RemarqueOT",
                    { otid: $(this).attr("otid"), path: '../' },
                    function (htmlResult) {
                        $("#RemarqueOT").remove();
                        $("#container").append(htmlResult);
                        $("#RemarqueOT").dialog({ width: 400 });


                    }
               );

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkJoinOT") {

                $.post(SERVER_HTTP_HOST() + '/OT/addGetJoinOT',
               { otid: $(this).attr("otid"), joinOtid: 0, op: 'listOT' },
               function (htmlResult) {


                   htmlResult = '<div id="divJointOT">' + htmlResult + '</div>';

                   $("#divJointOT").remove();
                   $("#container").append(htmlResult);
                   $("#divJointOT").dialog();


                   //                   $("#tableSelectedElement").remove();
                   //                   $("#divJoinElementOT").html(htmlResult);  lnkJoinDOC


               });

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkJoinDOC") {

                $.post(SERVER_HTTP_HOST() + '/OT/getUploadFileOTID',
               { otid: $(this).attr("otid") },
               function (htmlResult) {

                   htmlResult = '<div id="divJointDOC">' + htmlResult + '</div>';

                   $("#divJointDOC").remove();
                   $("#container").append(htmlResult);
                   $("#divJointDOC").dialog();


               });

            }


        }


    });
         

</script>


    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Recherche</legend>
            
            <table><tr><td>
            <div class="editor-label">
                Duréé
            </div>
            <div class="editor-field">
                <%: Html.DropDownListFor(model => model.interval, (IEnumerable<SelectListItem>)ViewData["list"])%> 
                <%: Html.ValidationMessageFor(model => model.interval) %>
            </div>
            </td>
            <td><div class="editor-label">
                Client
            </div>
             <div class="editor-field">
             <%: Html.DropDownListFor(model => model.client, (IEnumerable<SelectListItem>)ViewData["listClient"])%> 
             </div>


            </td>
            <td><div class="editor-label">
                Prestation
            </div>
             <div class="editor-field">
             <%: Html.DropDownListFor(model => model.prestation , (IEnumerable<SelectListItem>)ViewData["listPrestation"])%> 
             </div>


            </td>
            <td><input type="submit" value="Afficher" /></td></tr>
            </table>
           </fieldset>

            <div style="width:100%;">
            <%
           if (ViewData["contentList"] != null)
           {
               Response.Write(ViewData["contentList"].ToString());
           } %>

            </div>
      

    <% } %>


    </div>
</asp:Content>

