<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	detailPlan
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<% 
    System.Data.DataTable dt = (System.Data.DataTable)ViewData["InfoRepture"];
%>
   <h4 class="erreur"> <%
        string isOpen = ViewData["isOpen"].ToString();
        if(ViewData["erreur"] != null)
            Response.Write(ViewData["erreur"]); 
         %></h4>
         <div style="overflow: hidden">
             <div style="float: left; width: 50%"><% Response.Write(ViewData["titre"].ToString());%></div>
             <div style="float: right; width: 50%; background-color: #E0E2E2">
                <table style="width: 100%" id="tbl_InfoRepture">
                    <tr>
                        <th>Sous Plan</th>    
                        <th>Periodes</th>    
                        <th>NbrDossier</th>     
                        <th>Poids</th>          
                        <th>Volume</th>         
                        <th>Imprimer</th>         
                    </tr>
                <% foreach(System.Data.DataRow r in dt.Rows){ %>
                    <tr>
                        <td repture="<%: r["Repture"].ToString() %>"> MISSION</td>
                        <td><%: r["NbrPeriodes"].ToString() %></td>
                        <td><%: r["NbrDossier"].ToString() %></td>
                        <td><%: r["Poids"].ToString() %></td>
                        <td><%: r["Volume"].ToString() %></td>
                        <td><a href="#" class="print-repture-plan-pdf" plan-target="<%:ViewData["id"].ToString() %>" repture-target="<%: r["Repture"].ToString() %>" style='margin-left:10px;'>PDF</a></td>
                    </tr>
                <% } %>
                </table>
             </div>
         </div>
          
         <table>
            <tr>
                <td>
                    <h3> <%= Html.ActionLink("Retour au Plans", "RedirectToPost/0/" + ViewData["DatePlan"].ToString().Replace("/","-").Replace(".","-"), "RDV")%></h3>
                </td>
                <td>
                    <h3><a style='margin-left:10px;' href="#" data-target="<% Response.Write(ViewData["id"].ToString()); %>" id="print-plan-pdf">PDF</a></h3>
                </td>
                <% if(isOpen == "1") { %>
                <td>
                    <h3><a href="#" id="finPlannif" style='margin-left:10px;'>Fin Planification</a></h3>
                </td>
                <% } %>
            </tr>
        </table> 
    <% Response.Write(ViewData["periodePlan"]); %>

            <div id="contrClone" title=""></div>
            <div id="contrDgArt"></div>
    <script type="text/javascript">
        var Ndate = new Date();
        var strDay = ((Ndate.getDate() < 10)? "0" + Ndate.getDate() : Ndate.getDate()) + '-' +  ((Ndate.getMonth() + 1 < 10)? "0" + (Ndate.getMonth() + 1) : Ndate.getMonth() + 1) + '-' + Ndate.getFullYear();
        var datePlan  = "<% Response.Write(ViewData["DatePlan"].ToString()); %>";
        var idPlan= '<%: ViewData["id"].ToString() %>';
        
        $(document).ready(function () {
            $("a[type='delPeriode']").click(function () {
                var _conf = confirm("Confirmer la suppression ?");
                if (_conf == false) return false;
            });

            $("a[type='recPeriode']").click(function () {
                document.location.href = SERVER_HTTP_HOST() + "RDV/Reclamation?id=0&otid=" + $(this).attr("OTID") + "&planid=" + $(this).attr("planID");
            });

            $("a[type='showRecPeriode']").click(function () {
                document.location.href = SERVER_HTTP_HOST() + "RDV/Reclamation?id=" + $(this).attr("ID");
            });

            $("#clonePlan").click(function () {
                if (confirm("Voulez vous vraiment cloner ?") == false) {
                    event.preventDefault();
                    return;
                }

                $("#dialog").remove();
                $("#contrClone").html("<div id='dialog' title='Cloner Plan'>"
                        + "<table>"

                        + "<tr>"
                        + "<td>Plan Date</td>"
                        + "<td><input type='text' id='dateDest' /></td>"
                        + "</tr>"

                        + "<tr>"
                        + "<td align='right' colspan='2'><input type='button' value='Valider' id='btnvalidateClone' /></td>"
                        + "</tr>"

                        + "</table>"
                        + "</div>");

                $('#dateDest').datepicker({ dateFormat: 'dd/mm/yy' });
                $("#ui-datepicker-div").addClass("D1");
                $("#dialog").addClass("Date");

                $("#btnvalidateClone").click(function () {
                    $.post(SERVER_HTTP_HOST() + "RDV/clonePlan", { id: '<%: ViewData["id"].ToString() %>', date: $("#dateDest").val() }, function (htmlResult) {
                        if (parseInt(htmlResult) > 0) {
                            alert("Clonage faite avec succès ");
                            document.location.href = SERVER_HTTP_HOST() + "RDV/detailPlan/" + htmlResult;
                        }
                        else
                            alert("Erreur clonage !");
                    });
                });

                $("#dialog").dialog({
                    height: 200,
                    width: 350,
                    modal: true
                });

                event.preventDefault();
            });            

            $.fn.getDateNow = function(){
              var dt = new Date() ;
                var month = dt.getMonth() + 1;
                var currentTime = ((dt.getDate()<10)? "0" + dt.getDate() : dt.getDate())   + "-" + ((month < 10)? "0" + month : month) +  "-" + dt.getFullYear()  ;

                return currentTime;
            };
            

            $("a[Periode]").click(function(){
                
                if($(this).attr("type") == "delPeriode")
                {
                    if(datePlan == $.fn.getDateNow()){
                        alert("Action impossible !");
                        return false;
                    }
                }

            });

            var i = 0;
            $('#finPlannif').unbind('click').click(function (){
                $.get(SERVER_HTTP_HOST() + "/RDV/FinPannification", {id: idPlan}, function(result){
                    if(result == '1')
                        document.location.reload();
                    else
                        alert('Erreur !!');
                });
                
            });
            $('#print-plan-pdf').unbind('click').click(function (){
                $.get(SERVER_HTTP_HOST() + "/RDV/optionPrintPlan", {id: idPlan}, function(htmlResult){
                    $("#contrDgArticle").remove();
                        $("#contrDgArt").html("<div id='contrDgArticle' title='Option D&apos;Impression'>" + htmlResult + "</div>");
                        $("#contrDgArticle").dialog({
                            width: 400,
                            height: 400,
                            modal: true
                        });
                });                
            });

            ///////////////////////////////////////////////////////////////////////////////////////////
            ////////////////////////////////////// REPTURE DE CHARGE //////////////////////////////////
            ///////////////////////////////////////////////////////////////////////////////////////////
            // initialize button
            var repColor = [ "#FF0000", "#FFA500", "#0000FF", "#C0C0C0", "#008B8B", "#00FFFF", "#FF00FF", "#800000", "#808000", "#FFFF00", "#008000", "#800080", "#008080", "#000080", "#FF00FF", "#FFE4B5", "#FFD700" ]
            var tabRepture = [];
            $("#tableList").find("td[repture]").each(function () {
                var repture = $(this).attr("repture");
                var indexTR = $(this).closest("tr").attr("index");
                var btn = (repture == "-1") ? 
                  "<button event='addRepture' class='buttonRepture' style='background-color: #4CAF50'>+ MISSION</button>" 
                : "<button class='buttonRepture' style='background-color:" + repColor[repture] + "'>MISSION "+ (parseInt(repture) + 1) +"</button>";
                if(indexTR != "-1")
                {
                    $(this).html(btn);
                    if(parseInt(repture) >= 0 && !tabRepture.includes(parseInt(repture)))
                        tabRepture.push(parseInt(repture));
                }
            });
            // delete button
            if(tabRepture.length > 0)
            {
                $("#tableList").find("td[repture="+  Math.max.apply(null, tabRepture) +"] > button").each(function () {
                    var txt = $(this).attr("event", "deleteRepture").text();
                    $(this).text("x " + txt);
                });
            }
            // event button
            $("#tableList").find("button[event]").unbind('click').click(function(){
                var event = $(this).attr("event");
                var periode = $(this).closest("tr").attr("periode").replace("-", "").replace("-", "");
                    
                if(event == "addRepture")
                {
                     $.get(SERVER_HTTP_HOST() + "/RDV/addRepture", {idPlan: idPlan, periode: periode}, function(result){
                        if(result == "1")
                            location.reload();
                        else
                            alert("Erreur !!");
                     });
                }
                else if(event ==  "deleteRepture")
                {
                    var ReptureNum = $(this).closest("td").attr("repture");
                    $.get(SERVER_HTTP_HOST() + "/RDV/deleteRepture", {idPlan: idPlan, ReptureNum: ReptureNum}, function(result){
                        if(result == "1")
                            location.reload();
                        else
                            alert("Erreur !!");
                     });
                }
            });
            // Info Repture
            $("#tbl_InfoRepture").find("td[repture]").each(function () {
                var repture = $(this).attr("repture");
                $(this).css("padding-left", "5px");
                if(repture == "-1")
                {
                    $(this).text("HORS MISSION");
                    $(this).closest("tr").css( "background-color", "#4CAF50" );
                }
                else
                {
                    $(this).text($(this).text() + " " + (parseInt(repture) + 1));
                    $(this).closest("tr").css( "background-color", repColor[repture] );
                }                
            });
            // Imprimer Repture            
            $('.print-repture-plan-pdf').unbind('click').click(function (){
                var repture = $(this).attr("repture-target");
                $.get(SERVER_HTTP_HOST() + "/RDV/optionPrintPlan", {id: idPlan, repture: repture}, function(htmlResult){
                    $("#contrDgArticle").remove();
                        $("#contrDgArt").html("<div id='contrDgArticle' title='Option D&apos;Impression'>" + htmlResult + "</div>");
                        $("#contrDgArticle").dialog({
                            width: 400,
                            height: 400,
                            modal: true
                        });
                });                
            });
            ///////////////////////////////////////////////////////////////////////////////////////////
            ////////////////////////////////////// REPTURE DE CHARGE //////////////////////////////////
            ///////////////////////////////////////////////////////////////////////////////////////////
        });
    </script>

    <style>
        .Date {
            z-index:-1;
        }
    
            .D1
        {
            z-index:10000000;
            position :absolute;
        }
        .buttonRepture {
            border: none;
            color: white;
            padding: 0px 8px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
            margin: 4px 2px;
            cursor: pointer;
            font-weight: bold;
        }
        #tbl_InfoRepture th
        {
            text-align: left;
        }
        #tbl_InfoRepture td
        {
            color: #fff;
            font-size: 12px;
            font-weight: bold;
        }
    </style>

</asp:Content>

