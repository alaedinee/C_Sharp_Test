<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	afficherOT
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div id="afficher-ot-content">
<%     
    Response.Write(@"<link href='" + Globale_Varriables.VAR.get_URL_HREF() + "/Content/datetimepicker/jquery.datetimepicker.css' rel='stylesheet' type='text/css' />");
    Response.Write(@"<script language='javascript' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Content/datetimepicker/jquery.datetimepicker.full.js'></script>");
    var _mode = ViewData["mode"];
    var _OTID = ViewData["OTID"];
    var _valDataNOBL = ViewData["valDataNOBL"];
    var _valDataIdPackage = ViewData["valDataIdPackage"];
    var _isOpen = ViewData["isOpen"];
    var _isPalannifToPast = ViewData["isPalannifToPast"];
    var _callFromGroup = ViewData["callFromGroup"];

    DateTime _DateCreation = DateTime.Now;
    string _Date = _DateCreation.ToString("yyyy/MM/dd HH:mm");
        %>
        <style>
            .chercherBtn
            {
                width: 150px;  
            }
        </style>
        <div id="myForm">

        </div>

        <div id="magChoix">

        </div>


<script type="text/javascript">

        $(document).ready(function () {

            var _mode = '<%: _mode %>';
            var _OTID = '<%: _OTID %>';
            var _Date = '<%: _Date %>';
            var _valDataNOBL = '<%: _valDataNOBL %>';
            var _valDataIdPackage = '<%: _valDataIdPackage %>';
            var _isOpen = '<%: _isOpen %>';
            var _isPalannifToPast = '<%: _isPalannifToPast %>';
            var _callFromGroup = '<%: _callFromGroup %>';

            $.fn.myModify = function () {


                ////////////ADD button and elements///////////////
                //add button chercher magasin et ID magasin
                $("#FR_OT_OTNoBL").closest("td").append("-<input type='text' id='factValue' value='NO' />-<input type='text' id='choixValue' /><input type='Button' value='Magasin' class='chercherBtn' id='btnMag' /><input type='hidden' id='FR_OT_magID' /> <input type='hidden' value='-1' id='OT_OTID' /> ");
                
                //$("#FR_OT_OTNoBL").closest("td").append("<input type='Button' value='Magasin' class='chercherBtn' id='btnMag' /> <input type='hidden' id='FR_OT_magID' /> <input type='hidden' value='-1' id='OT_OTID' /> ");
                // add input Id Client hidden
                $("#FR_OT_Clieu_chargement").closest("tr").append("<td> <input type='hidden' id='FR_OT_chargID' /> </td>");
                $("#FR_OT_OTDestinNom").closest("tr").append("<td> <input type='hidden' id='FR_OT_livrID' /> </td>");
                $("#FR_OT_Clieu_donneur").closest("tr").append("<td> <input type='hidden' id='FR_OT_donnID' /> </td>");
                // add labelle et input Nom pour charg, donn, livr
//                $("#FR_OT_Clieu_chargement").closest("tr").after("<tr> <td><b>Nom </b></td> <td><input type='text' id='FR_OT_chargNom' /></td> </tr>");
//                $("#FR_OT_Clieu_livraison").closest("tr").after("<tr> <td><b>Nom </b></td> <td><input type='text' id='FR_OT_livrNom' /></td> </tr>");
//                $("#FR_OT_Clieu_donneur").closest("tr").after("<tr> <td><b>Nom </b></td> <td><input type='text' id='FR_OT_donnNom' /></td> </tr>");
                // add class pour les input des pays
                $("#FR_OT_pays_chargement").val("Suisse");
                $("#FR_OT_pays_livraison").val("Suisse");
                $("#FR_OT_pays_donneur").val("Suisse");
                //////////////////////////////////////////////////
                // add labelle et input Nom pour charg, donn, livr
                $("#FR_OT_OTChargementEmail").closest("tr").after("<tr> <td><input type='button' id='FR_OT_BTN_chargSearch' value='Chargement' /></td> <td> <span id='FR_OT_TXT_chargSearch'> </span> </td> </tr>");
                $("#FR_OT_OTDestinNom").closest("tr").before("<tr> <td><input type='button' id='FR_OT_BTN_livrSearch' value='Charger' /></td> <td><input type='text' id='CliLivTxtSearchCodeDyn' value='' placeholder='cherchez par code ...' /></td> <td><span id='FR_OT_TXT_livrSearch'> </span> </td> </tr>");
                $("#FR_OT_Clieu_donneur").closest("tr").before("<tr> <td><input type='button' id='FR_OT_BTN_donnSearch' value='Charger' /></td> <td><input type='text' id='CliDonneurTxtSearchCodeDyn' value='' placeholder='cherchez par code ...' /></td> <td><span id='FR_OT_TXT_donnSearch'> </span> </td> </tr>");

                $('#FR_OT_OTPoids').attr("readonly", true);
                $('#FR_OT_OTPoids').val("");
                $("#FR_OT_OTPoids").closest("td").append(" kg");

                $('#FR_OT_OTVolume').attr("readonly", true);
                $('#FR_OT_OTVolume').val("");
                $("#FR_OT_OTVolume").closest("td").append(" m3");

                if(_callFromGroup != '1')
                    $("#FR_OT_OTDateLivraison").closest("tr").after("<tr><td><b>Type de dossier</b></td><td> <input type='checkbox' name='type_OT' value='1' id='id_Dossier' checked>Dossier<input type='checkbox' name='type_OT' value='2' id='id_Transport'>Transport</td></tr>");
                else
                {
                    $.get($.fn.SERVER_HTTP_HOST() + "/OT/getOTGroupeType", {OTID : _OTID}, function(r){
                    var _typeGOTs = r.split(',');
                    var elm = "";
                    for(var i = 0; i < _typeGOTs.length; i ++)
                    {
                        var _typeGOT = _typeGOTs[i].split('|');
                        elm += "<option value='"+ _typeGOT[0] +"' " + (_typeGOT[0] == _typeGOT[2] ? " selected " : "") + ">"+ _typeGOT[1] +"</option>"
                    }                      

                    $("#FR_OT_OTDateLivraison").closest("tr").after("<tr><td><b>Type de dossier</b></td><td><select name='typeGroupeOT'>"  + elm + "</select></td></tr>");
                });   
                }
                $("#FR_OT_OTDateSaisie").attr("readonly", true);
                $("#FR_OT_codestock").attr("readonly", true);

               

                $("#FR_OT_OTNoBL").closest("tr").before("<tr> <td> Date création</td> <td> <span id='OT_Date_Creation'> </span> </td> </tr>");
                

                $("#OT_Date_Creation").text(_Date);
                $("#FR_OT_OTVolume").closest("tr").css("visibility", "hidden");
                $("#FR_OT_OTPoids").closest("tr").css("visibility", "hidden");
                $("#FR_OT_codestock").closest("tr").css("visibility", "hidden");

                $("#FR_OT_OTVolume").closest("tr").append("<tr><td> <input type='hidden' id='FR_OT_packID' /> </td></tr>");

                //////////////////////////////////////////MAke Input value to Upper/////////////////////////

                $('#afficher-ot-content input[type=text]').addClass('toUPPER');


                $(".toUPPER").keyup(function () {
                    this.value = this.value.toUpperCase();
                });

                if (_valDataNOBL != ""){
                    $("#FR_OT_OTNoBL").val(_valDataNOBL);
                    $('#FR_OT_OTNoBL').attr("disabled","disabled");

                    $("#FR_OT_packID").val(_valDataIdPackage);
                    $('#FR_OT_packID').attr("disabled","disabled");
                }
                    
                    $('input[type="checkbox"]').on('change', function() {
                     $('input[type="checkbox"]').not(this).prop('checked', false);
                    });

                   


                ////////////// Action déclencher, Cas modification ///////////////

                if (_mode == "modifier") {

                    $("#OT_OTID").val(_OTID);

                    $('#FR_OT_OTNoBL').attr("disabled","disabled");
                    $('#btnMag').attr("disabled","disabled");
                    $("#FR_OT_codestock").attr("readonly", true);

                    $("#FR_OT_OTPoids").closest("tr").css("visibility", "visible");
                    $("#FR_OT_codestock").closest("tr").css("visibility", "visible");
                    $("#FR_OT_OTVolume").closest("tr").css("visibility", "visible");

                     $('#FR_OT_OTPoids').attr("disabled","disabled");
                     $('#FR_OT_codestock').attr("disabled","disabled");
                     $('#FR_OT_OTVolume').attr("disabled","disabled");

                     $('#factValue').attr("disabled","disabled");
                     $('#choixValue').attr("disabled","disabled");

                     /////////////////////////////////////////// Add Validation RDV \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                     if(_isOpen == '1' && _isPalannifToPast == '1')
                        $("#FR_OT_OTDateLivraison").closest("td").append("<input type='Button' value='Validation RDV' class='chercherBtn' id='ValiderRDV' /> Hors Proposition : <input id='ValiderRDVChoixClient' type='checkbox' value='ENL|HCV' />");

  


                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/GetInfoMagByOTID", { OTID: $("#OT_OTID").val() }, function (data) {

                        if (data.toString != "") { // console.log(data);
                            var dtInfosMagasin = data.toString().split('*');
                            //$("#FR_OT_magID").val(dtInfosMagasin[0]);
                            //$("#FR_OT_OTNoBL").val(dtInfosMagasin[1] + "-");

                            var OTNOBL_FULL = dtInfosMagasin[0];
                            var OTNOBL_FULL_TAB = OTNOBL_FULL.toString().split('-');
                            $("#FR_OT_OTNoBL").val(OTNOBL_FULL_TAB[0]);
                            $("#factValue").val(OTNOBL_FULL_TAB[1]);
                            $("#choixValue").val(OTNOBL_FULL_TAB[2]);
                            $("#form_label").html((_callFromGroup != '1' ? "Dossier Client ( " : "Dossier Groupe ( ") + dtInfosMagasin[0] + " ) -- Dépot Mère ( "+ dtInfosMagasin[34] +" )");
                            $("#FR_OT_OTDateLivraison").val(                dtInfosMagasin[1]);

                            $("a[index=dv_step_groupe3]").append("(" +                      dtInfosMagasin[2] + ")");
                            $("#FR_OT_Clieu_chargement").val(               dtInfosMagasin[2]);
                            $("#FR_OT_OTLieuChargement").val(               dtInfosMagasin[3]);
                            $("#FR_OT_np_chargement").val(                  dtInfosMagasin[4]);
                            $("#FR_OT_ville_chargement").val(               dtInfosMagasin[5]);
                            $("#FR_OT_pays_chargement").val(                dtInfosMagasin[6]);

                            $("a[href='#dv_step_groupe4']").append("(" +    dtInfosMagasin[7] + ")");
                            $("#FR_OT_OTDestinNom").val(                    dtInfosMagasin[7]); // console.log('------------- is here 3 ------------');
                            $("#FR_OT_OTAdresse1").val(                     dtInfosMagasin[8]);
                            $("#FR_OT_np_livraison").val(                   dtInfosMagasin[9]);
                            $("#FR_OT_ville_livraison").val(                dtInfosMagasin[10]);
                            $("#FR_OT_pays_livraison").val(                 dtInfosMagasin[11]);

                            $("a[href='#dv_step_groupe5']").append("(" +    dtInfosMagasin[12] + ")");
                            $("#FR_OT_Clieu_donneur").val(                  dtInfosMagasin[12]);
                            $("#FR_OT_Adr_donneur").val(                    dtInfosMagasin[13]);
                            $("#FR_OT_np_donneur").val(                     dtInfosMagasin[14]);
                            $("#FR_OT_ville_donneur").val(                  dtInfosMagasin[15]);
                            $("#FR_OT_pays_donneur").val(                   dtInfosMagasin[16]);

                            $("#FR_OT_codestock").val(                      dtInfosMagasin[17]);
                            $("#FR_OT_OTPoids").val(                        dtInfosMagasin[18]);
                            $("#OT_Date_Creation").text(                    dtInfosMagasin[19].substring(0,16)); 
//                            _Date = dtInfosMagasin[19];
//                            console.log(_Date);
                           // console.log(dtInfosMagasin[19].substring(0,16));
                            $("#FR_OT_OTVolume").val(                       dtInfosMagasin[20]);
                            $("#FR_OT_OTTel1").val(                         dtInfosMagasin[21]);
                            $("#FR_OT_OTTel2").val(                         dtInfosMagasin[22]);
                            $("#FR_OT_OTLivraisonContact").val(             dtInfosMagasin[23]);
                            $("#FR_OT_Email").val(                          dtInfosMagasin[24]);
                            $("#FR_OT_OTDestEmail").val(                    dtInfosMagasin[25]);

                            if (dtInfosMagasin[26] == '2'){
                                $('#id_Transport').attr('checked', true);
                                $('#id_Dossier').attr('checked', false);
                                }
                            else{
                                $('#id_Dossier').attr('checked', true);
                                $('#id_Transport').attr('checked', false);
                                }
                            $("#FR_OT_OTNoteInterne").val(                    dtInfosMagasin[27]);
                            $("#FR_OT_OTMontObligatoire").val(                    dtInfosMagasin[28]);
                            $("#FR_OT_OTCommunication").val(                    dtInfosMagasin[29]);
                            //
                            $("#FR_OT_OTChargementContact").val(		dtInfosMagasin[30]);
                            $("#FR_OT_OTTelChargement").val(			dtInfosMagasin[31]);
                            $("#FR_OT_OTChargementEmail").val(			dtInfosMagasin[32]);

                            $("#FR_OT_OTTel3").val(                     dtInfosMagasin[33]);
 
                        }

                    });

                    if(_callFromGroup != '1')
                    {
                    $("#dv_loading_detail").css("display", "");
                     $.get($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: $("#OT_OTID").val(),  isOpen: _isOpen, isPalannifToPast: _isPalannifToPast}, function (data) {                      
                            $("#divPackageModifier").html(data);
                            $("#dv_loading_detail").css("display", "none");
                      });

                       $.get($.fn.SERVER_HTTP_HOST() + "/Communication/getlstCom", { RessourceID: $("#OT_OTID").val(), Ressource: "OT",  isOpen: _isOpen}, function (data) {                            
                            $("#divCommunication").html(data);
                      });

                     $.get($.fn.SERVER_HTTP_HOST() + "/Ajoindre/ajForm", { OTID: $("#OT_OTID").val(), facturer: "oui" ,  isOpen: _isOpen, isPalannifToPast: _isPalannifToPast}, function (data) {

                            $("#divAjoindre").html(data);

                      });

                       $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/getLstPrestation", { prestOTID: $("#OT_OTID").val(),  isOpen: _isOpen, isPalannifToPast: _isPalannifToPast }, function (data) {

                            $("#divPrestation").html(data);

                      });
                      ///////////////////////// Afficher Articles OT \\\\\\\\\\\\\\\\\\\\\
                       $.get($.fn.SERVER_HTTP_HOST() + "/Article/getLstArticles", { OTID: $("#OT_OTID").val(),  isOpen: _isOpen }, function (data) {

                            $("#divArticle").html(data);

                      });

                    }
                    
                }
              
                //////////////Buttons des click/////////////////

                $("#btnMag").click(function () { //// search magasin


                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/getRefListMagasin", { magID: "-1", input: "FR_OT_OTNoBL|MagasinCode", txtID: "FR_OT_magID" },
                   function (data) {
                       $("#magChoixx").remove();
                       $("#magChoix").html("<div id='magChoixx' title='Liste de magasins'>" + data + "</div>");
                       $("#magChoixx").dialog({
                           width: 650,
                           height: 500,
                           modal: true,
                           // position: 'top',
                       });

                      // $("#magChoixx").dialog("option", "position", [300, 300]);
                   });
                });

                $("#ValiderRDV").click(function () { 
                    if(confirm("Confirmer le RDV ?"))
                    {
                        var _date_rdv = $("#FR_OT_OTDateLivraison").val();
                        _date_rdv = _date_rdv.replace("/", "").replace("/", "");
                        var choixClient = '';
                        if($("#ValiderRDVChoixClient").is(':checked'))
                          choixClient = $("#ValiderRDVChoixClient").val();   

                         $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/addPrestationRDV", { OTID: _OTID, date_rdv: _date_rdv, choixClient: choixClient  }, function (data) {
                            var intData = parseInt(data);
                            if(intData > 0)
                                window.location.href = $.fn.SERVER_HTTP_HOST() +"/OT/afficherOT?mode=modifier&OTID=" + _OTID;
                            else
                            {
                                var msg = "Erreur !!";
                                if(intData == -2)
                                    msg = "Rendez vous déjà pris !!";
                                alert(msg);
                            }                                
                         });
                    }
                });



                ////////////////////////////////////////////////////////////AutoCompete, Date//////////////////////////////////////////////////
                /*
                $("#FR_OT_OTDateLivraison").datepicker({
                    dateFormat: 'dd/mm/yy',
                    // timeFormat:  "HH:mm",
                    changeMonth: true,
                    changeYear: true
                });
                

                $("#FR_OT_OTDateLivraison").click(function () {

                        $("#ui-datepicker-div").css("visibility", "visible");
                });             

                $("#ui-datepicker-div").css("visibility", "hidden");
                */
                // console.log(_Date);
                $('#FR_OT_OTDateLivraison').datetimepicker({
                    dayOfWeekStart : 1,
                    value: $(this).val(),
                    formatTime:'H:i',
	                formatDate:'Y/m/d',
                    lang:'fr',
                    step:30,
                     allowTimes:[
                      '05:00','05:30','06:00','06:30','07:00','07:30','08:00','08:30','09:00','09:30','10:00','10:30','11:00','11:30','12:00','12:30','13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30','17:00','17:30','18:00','18:30','19:00','19:30','20:00','20:30','21:00','21:30','22:00','22:30'
                     ]
                });

                
                $("#FR_OT_adr_donneur").autocomplete({  //Auto complete Adresse Donneur
                    source: function (request, response) {
                        $.ajax({
                            url: $.fn.SERVER_HTTP_HOST() + "/Orders/getAdresseComplete",
                            dataType: "json",
                            type: "POST",
                            data: { val: request.term, ClientID : $("#FR_OT_donnID").val() },
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
                        var infosAdr = ui.item.value.split('*');
                        $("#FR_OT_adr_donneur").val(infosAdr[0]);
                        $("#FR_OT_np_donneur").val(infosAdr[1]);
                        $("#FR_OT_ville_donneur").val(infosAdr[2]);
                        return false;
                    }
                });

                $("#FR_OT_OTLieuChargement").autocomplete({  //Auto complete Adresse Chargement
                    source: function (request, response) {
                        $.ajax({
                            url: $.fn.SERVER_HTTP_HOST() + "/Orders/getAdresseComplete",
                            dataType: "json",
                            type: "POST",
                            data: { val: request.term, ClientID: $("#FR_OT_chargID").val() },
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
                        var infosAdr = ui.item.value.split('*');
                        $("#FR_OT_OTLieuChargement").val(infosAdr[0]);
                        $("#FR_OT_np_chargement").val(infosAdr[1]);
                        $("#FR_OT_ville_chargement").val(infosAdr[2]);
                        return false;
                    }
                });


                $("#FR_OT_OTAdresse1").autocomplete({  //Auto complete Adresse Livraison
                    source: function (request, response) {
                        $.ajax({
                            url: $.fn.SERVER_HTTP_HOST() + "/Orders/getAdresseComplete",
                            dataType: "json",
                            type: "POST",
                            data: { val: request.term, ClientID: $("#FR_OT_livrID").val() },
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
                        var infosAdr = ui.item.value.split('*');
                        $("#FR_OT_OTAdresse1").val(infosAdr[0]);
                        $("#FR_OT_np_livraison").val(infosAdr[1]);
                        $("#FR_OT_ville_livraison").val(infosAdr[2]);
                        return false;
                    }
                });


                $("#FR_OT_pays_chargement").autocomplete({  //Auto complete Pays Chargement
                    
                    source: function (request, response) {
                        $.ajax({
                            url: $.fn.SERVER_HTTP_HOST() + "/Orders/getPaysComplete",
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
                        $("#FR_OT_pays_chargement").val(ui.item.value);
                        return false;
                    }
                });

                $("#FR_OT_pays_donneur").autocomplete({  //Auto complete Pays Chargement

                    source: function (request, response) {
                        $.ajax({
                            url: $.fn.SERVER_HTTP_HOST() + "/Orders/getPaysComplete",
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
                        $("#FR_OT_pays_donneur").val(ui.item.value);
                        return false;
                    }
                });

                $("#FR_OT_pays_livraison").autocomplete({  //Auto complete Pays Livraison

                    source: function (request, response) {
                        $.ajax({
                            url: $.fn.SERVER_HTTP_HOST() + "/Orders/getPaysComplete",
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
                        $("#FR_OT_pays_livraison").val(ui.item.value);
                        return false;
                    }
                });

                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                ///////////////////////////////////////Detecte changement   MAGASIN ///////////////////////////////////////////////

                $("#FR_OT_magID").change(function () {  /// changement Magasin BY ID

                    var _valID = $("#FR_OT_magID").val();


                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetInfos", { magValID: _valID }, function (data) {
                        if (data.toString() != "") {

                            var dtInfosAll = data.toString().split('|');
                            var dtInfosDonn = dtInfosAll[0].split('*');
                            var dtInfosCharg = dtInfosAll[1].split('*');
                            var dtInfosLivr = dtInfosAll[2].split('*');

                             $("#FR_OT_donnID").val(dtInfosDonn[0]);
                             $("a[href='#dv_step_groupe5']").text("");
                            $("a[href='#dv_step_groupe5']").append("Donneur (" + dtInfosDonn[1] + ")");
                            $("#FR_OT_Clieu_donneur").val(dtInfosDonn[1]);
                            $("#FR_OT_Adr_donneur").val(dtInfosDonn[2]);
                            $("#FR_OT_np_donneur").val(dtInfosDonn[3]);
                            $("#FR_OT_ville_donneur").val(dtInfosDonn[4]);
                            $("#FR_OT_pays_donneur").val(dtInfosDonn[5]);
                            $("#FR_OT_OTTel1").val(dtInfosDonn[6]);

                            $("#FR_OT_chargID").val(dtInfosCharg[0]);

                            $("#FR_OT_chargNom").val(dtInfosCharg[1]);
                            $("#FR_OT_Clieu_chargement").val(dtInfosCharg[2]);
                            $("#FR_OT_np_chargement").val(dtInfosCharg[3]);
                            $("#FR_OT_ville_chargement").val(dtInfosCharg[4]);
                            $("#FR_OT_pays_chargement").val(dtInfosCharg[5]);

                            $("#FR_OT_livrID").val(dtInfosLivr[0]);
                            $("a[href='#dv_step_groupe4']").text("");
                            $("a[href='#dv_step_groupe4']").append("Livraison (" + dtInfosLivr[1] + ")"); // console.log('------------- is here 1 ------------');
                            $("#FR_OT_OTDestinNom").val(dtInfosLivr[1]);
                            $("#FR_OT_OTAdresse1").val(dtInfosLivr[2]);
                            $("#FR_OT_np_livraison").val(dtInfosLivr[3]);
                            $("#FR_OT_ville_livraison").val(dtInfosLivr[4]);
                            $("#FR_OT_pays_livraison").val(dtInfosLivr[5]);
                            $("#FR_OT_OTTel2").val(dtInfosLivr[6]);

                        }
                    });
                });
                $("#FR_OT_OTNoBL").unbind("keypress").keypress(function(e) {
                    if(e.which == 13) {
                        alert('You pressed enter!');
                    }
                });
                $("input[id^=FR_OT_np_]").unbind("keypress").keypress(function(e) {
                    if(e.which == 13) {
                        var id = $(this).attr("id");
                        var tab = id.split("_");
                        // $("#FR_OT_ville_" + tab[3]).val("test");
                        $.get($.fn.SERVER_HTTP_HOST() + "/Orders/getVilleByNP", {np: $(this).val()}, function (res) {
                            if(res != '0')
                               $("#FR_OT_ville_" + tab[3]).val(res);
                            
                        });

                    }
                });
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                ///////////////////////////////////////////////////Button de la recherche Client ///////////////////////////////////

                $("#FR_OT_BTN_chargSearch").click(function () { //// search Chargement


                    $.post($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetRessources", { cliFamille: 'c', lbl: 'FR_OT_TXT_chargSearch|Nom', txt: 'FR_OT_chargID' },
                 function (data) {
                     //$("#dv_loading_detail").css("display", "none");

                     $("#magChoixx").remove();
                     $("#magChoix").html("<div id='magChoixx' title='Liste des clients: Chargement'>" + data + "</div>");
                     $("#magChoixx").dialog({
                         width: 500,
                         height: 500,
                         modal: true,
                         // position: 'top',

                     });

                     $("#magChoixx").dialog("option", "position", [600, 200]);
                   });
                });

                $("#FR_OT_BTN_livrSearch").click(function () { //// search Livraison


                    $.post($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetRessources", { cliFamille: 'l', lbl: 'FR_OT_TXT_livrSearch|Nom', txt: 'FR_OT_livrID' },
                 function (data) {
                     //$("#dv_loading_detail").css("display", "none");

                     $("#magChoixx").remove();
                     $("#magChoix").html("<div id='magChoixx' title='Liste des clients: Livraison'>" + data + "</div>");
                     $("#magChoixx").dialog({
                         width: 500,
                         height: 500,
                         modal: true,
                         // position: 'top',

                     });

                     $("#magChoixx").dialog("option", "position", [600, 200]);
                 });
                });

                $("#FR_OT_BTN_donnSearch").click(function () { //// search Donneur


                    $.post($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetRessources", { cliFamille: 'd', lbl: 'FR_OT_TXT_donnSearch|Nom', txt: 'FR_OT_donnID' },
                 function (data) {
                     //$("#dv_loading_detail").css("display", "none");

                     $("#magChoixx").remove();
                     $("#magChoix").html("<div id='magChoixx' title='Liste des clients: Donneur'>" + data + "</div>");
                     $("#magChoixx").dialog({
                         width: 500,
                         height: 500,
                         modal: true,
                         // position: 'top',

                     });

                     $("#magChoixx").dialog("option", "position", [600, 200]);


                 });
                });

                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                ///////////////////////////////////////// Changement Valeur DONNEUR, CHARGEMENT, LIVRAISON///////////////////////////

                $("#FR_OT_chargID").change(function () {  /// changement Chargement BY ID

                    var _valID = $("#FR_OT_chargID").val();


                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetRessourceClientByID", { cliFamille: 'c', valID: _valID }, function (data) {
                        if (data.toString() != "") {

                            var dtCharg = data.toString().split('*');

                            $("#FR_OT_Clieu_chargement").val(dtCharg[0]);
                            $("a[index=dv_step_groupe3]").html("");
                            $("a[index=dv_step_groupe3]").append("Chargement(" + dtCharg[0] + ")");
                            $("#FR_OT_OTLieuChargement").val(dtCharg[1]);
                            $("#FR_OT_np_chargement").val(dtCharg[2]);
                            $("#FR_OT_ville_chargement").val(dtCharg[3]);
                            $("#FR_OT_fax_chargement").val(dtCharg[4]);

                        }
                    });
                });

                $("#FR_OT_livrID").change(function () {  /// changement Livraison BY ID

                    var _valID = $("#FR_OT_livrID").val();


                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetRessourceClientByID", { cliFamille: 'l', valID: _valID }, function (data) {
                        if (data.toString() != "") {

                            var dtLivr = data.toString().split('*');

                            $("#FR_OT_OTDestinNom").val(dtLivr[0]);//console.log('------------- is here 2 ------------');
                            $("a[href='#dv_step_groupe4']").text("");
                            $("a[href='#dv_step_groupe4']").append("Livraison(" + dtLivr[0] + ")");
                            $("#FR_OT_OTAdresse1").val(dtLivr[1]);
                            $("#FR_OT_np_livraison").val(dtLivr[2]);
                            $("#FR_OT_ville_livraison").val(dtLivr[3]);
                            $("#FR_OT_fax_livraison").val(dtLivr[4]);
                            $("#FR_OT_OTTel2").val(dtDonn[5]);

                        }
                    });
                });

                $("#FR_OT_donnID").change(function () {  /// changement Donneur BY ID

                    var _valID = $("#FR_OT_donnID").val();


                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/OTGetRessourceClientByID", { cliFamille: 'd', valID: _valID }, function (data) {
                        if (data.toString() != "") {

                            var dtDonn = data.toString().split('*');

                            $("#FR_OT_Clieu_donneur").val(dtDonn[0]);
                            $("a[href='#dv_step_groupe5']").text("");
                            $("a[href='#dv_step_groupe5']").append("Donneur(" + dtDonn[0] + ")");
                            $("#FR_OT_Adr_donneur").val(dtDonn[1]);
                            $("#FR_OT_np_donneur").val(dtDonn[2]);
                            $("#FR_OT_ville_donneur").val(dtDonn[3]);
                            $("#FR_OT_fax_donneur").val(dtDonn[4]);
                            $("#FR_OT_OTTel1").val(dtDonn[5]);

                        }
                    });
                });
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                //////////////////////////Chercher Par Code Donneur///////////////////////////

                $("#CliDonneurTxtSearchCodeDyn").keypress(function (e) {// HERE
                    var key = e.which;
                    if (key == 13) {

                        var _valDonnCode = $("#CliDonneurTxtSearchCodeDyn").val();
                        //alert(_valCode);
                        if (_valDonnCode == "-") {
                            $("#FR_OT_donnID").val("-1");
                            $("#FR_OT_TXT_donnSearch").text("");

                           $("#FR_OT_Clieu_donneur").val("");
                            $("a[href='#dv_step_groupe5']").text("");
                            $("a[href='#dv_step_groupe5']").append("Donneur");
                            $("#FR_OT_Adr_donneur").val("");
                            $("#FR_OT_np_donneur").val("");
                            $("#FR_OT_ville_donneur").val("");
                            $("#FR_OT_fax_donneur").val("");
                            $("#FR_OT_OTTel1").val("");

                        }
                        else {
                            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByCode", { cliFamille: 'd', valChargCode: _valDonnCode }, function (data) {

                                if (data == "") {
                                    //alert("Code introuvable");
                                    $("#FR_OT_TXT_donnSearch").text("Ce code n'existe pas");
                                }
                                else if (data != null && data != "") {
                                    var infosDonneur = data.toString().split('*');
                                    $("#FR_OT_donnID").val(infosDonneur[0]).trigger('change');
                                    $("#FR_OT_TXT_donnSearch").text(infosDonneur[1]);
                                }
                                else
                                    alert("error");
                            });
                        }
                    }
                });

                ///////////////////////////////////////////////////

                //////////////////////////Chercher Par Code Livraison///////////////////////////

                $("#CliLivTxtSearchCodeDyn").keypress(function (e) {// HERE
                    var key = e.which;
                    if (key == 13) {

                        var _valDonnCode = $("#CliLivTxtSearchCodeDyn").val();
                        //alert(_valCode);
                        if (_valDonnCode == "-") {
                            $("#FR_OT_livrID").val("-1");
                            $("#FR_OT_TXT_livrSearch").text("");
                            
                             $("#FR_OT_OTDestinNom").val("");
                            $("a[href='#dv_step_groupe4']").text("");
                            $("a[href='#dv_step_groupe4']").append("Livraison");
                            $("#FR_OT_OTAdresse1").val("");
                            $("#FR_OT_np_livraison").val("");
                            $("#FR_OT_ville_livraison").val("");
                            $("#FR_OT_fax_livraison").val("");
                            $("#FR_OT_OTTel2").val("");
                            $("#FR_OT_OTLivraisonContact").val("");
                        }
                        else {
                            $.post($.fn.SERVER_HTTP_HOST() + "/Client/clientGetRessourceByCode", { cliFamille: 'l', valChargCode: _valDonnCode }, function (data) {

                                if (data == "") {
                                    //alert("Code introuvable");
                                    $("#FR_OT_TXT_livrSearch").text("Ce code n'existe pas");
                                }
                                else if (data != null && data != "") {
                                    var infosDonneur = data.toString().split('*');
                                    $("#FR_OT_livrID").val(infosDonneur[0]).trigger('change');
                                    $("#FR_OT_TXT_livrSearch").text(infosDonneur[1]);
                                }
                                else
                                    alert("error");
                            });
                        }
                    }
                });

                ///////////////////////////////////////////////////

            };
     


            ///////////////////Afficher a forme de la page ressource ///////////////////
            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/FormRessource", { RessourceCode: "OT", DetailID: _OTID, mode: "List", isOpen: _isOpen, isPalannifToPast: _isPalannifToPast, callFromGroup: _callFromGroup}, function (data) {
                $("#myForm").html(data);
                setTimeout(function () {
                    $.fn.myModify();

                    $("#FR_OT_BTN_donnSearch").attr("disabled", "disabled");

                }, 1000);
                
            });



        });

    </script>
</div>
</asp:Content>
