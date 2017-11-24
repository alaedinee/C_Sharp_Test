<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    System.Data.DataTable PrestAStatuer = (System.Data.DataTable)ViewData["PrestAStatuer"];
    string OTIDGroup = ViewData["OTIDGroup"].ToString();
    string isGroup   = ViewData["isGroup"].ToString();
%>
<style>
    .sp-input{ width: 140px;margin-left: 5px;}
</style>
<div id="sp_content">
    <fieldset>
        <legend>filter</legend>
        <table>
            <tr>
                <th>Perstation</th>
                <td>:
                    <select id="sp-prestation" class="sp-input">
                        <option value=""> -- </option>
                        <% foreach (System.Data.DataRow r in PrestAStatuer.Rows)
                           {
                               Response.Write("<option value=\"" + r["produit"].ToString() + "\">" + r["Designation"].ToString() + " (" + r["NbrPrestation"].ToString() + ")</option>");
                           } 
                        %>
                    </select>
                </td>
                <!-- -->
                <th>Statu</th>
                <td>:
                    <select id="sp-statu" class="sp-input">
                    </select>
                </td>
                <th></th>
                <td><input type="button" id="sp-btnOK" class="validerBtn sp-input" value="  Statuer  " /></td>
            </tr>
        </table>
    </fieldset>
    <br />
    <fieldset id="fs-sp-tabs">
        <legend></legend>
        <div id="div-tab-sp" style="width:100%; min-height: 300px;overflow: hidden;">    
            <ul></ul>
        </div>
    </fieldset>
</div>
<script>
    var OTIDGroup = '<%:OTIDGroup %>';
    var IS_Group = '<%:isGroup %>';//test  si group = 0 
    $(document).ready(function () {
        $("#sp-prestation").change(function () {
            var presation = $("#sp-prestation option:selected").val();
            $("#sp-statu option").remove();
            if (presation == "") return;
            //
            $.get($.fn.SERVER_HTTP_HOST() + "/OT/GetStatuAStatuer", { Prestation: presation }, function (data) {
                var status = data.split("#");
                $.each(status, function (i) {
                    var statu = status[i].split("@");
                    $('#sp-statu').append($('<option>', { value: statu[0], text: statu[1] + ' (' + statu[0] + ')' }));
                });
            });
        });
        // BT OK
        $("#sp-btnOK").click(function () {
            var presation = $("#sp-prestation option:selected").val();
            var presationtxt = $("#sp-prestation option:selected").text();
            var Statu = $("#sp-statu option:selected").val();
            var msg = "";
            if (presation == "")
                msg += "Prestation Vide !\n";
            if (Statu == "")
                msg += "Statu Vide !\n";
            if (msg != "") {
                alert(msg);
                return;
            }
            //
            $.get($.fn.SERVER_HTTP_HOST() + "/OT/GetPrestOrderedByStatus", { OTIDGroup: OTIDGroup, Prestation: presation, Statu: Statu , IsGroup: IS_Group }, function (data) {
                var tab = data.split("#");
                // initialize div tab
                $("#div-tab-sp").remove();
                $("#fs-sp-tabs").append("<div id='div-tab-sp' style='width:100%; min-height: 300px;'><ul></ul></div>");
                $("#fs-sp-tabs").find("legend").text(presationtxt);
                $.each(tab, function (i) {
                    var e = tab[i].split("@");
                    $("#div-tab-sp ul").append(
                        $('<li>')
                        .append($('<img>', { src: $.fn.SERVER_HTTP_HOST() + "/Images/" + (e[0] == "Y" ? "rendezvouspriscirclegreen16" : "npartagee") + ".png" }))
                        .append($('<a>', { href: "#tab-sp-" + e[0] + "-" + e[3], text: e[2] + ' (' + e[4] + ')' }))
                    );
                    // get content of div
                    /*$.get($.fn.SERVER_HTTP_HOST() + "/OT/GetPrestOrderedByStatus_DestStatu"
                        , { OTIDGroup: OTIDGroup, Prestation: presation, Statu: e[3], DestStatu: Statu, enabled: e[0] }
                        , function (Prestdata) {
                            $("#div-tab-sp").append(
                                $('<div>', { id: "tab-sp-" + e[0] + "-" + e[3] }).html(Prestdata)
                            );
                    });*/
                    $.ajax({
                        type: 'get',
                        url: $.fn.SERVER_HTTP_HOST() + "/OT/GetPrestOrderedByStatus_DestStatu",
                        data: { OTIDGroup: OTIDGroup, Prestation: presation, Statu: e[3], DestStatu: Statu, enabled: e[0], IsGroup: IS_Group },
                        success: function (Prestdata) {
                                $("#div-tab-sp").append(
                                    $('<div>', { id: "tab-sp-" + e[0] + "-" + e[3] }).html(Prestdata)
                                );},
                        async: false
                    });
                });
                $("#div-tab-sp").tabs();
            });
        });

    });
</script>