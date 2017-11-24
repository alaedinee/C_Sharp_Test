<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<%
    
    var _cliLivID = ViewData["cliLivID"];
    var _cliLivClt = ViewData["cliLivNom"] + "," + ViewData["cliLivCode"];
    var _cliLivAdr = ViewData["cliLivAdr"];
    var _cliLivNpVille = ViewData["cliLivNp"] + "," + ViewData["cliLivVille"];
    var _cliLivPays = ViewData["cliLivPays"];
    var _cliLivTel = ViewData["cliLivTel"];
    var _cliLivFax = ViewData["cliLivFax"];
    var _cliLivMail = ViewData["cliLivMail"];
    //var _cliLivDateLiv = ViewData["cliLivDateLiv"];
    //var _cliLivHeurLiv = ViewData["cliLivHeurLiv"];
    //var _cliLivDateMon = ViewData["cliLivDateMon"];

    var _livrID = ViewData["LivrID"];

    var _cliLivMode = ViewData["cliLivMode"].ToString();
    
%>


<div id="cliLiv_div">


       <%-- <input type="button" id="cliLivAdd" value="<%: (_cliLivClt == "") ? "Sélectionner" : _cliLivClt %>" />--%>

        <div id="cliLivDivInfos">

            <table>

             <% if (_cliLivMode == "modifier" || _cliLivMode == "ajouter") { %>
                <tr>
                    <td>
                        <span>
                            <input type="button" id="CliLivChercher" value=" Charger " />: 
                        </span>
                    </td>
                    <td>
                        <input type="text" id="CliLivTxtSearchCode" value="" placeholder="cherchez par code ..." />

                        <span id="CliLivLblCltNom"></span>
                        <input type="hidden" id="CliLivTxtCltID" value="" />
                        
                    </td>
                </tr>
                <% } %>

                <tr>
                    <td>Client:</td>
                    <td>
                        <input type="text" id="CliLivClt" value="<%: (_cliLivClt == "") ? "" : _cliLivClt %>" />
                        <input type="hidden" id="CliLivID" value="<%: (_cliLivID == "") ? "0" : _cliLivID %>" /></td>
                </tr>

                <tr>
                    <td>Adresse :</td>
                    <td>
                        <input type="text" id="CliLivAdr" value="<%: (_cliLivAdr == "") ? "" : _cliLivAdr %>" /></td>
                </tr>

                <tr>
                    <td>NP, Ville :</td>
                    <td>
                        <input type="text" id="CliLivNpVille" value="<%: (_cliLivNpVille == "") ? "" : _cliLivNpVille %>" /></td>
                </tr>

                <tr>
                    <td>Pays :</td>
                    <td>
                        <input type="text" id="CliLivPays" value="<%: (_cliLivPays == "") ? "" : _cliLivPays %>" /></td>
                </tr>

                <tr>
                    <td>Tél. :</td>
                    <td>
                        <input type="text" id="CliLivTel" value="<%: (_cliLivTel == "") ? "" : _cliLivTel %>" /></td>
                </tr>

                <tr>
                    <td>Fax :</td>
                    <td>
                        <input type="text" id="CliLivFax" value="<%: (_cliLivFax == "") ? "" : _cliLivFax %>" /></td>
                </tr>

                <tr>
                    <td>Adr. mail :</td>
                    <td>
                        <input type="text" id="CliLivMail" value="<%: (_cliLivMail == "") ? "" : _cliLivMail %>" /></td>
                </tr>

                <%-- <tr>
                    <td>Date livraison :</td>
                    <td>
                        <input type="text" id="cliLivDateLiv" value="<%: (_cliLivDateLiv == "") ? "" : _cliLivDateLiv %>" />
                        <input type="text" id="cliLivHeurLiv" value="<%: (_cliLivHeurLiv == "") ? "" : _cliLivHeurLiv %>" />
                    </td>
                </tr>

                 <tr>
                    <td>Date montage :</td>
                    <td>
                        <input type="text" id="cliLivDateMon" value="<%: (_cliLivDateMon == "") ? "" : _cliLivDateMon %>" /></td>
                </tr>--%>

               


            </table>

        </div>
   
</div>

<script type="text/javascript">
    $().ready(function () {

        var _cliLivClt = '<%: _cliLivClt %>';

        $("#cliLivAcc").text("Livraison : " + _cliLivClt);
        /////////////////HEUR - Date ....//////////////////////
        //$('#cliLivDateLiv').datepicker({ dateFormat: 'dd/mm/yy' });
        //$('#cliLivDateMon').datepicker({ dateFormat: 'dd/mm/yy' });
        //////////////////////////////////////////////



                                                ////////////////Auto Complete/////////////////

        //$("#cliLivClt").autocomplete({  //Auto complete Client livraison
        //    source: function (request, response) {
        //        $.ajax({
        //            url: $.fn.SERVER_HTTP_HOST() + "/Client/getClientLivriason",
        //            dataType: "json",
        //            type: "POST",
        //            data: { type: "l", term: request.term },
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
        //        $("#cliLivClt").val(ui.item.value); 
        //        $("#cliLivID").val(item.key);
        //        return false;
        //    }
        //});

        /////////////////////////////////////////////

                                                            /////////////////ALLER/RETOUR////////////////
          
        $("#CliLivChercher").click(function () {

            //$("#dv_loading_detail").css("display", "");
            //alert(_stepNextGetIntv);
            //alert("Current step " + _stepGetIntv);
            //alert("Next step " + _stepNextGetIntv);

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessources", { cliFamille: 'l', lbl: 'CliLivLblCltNom|Nom', txt: 'CliLivTxtCltID' },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");

                    $("#cliDGress").remove();
                    $("#cliDG").html("<div id='cliDGress' title='Liste des clients: Livraison'>" + data + "</div>");
                    $("#cliDGress").dialog({
                        width: 500,
                        height: 500,
                        modal: true,
                        // position: 'top',

                    });


                });
        });

        ////////////////////////////////////////////

                    $("#CliLivID").attr("readonly", true);
                    $("#CliLivClt").attr("readonly", true);
                    $("#CliLivAdr").attr("readonly", true);
                    $("#CliLivNpVille").attr("readonly", true);
                    $("#CliLivPays").attr("readonly", true);
                    $("#CliLivTel").attr("readonly", true);
                    $("#CliLivFax").attr("readonly", true);
                    $("#CliLivMail").attr("readonly", true);

                                                //////////////////////////Chercher Par Code///////////////////////////

        $("#CliLivTxtSearchCode").keypress(function (e) {
            var key = e.which;
            if (key == 13) {

                var _valLivCode = $("#CliLivTxtSearchCode").val();
                //alert(_valCode);
                if (_valLivCode == "-") {
                    $("#CliLivTxtCltID").val("-1");
                    $("#CliLivID").val("-1");
                    $("#CliLivLblCltNom").text("");

                    $("#CliLivClt").val("");
                    $("#CliLivAdr").val("");
                    $("#CliLivNpVille").val("");
                    $("#CliLivPays").val("");
                    $("#CliLivTel").val("");
                    $("#CliLivFax").val("");
                    $("#CliLivMail").val("");
                }
                else {
                    $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByCode", { cliFamille: 'l', valChargCode: _valLivCode }, function (data) {

                        if (data == "") {
                            //alert("Code introuvable");
                            $("#CliLivLblCltNom").text("Ce code n'existe pas");
                        }
                        else if (data != null && data != "") {
                            var infosDonneur = data.toString().split('*');
                            $("#CliLivTxtCltID").val(infosDonneur[0]).trigger('change');
                            $("#CliLivID").val(infosDonneur[0])
                            $("#CliLivLblCltNom").text(infosDonneur[1]);
                        }
                        else
                            alert("error");
                    });
                }
            }
        });

        ///////////////////////////////////////////////////


                                                //////////////////////////Detecte changement ID///////////////////////////

        $("#CliLivTxtCltID").change(function () {
            //alert("detecte change");
            var _cliLivValID = $("#CliLivTxtCltID").val();
            //alert(_valID);

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByID", { cliFamille: 'l', valID: _cliLivValID }, function (data) {
                if (data.toString() != "") {
                    //alert(data);
                    var dtLivraison = data.toString().split('*');

                    $("#CliLivID").val(dtLivraison[0])
                    $("#CliLivClt").val(dtLivraison[1] + "," + dtLivraison[2])
                    $("#CliLivAdr").val(dtLivraison[3])
                    $("#CliLivNpVille").val(dtLivraison[4] + "," + dtLivraison[5])
                    $("#CliLivPays").val(dtLivraison[6])
                    $("#CliLivTel").val(dtLivraison[7])
                    $("#CliLivFax").val(dtLivraison[8])
                    $("#CliLivMail").val(dtLivraison[9])
                    //alert($("#tlfDonneur").val());
                    //alert($("#txt_cltCodeDonn").val());

                }
            });

        });

        //////////////////////////////////////////////////

    });
</script>
