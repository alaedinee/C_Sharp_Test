<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>


<%
 
    var _fourniName = ViewData["fourniName"];
    var _fourniID = ViewData["fourniID"];
    
    var _mode = ViewData["mode"].ToString();
    
%>


<div id="fourni_div_Ajout">


       <%-- <input type="button" id="cliLivAdd" value="<%: (_cliLivClt == "") ? "Sélectionner" : _cliLivClt %>" />--%>

        


        <div id="tabsFourni">
              <ul>
                <li><a href="#tabs-fourni-1"><%: _mode %></a></li>
              <%--  <li><a href="#tabs-4">Chargement</a></li>--%>
              </ul>


              <div id="tabs-fourni-1">
                

                        <table>
                            <tr>
                                <td>Code:</td>
                                <td>
                                    <input type="text" id="fourniName" value="<%: (_fourniName == "") ? "" : _fourniName %>" />
                                    <input type="hidden" id="fourniID" value="<%: (_fourniID == "") ? "" : _fourniID %>" /></td>
                            </tr>

                            

                           


                            <%
                                if (_mode == "modifier")
                                { 
                                 %>

                            <tr>
                                <td>
                                    <input type="button" id="fourniModifier" class="customBtn" value=" Modifier " />
                                </td>
                            </tr>

                            <%} else {
                                     %>
                             <tr>
                                <td>
                                    <input type="button" id="fourniAjouter" class="customBtn" value=" Ajouter " />
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

        var _fourniID = '<%: _fourniID %>';

        $('input[type=text]').addClass('toUPPER');


        $(".toUPPER").keyup(function () {
            this.value = this.value.toUpperCase();
        });


        $(function () {
            $("#tabsFourni").tabs();
        });



        ////////////////////////UPDATE / ADD//////////////////////////

        /////UPDATE/////

        $("#fourniModifier").click(function () {

            var _mode = "Modifier";

            var _fourniName = $("#fourniName").val();


            if (_fourniName == "") {
                alert("Nom de fournisseur est incorrecte");
                return false;
            }


            $.post($.fn.SERVER_HTTP_HOST() + "/Client/MAJFournisseur", {
                mode: _mode, fourniID: _fourniID, fourniName: _fourniName
            },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");
                    if (data != "0" && data != "") {

                        alert("Opération réussite");

                        $.post($.fn.SERVER_HTTP_HOST() + "/Client/listeFourniss", { IDListe: "10" },
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

        $("#fourniAjouter").click(function () {

            var _mode = "Ajouter";

            var _fourniName = $("#fourniName").val();
         

            if (_fourniName == "") {
                alert("Nom de fournisseur est incorrecte");
                return false;
            }

            
            $.post($.fn.SERVER_HTTP_HOST() + "/Client/MAJFournisseur", {
                mode: _mode, fourniID: _fourniID, fourniName: _fourniName
            },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");
                    if (data.toString() != "0" && data.toString() != "") {

                        alert("Opération réussite");
                        $.post($.fn.SERVER_HTTP_HOST() + "/Client/listeFourniss", { fourniID: "10" },
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
