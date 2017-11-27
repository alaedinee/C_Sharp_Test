<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    $().ready(function () {
        alert('k');


        $().ready(function () {
            $('#example').dataTable();

        });

        $("a").click(function () {

            if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewCom") {
                $.post(
                    "../OT/PopUpMAJViewMAJ",
                    { mode: "", otid: $(this).attr("otid") },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();

                    }
               );

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewRemarques") {
                $.post(
                    "../OT/RemarqueOT",
                    { otid: $(this).attr("otid"), path: '../' },
                    function (htmlResult) {
                        $("#RemarqueOT").remove();
                        $("#container").append(htmlResult);
                        $("#RemarqueOT").dialog();

                        var divS = document.getElementsByTagName("div");

                        for (var i = 0; i < divS.length; i++) {
                            if ($(divS[i]).attr("role") != null) {
                                $(divS[i]).css("width", "400px");
                            }
                        }

                    }
               );

            }

        });


    });
         
</script>




   <% Response.Write(ViewData["ListOT"].ToString());    %>
    
</asp:Content>