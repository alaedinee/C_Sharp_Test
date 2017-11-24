<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	getNBRCommande_Mag
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div id="container">
        <%
            if (ViewData["getNBRCommande_Mag"] != null)
            {
                System.Data.DataTable dt = (System.Data.DataTable)ViewData["getNBRCommande_Mag"];

                Response.Write("<fieldset id='getNBRCommande_Mag' style='width:500px'><legend>NOMBRE DE COMMANDES RECUS PAR MAGASIN</legend><br />" +
                    
                    "<table id='tableList' align='left'>" +
                                "<thead><tr>" +
                                "<th>Client</th>" +
                                "<th>Magasin</th>" +
                                "<th>Order du jour</th></tr></thead>" );
                
                
                for(int i = 0 ; i < dt.Rows.Count ; i++){
                    
                    
                    Response.Write("<tr>" +
                                    "<td>" + dt.Rows[i]["mag"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["Magasin"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["NombreDeCmdDujour"].ToString() + "</td>" +
                                    "</tr>" );
                }

                Response.Write("</table></fieldset>");
            }     
         %>

         <script type="text/javascript">

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
