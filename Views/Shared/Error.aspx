<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>

<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Erreur
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
   <center>
    <h2>
   <br/><br/>
        Veuillez vous reconnecter <br />
        <% Response.Write("<a href='javascript:history.go(-1)'>Actualiser</a>"); %>
        <br/> <br/><br/>
        <%: Html.ActionLink("Reconnexion", "LogOn", "User")%>
   
    </h2>
    </center>
</asp:Content>
