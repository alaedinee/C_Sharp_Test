<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    
    string idPlans = ViewData["idPlans"].ToString();
    string OTID = ViewData["OTID"].ToString();
    string idPeriode    = ViewData["idPeriode"].ToString();
    string pr           = ViewData["pr"].ToString();
    string type = ViewData["OTType"] == null ? null : ViewData["OTType"].ToString();
    
    System.Data.DataTable OTData = (System.Data.DataTable)ViewData["dataGroupe"];
    int _OTNbrCol = OTData.Columns.Count;
    System.Data.DataTable OTDataJoin = (System.Data.DataTable)ViewData["dataJoin"];
    int _OTNbrColJoin = OTData.Columns.Count; 
    
    
    %>
 <div>

                <table>
                    <tr>
                        <td>Nombre Periode : </td>
                        <td><input type="text" id="per_nec" value="<%:pr %>" /></td>
                    </tr>
                    <% if (type != null)
                    { %>
                        <tr>
                            <td>Type Groupe : </td>
                            <td id="type-groupe-container"></td>
                        </tr>
                    <% } %>
                    <tr>
                        <td></td>
                        <td><input type="button" id="btn_Affecter" class="validerBtn" value="Affecter" style="margin-top: 5px"></input></td>
                    </tr>
                </table>
                <br />
            <div id="tabsGroupeJoin" style="width:100%; min-height: 300px">
              <ul>
                <li><a href="#tabs-gj-1">Dossier Group (<%: OTData.Rows.Count %>)</a></li>
                <li><a href="#tabs-gj-2">Dossier Join (<%: OTDataJoin.Rows.Count %>)</a></li>
              </ul>


                <div id="tabs-gj-1">
                    <fieldset >    
                        <legend>Dossier Group (<%: OTData.Rows.Count %>)</legend>  
                        <%
                            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTData, "dataGroupe", "cellspacing='4' width='100%'"));
                            %>
                    </fieldset>
                </div>
                <div id="tabs-gj-2">

                    <fieldset >    
                        <legend>Dossier Join (<%: OTDataJoin.Rows.Count %>)</legend>  
                        <%
                            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTDataJoin, "dataJoin", "cellspacing='4' width='100%'"));
                            %>
                    </fieldset>
                </div>
            </div>

<script type="text/javascript">
    $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>';
        var _OTID = '<%: OTID %>';
        var _idPlans = '<%: idPlans %>';
        var _idPeriode = '<%: idPeriode %>';

        $("#tabsGroupeJoin").tabs();

        var table = $("#dataGroupe").not('.initialized').addClass('initialized').DataTable({
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
                $("#dataGroupe tr[index]").each(function () {
                    var _ID = $(this).attr("index");
                    var _tdcount = $(this).find("td");

                    if (!$(this).hasClass("affected")) {
                        var elem = $(this).find("td:first");
                        var val = elem.html();
                        elem.html("<a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

//                        var elem1 = $(this).find("td:eq(1)");
//                        val = elem1.html();
//                        elem1.html("<a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                        $(this).addClass("affected");
                    }
                });
                $(this).find("a[OTEditEvent]").unbind('click').click(function () {
                    var _OTID = $(this).attr("OTEditEvent");
                    var url = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _OTID;
                    var win = window.open(url, '_blank');
                    win.focus();
                });
            },
            "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
            "iDisplayLength": 10,
        });
        

        $("#btn_Affecter").unbind('click').click(function () {                        
            var per_nec = $('#per_nec').val();
            var ottype = null;
            if($('#typeGroupeOT'))
                ottype = $('select[name="typeGroupeOT"]').val();

            if (per_nec != null && !isNaN(per_nec)) {
                $.get(
                    $.fn.SERVER_HTTP_HOST() + "/RDV/InsertToPeriode/?" + $.param({ OTID: _OTID, pr: per_nec, PeriodeID: _idPeriode, PlanID: _idPlans, typeGroupe: ottype, AvecRemplacementOT: "", causeRetard: "" }),
                    function (result) {
                        if (result == '1')
                            location.href = $.fn.SERVER_HTTP_HOST() + "/RDV/detailPlan/" + _idPlans;
                        else
                            alert('Erreur !!');
                    }
                );
            }
        });

        $.get($.fn.SERVER_HTTP_HOST() + "/OT/getOTGroupeType", function(r){
            var _typeGOTs = r.split(',');
            var elm = "";
            for(var i = 0; i < _typeGOTs.length; i ++)
            {
                var _typeGOT = _typeGOTs[i].split('|');
                elm += "<option value='"+ _typeGOT[0] +"' " + (_typeGOT[0] == '<%:type %>' ? " selected " : "") + ">"+ _typeGOT[1] +"</option>"
            }                      

            $("#type-groupe-container").html("<select name='typeGroupeOT'>"  + elm + "</select>");
        });
        /////////////////////////////////////////// data Join /////////////////////////////////////////////
        
        var dataJoin = $("#dataJoin").not('.initialized').addClass('initialized').dataTable({
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
                 $("#groupeList tr[index]").each(function () {

                     if (!$(this).hasClass("affected")) {
                            var elem = $(this).find("td:first");
                            var val = elem.html();
                            var _ID = $(this).attr("index");
                            var url = $.fn.SERVER_HTTP_HOST() + '/OT/afficherOT?mode=modifier&OTID=' + _ID;

                            elem.html("<a class='link' href='" + url + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");
                            $(this).addClass("affected");
                        }
                 });

             },
             "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
             
             "iDisplayLength": 5, 

         });


        /////////////////////////////////////////// data Join /////////////////////////////////////////////


    });

</script>
</div>