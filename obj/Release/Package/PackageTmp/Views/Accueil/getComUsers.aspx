<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	getCom_Users
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
             if (ViewData["getCom_Users"] != null)
            {
                System.Data.DataTable dt = (System.Data.DataTable)ViewData["getCom_Users"];

                Response.Write("<fieldset id='getCom_Users' style='width:500px'><legend>COMMUNICATIONS EFFECTUES PAR UTILISATEUR</legend><br />" +
                    
                    "<table id='tableList' align='left'>" +
                                "<thead><tr>" +
                                "<th>Utilisateur</th>" +
                                "<th>Order du jour</th>" +
                                "<th>Date</th></tr></thead>" );
                
                
                for(int i = 0 ; i < dt.Rows.Count ; i++){                    
                    Response.Write("<tr>" +
                                    "<td>" + dt.Rows[i]["Login"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["NBRORDRE"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["DATE"].ToString() + "</td>" +
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

