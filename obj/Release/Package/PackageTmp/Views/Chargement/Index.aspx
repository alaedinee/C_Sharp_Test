﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.ChargementModels>" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liste
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">

    $().ready(function () {
	$('#dateChargement').datepicker({ dateFormat: 'dd/mm/yy' });
        function aClick() {

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
                        $("#RemarqueOT").dialog({ width: 400 });



                    }
               );

            }


        }


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
        var gCard = $('#tableList tbody').delegate("a", "click", aClick);

        //oTable.fnPageChange(function () { alert('ok'); });

        //var  oLink = oTable.
        //        $("a").click(function () {
        //            if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewCom") {
        //                $.post(
        //                    "../OT/PopUpMAJViewMAJ",
        //                    { mode: "", otid: $(this).attr("otid") },
        //                    function (htmlResult) {
        //                        $("#PopUpMAJ").remove();
        //                        $("#container").append(htmlResult);
        //                        $("#PopUpMAJ").dialog();
        //                    }
        //               );
        //            }
        //            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewRemarques") {
        //                $.post(
        //                    "../OT/RemarqueOT",
        //                    { otid: $(this).attr("otid"), path: '../' },
        //                    function (htmlResult) {
        //                        $("#RemarqueOT").remove();
        //                        $("#container").append(htmlResult);
        //                        $("#RemarqueOT").dialog();
        //                        var divS = document.getElementsByTagName("div");
        //                        for (var i = 0; i < divS.length; i++) {
        //                            if ($(divS[i]).attr("role") != null) {
        //                                $(divS[i]).css("width", "400px");
        //                            }
        //                        }
        //                    }
        //               );
        //            }
        //        });


    });
         

</script>
 <div id="container"> 
    <% using (Html.BeginForm("Liste","Chargement")) {%>
        <%: Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Critéres de recherche</legend>
            <table>
            <tr>
            <td> <div class="editor-label">
              Date 
            </div></td><td>
            
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.dateChargement)%>
                <%: Html.ValidationMessageFor(model => model.dateChargement)%>
            </div>
           
           <%-- <ajaxControl:CalendarExtender ID="CalendarExtender2" runat="server">
            </ajaxControl:CalendarExtender>--%>
            </td>
            <td> <div class="editor-label">
               Code stock
            </div></td><td>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.Codestock) %>
            </div>
           </td>
           <td><div class="editor-label">
               Remarque
            </div></td>

           <td <div class="editor-field">
           <%: Html.TextBoxFor(m => m.remarque) %></div></td>
           <td><input type="submit" id="submitBtn" value="Chercher" /></td>
            </tr>
            </table>
            
        </fieldset>
        <fieldset>
        <legend>Chargement disponible</legend>
        <% if(ViewData["plantLibre"]!= null) Response.Write(ViewData["plantLibre"].ToString()); %>
        </fieldset>
        <% if (ViewData["plantLibre"]!= null && ViewData["linkNewPlan"] != "")
           {
           %>
        <%: Html.HiddenFor(m => m.actionPlan)%>
    
        <%} %>

    <% } %>
    </div>

    <script type="text/javascript">


         <% if (Model != null)
     Response.Write(""
         + "  if (document.getElementById('dateRdv').value == null || document.getElementById('dateRdv').value == \"\") {"
         + " document.getElementById('dateRdv').value ='" + Model.dateRdv + "';"
         + "}");%>

        function chargerSelect( val) {
            // $(this).attr("nobl");
           // alert('ok');
            document.getElementById('NoBL').value = val;
            document.getElementById('submitBtn').form.submit();
        }

       

        

        document.getElementById('actionPlan').value = "";
       
        function actionManip(form) {
            form.actionPlan.value = "add";
            form.submit();

        }


    </script>
    

</asp:Content>

