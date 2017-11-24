<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"  %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


 <div id="container">
        <a href="#" id="lst1">Liste</a>
 </div>
    <script type="text/javascript">

        $().ready(function () {
            $("#lst1").click(function () {

                $.post(SERVER_HTTP_HOST() + '/Accueil/getNBRCommande_Mag',
                           { otid: '' },
                           function (htmlResult) {

                               alert(htmlResult);

                           });
            });
        });
    </script>
    

</asp:Content>

