<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    System.Data.DataTable dtEmp = (System.Data.DataTable) ViewData["Emp"];
    System.Data.DataTable dtPack = (System.Data.DataTable) ViewData["dtPack"];
    System.Data.DataTable dtStatus = (System.Data.DataTable) ViewData["Status"];
    System.Data.DataTable dtDetails = (System.Data.DataTable) ViewData["Details"];
    String prestations = (String) ViewData["prestations"];    
    
    String optional = (String) ViewData["optional"];

    var _recepPackAddConfirmer = Session["loginReception"].ToString();
    var _recepPackType = Session["loginReceptionType"].ToString();

       
    System.Data.DataRow rPack = null;
    if (Omniyat.Models.MTools.verifyDataTable(dtPack))
    {
        rPack = dtPack.Rows[0];
    }
    string ID = ViewData["ID"].ToString();
    
%>
<div id="DGPACKRECEP"></div>

<input type="hidden" id="ID" value="<%: ID  %>" /> 
<input type="hidden" id="otid" value="<%: ViewData["otid"].ToString()   %>" /> 
<table border="0">
    <tr>
        <td>Numéro</td>
        <td><input type="text" id="numero" readonly='readonly' value="<%: (rPack != null )? rPack["packageNumber"].ToString() : ""  %>" />  </td>
    </tr>

    

    <tr>
        <td>Poids</td>
        <td><input type="text" id="weight" maxlength="6" style="width:50px;" value="<%: (rPack != null )? rPack["weight"].ToString() : "0"  %>" />Kg</td>
    </tr>

    <tr>
        <td>Volume</td>
        <td><input type="text" id="volume" maxlength="6" style="width:50px;" value="<%: (rPack != null )? rPack["volume"].ToString() : "0"  %>" />m3</td>
    </tr>

    <tr>
        <td>Statut</td>
        <td>
            <select id="status" style="width:150px">
                <% string status = (rPack != null) ? rPack["statut"].ToString() : ""; %>
                <%
                    if(Omniyat.Models.MTools.verifyDataTable(dtStatus)) {
                        for (int i = 0; i < dtStatus.Rows.Count; i++)
                        {
                            System.Data.DataRow r = dtStatus.Rows[i];
                %>
                            <option value="<%: r["Etat_Destination"].ToString() %>" <%: (r["Etat_Destination"].ToString() == status)? "selected='selected'" : "" %>><%: r["Description"].ToString()%> (<%: r["Etat_Destination"].ToString()%>)</option>
                <%
                        }
                    }
                 %>
            </select>
        </td>
    </tr>

    <tr>
        <td>Emplacement</td>
        <td>
            <input type="text" id="autoEmp" value = "" />
            <input type="hidden" id="emp" value="<%: (rPack != null )? rPack["idEmplacement"].ToString() : ""  %>" />


            <select id="DtEmp" style="display:none;width:150px">
                <option value="0"></option>
                <%
                    var empVal = "";
                    if(Omniyat.Models.MTools.verifyDataTable(dtEmp)) {
                        string empF = (rPack != null) ? rPack["idEmplacement"].ToString() : "";
                        
                        for (int i = 0; i < dtEmp.Rows.Count; i++)
                        {
                            System.Data.DataRow r = dtEmp.Rows[i];
                            if (dtEmp.Rows[i]["idEmplacement"].ToString() == empF)
                                empVal = dtEmp.Rows[i]["CABEmplacement"].ToString();
                              
                                
                %>
                            <option value="<%: r["idEmplacement"].ToString() %>" <%: (r["idEmplacement"].ToString() == empF)? "selected='selected'" : "" %>><%: r["CABEmplacement"].ToString()%></option>
                <%
                        }
                    }
                 %>
                
                
            </select>
        </td>
    </tr>

    <tr>
        <td>Récéption</td>
        <td>
            <input type="hidden" id="PKRecepID" value="<%: (rPack != null )? rPack["receptionID"].ToString() : ""  %>" />

            <b id="bPKRecepID"><%: (rPack != null) ? rPack["receptionNumber"].ToString() : ""%></b>
            <a id="btn_Recep" style="cursor:pointer">Modifier</a>
        </td>
    </tr>

    <tr>
        <td>Prestations</td>
        <td>
            <input type="hidden" id="prestations" value="<%: (prestations != null )? prestations : ""  %>" />

            <select id="DtPrestations" style="width:150px">
                <%
                    if(Omniyat.Models.MTools.verifyDataTable(dtDetails)) {
                        for (int i = 0; i < dtDetails.Rows.Count; i++)
                        {
                            System.Data.DataRow r = dtDetails.Rows[i];
                            string is_ret = r["CalculPoid"].ToString() == "-1" || r["CalculPoid"].ToString() == "-2" ? r["DetailID"].ToString() : "0";
                %>
                            <option value="<%: r["DetailID"].ToString() %>" is_ret="<%:is_ret %>"><%: r["produit"].ToString()%></option>
                <%
                        }
                    }
                 %>
                
                
            </select>
            <a id="btn_add_prestation" style="cursor:pointer">Ajouter</a>
        </td>
    </tr>

        <tr >
            <td>&nbsp;</td>
            <td>
                <div id="lstprestations"></div>
            </td>
         </tr>


    <tr>
        <td>Completé</td>
        <td><input type="checkbox" id="optional" <%: (rPack != null )? ((rPack["optional"].ToString() == "1")? "checked='checked'": "" ) : ""  %>"  /></td>
        <td><input type="hidden" id="packVerifyComplet" value="<%: (rPack != null )? rPack["optional"].ToString() : ""  %>"  /></td>
    </tr>


    <tr>
        <td>Palettisé</td>
        <td><input type="checkbox" id="ddc" <%: (rPack != null )? ((rPack["ddc"].ToString() == "true" || rPack["ddc"].ToString() == "1")? "checked='checked'": "" ) : ""  %>" /></td>
    </tr>

    <tr id="trPalette" style="display:none">
        <td>Num. Palette</td>
        <td><input type="text" id="numPalette" value="<%: (rPack != null )? rPack["numPalette"].ToString() : ""  %>"  /></td>
    </tr>

    <tr>
        <td align="left"><input type="button" value='<%: (ID == "0")? "Ajouter" : "Modifier" %>' id="btnSave"  /></td>
        <% if(ID != "0") {%>
            <td align="left"><input type="button" value='Ajouter marchandise' id="bntAddMarchadise"  /></td>
        <% } %>

        <%--<td colspan="2" align="right"><input type="button" value='Terminer' id="btnTerminer"  /></td>--%>
    </tr>

   
</table>
    


<style>
    .Date {
        z-index:-1;
    }
    
    .D1
    {
        z-index:10000000;
        position :absolute;
    }
</style>

<script type="text/javascript">
    $(document).ready(function () {

        var _lstStat = [];

        var empVal = '<%: empVal %>';

        var _recepPackAddConfirmer = '<%: _recepPackAddConfirmer %>';
        var _recepPackType = '<%: _recepPackType %>';


        //alert(empVal);

        if ($("#ddc").is(':checked')){
             $("#trPalette").toggle(this.checked);
        }

        $('#ddc').click(function () {
            $("#trPalette").toggle(this.checked);
        });

        $("#autoEmp").val(empVal);

        jQuery.fn.verify = function (array, val) {
            var ok = -1;
            for (var i = 0; i < array.length; i++) {
                if (array[i] == val) {
                    ok = i;
                    break;
                }
            }
            return ok;
        }

        jQuery.fn.addItem = function (id, val) {
            if (jQuery.fn.verify(_lstStat, id) != -1)
                alert("Existe déjà !");
            else {
                _lstStat.push(id);
                $("#lstprestations").append("<div><a del='" + id + "' style='color:red;cursor:pointer'>X</a> &nbsp;<span>" + val + "</span></div>");
                jQuery.fn.removerFn();
            }
        };

        jQuery.fn.removerFn = function () {
            $("a[del]").not('.initialized').addClass('initialized').click(function () {
                var _txt = $(this).attr("del");
                var idx = jQuery.fn.verify(_lstStat, _txt);
                $(this).closest("div").remove();
                _lstStat[idx] = "";
            });
        };

        jQuery.fn.getLst = function (array) {
            var str = "";
            for (var i in array) {
                if (array[i] == "") continue;

                str += array[i] + "|";
            }

            if (str != "") str = str.substring(0, str.length - 1);
            return str;
        };

        var _prestations = $("#prestations").val().split('|');
        for (var i in _prestations) {
            if (_prestations[i] == "") continue;
            $("#DtPrestations").val(_prestations[i]);
            jQuery.fn.addItem(_prestations[i], $("#DtPrestations option:selected").text());
        }

        $("#btn_add_prestation").click(function () {
            var _prestID = $("#DtPrestations option:selected").val();
            var _prestVAL = $("#DtPrestations option:selected").text();
            var _is_ret = $("#DtPrestations option:selected").attr('is_ret');

            var _ID = $("#ID").val();
            if (_ID == "0" && _recepPackAddConfirmer == "" && _is_ret == "0")
                alert("Vous devez créer/choisir une récéption !");
            else
                jQuery.fn.addItem(_prestID, _prestVAL);
        });

        $("#btn_Recep").click(function () {
            
            $.post(SERVER_HTTP_HOST() + "/OT/lstReception", function (htmlResult) {
                
                $("#DGpacK1").remove();
                $("#DGPACKRECEP").html("<div id='DGpacK1' title='Liste des récéptions '>" + htmlResult + "</div>");

                $("#DGpacK1").dialog({
                    height: 400,
                    width: 750,
                    modal: true, draggable: true
                });

                //$("#DGpacK1").dialog("option", "position", [350, 250]);

            });
        });


        $('input[date]').datepicker({ dateFormat: 'dd/mm/yy' });
        $("#dialog").addClass("Date");


        $.fn.getEmpID = function (str) {
            var EmpID = "0";
            $("#DtEmp option").each(function () {
                if ($(this).text() == str) {
                    EmpID = $(this).val();
                    return false;
                }
            });

            return EmpID;
        };

$("#autoEmp").autocomplete(SERVER_HTTP_HOST() + '/Package/getEmplacement', {
            delay: 0,
            max: 8000,
            minLength: 1,
            minChars: 1,
            matchSubset: 4,
            matchContains: 4,
            cacheLength: 10
        });

        $('#autoEmp').result(function (event, data, formatted) {
            var EmpID = $.fn.getEmpID(data);
            $("#emp").val(EmpID);
        });

        $("#autoEmp").val($("#DtEmp option:selected").text());

        $("#ui-datepicker-div").addClass("D1");

        $("#btnSave").click(function () {
            var _ID = $("#ID").val();
            var _otid = $("#otid").val();
            var _numero = $("#numero").val();
            var _ddc = ($("#ddc").is(':checked')) ? "1" : "0";
            var _weight = $("#weight").val();
            var _volume = $("#volume").val();
            var _status = $("#status option:selected").val();
            var _emp = $("#emp").val();
            var _lstPrest = jQuery.fn.getLst(_lstStat);
            var _optional = ($("#optional").is(':checked')) ? "1" : "0";
            var _numPalette = $("#numPalette").val();
            var _PKRecepID = $("#PKRecepID").val();

            if (_ddc == "0"){
                _numPalette = "";
            }

            var _error = '';

//            if (_ID == "0" && _recepPackAddConfirmer == ""){
//                _error = "Vous devez créer/choisir une récéption !";
//				$('#DGpacK').dialog('close');
//			}
//            if (_emp == "")
//                _error = "Emplacement invalide !";
            if (_weight.length < 1)
                _error = "Poids invalide !";
            else if (_volume.length < 1)
                _error = "Volume invalide !";
//            else if (_lstPrest == '')
//                _error = "Choisir la prestation !";

            if (_error == '') {
                $.post(SERVER_HTTP_HOST() + "/Package/savePackage", { id: _ID, otid: _otid,
                    numero: _numero, ddc: _ddc, weight: _weight, volume: _volume, status: _status, emp: _emp
                    , lstPrest: _lstPrest,
                    optional: _optional,
                    numPalette : _numPalette, RecepID: _PKRecepID
                }, function (htmlResult) {
                    if (htmlResult == "0") {
                        //$.fn.getPackages();
                        //$.fn.Vider();
                        // alert('<%: (ID == "0")? "Ajout" : "Modifi" %>é avec succès !');
                        $.fn.Vider();
                        // refresh package
                          $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _otid },

                                        function (htmlResult) {

                                            $("#divPackageModifier").html(htmlResult);
											 $('#DGpacK').dialog('close');
                                        });  
                        // refresh prestation
                        $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/getLstPrestation", { prestOTID: _otid },

                                        function (htmlResult) {

                                            $("#divPrestation").html(htmlResult);

                                        });
                    }
                    else if (htmlResult == "-2")
                        alert("Ce package existe déjà !");
                    else
                        alert('Erreur <%: (ID == "0")? "d''ajout" : "de modification" %> !');
                });

            } else
                alert(_error);
        });


         $("#bntAddMarchadise").click( function(){

            var _verifyComp = $("#packVerifyComplet").val(); 
            var _ID = $("#ID").val();
            var _otid = $("#otid").val();

            if(_verifyComp == "1"){

                alert("ce package est complet");
                return false;
            }

            if (_recepPackType == "" || _recepPackType == null)
            {
                alert("aucune récéption n'as été choisi");
                return false;
            }
       
            $.post($.fn.SERVER_HTTP_HOST() + "/Package/addMarchandiseReception", { IDPackage: _ID, OTID : _otid },
             function (htmlResult) {

                if (htmlResult.toString() == "0")
                    alert("cet marchandise exite déja dans ce package");
                else
                    // alert("Opération réussie");
                    $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _otid },

                                        function (htmlResult) {

                                            $("#divPackageModifier").html(htmlResult);

                                        });  

             }); 
       
       
       });


        $("#btnTerminer").click(function () {

            $("#DGpacK").remove();
        });

         $.fn.Vider = function (valeur) {

                 $("#weight").val("0");
                 $("#volume").val("0");
                 $("#autoEmp").val("");
                 $("#emp").val("");
                 $("#lstprestations").text("");
                 $("#numPalette").val("");
                 $('#optional').attr('checked', false);
                 $('#ddc').attr('checked', false);
                 //$("#trPalette").toggle(this.checked);
             };
    });
</script>