<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	AfficherTout
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

     <script type="text/javascript">
         $().ready(function () {
             $('#tableList').dataTable({
                     "oLanguage"       : {
                     "sLengthMenu"     : "Afficher _MENU_ Lignes par page",
                     "sZeroRecords"    : "Aucu'un element ne correspond a votre recherche",
                     "sInfo"           : "Voir _START_ a _END_ de _TOTAL_ Lignes",
                     "sInfoEmpty"      : "Voir 0 a 0 de 0 Lignes",
                     "sInfoFiltered"   : "(Filtrer de _MAX_ Lignes)"
                                         },
                     "sPaginationType" : "full_numbers"

             });     
         });
    </script>

     <h2>Consultation des Ordres de transports</h2>
     <%: Html.ActionLink("Ajouter un ordre", "Index")%><br /><br />

<% Response.Write(ViewData["listOT"].ToString()); %>

</asp:Content>
