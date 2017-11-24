<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	test
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>test</h2>






    <a href="#" id="tr">test</a>
    <div id="DGpack"></div>

    <script>
        $(document).ready(function () {
            $("#tr").click(function () {
                $("#DGpacK").remove();
                $("#DGpack").html("<div id='DGpacK' title='Modifier un package'>hello world !</div>");

                $("#DGpacK").dialog({
                    height: 300,
                    width: 350,
                    modal: true
                });

               // $("#DGpacK").dialog("option", "position", [600, 500]);
            });
        });
    </script>

</asp:Content>
