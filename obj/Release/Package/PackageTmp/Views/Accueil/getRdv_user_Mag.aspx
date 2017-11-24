<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	getRdv_user_Mag
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

 <%
        if (ViewData["getRdv_user_Mag"] != null)
            {
                System.Data.DataTable dt = (System.Data.DataTable)ViewData["getRdv_user_Mag"];

                Response.Write("<fieldset id='getRdv_user_Mag' style='width:500px'><legend>RENDEZ VOUS PRIS PAR UTLISATEUR PAR MAGASIN</legend><br />" +
                    
                    "<table id='tableList' align='left'>" +
                                "<thead><tr>" +
                                "<th>Utilisateur</th>" +
                                "<th>Date</th>" +
                                "<th>Magazin Code</th>" +
                                "<th>Magasin</th>" +
                                "</tr></thead>" );
                
                
                for(int i = 0 ; i < dt.Rows.Count ; i++){
                    
                    
                    Response.Write("<tr>" +
                                    "<td>" + dt.Rows[i]["Login"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["NBRORDRE"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["DATE"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["MagasinCode"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["Magasin"].ToString() + "</td>" +
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
