<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="System.Data" %>

<%
    var _typeComm = ViewData["typeComm"];
    var _ressource = ViewData["Ressource"];
    var _otid = ViewData["otid"];
    DataTable _prestList = (DataTable)ViewData["prestList"];
    DataTable _eventList = (DataTable)ViewData["eventList"];
    
    string _usern = "";
    if (Session["login"] != null)
    {
        //Omni_TTM.Objects.User _user = (Omni_TTM.Objects.User)Session["login"];
        _usern = Session["login"].ToString();
    }
    
     %>

<div style="width: 100%; text-align:right;">
    <input type="button" id="addComm" value=" Valider " />
</div>

<fieldset>
    <legend>Nouvelle communication</legend>
    <table border="0" cellspacing='2' cellpadding='2'>

           
            <tr>
                <td>Type communication</td>
                <td>
                        <input type="text" id="Type" value="<%: (_typeComm == null)? "Inconnu" : _typeComm  %>" />
                </td>
            </tr>

            <tr>
                <td>Sujet</td>
                
                <td>
                       <input type="text" id="Sujet"  style="width: 200px;"/>
               </td>
            </tr>
            <% 
                if ("MDM_COM".Equals(_typeComm))
                { %>
            <tr>
                <td>Prestation</td>
                <td>
                    <select id="Prestation" style="width:200px;">
                    <%
                        if (_prestList != null)
                            {
                                DataTable prestList = (DataTable)_prestList;
                                if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(prestList))
                                {
                                    Response.Write("<option value=''></option>");
                                    for (int i = 0; i < prestList.Rows.Count; i++)
                                    {
                                        DataRow row = prestList.Rows[i];                                        
                                        Response.Write("<option value='" + row["DetailID"].ToString() + "'>[" + row["Référence"].ToString() +"] "+ row["Produit"].ToString() + "</option>");                                        
                                    }
                                }
                            }
                        %>
                       </select>
                    <input type="button" id="SelectArticle" value=" Article " style="display:none; padding: 0 3px !important;" />
                </td>
            </tr>

            <tr>
                <td>Type Evenement</td>
                <td>
                    <select id="TypeEvent" style="width:200px;">
                        
                    </select>
                </td>
            </tr>
            <% } %>
            <tr>
                <td>Message</td>
                
                <td>
                       <textarea type="text" id="Message" style="width: 300px; height: 150px;" />
               </td>
            </tr>

           <%-- <tr>
                <td>Date communication</td>
                
                <td>
                       <input type="text" id="DateTimePicker" />
               </td>
            </tr>--%>

</table>
</fieldset>
<div id="ComlstArticle">
</div>
<script>
    $().ready(function () {

        var _OtID = '<%: _otid %>';
        var _Ressource = '<%: _ressource %>';
        var _TypeComm = '<%: _typeComm %>';
        var _usern = '<%: _usern %>';



        $("#Type").prop("disabled", true);

        $('input[type=text]').addClass('toUPPER');
        $('textarea[type=text]').addClass('toUPPER');


        $(".toUPPER").keyup(function () {
            this.value = this.value.toUpperCase();
        });

        $("#Prestation").change(function(){
            var _Prestation = $("#Prestation option:selected").val();
            // alert(_Prestation);
            if (_Prestation != '')
                $("#SelectArticle").show();
            else
                $("#SelectArticle").hide();
        });

        $("#Prestation").click(function () {
            var _Prestation = $("#Prestation option:selected").val();
            if (_Prestation != '') {
                var actionUrl = $.fn.SERVER_HTTP_HOST() + "/Communication/eventType/?produit=" + _Prestation;
                $.getJSON(actionUrl, function (response) {
                    if (response != null) {
                        $("#TypeEvent").empty();
                        for (var i = 0; i < response.length; i++) {
                            $("#TypeEvent").append("<option value='" + response[i].code + "'>" + response[i].name + "</option>")
                        }
                    }
                });
            }
        });

        $("#SelectArticle").unbind('click').click(function () {
            var _Prestation = $("#Prestation option:selected").val();
            if (_Prestation == "") {
                alert("Choisir prestation");
                return false;
            }
            $.get($.fn.SERVER_HTTP_HOST() + "/Article/getComArticles/", { DetailID: _Prestation }, function (htmlResult) {
                $("#ComlstArticle_Content").remove();
                $("#ComlstArticle").html("<div id='ComlstArticle_Content' title='Liste Article'>" + htmlResult + "</div>");
                $("#ComlstArticle_Content").dialog({
                    width: 600,
                    height: 400,
                    modal: true
                });
            });
        });

        $("#addComm").click(function () {
            //$('a.mainpanel[action=2]').click();
            //$('#dv_main_step2').html("");

            var _Sujet = $("#Sujet").val();
            var _Msg = $("#Message").val();

            var _Prestation = $("#Prestation option:selected").val();
            var _TypeEvent = $("#TypeEvent option:selected").val();
            var _articles_id = $("#Message").attr("articles_id");

            if (_Sujet == "") {
                alert('Sujet invalide');
            }
            else if (_Prestation == "") {
                alert('Prestation invalide');
            }
            else if (_TypeEvent == null || _TypeEvent == "") {
                alert('Type Evenement invalide');
            }

            else {


                $("#dv_loading_detail").css("display", "");


                $.post($.fn.SERVER_HTTP_HOST() + "/Communication/AjouterCommunication",
                    { OtID: _OtID, Sujet: _Sujet, Msg: _Msg, /*Date: _Date,*/Ressource: _Ressource, TypeComm: _TypeComm
                    , usern: _usern, PrestationID: _Prestation, TypeEvent: _TypeEvent, articles_id: _articles_id }, function (data) {

                        $("#dv_loading_detail").css("display", "none");
                        //$('#dv_main_step2').html(data);
                        if (data == "1") {
                            //alert('Opération réussie');
                            //$.post($.fn.SERVER_HTTP_HOST() + "/Ressources/getFormRessourceColumns",{ RessourceCode: _Ressource, DetailID: _OtID}, function (data) {
                            //});
                            //this.close();
                            //$.fn.getListComm();
                            $("#contrDgCom").remove();
                            $.post($.fn.SERVER_HTTP_HOST() + "/Communication/getlstCom", { RessourceID: _OtID, Ressource: "OT" },

                                        function (htmlResult) {

                                            $("#divCommunication").html(htmlResult);

                                        });
                            //location.reload();

                        }
                        else
                            alert('Opération échouée')
                    });

            }

        });


        //$('#DateTimePicker').datetimepicker({
        //    addSliderAccess: true,
        //    dateFormat: 'dd/mm/yy',
        //    stepHour: 1,
        //    hourMin: 1,
        //    hourMax: 23,
        //    sliderAccessArgs: { touchonly: false }
        //});


    });
</script>