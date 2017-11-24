<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<%
    
    var _CliChargID = ViewData["CliChargID"];
    var _CliChargClt = ViewData["CliChargNom"] + "," + ViewData["CliChargCode"];
    var _CliChargAdr = ViewData["CliChargAdr"];
    var _CliChargNpVille = ViewData["CliChargNp"] + "," + ViewData["CliChargVille"]; ;
    var _CliChargPays = ViewData["CliChargPays"];
    var _CliChargTel = ViewData["CliChargTel"];
    //var _CliChargDateCharg = ViewData["CliChargDateCharg;

    var _chargID = ViewData["ChargID"];

    var _cliChargMode = ViewData["cliChargMode"].ToString();
    
%>


<div id="CliCharg_div">
    

        <%--<input type="button" id="CliChargAdd" value="<%: (_CliChargClt == "") ? "Sélectionner" : _CliChargClt %>" />--%>

        <div id="CliChargDivInfos">

            <table>

            <% if (_cliChargMode == "modifier" || _cliChargMode == "ajouter")
                    {
                        %>
                <tr>
                    <td>
                        <span>
                            <input type="button" id="CliChargChercher" value=" Chercher " />: 
                        </span>
                    </td>
                    <td>
                        <input type="text" id="CliChargTxtSearchCode" value="" placeholder="cherchez par code ..." />

                   
                        <span id="CliChargLblCltNom"></span>
                        <input type="hidden" id="CliChargTxtCltID" value="" />
                    </td>
                </tr>

                <% } %>

                <tr>
                    <td>Client:</td>
                    <td>
                        <input type="text" id="CliChargClt" value="<%: (_CliChargClt == "") ? "" : _CliChargClt %>" />
                        <input type="hidden" id="CliChargID" value="<%: (_CliChargID == "") ? "0" : _CliChargID %>" /></td>
                </tr>

                <tr>
                    <td>Adresse :</td>
                    <td>
                        <input type="text" id="CliChargAdr" value="<%: (_CliChargAdr == "") ? "" : _CliChargAdr %>" /></td>
                </tr>

                <tr>
                    <td>NP, Ville :</td>
                    <td>
                        <input type="text" id="CliChargNpVille" value="<%: (_CliChargNpVille == "") ? "" : _CliChargNpVille %>" /></td>
                </tr>

                <tr>
                    <td>Pays :</td>
                    <td>
                        <input type="text" id="CliChargPays" value="<%: (_CliChargPays == "") ? "" : _CliChargPays %>" /></td>
                </tr>

                <tr>
                    <td>Tél. :</td>
                    <td>
                        <input type="text" id="CliChargTel" value="<%: (_CliChargTel == "") ? "" : _CliChargTel %>" /></td>
                </tr>

                 <%--<tr>
                    <td>Date chargement :</td>
                    <td>
                        <input type="text" id="CliChargDateLiv" value="<%: (_CliChargDateCharg == "") ? "" : _CliChargDateCharg %>" /></td>
                </tr>--%>

                 


            </table>

        </div>
    
</div>


<script type="text/javascript">
    $().ready(function () {

        var _CliChargClt = '<%: _CliChargClt %>';

        $("#cliChargAcc").text("Chargement : " + _CliChargClt);

        /////////////////HEUR - Date ....//////////////////////
        //$('#CliChargDateLiv').datepicker({ dateFormat: 'dd/mm/yy' });
        //////////////////////////////////////////////



        ////////////////Auto Complete/////////////////

        //$("#CliChargClt").autocomplete({  //Auto complete Client livraison
        //    source: function (request, response) {
        //        $.ajax({
        //            url: $.fn.SERVER_HTTP_HOST() + "/Client/getClientLivriason",
        //            dataType: "json",
        //            type: "POST",
        //            data: { type: "c", term: request.term },
        //            success: function (data) {
        //                response($.map(data, function (item) {
        //                    return {
        //                        value: item.value,
        //                        key: item.key
        //                    };
        //                }));
        //            }
        //        });
        //    },
        //    minchar: 2,
        //    select: function (event, ui) {
        //        var _tp = ui.item.value;
        //        $("#CliChargClt").val(ui.item.value); 
        //        $("#CliChargID").val(item.key);
        //        return false;
        //    }
        //});


        /////////////////////////////////////////////

        /////////////////ALLER/RETOUR////////////////

        $("#CliChargChercher").click(function () {

            
            //alert(_stepNextGetIntv);
            //alert("Current step " + _stepGetIntv);
            //alert("Next step " + _stepNextGetIntv);

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessources", { cliFamille: 'c', lbl: 'CliChargLblCltNom|Nom', txt: 'CliChargTxtCltID' },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");

                    $("#cliDGress").remove();
                    $("#cliDG").html("<div id='cliDGress' title='Liste des clients: chargement'>" + data + "</div>");
                    $("#cliDGress").dialog({
                        width: 500,
                        height: 500,
                        modal: true,
                        // position: 'top',

                    });

                    $("#cliDGress").dialog("option", "position", [600, 500]);
                    $(".ui-dialog").resize();

                 });
        });





        ////////////////////////////////////////////

                    $("#CliChargID").attr("readonly", true);
                    $("#CliChargClt").attr("readonly", true);
                    $("#CliChargAdr").attr("readonly", true);
                    $("#CliChargNpVille").attr("readonly", true);
                    $("#CliChargPays").attr("readonly", true);
                    $("#CliChargTel").attr("readonly", true);
                    $("#CliChargFax").attr("readonly", true);

        //////////////////////////Chercher Par Code///////////////////////////

        $("#CliChargTxtSearchCode").keypress(function (e) {
            var key = e.which;
            if (key == 13) {

                var _valChargCode = $("#CliChargTxtSearchCode").val();
                //alert(_valCode);
                if (_valChargCode == "-") {
                    $("#CliChargTxtCltID").val("-1");
                    $("#CliChargLblCltNom").text("");
                }
                else {
                    $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByCode", { cliFamille: 'c', valChargCode: _valChargCode }, function (data) {

                        if (data == "") {
                            //alert("Code introuvable");
                            $("#CliChargLblCltNom").text("Ce code n'existe pas");
                        }
                        else if (data != null && data != "") {
                            var infosDonneur = data.toString().split('*');
                            $("#CliChargTxtCltID").val(infosDonneur[0]).trigger('change');
                            $("#CliChargID").val(infosDonneur[0])
                            $("#CliChargLblCltNom").text(infosDonneur[1]);
                        }
                        else
                            alert("error");
                    });
                }
            }
        });

        ///////////////////////////////////////////////////


        //////////////////////////Detecte changement ID///////////////////////////

        $("#CliChargTxtCltID").change(function () {
            //alert("detecte change");
            var _cliChargValID = $("#CliChargTxtCltID").val();
            //alert(_valID);

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByID", { cliFamille: 'c', valID: _cliChargValID }, function (data) {
                if (data.toString() != "") {
                    //alert(data);
                    var dtChargement = data.toString().split('*');

                    $("#CliChargID").val(dtChargement[0]);
                    $("#CliChargClt").val(dtChargement[1] + "," + dtChargement[2]);
                    $("#CliChargAdr").val(dtChargement[3]);
                    $("#CliChargNpVille").val(dtChargement[4] + "," + dtChargement[5]);
                    $("#CliChargPays").val(dtChargement[6]);
                    $("#CliChargTel").val(dtChargement[7]);
                    //alert($("#tlfDonneur").val());
                    //alert($("#txt_cltCodeDonn").val());

                }
            });

        });

        //////////////////////////////////////////////////






    });
</script>
