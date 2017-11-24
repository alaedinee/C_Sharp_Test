<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.DormantsModels>" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liste
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


 <div id="container"> 


    <% using (Html.BeginForm("Liste", "Dormants"))
       {%>
        <%: Html.ValidationSummary(true)%>

        <fieldset>
            <legend>Critéres de recherche</legend>
            <table>
            <tr>
            <td> <div class="editor-label">
              Nombre de jour 
            </div></td><td>
            
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.nbr)%>
            </div>
            </td>
            
           <td><input type="submit" id="submitBtn" value="Chercher" /></td>
            </tr>
            </table>
            
        </fieldset>
    </div>
    <% } %>
   
        <%
            if (ViewData["dt"] != null)
            {
                System.Data.DataTable  dt = (System.Data.DataTable) ViewData["dt"];

                Response.Write("<br /><fieldset><legend>Liste des dormants</legend>" + 
                    "<div style='text-align:right'><a href='" + Globale_Varriables.VAR.get_URL_HREF()  + "/Dormants/ExportListeDormants/" + ViewData["nbr"].ToString() + "' target='blank'><img align='center' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/excel_icon.png' width='32' /> Exportez vers Excel</a></div><br />" +
                    "<table id='tableList' align='left'>" +
                                "<thead><tr>" +
                                "<th>No Bulletin</th>" +
                                "<th>Client</th>" +
                                "<th>Code</th>" +
                                    "<th>Nbr Colis</th>" +
                                    "<th>Periode</th>" +
                                   "<th>Etat</th>" +
                                   "<th>Date reçu</th>" + 
                                   "<th>Résidence en Jour(s)</th>" + 
                                   "<th>Code postal</th>" +
                                   "<th>Ville</th>" +
                                   "<th>Tél 1</th>" +
                                   "<th>Tél 2</th></tr></thead>" );
                
                
                for(int i = 0 ; i < dt.Rows.Count ; i++){
                    //No Bulletin, Nom du client,
                    //Code, PlanInstruction, 
                    //OTNoteInterne,  DATEPLAN, OTNbrColis, RessourceCode
                    
                    Response.Write("<tr>" +
                                    "<td>" + dt.Rows[i]["OTNoBL"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["Client"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["Code"].ToString() + "</td>" +

                                    "<td>" + dt.Rows[i]["OTNbrColis"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["OTPeriodesNonAttribuees"].ToString() + "</td>" +

                                   "<td>" + dt.Rows[i]["OTEtat"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["Recu le"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["Résidence en Jour(s)"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["OTDESTNP"].ToString() + "</td>" +

                                   "<td>" + dt.Rows[i]["OTDestVille"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["OTTel1"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["OTTel2"].ToString() + "</td></tr>" );
                }

                Response.Write("</table></fieldset>");
            }     
         %>
    

    <script type="text/javascript">


         <% if (Model != null)
     Response.Write(""
         + "  if (document.getElementById('nbr').value == null || document.getElementById('nbr').value == \"\") {"
         + " document.getElementById('nbr').value ='" + Model.nbr + "';"
         + "}");%>

        function chargerSelect( val) {
            document.getElementById('NoBL').value = val;
            document.getElementById('submitBtn').form.submit();
        }

			$().ready(function () {
var oTable = $("#tableList").dataTable({
                "oLanguage": {
                    "sLengthMenu": "Afficher _MENU_ Lignes par page",
                    "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
                    "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
                    "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
                    "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
                },

                "sPaginationType": "full_numbers"
            });				
                });

    </script>
    

</asp:Content>

