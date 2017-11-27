<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.ChargementModels>" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liste
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


 <div id="container"> 
    <% using (Html.BeginForm("Liste", "Chargement"))
       {%>
        <%: Html.ValidationSummary(true)%>

        <fieldset>
            <legend>Critéres de recherche</legend>
            <table>
            <tr>
            <td> <div class="editor-label">
              Date 
            </div></td><td>
            
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.dateChargement)%>
                <%: Html.ValidationMessageFor(model => model.dateChargement)%>
            </div>
           
            </td>
            <td> <div class="editor-label">
               Code stock
            </div></td><td>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.Codestock)%>
            </div>
           </td>
           <td><div class="editor-label">
               Remarque
            </div></td>

           <td <div class="editor-field">
           <%: Html.TextBoxFor(m => m.remarque)%></div></td>
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

                Response.Write("<br /><fieldset><legend>Liste des chargements</legend>" + 
                    "<div style='text-align:right'><a href='" + Globale_Varriables.VAR.get_URL_HREF()  + "/Chargement/ExportListeChargement/" + ViewData["dateChagement"].ToString().Replace("/", "-") + '/' + ViewData["Codestock"] + '/' + ViewData["remarque"] + "/feature' target='blank'><img align='center' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/excel_icon.png' width='32' /> Exportez vers Excel</a></div><br />" +
                    "<table id='tableList' align='left'>" +
                                "<thead><tr>" +
                                "<th>Date Plan</th>" +
                                "<th>Heure Début</th>" +
                                "<th>Heure Fin</th>" +
                                    "<th>No Bulletin</th>" +
                                    "<th>Service</th>" +
                                   "<th>Nom du client</th>" +
                                   "<th>Camion</th>" + 
                                   "<th>Remarque</th>" + 
                                   "<th>Nbr Colis</th>" + 
                                   "<th>Code</th></tr></thead>" );
                
                
                for(int i = 0 ; i < dt.Rows.Count ; i++){
                    //No Bulletin, Nom du client,
                    //Code, PlanInstruction, 
                    //OTNoteInterne,  DATEPLAN, OTNbrColis, RessourceCode
                    
                    Response.Write("<tr>" +
                                    "<td>" + dt.Rows[i]["PlanDate"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["DEBUT"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["FIN"].ToString() + "</td>" +
                                        
                                    "<td>" + dt.Rows[i]["No Bulletin"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["Service"].ToString() + "</td>" +
                                    
                                   "<td>" + dt.Rows[i]["Nom du client"].ToString() + "</td>" + 
                                   "<td>" + dt.Rows[i]["RessourceCode"].ToString() + "</td>" + 
                                   "<td>" + dt.Rows[i]["PlanInstruction"].ToString() + "</td>" + 
                                   "<td>" + dt.Rows[i]["OTNbrColis"].ToString() + "</td>" + 
                                   "<td>" + dt.Rows[i]["Code"].ToString() + "</td></tr>" );
                }

                Response.Write("</table></fieldset>");
            }     
         %>
    

    <script type="text/javascript">


         <% if (Model != null)
     Response.Write(""
         + "  if (document.getElementById('dateRdv').value == null || document.getElementById('dateRdv').value == \"\") {"
         + " document.getElementById('dateRdv').value ='" + Model.dateChargement + "';"
         + "}");%>

        function chargerSelect( val) {
            document.getElementById('NoBL').value = val;
            document.getElementById('submitBtn').form.submit();
        }

			$().ready(function () {
			 $('#dateChargement').datepicker({ dateFormat: 'dd/mm/yy' });
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

