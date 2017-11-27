<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<%
 
    var _cliType = ViewData["CliType"];

    var _cliID = ViewData["CliID"];
    
    
    var _cliCode = ViewData["CliCode"];
    var _cliNom = ViewData["CliNom"] ;
    var _cliAdr = ViewData["CliAdresse"];
    var _cliNp = ViewData["CliNp"];
    var _cliVille = ViewData["CliVille"];
    var _cliPays = ViewData["CliPays"];
    var _cliTel = ViewData["CliTel"];
    var _cliFax = ViewData["CliFax"];
    var _cliMail = ViewData["CliMail"];

    var _mode = ViewData["mode"].ToString();
    
%>


<div id="cli_div_Ajout">


       <%-- <input type="button" id="cliLivAdd" value="<%: (_cliLivClt == "") ? "Sélectionner" : _cliLivClt %>" />--%>

        


        <div id="tabsClient">
              <ul>
                <li><a href="#tabs-cli-1"><%: _mode %></a></li>
              <%--  <li><a href="#tabs-4">Chargement</a></li>--%>
              </ul>


              <div id="tabs-cli-1">
                

                        <table>
                            <tr>
                                <td>Code:</td>
                                <td>
                                    <input type="text" id="CliCode" value="<%: (_cliCode == "") ? "" : _cliCode %>" />
                                    <input type="hidden" id="CliID" value="<%: (_cliID == "") ? "" : _cliID %>" /></td>
                            </tr>

                            <tr>
                                <td>Client</td>
                                <td>
                                    <input type="text" id="CliNom" value="<%: (_cliNom == "") ? "" : _cliNom %>" />
                            </tr>

                            <tr>
                                <td>Adresse :</td>
                                <td>
                                    <input type="text" id="CliAdresse" value="<%: (_cliAdr == "") ? "" : _cliAdr %>" /></td>
                            </tr>

                            <tr>
                                <td>NP</td>
                                <td>
                                    <input type="text" id="CliNp" value="<%: (_cliNp == "") ? "" : _cliNp %>" /></td>
                            </tr>

                            <tr>
                                <td>Ville :</td>
                                <td>
                                    <input type="text" id="CliVille" value="<%: (_cliVille == "") ? "" : _cliVille %>" /></td>
                            </tr>

                            <tr>
                                <td>Pays :</td>
                                <td>
                                    <input type="text" id="CliPays" value="<%: (_cliPays == "") ? "" : _cliPays %>" /></td>
                            </tr>

                            <tr>
                                <td>Tél. :</td>
                                <td>
                                    <input type="text" id="CliTel" value="<%: (_cliTel == "") ? "" : _cliTel %>" /></td>
                            </tr>

                            <tr>
                                <td>Fax :</td>
                                <td>
                                    <input type="text" id="CliFax" value="<%: (_cliFax == "") ? "" : _cliFax %>" /></td>
                            </tr>

                            <tr>
                                <td>Adr. mail :</td>
                                <td>
                                    <input type="text" id="CliMail" value="<%: (_cliMail == "") ? "" : _cliMail %>" /></td>
                            </tr>

                             <tr>
                                <td>Type :</td>
                                <td>
                                    <% if (ViewData["cheakCharg"] == "true") { %>
                                    <INPUT type="checkbox" id="cliChargChoix" value="c" checked> Chargement
                                    <% } else { %>
                                    <INPUT type="checkbox" id="cliChargChoix" value="c"> Chargement
                                    <% } %>

                                    <% if (ViewData["cheakLivr"] == "true") { %>
                                    <INPUT type="checkbox" id="cliLivrChoix" value="l" checked> Livraison
                                    <% } else { %>
                                    <INPUT type="checkbox" id="cliLivrChoix" value="l"> Livraison
                                    <% } %>

                                    <% if (ViewData["cheakDonn"] == "true") { %>
                                    <INPUT type="checkbox" id="cliDonnChoix" value="d" checked> Donneur
                                    <% } else { %>
                                    <INPUT type="checkbox" id="cliDonnChoix" value="d"> Donneur
                                    <% } %>
                                </td>
                            </tr>


                            <%
                                if (_mode == "modifier")
                                { 
                                 %>

                            <tr>
                                <td>
                                    <input type="button" id="CliModifier" class="customBtn" value=" Modifier " />
                                </td>
                            </tr>

                            <%} else {
                                     %>
                             <tr>
                                <td>
                                    <input type="button" id="CliAjouter" class="customBtn" value=" Ajouter " />
                                </td>
                            </tr>

                            <% } %>

              


                        </table>

    
                 
              </div>
                      
          </div> 
</div>

<script type="text/javascript">
    $().ready(function () {

        /////////////////HEUR - Date ....//////////////////////
        //$('#cliLivDateLiv').datepicker({ dateFormat: 'dd/mm/yy' });
        //$('#cliLivDateMon').datepicker({ dateFormat: 'dd/mm/yy' });
        //////////////////////////////////////////////

        var _cliID = '<%: _cliID %>';

        $('input[type=text]').addClass('toUPPER');


        $(".toUPPER").keyup(function () {
            this.value = this.value.toUpperCase();
        });


        $(function () {
            $("#tabsClient").tabs();
        });


        ////////////////Auto Complete/////////////////

        $("#CliClt").autocomplete({  //Auto complete Client livraison
            source: function (request, response) {
                $.ajax({
                    url: $.fn.SERVER_HTTP_HOST() + "/Client/getClientComplete",
                    dataType: "json",
                    type: "POST",
                    data: { val: request.term },
                    success: function (data) {
                        response($.map(data, function (item) {
                            return {
                                value: item.value,
                                key: item.key
                            };
                        }));
                    }
                });
            },
            minchar: 2,
            select: function (event, ui) {
                //var _tp = ui.item.value;
                $("#cliClt").val(ui.item.value);
                $("#cliID").val(ui.item.key);
                return false;
            }
        });

        $("#CliAdresse").autocomplete({  //Auto complete Client livraison
            source: function (request, response) {
                $.ajax({
                    url: $.fn.SERVER_HTTP_HOST() + "/Client/getAdresseComplete",
                    dataType: "json",
                    type: "POST",
                    data: { val: request.term },
                    success: function (data) {
                        response($.map(data, function (item) {
                            return {
                                value: item.value,
                                key: item.key
                            };
                        }));
                    }
                });
            },
            minchar: 2,
            select: function (event, ui) {
                //var _tp = ui.item.value;
                $("#CliAdresse").val(ui.item.value);
                return false;
            }
        });

        //////////////////////////////////////////////////

        ////////////////////////UPDATE / ADD//////////////////////////

        /////UPDATE/////

        $("#CliModifier").click(function () {

            var _mode = "Modifier";

            var _cliType = "";

            var _cliCode = $("#CliCode").val();
            var _cliNom = $("#CliNom").val();
            var _cliAdresse = $("#CliAdresse").val();
            var _cliNp= $("#CliNp").val();
            var _cliVille = $("#CliVille").val();
            var _cliPays = $("#CliPays").val();
            var _cliTel = $("#CliTel").val();
            var _cliFax = $("#CliFax").val();
            var _cliMail = $("#CliMail").val();

            if ($("#cliChargChoix").prop("checked"))
                _cliType += "c";
            if ($("#cliLivrChoix").prop("checked"))
                _cliType += "l";
            if ($("#cliDonnChoix").prop("checked"))
                _cliType += "d";


            if (_cliNom == "") {
                alert("Nom client est incorrecte");
                return false;
            }

            if (_cliCode == "") {
                alert("Code client est incorrecte");
                return false;
            }

            if (_cliAdresse == "") {
                alert("L'adresse est vide");
                return false;
            }

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/MAJClient", {
                mode: _mode, cliID: _cliID, cliNom: _cliNom, cliCode: _cliCode,
                cliAdresse: _cliAdresse, cliNp: _cliNp, cliVille: _cliVille, cliPays: _cliPays, cliTel: _cliTel, cliFax: _cliFax, cliMail: _cliMail, cliType: _cliType
            },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");
                    if (data != "0" && data != "") {

                        alert("Opération réussite");

                        $.post($.fn.SERVER_HTTP_HOST() + "/Client/list", { cliID: "-1", typeClient: "" },
                            function (data) {
                                $("#main").html(data);
                            });

                    }
                    else {

                        alert("échec de modification");

                    }
                });
        });


        /////UPDATE/////

        $("#CliAjouter").click(function () {

            var _mode = "Ajouter";

            var _cliType = "";

            var _cliCode = $("#CliCode").val();
            var _cliNom = $("#CliNom").val();
            var _cliAdresse = $("#CliAdresse").val();
            var _cliNp = $("#CliNp").val();
            var _cliVille = $("#CliVille").val();
            var _cliPays = $("#CliPays").val();
            var _cliTel = $("#CliTel").val();
            var _cliFax = $("#CliFax").val();
            var _cliMail = $("#CliMail").val();

            if ($("#cliChargChoix").prop("checked"))
                _cliType += "c";
            if ($("#cliLivrChoix").prop("checked"))
                _cliType += "l";
            if ($("#cliDonnChoix").prop("checked"))
                _cliType += "d";

            

            if (_cliNom == "") {
                alert("Nom client est incorrecte");
                return false;
            }

            if (_cliCode == "") {
                alert("Code client est incorrecte");
                return false;
            }

            if (_cliAdresse == "") {
                alert("L'adresse est vide");
                return false;
            }


            $.post($.fn.SERVER_HTTP_HOST() + "/Client/MAJClient", {
                mode: _mode, cliID: _cliID, cliNom: _cliNom, cliCode: _cliCode,
                cliAdresse: _cliAdresse, cliNp: _cliNp, cliVille: _cliVille, cliPays: _cliPays, cliTel: _cliTel, cliFax: _cliFax, cliMail: _cliMail, cliType: _cliType
            },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");
                    if (data.toString() != "0" && data.toString() != "") {

                        alert("Opération réussite");
                        $.post($.fn.SERVER_HTTP_HOST() + "/Client/list", { cliID: "-1", typeClient: "" },
                           function (data) {
                               $("#main").html(data);
                           });

                    }
                    else {

                        alert("échec d'ajout");

                    }


                });


        });



        ////////////////////////////////////


        //////////////////////////////////////////////////

    });
</script>
