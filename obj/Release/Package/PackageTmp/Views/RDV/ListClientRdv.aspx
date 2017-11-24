<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.RdvSelectOTModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListClientRdv
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">


 
    function chargerSelect(val) {
        // $(this).attr("nobl");
        // alert('ok');
        document.getElementById('NoBL').value = val;
        document.getElementById('submitBtn').form.submit();
    }
    $().ready(function () {
        //    $("#lnkNewCom0").click(function () {
        //        $.post(
        //                    "../OT/PopUpMAJViewMAJ",
        //                    { otid: $(this).attr("otid") },
        //                    function (htmlResult) {
        //                        $("#PopUpMAJ").remove();
        //                        $("#container").append(htmlResult);
        //                        $("#PopUpMAJ").dialog();
        //                    }
        //               );
        //    });

        $("a").click(function () {

            if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewCom") {
               
              
                   $.post(
                    document.getElementById('path').value,
                    { mode: "SMS", otid: $(this).attr("otid") },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();
                    }
               );

               

            }
          
            
                else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewRemarque") {
              
                $.post(

                    document.getElementById('path').value.toString().replace("PopUpMAJViewMAJ", "RemarqueOT"),
                    { otid: $(this).attr("otid") , path: document.getElementById('path').value.toString().replace("OT/PopUpMAJViewMAJ", "")},
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
<script type="text/javascript">
  
//    $().ready(function () {
//     
//        $("a").click(function () {


//            if ($(this).attr("otid") != null) {

//                $.post(
//                    document.getElementById('path').value,
//                    { mode: "SMS", otid: $(this).attr("otid") },
//                    function (htmlResult) {
//                        $("#PopUpMAJ").remove();
//                        $("#container").append(htmlResult);
//                        $("#PopUpMAJ").dialog();
//                    }
//               );
//            }

//        });
//    });
//         

</script>
  <div id="container">
  <% using (Html.BeginForm("ListClientRdv", "RDV"))
     {%>
        <%: Html.ValidationSummary(true)%>
    <h2>Liste des clients pour un rendez-vous le <%: Model.periodeID %> </h2>
    <h2>N° Plan [<%:Model.planID %>]</h2>
    <%: Html.HiddenFor(m => m.planID)%>
    <%: Html.HiddenFor(m => m.periodeID)%>
    <%: Html.HiddenFor(m => m.OTID)%>
    <% Response.Write("<input type='hidden' id='path' value='"+ ViewData["path"].ToString() +"'>"); %>
  <table>
  <tr><td>Ordre</td><td><%: Html.TextBoxFor(m => m.NoBL)%></td> <td><input type="submit" id="submitBtn" value="Chercher" /></td></tr>
  </table>
    <%} %>
    <% 
         Response.Write(ViewData["content"]);
        
         %>

         </div>

</asp:Content>

