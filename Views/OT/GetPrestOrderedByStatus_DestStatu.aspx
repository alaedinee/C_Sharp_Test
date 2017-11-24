<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
<% 
    DataTable data = (DataTable)ViewData["data"];

    string OTIDGroup = ViewData["OTIDGroup"].ToString();
    string DestStatu = ViewData["DestStatu"].ToString();
    string Statu     = ViewData["Statu"].ToString();
    string isgroup = ViewData["isGroup"].ToString();
    string enabled = ViewData["enabled"].ToString();
    string lstName = "sp_PrestationList_" + enabled + "_" + Statu;
    string ChekName = "sp_ChekAll_" + enabled + "_" + Statu;
    string btName = "sp_BtValider_" + enabled + "_" + Statu;
%>
<div>
<% if (enabled == "Y"){ %>
    <p>
        <span> Cocher Tout <input type="checkbox" id="<%:ChekName %>" /></span>
        <input type="button" class="validerBtn" id="<%:btName %>" value="  Valider  " />
    </p>
<% } %>
    <%
        Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(data, lstName, "cellspacing='4' width='100%'"));
    %>
</div>
<script>
    $(document).ready(function () {
        var lstName = '#<%:lstName %>';
        var ChekName = '#<%:ChekName %>';
        var btName = '#<%:btName %>';
        var enabled = '<%:enabled %>';
        var DestStatu = '<%:DestStatu %>';
        var OTIDGroup = '<%:OTIDGroup %>';
        var is_Group = '<%:isgroup %>';

        $(lstName + " tr:first").append("<th>Action</th>");
        $(lstName + " tr[index]").each(function () {

                     if (!$(this).hasClass("affected")) {
                        // get id
                        var _ID = $(this).attr("index").split('#');
                        // add link to OT
                        var elem = $(this).find("td:first");
                        var val = elem.html();
                        var url = $.fn.SERVER_HTTP_HOST() + '/OT/afficherOT?mode=modifier&OTID=' + _ID[0];
                        elem.html("<a class='link' href='" + url + "' style='color:#E50051;cursor:pointer' target='_blank'>" + val + "</a>");
                        // add checkbox for select item
                        var cocher = "<td align='center' width='130'><input type='checkbox' sp-select-perst='"+ _ID[1] +"' /></td>";
                        if(enabled != 'Y')
                            cocher = "<td align='center' width='130'></td>"
                        $(this).append(cocher);

                        $(this).addClass("affected");
                    }
                 });

        var sp_PrestationList = $(lstName).not('.initialized').addClass('initialized').dataTable({
             sPaginationType: "full_numbers"
                , "oLanguage": {
                    "sProcessing": "Traitement en cours...",
                    "sLengthMenu": "Afficher _MENU_ éléments",
                    "sZeroRecords": "Aucun élément à afficher",
                    "sInfo": "Affichage de l'élement _START_ à _END_ sur _TOTAL_ éléments",
                    "sInfoEmpty": "Affichage de l'élement 0 à 0 sur 0 éléments",
                    "sInfoFiltered": "(filtré de _MAX_ éléments au total)",
                    "sInfoPostFix": "",
                    "sSearch": "Rechercher:",

                    "sUrl": "",


                    "oPaginate": {
                        "sFirst": "<<",
                        "sPrevious": "<",
                        "sNext": ">",
                        "sLast": ">>"
                    }

                },
             "fnDrawCallback": function (oSettings) {
                 

             },
             "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],             
             "iDisplayLength": 5, 
        });
        // check all item in grid
        $(ChekName).change(function () {
            var is_checked = this.checked;
            // $('input[sp-select-perst]').prop('checked', is_checked);
            var rows = sp_PrestationList.fnGetNodes();
            $(rows).each(function() {
                    $( this ).find('input[sp-select-perst]').prop('checked', is_checked);
            });
        });
        // btn valider
        $(btName).click(function () {
            var ids = '';
            var rows = sp_PrestationList.fnGetNodes();
            $(rows).each(function() {
                var chek = $( this ).find('input[sp-select-perst]');
                if($(chek).is(':checked'))
                    ids += (ids == '' ? '' : ',') + $(chek).attr("sp-select-perst");
            });
            if(ids == '') return;
            console.log("les ids = "+ids)
            $.get($.fn.SERVER_HTTP_HOST() + '/OT/setPerstationStatu', {ids: ids, etat: DestStatu, OTIDGroup: OTIDGroup , IsGroup: is_Group}, function (r) {
                if(r == "1")
                    $("#sp-btnOK").click();
                else
                    alert("Erreur !!");
            });
        });
    });
</script>