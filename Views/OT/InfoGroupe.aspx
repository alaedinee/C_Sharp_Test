<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string OTIDGroup = (string)ViewData["OTIDGroup"];
    string Poids    = (string)ViewData["Poids"];
    string Volume   = (string)ViewData["Volume"];
    string NbrOT    = (string)ViewData["NbrOT"];
    string PoidsMax = (string)ViewData["PoidsMax"]; 
%>
<div>
    <table border="0" width="100%" style="font-size: 24px; margin-top: 30px;">
        <tr>
            <th>Poids</th>
            <td><b><%:Poids %></b> KG</td>
        </tr>
        <tr>
            <th>Poids Max</th>
            <td><b><%:PoidsMax %></b> KG <input type="button" id="btn_UPDPoidsMax" data-id="<%:OTIDGroup %>" value=" Modifier " style="font-size: 12px;"></td>
        </tr>
        <tr>
            <th>Volume</th>
            <td><b><%:Volume%></b> M3</td>
        </tr>
        <tr>
            <th>Nombre Dossier</th>
            <td><b><%:NbrOT%></b></td>
        </tr>
    </table>
</div>
<div id="div-modal-info"></div>
<script>
function isNumeric(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}
$(document).ready(function () {
    var Poids = '<%:Poids %>'.replace(',', '.');
    var PoidsMax = '<%:PoidsMax %>'.replace(',', '.');
    var NbrOT = '<%:NbrOT%>';
    var percent = 0;
    if (isNumeric(Poids) && isNumeric(PoidsMax) && PoidsMax > 0) {
        percent = Math.ceil((Poids * 100 / PoidsMax));
    }
    var backcolor = percent > 100 ? "#CD0A0A" : "#7AB900";

    var spanTotal = '<span style="background-color: #2E8ECA; color: #fff; padding: 0px 7px; border-radius: 7px;">' + NbrOT + '</span>';
    var spanPercent = '<span style="background-color: ' + backcolor + '; color: #fff; padding: 0px 7px; border-radius: 7px;">' + percent + '%</span>';
    $("a[href='#div-tab-ot-group']").html("Liste Dossier " + spanTotal);
    $("a[href='#div-tab-ot-info']").html("Info Dossier " + spanPercent);

    $("#btn_UPDPoidsMax").unbind().click(function () {
        var otid = $(this).attr("data-id");
        $.get($.fn.SERVER_HTTP_HOST() + "/OT/EnterPoidsMax", { OTID: otid }, function (r) {
            // $('#div-modal').html("");
            $("#div-modal-info-content").remove();
            $("#div-modal-info").html("<div id='div-modal-info-content' title='Changer Poids Max'>" + r + "</div>");

            $("#div-modal-info").dialog({
                width: 300,
                height: 150,
                modal: true
            });
            $("#div-modal-info").dialog('option', 'title', 'Changer Poids Max');
        });
    });

});
</script>