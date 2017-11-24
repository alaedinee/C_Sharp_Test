<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<% 
    string OTID = ViewData["OTID"].ToString();
    string PoidsMax = ViewData["PoidsMax"].ToString();    
%>
<style>
    #tbl-udp-poix-max
    {
        padding: 10px;
        margin: 10px;    
    }
    #tbl-udp-poix-max th, #tbl-udp-poix-max td
    {
        padding: 3px;  
        width: 50%;
    }
    #tbl-udp-poix-max td input
    {
        width: 100px;
    }
</style>
<div>
    <table id="tbl-udp-poix-max">
        <tr>
            <th>Pois Max</td>
            <td><input type="text" id="txt_EnterUPDPoidsMax" value="<%:PoidsMax %>" /></td>
        </tr>
        <tr>
            <th></td>
            <td><input type="button" id="btn_EnterUPDPoidsMax" data-id="<%:OTID %>" value="Modifier"></td>
        </tr>
    </table>
</div>
<script>
    function isNumeric(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }
    $(document).ready(function () {
        $("#btn_EnterUPDPoidsMax").unbind().click(function () {
            var id = $(this).attr("data-id");
            var poids = $("#txt_EnterUPDPoidsMax").val().replace(',', '.');
            if (!isNumeric(poids)) {
                alert("Poids invalide !");
                return;
            }
            if (parseFloat(poids) < 0) {
                alert("Poids doit etre supérieur a zéro !");
                return;
            }
            $.get($.fn.SERVER_HTTP_HOST() + "/OT/UpdatePoidsMax", { OTID: otid, poids: poids }, function (r) {
                if (r == '1') {
                    $("#div-modal-info").dialog('close');
                    // dossier groupe list
                    $.get($.fn.SERVER_HTTP_HOST() + "/OT/ListOTByGroup/", { OTIDGroup: OTIDG }, function (result) {
                        $('#div-tab-ot-group').html(result);
                    });
                    // dossier groupe info
                    $.get($.fn.SERVER_HTTP_HOST() + "/OT/InfoGroupe/", { OTIDGroup: OTIDG }, function (result) {
                        $('#div-tab-ot-info').html(result);
                    });
                }
                else
                    alert('Erreur !!');
            });
        });
    });
</script>