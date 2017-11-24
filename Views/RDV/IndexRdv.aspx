<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.Objects.RDV.RDVModels>" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	IndexRdv
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    string fromPeriode = (ViewData["fromPeriode"] != null) ? ViewData["fromPeriode"].ToString() : "";
    string toPeriode = (ViewData["toPeriode"] != null) ? ViewData["toPeriode"].ToString() : "";
%>

<style type="text/css">
 
#vars li 
{
    cursor:pointer;
}  
  
#vars li:hover
{
    color:blue;
}
  
 
 #menuOT
 {
       float:left;
       margin-left:-20px;
       margin-top:-55px;
       padding-bottom:30px;
 }
 
 ul#menuOT  {
 margin:0;
 padding:0;

 }
 ul#menuOT li {
 float:left;
 list-style: none;
 padding:0;
 text-decoration:none;
 background-color:#58ACFA;
 }
 ul#menuOT li a {
 display:block;
 width:80px;
 color:white;
 height:22px;
 text-decoration:none;
 padding:7px;
 font-family:Verdana;
 font-style:oblique;
 font-size:small;
 }
 ul#menuOT li a:hover {
 background-color:#81BEF7;
 }
 .pause-field-display
 {
     width: 105px;
     display: inline-block;
 }
 .pause-field-display input[type="text"], .pause-field-display label
 {
     width: 50px;
 }
</style>
<br />
<%--<ul id="menuOT" >
    <li><a class="lienHyper" href="../RDV/PlanningSystem" style="width:130px">Planning Système</a></li>
    <li style="margin-left:14px"><a class="lienHyper" style="margin-left:14px" href="../Ajout/DayListe">Day Liste</a></li>
</ul>--%>

<br clear="all" />
<%
    string TypeValues = "";
    
    System.Data.DataTable lstTypes = (System.Data.DataTable)ViewData["TypeTournees"];
                                if (lstTypes != null)
                                {
                                    for (int i = 0; i < lstTypes.Rows.Count; i++)
                                    {
                                        System.Data.DataRow row = lstTypes.Rows[i];
                                        TypeValues += "<option value='" + row["name"].ToString() + "'>" + row["name"].ToString() + "</option>";
                                    }
                                }
                                
 %>
<script type="text/javascript">

    function decodeHtml(html) {
        var txt = document.createElement("textarea");
        txt.innerHTML = html;
        return txt.value;
    }

    var strType = decodeHtml('<%: TypeValues %>');

    $(document).ready(function () {
        $("#btnAddNewPlan").click(function () {

            $("#dialog").remove();
            $("#contr").html("<div id='dialog' title='Ajouter nouveau plan'> " +
                     "<div class='editor-label'> Du </div>" +
                     "<div class='editor-field'>" +
                     "  <input type='text' id='txt_from'  value='" + $("#fromPeriode").val() + "' /> " +
                     "</div>" +

                     "<div class='editor-label'> Au </div>" +
                     "<div class='editor-field'>" +
                     "  <input type='text' id='txt_to' value='" + $("#toPeriode").val() + "' /> " +
                     "</div>" +

                     "<div class='editor-label'> Type </div>" +
                     "<div class='editor-field'>" +
                     "  <select id='lst_type_tournees'> " + strType + " </select>" +
                     "</div>" +

                     "<div class='editor-label'> Pause </div>" +
                     "<div class='editor-field' style='width: 250px;margin-left: 20px;'>" +
                     "  <div class='pause-field-display'><label>début pause</label> <input type='text' id='txt_pause_from'  value='12:00' /></div>" +
                     "  <div class='pause-field-display'><label>Nombre Périodes</label> <input type='text' id='txt_pause_nbrPeriodes'  value='2' /></div>" +
                     "</div>" +

                     "<div class='editor-label'> Remarque </div>" +
                     "<div class='editor-field'>" +
                     "  <input type='text' id='txt_rem' value='' /> " +
                     "</div>" +

                     "<br />" +
                     "<input type='button' id='btn_validate_plan' value='Ajouter' />" +
                     "</div>");

            $("#dialog").dialog({
                height: 300,
                width: 300,
                modal: true
            });

            $("#btn_validate_plan").click(function () {
                $("#from").val($("#txt_from").val());
                $("#to").val($("#txt_to").val());
                $("#rem").val($("#txt_rem").val());
                $("#type").val($("#lst_type_tournees option:selected").val());
                $("#pause_from").val($("#txt_pause_from").val());
                $("#pause_nbrPeriodes").val($("#txt_pause_nbrPeriodes").val());
                $("#dialog").remove();

                document.forms[0].actionPlan.value = "add";
                document.forms[0].submit();
            });
        });


        $('#dateRdv').datepicker({ dateFormat: 'yy/mm/dd' });

        $("a[type='delPlan']").click(function () {
            var _conf = confirm("Confirmer la suppression ?");
            if (_conf == false) return false;
        });


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


        $("#btn_evaluate").click(function () {
            $("#tableList tr[index]").each(function () {
                var _id = $(this).attr("index");
                var elem = $(this);
                elem.find("td:eq(6)").html("<img src='../Content/template/loading.gif' width='32' border='0' />");
                elem.find("td:eq(7)").html("<img src='../Content/template/loading.gif' width='32' border='0' />");

                $.get("../RDV/getPlanDistanceBy", { id: _id },
                    function (htmlResult) {
                        var tab = htmlResult.split("|");
                        if (tab[0] == "") tab[0] = "0";
                        if (tab[1] == "") tab[1] = "0";

                        elem.find("td:eq(6)").html(tab[0]);
                        elem.find("td:eq(7)").html(tab[1]);
                    }
               );
            });
        });

        /*
        $("#tableList tr td a[sendGps]").click(function () {
            var _id = $(this).attr("sendGps");
            $.get("../RDV/sendPlanGps", { id: _id }, function (htmlResult) {
                alert(htmlResult);
            });
        });
        */

        $("#tableList tr td a[evaluer]").click(function () {
            var _id = $(this).attr("evaluer");
            var elem = $(this).closest("tr");
            elem.find("td:eq(6)").html("<img src='../Content/template/loading.gif' width='32' border='0' />");
            elem.find("td:eq(7)").html("<img src='../Content/template/loading.gif' width='32' border='0' />");

            $.get("../RDV/getPlanDistanceBy", { id: _id }, function (htmlResult) {
                var tab = htmlResult.split("|");
                if (tab[0] == "") tab[0] = "0";
                if (tab[1] == "") tab[1] = "0";

                elem.find("td:eq(6)").html(tab[0]);
                elem.find("td:eq(7)").html(tab[1]);

            });
        });

        $("#tableList tr td a[cOpen]").click(function () {
            var _id = $(this).attr("cOpen");
            var _act = $(this).attr("cOpenType");


            $.get("../RDV/savePlanEtat", { id: _id, act: _act }, function (htmlResult) {
                if (htmlResult == "1")
                    $("#submitBtn").click();
                else if (htmlResult != "-1")
                    alert("Erreur !");
            });
        });


        $("#tableList tr[index]").each(function () {

//            var planID = $(this).attr("index");

//            var elem = $(this);

//            $.ajax({
//                url: SERVER_HTTP_HOST() + "RDV/PeriodePlanStatus",
//                data: { PlanID: planID, Periode: "" }
//            }).done(function (msg) {

//                if (msg.indexOf("yellow") >= 0) {
//                    $(elem).css("background-color", "yellow");
//                    $(elem).css("color", "#000");
//                }

//            });

        });

//        var oTable = $("#tableList").dataTable({
//            "oLanguage": {
//                "sLengthMenu": "Afficher _MENU_ Lignes par page",
//                "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
//                "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
//                "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
//                "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
//            },

//            "sPaginationType": "full_numbers"
//        });



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
    <input type="hidden" id="fromPeriode" value="<%: fromPeriode %>" />
    <input type="hidden" id="toPeriode" value="<%: toPeriode %>" />
  

    <% using (Html.BeginForm("IndexRdv","RDV")) {%>
        <%: Html.ValidationSummary(true) %>

        <%: Html.HiddenFor(model => model.from )%>
        <%: Html.HiddenFor(model => model.to )%>
        <%: Html.HiddenFor(model => model.rem )%>
        <%: Html.HiddenFor(model => model.type )%>
        <%: Html.HiddenFor(model => model.pause_from )%>
        <%: Html.HiddenFor(model => model.pause_nbrPeriodes)%>

        <fieldset>
            <legend>Critéres de recherche</legend>
            <table style="float:left;">
            <tr>
            <td> <div class="editor-label">
              Date 
            </div></td><td>
            
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.dateRdv )%>
                <%: Html.ValidationMessageFor(model => model.dateRdv)%> 
             
            </div>
           
           <%-- <ajaxControl:CalendarExtender ID="CalendarExtender2" runat="server">
            </ajaxControl:CalendarExtender>--%>
            </td>
            <td> 
                <div class="editor-label" style="display:none;">N° Bulletin</div>
            </td>
            <td> 
                <div class="editor-field" style="display:none;"> <%: Html.TextBoxFor(model => model.NoBL) %> <%: Html.ValidationMessageFor(model => model.NoBL) %></div>
           </td>
           <td>
                <div class="editor-label" style="display:none;">Client/NP</div>
           </td>
           <td 
                <div class="editor-field" style="display:none;"> <%: Html.TextBoxFor(m => m.client) %> </div>
           </td>

           <td><div class="editor-label" style="display:none;">
               Plan/NP
            </div></td>

           <td <div class="editor-field" style="display:none;">
           <%: Html.TextBoxFor(m => m.plan) %></div></td>

           <td><input type="submit" id="submitBtn" value="Chercher" /></td>
            
            <!-- <td><input type="button" id="btn_gpsPlan" value="GPS" /></td> -->

            </tr>
            </table>
            
            <% 
            
				if(Model != null && Model.dateRdv != null){
         %>
            <div style="text-align:right; float:right"><a href="../RDV/RdvExportPalnning?date=<%: Model.dateRdv %>" target="_blank"><img align='center' src='../Images/excel_icon.png' width='32' /> Exporter Planning Excel</a></div>
            
         <%
				}
           %>
            
        </fieldset>
        <fieldset>
        <legend>Plans disponible</legend>
        <% 
            if (ViewData["plantLibre"] != null) {  
				if(Model != null && Model.dateRdv != null){
         %><%----%>
            <div style="text-align:right; margin-right:20px"><a href="../RDV/RdvExport?date=<%: Model.dateRdv %>&nobl=<%: Model.NoBL %>&client=<%: Model.client %>" target="_blank"><img align='center' src='../Images/excel_icon.png' width='32' /> Exporter Excel</a></div>
            
         <%
				}
                Response.Write(ViewData["plantLibre"].ToString()); 
        %>
             <br />
        <%--<div style="text-align:right;"><a id="btn_evaluate" style="cursor:pointer;color:blue"> Evaluer Distances</a></div>--%>
        <%                
            }
         %>
        </fieldset>
        <% if (ViewData["plantLibre"]!= null && ViewData["linkNewPlan"] != "" && Model.dateRdv != "")
           {
           %>
        <%: Html.HiddenFor(m => m.actionPlan)%>
        <input type="button" value="Nouveau Plan" id="btnAddNewPlan" />
    
        <%} %>

    <% } %>
    <fieldset>
        <legend>Dossier a plannifier</legend>
        <div id="lst_ot_to_affect"></div>
    </fieldset>
    </div>

    <div id="contr"></div>
    <div id="contrDgArt"></div>
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

        // document.getElementById('actionPlan').value = "";
       
        function actionManip(form) {
            form.actionPlan.value = "add";
            form.submit();

        }

        var dateRdv = $('#dateRdv').val();
        if(dateRdv != null && dateRdv != '')
        {
            dateRdv = dateRdv.replace("/", "-").replace("/", "-") + "_00-00";
            $.get(SERVER_HTTP_HOST() + "/RDV/ListClientRdv", {id: '-1', date: dateRdv}, function (result){
                $('#lst_ot_to_affect').html($(result).find('#OTListField'));
            });
        }

        
        $(document).ready(function () {
            $('.print-plan-pdf').unbind('click').click(function (){
                $.get(SERVER_HTTP_HOST() + "/RDV/optionPrintPlan", {id: $(this).attr("data-target")}, function(htmlResult){
                    $("#contrDgArticle").remove();
                        $("#contrDgArt").html("<div id='contrDgArticle' title='Option D&apos;Impression'>" + htmlResult + "</div>");
                        $("#contrDgArticle").dialog({
                            width: 400,
                            height: 400,
                            modal: true
                        });
                });                
            });
        });

    </script>
    

</asp:Content>

