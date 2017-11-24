<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    
    var _cliDonneurID = ViewData["cliDonneurID"];
    var _cliDonneurClt = ViewData["cliDonneurNom"] + "," + ViewData["cliDonneurCode"];
    var _cliDonneurAdr = ViewData["cliDonneurAdr"];
    var _cliDonneurNpVille = ViewData["cliDonneurNp"] + "," + ViewData["cliDonneurVille"];
    var _cliDonneurPays = ViewData["cliDonneurPays"];
    var _cliDonneurTel = ViewData["cliDonneurTel"];
    var _cliDonneurFax = ViewData["cliDonneurFax"];
    var _cliDonneurMail = ViewData["cliDonneurMail"];
    

    var _cliDonnMode = ViewData["cliDonnMode"].ToString();
    
     %>


<div id="magDonneur_div">


        <%--<input type="button" id="cliDonneurAdd" value="<%: (_cliDonneurClt == "") ? "Sélectionner" : _cliDonneurClt %>" />--%>

        <div id="cliDonneurDivInfos">

            <table>

            <% if (_cliDonnMode == "modifier" || _cliDonnMode == "ajouter") { %>
                <tr>
                    <td>
                        <span>
                            <input type="button" id="CliDonneurChercher" value=" Charger " />: 
                        </span>
                    </td>
                    <td>
                        <input type="text" id="CliDonneurTxtSearchCode" value="" placeholder="cherchez par code ..." />

                         <span id="CliDonneurLblCltNom"></span>
                        <input type="hidden" id="CliDonneurTxtCltID" value="" />
                       
                    </td>
                </tr>

                <% } %>

                <tr>
                    <td>Donneur d'ordre:</td>
                    <td>
                        <input type="text" id="CliDonneurClt" value="<%: (_cliDonneurClt == "") ? "" : _cliDonneurClt %>" />
                        <input type="hidden" id="CliDonneurID" value="<%: (_cliDonneurID == "") ? "0" : _cliDonneurID %>" /></td>
                </tr>

                <tr>
                    <td>Adresse :</td>
                    <td>
                        <input type="text" id="CliDonneurAdr" value="<%: (_cliDonneurAdr == "") ? "" : _cliDonneurAdr %>" /></td>
                </tr>

                <tr>
                    <td>NP, Ville :</td>
                    <td>
                        <input type="text" id="CliDonneurNpVille" value="<%: (_cliDonneurNpVille == "") ? "" : _cliDonneurNpVille %>" /></td>
                </tr>

                <tr>
                    <td>Pays :</td>
                    <td>
                        <input type="text" id="CliDonneurPays" value="<%: (_cliDonneurPays == "") ? "" : _cliDonneurPays %>" /></td>
                </tr>

                <tr>
                    <td>Tél. :</td>
                    <td>
                        <input type="text" id="CliDonneurTel" value="<%: (_cliDonneurTel == "") ? "" : _cliDonneurTel %>" /></td>
                </tr>

                <tr>
                    <td>Fax :</td>
                    <td>
                        <input type="text" id="CliDonneurFax" value="<%: (_cliDonneurFax == "") ? "" : _cliDonneurFax %>" /></td>
                </tr>

                <tr>
                    <td>Adr. mail :</td>
                    <td>
                        <input type="text" id="CliDonneurMail" value="<%: (_cliDonneurMail == "") ? "" : _cliDonneurMail %>" /></td>
                </tr>

                 


            </table>

        </div>
    
</div>


<script type="text/javascript">
    $().ready(function () {

        var _cliDonneurClt = '<%: _cliDonneurClt %>';

        $("#cliDonnAcc").text("Donneur : " + _cliDonneurClt);

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
        //        //var _tp = ui.item.value;
        //        $("#CliDonneurClt").val(ui.item.value);
        //        $("#CliDonneurID").val(item.key);

        //        return false;
        //    }
        //});


        /////////////////////////////////////////////

                                                                /////////////////ALLER/RETOUR////////////////

        $("#CliDonneurChercher").click(function () {

            //$("#dv_loading_detail").css("display", "");
            //alert(_stepNextGetIntv);
            //alert("Current step " + _stepGetIntv);
            //alert("Next step " + _stepNextGetIntv);

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessources", { cliFamille: 'd', lbl: 'CliDonneurLblCltNom|Nom', txt: 'CliDonneurTxtCltID' },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");

                    $("#cliDGress").remove();
                    $("#cliDG").html("<div id='cliDGress' title='Liste des clients: Donneur'>" + data + "</div>");
                    $("#cliDGress").dialog({
                        width: 500,
                        height: 500,
                        modal: true,
                        // position: 'top',

                    });


                });
        });

        ////////////////////////////////////////////

                    $("#CliDonneurID").attr("readonly", true);
                    $("#CliDonneurClt").attr("readonly", true);
                    $("#CliDonneurAdr").attr("readonly", true);
                    $("#CliDonneurNpVille").attr("readonly", true);
                    $("#CliDonneurPays").attr("readonly", true);
                    $("#CliDonneurTel").attr("readonly", true);
                    $("#CliDonneurFax").attr("readonly", true);
                    $("#CliDonneurMail").attr("readonly", true);

        //////////////////////////Chercher Par Code///////////////////////////

        $("#CliDonneurTxtSearchCode").keypress(function (e) {
            var key = e.which;
            if (key == 13) {

                var _valDonnCode = $("#CliDonneurTxtSearchCode").val();
                //alert(_valCode);
                if (_valDonnCode == "-") {
                    $("#CliDonneurTxtCltID").val("-1");
                     $("#CliDonneurID").val("-1");
                    $("#CliDonneurLblCltNom").text("");
                     $("#CliDonneurClt").val("");
                    $("#CliDonneurAdr").val("");
                    $("#CliDonneurNpVille").val("");
                    $("#CliDonneurPays").val("");
                    $("#CliDonneurTel").val("");
                    $("#CliDonneurFax").val("");
                    $("#CliDonneurMail").val("");
                }
                else {
                    $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByCode", { cliFamille: 'd', valChargCode: _valDonnCode }, function (data) {

                        if (data == "") {
                            //alert("Code introuvable");
                            $("#CliDonneurLblCltNom").text("Ce code n'existe pas");
                        }
                        else if (data != null && data != "") {
                            var infosDonneur = data.toString().split('*');
                            $("#CliDonneurTxtCltID").val(infosDonneur[0]).trigger('change');
                            $("#CliDonneurID").val(infosDonneur[0]);
                            $("#CliDonneurLblCltNom").text(infosDonneur[1]);
                        }
                        else
                            alert("error");
                    });
                }
            }
        });

        ///////////////////////////////////////////////////


        //////////////////////////Detecte changement ID///////////////////////////

        $("#CliDonneurTxtCltID").change(function () {
            //alert("detecte change");
            var _cliDonneurValID = $("#CliDonneurTxtCltID").val();
            //alert(_valID);

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByID", { cliFamille: 'd', valID: _cliDonneurValID }, function (data) {
                if (data.toString() != "") {
                    //alert(data);
                    var dtDonneur = data.toString().split('*');

                    $("#CliDonneurID").val(dtDonneur[0]);
                    $("#CliDonneurClt").val(dtDonneur[1] + "," + dtDonneur[2]);
                    $("#CliDonneurAdr").val(dtDonneur[3]);
                    $("#CliDonneurNpVille").val(dtDonneur[4] + "," + dtDonneur[5]);
                    $("#CliDonneurPays").val(dtDonneur[6]);
                    $("#CliDonneurTel").val(dtDonneur[7]);
                    $("#CliDonneurFax").val(dtDonneur[8]);
                    $("#CliDonneurMail").val(dtDonneur[9]);
                    //alert($("#tlfDonneur").val());
                    //alert($("#txt_cltCodeDonn").val());

                }
            });

        });

        //////////////////////////////////////////////////
       




    });
</script>
