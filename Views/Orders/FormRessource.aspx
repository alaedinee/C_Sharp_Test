<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="System.Data" %>

       <%-- <%
            //string adr = HttpContext.Current.Request.Url.Host;
            //Response.Write(@"<script language='javascript' src='" + Globale_Varriables.VAR.get_URL_HREF() + "Content/jquery.min.js'></script>");           
            Response.Write(@"<link href='../../Content/styles2.css' rel='stylesheet' type='text/css' />");
        %>--%>

<%
    string _RessourceCode = ViewData["RessourceCode"].ToString();
    string _DetailID = ViewData["DetailID"].ToString();
    string _step = ViewData["step"].ToString();
    string _mode = ViewData["mode"].ToString();
    string _isOpen = ViewData["isOpen"].ToString();
    string _isPalannifToPast = ViewData["isPalannifToPast"].ToString();
    int _OTPeriodesNonAttribuees = (int)ViewData["OTPeriodesNonAttribuees"];
    string _callFromGroup = ViewData["callFromGroup"].ToString();
%>

<style>
          .block {
                float:left;
                width:100%;
                margin:5px;
            }
            
         .block-left {
                float:left;
                width:49%;
                margin:5px;
            }
         .block-right 
         {
                float: left;
                width:49%;
                margin:5px;
            }
             .row 
         {
                float: left;
          
            }
            
          #FR_OT_OTNoBL 
         {
               width:58px;
            }
            #factValue 
         {
               width:58px;
            }
            #choixValue 
         {
               width:65px;
            }

</style>




        <div style="overflow:hidden;" >

           <br />
            
           <div id="div_info_ot_header">
               <div style="float: left;">
               <%if (_DetailID == "0"){ %>
                    Dossier groupe : <input type="checkbox" id="chx_ot_groupe" />
                <%} %>
               </div>
                <div style='text-align:right'>
                <% if (_isOpen != "0"){ %>
                        <% if (_isPalannifToPast != "0"){ %>
                        <input type="button" id="FR_<%: _RessourceCode %>_<%: _step %>_btnSave" class="validerBtn" value="  Sauver  " />
                        <% } %>
                        <%if (_DetailID != "0")
                          { %>
                          <%if (_OTPeriodesNonAttribuees == 0){%>
                        <input type="button" id="FR_<%: _RessourceCode %>_<%: _step %>_btnRelivrer" class="validerBtn" value="  Relivrer  " />
                          <%}%>
                        <input type="button" id="FR_<%: _RessourceCode %>_<%: _step %>_btnCloturer" class="validerBtn" value="  Clôturer  " />
                        <%if (_callFromGroup == "1")
                          {%>
                        <input type="button" id="FR_<%: _RessourceCode %>_<%: _step %>_btnStatuer" class="validerBtn" value="  Statuer  " />
                        <%}%>
                        <input type="button" id="FR_<%: _RessourceCode %>_<%: _step %>_btnImprimer" class="validerBtn" value="  Imprimer  " />
                        <input type="button" id="FR_<%: _RessourceCode %>_<%: _step %>_btnImprimerBL" class="validerBtn" value="  Imprimer BL  "/>
                        <%} %>
                <% } %>
                </div>
                           <br />
                <fieldset>
                    <legend id="form_label"></legend>
                    <div >
                        <div id="FR_<%: _RessourceCode %>_<%: _step %>_dvColumns"></div>                    
                    </div>
                    <div id="PAR_<%: _RessourceCode %>_<%: _step %>"></div>                
                </fieldset>            
            </div>
            <div id="div_info_ot_body">
                <div class="row" style="width:100%;">

                    <div id="divPackageModifier" class="block" >
            
                    </div>
                        
                </div>

                <div class="row" style="width:100%;">

                    <div id="divPrestation"  class="block-left">
             
                    </div>   

                    <div id="divAjoindre"  class="block-right">
             
                    </div>
                    
                </div>

                <div class="row" style="width:100%;">

                    <div id="divArticle"  class="block-left">
             
                    </div>  
                    <div id="divCommunication" class="block-right"  >
             
                    </div>        
                    
                </div>
            </div>
            


        

            
            

        </div>

<div id="sp-dialog"></div>
        

<script>
    var _RessourceCode = '<%: _RessourceCode %>';
    var _DetailID = '<%: _DetailID %>';
    var _step = '<%: _step %>';
    var _mode = '<%: _mode %>';

    var tab = new Array();
    var lat;
    var lon;
    var typeDossierGroupe = true;

    $(document).ready(function () {
        $("#hrefValider").click(function () {
            $('#displayMap').dialog("close");
        });

        $.fn.validateField = function (id) {
            var ok = false;
            var regex = $("#" + id).attr("RegEx");
            var _value = $("#" + id).val();

            if (_value != '') {// && _value.match(new RegExp(regex, 'i'))) {
                $("#" + id).css("border", "1px solid LightGray ");
                ok = true;
            }
            else {
                $("#" + id).css("border", "1px solid red");
                ok = false;
            }
            return ok;
        };

       

        $.fn.setAutoRessource = function (_obj, _tag) {
            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/getAutoRessource", { tag: _tag }, function (data) {
                var _idx = _tag.split("|")[0];
                tab[_idx] = data.split("\n");

                $(_obj).autocomplete({
                    source: tab[_idx]
                });
            });
        };

        $.fn.GenerateForm = function (json, dvName) {
            var lst = jQuery.parseJSON(json);

            var contents = '';
            for (i = 0; i < lst.length; i++) {
                var obj = lst[i];
                var elem = "<tr><td><b>" + ((obj.Type != "LINK" && obj.Type != "GEO" && obj.Type != "LATITUDE" && obj.Type != "LONGITUDE") ? obj.Label : " ") + "</b></td><td>";
                var attr = " auto='" + obj.auto + "' ";
                attr += (_DetailID != '0' && obj.Editable == '0') ? " readonly='readonly' " : " ";
                attr += " CCode='" + obj.Code + "' ";
                attr += " RegEx='" + obj.RegEx + "' ";
                attr += " isRequired='" + obj.Required + "' ";
                var name = " id='FR_" + _RessourceCode + "_" + obj.Code + "' name='FR_" + _RessourceCode + "_" + obj.Code + "' ";

               // alert(obj.Code);
                if (obj.Type == "TEXT" || obj.Type == "ADRESSE" || obj.Type == "DATE" || obj.Type == "VILLE" || obj.Type == "PAYS"){
                        elem += "<input type='text' " + name + " value='" + obj.Value + "' CType='" + obj.Type + "' CID='" + obj.ID + "' " + attr + " /></td></tr>";
                }    
                else if (obj.Type == "LATITUDE" || obj.Type == "LONGITUDE")
                    elem += "<input type='hidden' " + name + " value='" + obj.Value + "' CType='" + obj.Type + "' CID='" + obj.ID + "' " + attr + " /></td></tr>";
                else if (obj.Type == "LINK")
                    elem += "<input type='button'  Source='" + obj.Source + "' value='" + obj.Label + "' LINK='FR_" + _RessourceCode + "_" + obj.Code + "' /><input type='hidden' CType='" + obj.Type + "' " + name + " value='" + obj.Value + "' CID='" + obj.ID + "' " + attr + "  Source='" + obj.Source + "' />  &nbsp;  <span id='FR_" + _RessourceCode + "_" + obj.Code + "_lbl'>" + obj.Value + "</span></td></tr>";
                else if (obj.Type == "GEO")
                    elem += "<input type='button' " + name + " CType='" + obj.Type + "' CID='" + obj.ID + "' " + attr + " value='" + obj.Label + "' /></td></tr>";
                else if (obj.Type == "TEXTAREA")
                    elem += "<textarea " + name + " CType='" + obj.Type + "' CID='" + obj.ID + "' " + attr + ">" + obj.Value + "</textarea></td></tr>";
                
                contents += elem;
            }

            if (contents != '') {
                contents = '<table>' + contents + '</table>';

                $("#" + dvName).html(contents);
            }

            $("#" + dvName + " table input[auto]").each(function () {
                var tag = $(this).attr("auto");
                if (tag != '') {
                    var _name = "#" + $(this).attr("id");
                    $.fn.setAutoRessource(_name, tag);
                }
            });

           

            $("#" + dvName + " table input[LINK]").click(function () {
                var _src = $(this).attr("Source");
                var _nStep = parseInt(_step) + 2;
                var _cStep = parseInt(_step) + 1;

                var _txt = $(this).attr("LINK");
                var _lbl = $(this).attr("LINK") + "_lbl|Code|Nom";

                $.fn.loadParentRessourceList(_src, _lbl, _txt, _nStep, _cStep);
            });
            /**/
            $("#FR_" + _RessourceCode + "_<%: _step %>_btnImprimerBL").not(".init").addClass("init").click(function () {
                    var typeBL_Print = $('select[name="typeGroupeOT"]').val();
                    var url = $.fn.SERVER_HTTP_HOST() + "/Ajoindre/Imprime_BL_MULTI/?OTID=" + _DetailID;
                    if(typeBL_Print)
                        url += "&temp_name=BL_GROUPE_" + typeBL_Print;                        
                    window.open(url, '_blank');
            });
            
            $("#FR_" + _RessourceCode + "_<%: _step %>_btnImprimer").not(".init").addClass("init").click(function () {

             $.post($.fn.SERVER_HTTP_HOST() + "/Mob/GetFromPrint", { OTID : _DetailID },
                 function (data) {
                     //$("#dv_loading_detail").css("display", "none");

                     $("#magChoixx").remove();
                     $("#magChoix").html("<div id='magChoixx' title='from impression'>" + data + "</div>");
                     $("#magChoixx").dialog({
                         width: 400,
                         height: 200,
                         modal: true,
                         // position: 'top',

                     });

                     $("#magChoixx").dialog("option", "position", [600, 200]);


                 });

           
                });
                ///////////////////////////////// btn relivrer \\\\\\\\\\\\\\\\\\\\\\\\\\\\\_
            $("#FR_" + _RessourceCode + "_<%: _step %>_btnRelivrer").not(".init").addClass("init").click(function () {
                        var _OTID = _DetailID;
                        var _conf = confirm("Voulez vous relivrer cet OT?");
                        if (_conf) {

                        

                            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/RelivrerOT", { OTID: _OTID },

                                    function (htmlResult) {

                                        if(htmlResult.toString() == "1") {
                                        // alert("Opération réussie");
                                        location.reload();
                                        }
                                 
                                    }
                                );

                                }
                        });
                ///////////////////////////////// btn cloturer \\\\\\\\\\\\\\\\\\\\\\\\\\\\\_
            $("#FR_" + _RessourceCode + "_<%: _step %>_btnCloturer").not(".init").addClass("init").click(function () {

                        var _OTID = _DetailID;
                        var _conf = confirm("Voulez vous cloturer cet OT?");
                        if (_conf) {

                        

                            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/CloturerOT", { OTID: _OTID },

                                    function (htmlResult) {

                                        if(htmlResult.toString() == "1") {
                                        // alert("Opération réussie");
                                        window.location.replace($.fn.SERVER_HTTP_HOST() + "/Orders/getLstOTcloture");
                                        }
                                 
                                    }
                                );

                                }
                        });
                ///////////////////////////////// btn statuer \\\\\\\\\\\\\\\\\\\\\\\\\\\\\_
            $("#FR_" + _RessourceCode + "_<%: _step %>_btnStatuer").not(".init").addClass("init").click(function () {

                        var _OTID = _DetailID;
                        $.get($.fn.SERVER_HTTP_HOST() + "/OT/SelectPrestAStatuer", {OTIDGroup: _OTID },
                           function (data) {
                               $("#sp-dialog-content").remove();
                               $("#sp-dialog").html("<div id='sp-dialog-content' title='Statuer Les Prestation'>" + data + "</div>");
                               $("#sp-dialog-content").dialog({
                                   width: 650,
                                   height: 500,
                                   modal: true
                            });
                        });                        
            });

           
                
              
              

           <%-- $("#FR_" + _RessourceCode + "_<%: _step %>_btnSave").not(".init").addClass("init").click(function () {
                var _ok = true;
                var _jsonData = '';
                $("#FR_" + _RessourceCode + "_<%: _step %>_dvColumns input[CType]").each(function () {
                    var _isRequired = $(this).attr("isRequired");
                    var _value = "", _type = $(this).attr("CType"), _id = $(this).attr("id");

                    if (_isRequired == "1") _ok = _ok && $.fn.validateField(_id);

                    _jsonData += '{"ID": "' + $(this).attr("CID") + '"';
                    _jsonData += ', "Code": "' + $(this).attr("CCode") + '"';
                    if (_type == 'TEXT' || _type == 'ADRESSE' || _type == "LINK" || _type == "DATE" || _type == "VILLE" || _type == "PAYS" || _type == "LATITUDE" || _type == "LONGITUDE") _value = $("#" + _id).val();
                    _jsonData += ', "Value": "' + _value + '"}, ';
                });

                if (_ok) {
                    if (_jsonData.length > 2) _jsonData = _jsonData.substring(0, _jsonData.length - 2);
                    _jsonData = '[' + _jsonData + ']';

                    alert($.fn.SERVER_HTTP_HOST() + _formLink);

                    $.get($.fn.SERVER_HTTP_HOST() + _formLink, { RessourceCode: _RessourceCode, DetailID: _DetailID, json: _jsonData }, function (data) {
                        if (data == "0") {
                            alert("Erreur !");
                        }
                        else {
                            alert("Enregistrée avec succès !");
                        }
                    });
                } else
                    alert("Veuillez vérifier les champs !");
            });--%>

            $("#FR_OT_OTNoBL").attr("maxlength", "9");
            $("#factValue").attr("maxlength", "9");


            $("#FR_" + _RessourceCode + "_<%: _step %>_btnSave").not(".init").addClass("init").click(function () {
                        var _ok = true;

                        var _dateLivr = $("#FR_OT_OTDateLivraison").val();
                        _dateLivr = _dateLivr.replace("/", "").replace("/", "");
                        
                        var _OTNoBL = $("#FR_OT_OTNoBL").val() + "-" + $("#factValue").val() + "-" + $("#choixValue").val();  

                        

                        var _OTCodeStock = $("#FR_OT_codestock").val();

                        var _nomCharg = $("#FR_OT_Clieu_chargement").val();
                        var _lieuCharg = $("#FR_OT_OTLieuChargement").val();
                        var _NPCharg = $("#FR_OT_np_chargement").val();
                        var _villeCharg = $("#FR_OT_ville_chargement").val();
                        var _paysCharg = $("#FR_OT_pays_chargement").val();
                        //
                        var _OTChargementContact    = $("#FR_OT_OTChargementContact").val();
                        var _OTTelChargement        = $("#FR_OT_OTTelChargement").val();
                        var _OTChargementEmail      = $("#FR_OT_OTChargementEmail").val();

                        var _nomLivr = $("#FR_OT_OTDestinNom").val();
                        var _lieuLivr = $("#FR_OT_OTAdresse1").val();
                        var _NPLivr = $("#FR_OT_np_livraison").val();
                        var _villeLivr = $("#FR_OT_ville_livraison").val();
                        var _paysLivr = $("#FR_OT_pays_livraison").val();
                        var _contLivr = $("#FR_OT_OTLivraisonContact").val();
                        var _telLivr = $("#FR_OT_OTTel2").val();
                        var _telLivr2 = $("#FR_OT_OTTel3").val();
                        var _courrLivr = $("#FR_OT_Email").val();

                        var _nomDonn = $("#FR_OT_Clieu_donneur").val();
                        var _lieuDonn = $("#FR_OT_Adr_donneur").val();
                        var _NPDonn = $("#FR_OT_np_donneur").val();
                        var _villeDonn = $("#FR_OT_ville_donneur").val();
                        var _paysDonn = $("#FR_OT_pays_donneur").val();
                        var _telDonn = $("#FR_OT_OTTel1").val();
                        var _courrDonn = $("#FR_OT_OTDestEmail").val();

                        var _OTMagID = $("#FR_OT_magID").val();
                        var _DetailID = $("#OT_OTID").val();
                        var _packID = $("#FR_OT_packID").val();

                        var _OTNoteInterne = $("#FR_OT_OTNoteInterne").val();
                        var _OTCommunication = $("#FR_OT_OTCommunication").val();

                        var _OTMontObligatoire = $("#FR_OT_OTMontObligatoire").val();
                        
                        var _typeDoss = '1';
                        var _typeGDoss = null;
                        if(!typeDossierGroupe)
                            _typeDoss = $('input[name="type_OT"]:checked').val();
                        else
                            _typeGDoss = $('select[name="typeGroupeOT"]').val();

                        if (_OTNoBL == ""){
                            alert("Le numéro de bulletin est vide");
                            return  false;
                        }
                        if (_nomDonn == ""){
                            alert("Info donneur est vide !");
                            return  false;
                        }
                        if (_NPLivr == ""){
                            alert("NP Livraison est vide !");
                            return  false;
                        }

                        console.log(_OTMontObligatoire, (_OTMontObligatoire != null && _OTMontObligatoire.length > 0), !isNaN(_OTMontObligatoire))
                        if((_OTMontObligatoire != null && _OTMontObligatoire.length > 0) && isNaN(_OTMontObligatoire))
                        {
                            alert("Somme obligatoire n'est valide !!");
                            return  false;
                        }

                        if ($("#factValue").val() == ""){
                            alert("Le numéro de facture est vide");
                            return  false;
                        }

                        if ($("#FR_OT_OTNoBL").val() == ""){
                            alert("Le numéro de magasin est vide");
                            return  false;
                        }

                        if($("#choixValue").val().indexOf('-') >= 0 || $("#choixValue").val().indexOf('-') >= 0 || $("#FR_OT_OTNoBL").val().indexOf('-') >= 0)
                        {
                          alert("Le N° de dossier n'accepte pas des tirets");
                          return false;
                        }


                            if (_OTNoBL.toUpperCase().indexOf("-NO-") >= 0){ //debut if existe 'NO'
                       
                                var _valDonn = $("#FR_OT_OTNoBL").val();
                                var _valChoix = $("#choixValue").val();
                                var _existe = 0;
                                $.get($.fn.SERVER_HTTP_HOST() + "/Orders/verifierOTexiste", { valDonn: _valDonn , valChoix : _valChoix }, function (data) {

                                if (data != "0") { // if 'existe'
                                     $.get($.fn.SERVER_HTTP_HOST() + "/Orders/propositionOT", { valDonn: _valDonn , valChoix : _valChoix }, function (data) {
                                         $("#magChoixx").remove();
                                         $("#magChoix").html("<div id='magChoixx' title='List des propositions'>" + data + "</div>");
                                         $("#magChoixx").dialog({
                                             width: 650,
                                             height: 500,
                                             modal: true,
                                             // position: 'top',
                                         });
                                     $("#magChoixx").dialog("option", "position", [600, 200]);
                                    });
                                }// fin if 'existe'
                                else { // else 'n existe pas'
                                    $.get($.fn.SERVER_HTTP_HOST() + "/Orders/saveRessourceFigee", { datLivr: _dateLivr, NOBL: _OTNoBL, cStock:_OTCodeStock, typeDoss : _typeDoss,
                                        chargNom: _nomCharg, chargLieu: _lieuCharg, chargNP: _NPCharg, chargPays: _paysCharg, chargVille: _villeCharg,
                                        livrNom: _nomLivr, livrLieu: _lieuLivr, livrNP: _NPLivr,  livrPays : _paysLivr, livrVille: _villeLivr, livrTel : _telLivr, livrCont: _contLivr, livrCourr: _courrLivr,
                                        donnNom: _nomDonn, donnLieu: _lieuDonn, donnNP: _NPDonn, donnPays: _paysDonn, donnVille: _villeDonn, donnTel : _telDonn, donnCourr: _courrDonn,
                                    OTMagID: _OTMagID, DetailID: _DetailID , packID: _packID, OTNoteInterne: _OTNoteInterne, OTMontObligatoire: _OTMontObligatoire, typeGDoss: _typeGDoss, OTCommunication: _OTCommunication,
                                    OTChargementContact: _OTChargementContact,OTTelChargement: _OTTelChargement,OTChargementEmail: _OTChargementEmail, livrTel2: _telLivr2  }, function (data) {
                                        if (data == "0" || data == "") {
                                            alert("Erreur !");
                                        }
                                        else {
                                            alert("Enregistrée avec succès !");
                                            // alert("_DetailID : " + _DetailID + " data : " + data.toString());
                                           if (_DetailID == "-1"){
                                                $.post($.fn.SERVER_HTTP_HOST() + "/Orders/Afficher", { mode: "modifier", OTID: data.toString() },
                                                    function (htmlResult) {
                                                        $("#main").html(htmlResult);
                                                    });  
                                            }
                                            else {
                                                $.post($.fn.SERVER_HTTP_HOST() + "/Orders/getLst", {OTID: "-1"},
                                                function (htmlResult) {
                                                    $("#main").html(htmlResult);
                                                });  
                                            }
                                           }
                                        });

                                }// fin else
                             });
                        } // fin if existe

                        else // debut if n existe pas 'NO'
                        {

                             $.get($.fn.SERVER_HTTP_HOST() + "/Orders/saveRessourceFigee", { datLivr: _dateLivr, NOBL: _OTNoBL, cStock:_OTCodeStock, typeDoss : _typeDoss,
                                        chargNom: _nomCharg, chargLieu: _lieuCharg, chargNP: _NPCharg, chargPays: _paysCharg, chargVille: _villeCharg,
                                        livrNom: _nomLivr, livrLieu: _lieuLivr, livrNP: _NPLivr,  livrPays : _paysLivr, livrVille: _villeLivr, livrTel : _telLivr, livrCont: _contLivr, livrCourr: _courrLivr,
                                        donnNom: _nomDonn, donnLieu: _lieuDonn, donnNP: _NPDonn, donnPays: _paysDonn, donnVille: _villeDonn, donnTel : _telDonn, donnCourr: _courrDonn,
                                    OTMagID: _OTMagID, DetailID: _DetailID , packID: _packID, OTNoteInterne: _OTNoteInterne,OTMontObligatoire: _OTMontObligatoire , typeGDoss: _typeGDoss, OTCommunication: _OTCommunication   ,
                                    OTChargementContact: _OTChargementContact,OTTelChargement: _OTTelChargement,OTChargementEmail: _OTChargementEmail, livrTel2: _telLivr2 }, function (data) {
                                        if (data == "0" || data == "") {
                                            alert("Erreur !");
                                        }
                                        else {
                                            alert("Enregistrée avec succès !");
                                            location.href = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + data;
                                            }
                                        });

                        }
           
                });

            };
       
        var _formName = "";
        var _formLabel = "";
        var _formLink = "";

        $.fn.getForm = function (json) {
            var lst = jQuery.parseJSON(json);

            var obj = lst[0];
            _formName = obj.Name;
            _formLabel = obj.Label;
            _formLink = obj.Value;

            $("#form_label").html(_formLabel);

            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/getSteps", { RessourceCode: _RessourceCode }, function (data) {
           
                $.fn.getStep(data);
            });

        };

        var ip = 0;
        var clst = 0;
        var Olst = null;

        $.fn.getStep = function (json) {
            Olst = jQuery.parseJSON(json);
            var contents = '<div id="tabs" style="width:100%">';
            var divs = "";
            var uls = "";

            for (i = 0; i < Olst.length; i++) {
                var obj = Olst[i];
                divs += '<div id="dv_step_' + obj.Code + '" style="width:95%"></div>';
                uls += '<li><a href="#dv_step_' + obj.Code + '" index="dv_step_' + obj.Code + '">' + obj.Label + '</a></li>';
            }

            contents += "<ul>" + uls + "</ul>" + divs + "</div>";

            $("#FR_" + _RessourceCode + "_<%: _step %>_dvColumns").html(contents);

            $("#tabs").tabs();

            clst = Olst.length - 1;

            $.fn.Loop();
        };

        $.fn.Loop = function () {
            var objj = Olst[ip];
            
            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/getFormRessourceColumns", { ID: objj.ID, ObjID: '0' }, function (data) {
                $.fn.GenerateForm(data, 'dv_step_' + objj.Code);

                if (ip != clst) {
                    ip++;
                    $.fn.Loop();
                }
            });
        };


        $.get($.fn.SERVER_HTTP_HOST() + "/Orders/getForm", { RessourceCode: _RessourceCode }, function (data) {
            $.fn.getForm(data);
            
        });

        $('#chx_ot_groupe').change(function (){
            typeDossierGroupe = this.checked;
            if(!this.checked)
            {
                $("#FR_OT_OTDateLivraison").closest("tr").next('tr').find('td:eq(1)').html(" <input type='checkbox' name='type_OT' value='1' id='id_Dossier' checked>Dossier<input type='checkbox' name='type_OT' value='2' id='id_Transport'>Transport");
                $('input[type="checkbox"]').on('change', function() {
                    $('input[type="checkbox"]').not(this).prop('checked', false);
                });
            }
            else
            {
                $.get($.fn.SERVER_HTTP_HOST() + "/OT/getOTGroupeType", function(r){
                    var _typeGOTs = r.split(',');
                    var elm = "";
                    for(var i = 0; i < _typeGOTs.length; i ++)
                    {
                        var _typeGOT = _typeGOTs[i].split('|');
                        elm += "<option value='"+ _typeGOT[0] +"' " + (i == 0 ? " selected " : "") + ">"+ _typeGOT[1] +"</option>"
                    }                      

                    $("#FR_OT_OTDateLivraison").closest("tr").next('tr').find('td:eq(1)').html("<select name='typeGroupeOT'>"  + elm + "</select>");
                });
            }
        });
   
    });
</script>

