<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	detailPlan
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <h4 class="erreur"> <%
        if(ViewData["erreur"] != null)
            Response.Write(ViewData["erreur"]); 
         %></h4>
          <% Response.Write(ViewData["titre"].ToString());%>
         <table><tr><td><h3> <%= Html.ActionLink("Retour au Plans", "RedirectToPost/0/" + ViewData["DatePlan"].ToString().Replace("/","-").Replace(".","-"), "RDV")%></h3></td><td><h3><% Response.Write("<a target=\"_blank\" href='../../displayPlanPDF/" + ViewData["id"].ToString() + "'>PDF</a>"); %></h3></td></tr></table> 
    <% Response.Write(ViewData["periodePlan"]); %>

    <script type="text/javascript">
        $(document).ready(function () {
            $("a[type='delPeriode']").click(function () {
                var _conf = confirm("Confirmer la suppression ?");
                if (_conf == false) return false;
            });
        });
    </script>

</asp:Content>

