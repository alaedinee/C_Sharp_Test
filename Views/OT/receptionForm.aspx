<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>
<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Récéption
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">

<%
    DataTable _Reception = (DataTable) ViewData["reception"];
    var _login = ViewData["login"];
    var _loginID = ViewData["loginID"];

    var _recType = ViewData["recType"];
    var _recFournisseur = ViewData["recFournisseur"];
    var _recDonneur = ViewData["recDonneur"];  

    var _receptionLog = (Session["loginReception"]==null)? "" : Session["loginReception"].ToString();
    var _receptionLogID = Session["loginReceptionID"].ToString();
    var _receptionLogDate = Session["loginReceptionDate"].ToString();
    var _receptionLogType = Session["loginReceptionType"].ToString();
    var _receptionLogPoid = Session["loginReceptionPoid"].ToString();
    var _receptionLogVolume = Session["loginReceptionVolume"].ToString();
    var _receptionLogCamio = Session["loginReceptionCamio"].ToString();
    var _receptionLogChauffeur = Session["loginReceptionChauffeur"].ToString();
    var _color = Session["color"].ToString();
    var _visibility = "hidden";

    DateTime date = DateTime.Now;
    string _date = date.ToString("dd/MM/yyyy");    
%>

<style>
         
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

</style>

        <div id="recepTabs" style="width:100%; min-height: 300px;">
                <ul>

                    
                    <li><a href="#recep_dv_list">Récéption en cours</a></li>
                    <li><a href="#recep_dv_nouvelle">Nouvelle récéption</a></li>
                    <li><a href="#recep_dv_info">Informations récéption</a></li>
                    <li><a href="#recep_dv_AllRecep">Liste des récéptions</a></li>
                    
                </ul>

                <div id="recep_dv_list" style="width:95%;" >

                    <%
                        string recepHTML = "<table style='width:100%;' border='0' id='tableResultDoc'> <thead><tr align='left' bgcolor='orange' style=\"color:#fff\" height='35'><th>Num Reception</th><th>Fournisseur</th> <th>Marchandise</th>  <th>Donneur d'ordre</th> <th>Date récéption</th> <th>Etat de récéption</th><th>Séléctionner/Cloturer</th></tr></thead><tbody>";

                        if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_Reception))
                        {
                            for (int i = 0; i < _Reception.Rows.Count; i++)
                            {
                                DataRow row = _Reception.Rows[i];
                                if (_receptionLogID == row["receptionID"].ToString())
                                {
                                    recepHTML = recepHTML + "<tr style='color:" + _color + ";'>"
                                       + "<td width='20%'><b>" + _Reception.Rows[i]["receptionNumber"] + "</b></td>"
                                       + "<td width='20%'><b>" + _Reception.Rows[i]["Fournisseur"] + "</b></td>"
                                       + "<td width='20%'><b>" + _Reception.Rows[i]["typeReception"] + "</b></td>"
									   + "<td width='20%'><b>" + _Reception.Rows[i]["Donneur"] + "</b></td>"
                                       + "<td width='20%'><b>" + _Reception.Rows[i]["dateReception"] + "</b></td>"
                                       + "<td width='20%'><b>" + _Reception.Rows[i]["etatReception"] + "</b></td>"
                                       + "<td width='10%'><img select='oui' title='Ajouter packages' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/Add.png' recepID='" + _Reception.Rows[i]["receptionID"] + "' recepCODE='" + _Reception.Rows[i]["receptionNumber"] + "' recepDate='" + _Reception.Rows[i]["dateReception"] + "' recepType='" + _Reception.Rows[i]["typeReception"] + "' recepPoid='" + _Reception.Rows[i]["poid"] + "' recepVolume='" + _Reception.Rows[i]["volume"] + "' recepCamio='" + _Reception.Rows[i]["camio"] + "' recepChauffeur='" + _Reception.Rows[i]["chauffeur"] + "' /> "
                                                        +"<img close='oui' alt='cloturer icone' title='Cloturer cette récéption' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/not_red.png' align='right'  /> " +
                                                         "<a href='#' recepID='" + _Reception.Rows[i]["receptionID"] + "'>Modifier</a>" 
                                                        + "</td> "
                                    + "</tr> "; 
                                }

                                else
                                {
                                    recepHTML = recepHTML + "<tr> "  
                                        + "<td width='20%'><b>" + _Reception.Rows[i]["receptionNumber"] + "</b></td>"
                                        + " <td width='20%'><b>" + _Reception.Rows[i]["Fournisseur"] + "</b></td>"
                                        + "<td width='20%'><b>" + _Reception.Rows[i]["typeReception"] + "</b></td>"
                                      
										+ "<td width='20%'><b>" + _Reception.Rows[i]["Donneur"] + "</b></td>"
                                        + "<td width='20%'><b>" + _Reception.Rows[i]["dateReception"] + "</b></td>"
                                        + "<td width='20%'><b>" + _Reception.Rows[i]["etatReception"] + "</b></td>"
                                       + "<td width='10%'><img select='oui' title='Ajouter packages' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/Add.png' recepID='" + _Reception.Rows[i]["receptionID"] + "' recepCODE='" + _Reception.Rows[i]["receptionNumber"] + "' recepDate='" + _Reception.Rows[i]["dateReception"] + "' recepType='" + _Reception.Rows[i]["typeReception"] + "' recepPoid='" + _Reception.Rows[i]["poid"] + "' recepVolume='" + _Reception.Rows[i]["volume"] + "' recepCamio='" + _Reception.Rows[i]["camio"] + "' recepChauffeur='" + _Reception.Rows[i]["chauffeur"] + "'/> "+
                                       "<a href='#' recepID='" + _Reception.Rows[i]["receptionID"] + "'>Modifier</a>" + 
                                       "</td> </tr> ";
                                }
                            }
                        }

                        recepHTML = recepHTML + "</tbody></table>";
                        Response.Write(recepHTML);
                    %>
                    
                    <div  id="divAddPackageToReception" style="visibility:hidden">
                
                        <input type="button" value="ajouter package" id="btnAddPackRecep" valIDRecep="" />
                
                    </div>

                </div>

                <div id="recep_dv_nouvelle" >

                    <table>

                        <tr>
                            <td>
                                FOURNISSEUR
                            </td>
                            <td>
                                <select id="recValSelected" style="width:204px;">
                                         <%
                                             if (_recFournisseur != null)
                                                {
                                                    DataTable _ListRecFournisseur = (DataTable)_recFournisseur;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_ListRecFournisseur))
                                                    {
                                                        for (int i = 0; i < _ListRecFournisseur.Rows.Count; i++)
                                                        {
                                                            DataRow row = _ListRecFournisseur.Rows[i];

                                                            Response.Write("<option value='" + row["name"].ToString() + "'>" + row["name"].ToString() + "</option>");

                                                        }
                                                    }             
                                                }
                                            %>
                                </select>
                            </td>
                            
                        </tr>

                        <tr>
                            <td>
                                Donneur
                            </td>
                            <td>
                                <select id="DonneurValSelected" style="width:204px;">
                                         <%
                                             if (_recDonneur != null)
                                                {
                                                    DataTable _List_recDonneur = (DataTable)_recDonneur;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_List_recDonneur))
                                                    {
                                                        for (int i = 0; i < _List_recDonneur.Rows.Count; i++)
                                                        {
                                                            DataRow row = _List_recDonneur.Rows[i];

                                                            Response.Write("<option value='" + row["ID"].ToString() + "'>" + row["Nom"].ToString() + "</option>");

                                                        }
                                                    }             
                                                }
                                            %>
                                </select>
                            </td>
                            
                        </tr>

                        <tr>
                            <td>
                                DATE RÉCÉPTION
                            </td>

                            <td>
                                <input type="text" value="<%: (_date == null) ? "" : _date %>" id="dateReception" />
                            </td>
                        
                        </tr>

                        <tr>
                            <td>
                                TYPE DE MARCHANDISE
                            </td>
                            <td>
                                <select id="recTypeSelected" style="width:204px;">
                                         <%
                                             if (_recType != null)
                                                {
                                                    DataTable _ListRecType = (DataTable)_recType;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_ListRecType))
                                                    {
                                                        for (int i = 0; i < _ListRecType.Rows.Count; i++)
                                                        {
                                                            DataRow row = _ListRecType.Rows[i];

                                                            Response.Write("<option idx='" + row["id"].ToString() + "' value='" + row["name"].ToString() + "'>" + row["name"].ToString() + "</option>");

                                                        }
                                                    }             
                                                }
                                            %>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                POIDS
                            </td>

                            <td>
                                <input type="text" value="" id="recPoid" />
                            </td>
                        
                        </tr>

                        <tr>
                            <td>
                                VOLUME
                            </td>

                            <td>
                                <input type="text" value="" id="recVolume" />
                            </td>
                        
                        </tr>

                        <tr>
                            <td>
                                CAMION
                            </td>
                            <td>
                                <input type="text" value="" id="recCamio" />
                            </td>                     
                        </tr>

                        <tr>
                            <td>
                                CHAUFFEURS
                            </td>
                            <td>
                                <input type="text" value="" id="recChauffeur" />
                            </td>                     
                        </tr>


                        <tr>

                            <td>
                         <%--   <% if (_receptionLog == "")
                               { %>--%>
                                <input type="button" value="Générer récéption" attrVal="Begin" id="genererRec" />
                               <%-- <%}
                               else
                               { %>
                                <input type="button" value="Finir récéption" attrVal="Finish" id="genererRec" />
                                <%} %>--%>
                            </td>
                        
                        </tr>
                    </table>

                </div>
                
                <div id="recep_dv_info" style="width:95%;" >

                    <fieldset>
                        <legend>Informations sur la récéption en cours: </legend>

                        <table>
                            <tr>
                                <td>FOURNISSEUR </td> <td>: <b><span id="receptionCours"></span></b> </td>
                            </tr>
                    
                             <tr>
                                <td>DATE RÉCÉPTION </td> <td>: <b><span id="dateCours"></span></b> </td>
                            </tr>

                             <tr>
                                <td>MARCHANDISE </td> <td>: <b><span id="typeCours"></span></b> </td>
                            </tr>
                    
                             <tr>
                                <td>POIDS </td> <td>: <b><span id="poidCours"></span></b> </td>
                            </tr>

                             <tr>
                                <td>VOLUME </td> <td>: <b><span id="volumeCours"></span></b> </td>
                            </tr>

                            <tr>
                                <td>CAMION </td> <td>: <b><span id="camioCours"></span></b> </td>
                            </tr>

                             <tr>
                                <td>CHAUFFEUR </td> <td>: <b><span id="chauffeurCours"></span></b> </td>
                            </tr>

                        </table>
 
                    </fieldset>
     
                </div>
                
                <div id="recep_dv_AllRecep" style="width:95%;" >

                 
                </div>
                


           <div id="addPackRecDg" title="">


          </div>
    </div>

<div id="DGPACKRECEP"></div>

     <script type="text/javascript">
         $(document).ready(function () {
             var nbr = $("#tableResultDoc tr").length;
             var tabPacksRec = null;
             if (nbr > 1) {
                 tabPacksRec = $("#tableResultDoc").not('.initialized').addClass('initialized').dataTable({
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

                         $("#tableResultDoc tr img[close]").not('.initialized').addClass('initialized').click(function () {
                             confirm("Voulez vous cloturer cette récéption?");

                             //alert($(this).attr("path"));

                             var _conf = confirm("Voulez vous cloturer cette récéption?");
                             if (_conf) {

                                 $.get($.fn.SERVER_HTTP_HOST() + "/OT/destroyReception", { recepID: _receptionLogID }, function (htmlResult) {

                                     if (htmlResult.toString() != "" && htmlResult.toString() != null) {

                                         alert("La récéption est fermée");

                                         $(_tr).remove();
                                         $("#genererRec").val("Générer récéption");
                                         $("#genererRec").attr("attrVal", "Begin");
                                         $("#receptionCours").text("");
                                         $("#fournisseurCours").text("");
                                         $("#dateCours").text("");
                                         $("#typeCours").text("");
                                         $("#poidCours").text("");
                                         $("#volumeCours").text("");
                                         $("#camioCours").text("");
                                         $("#chauffeurCours").text("");

                                         $.get($.fn.SERVER_HTTP_HOST() + "/Export/CluturedReception", { recepID: _receptionLogID }, function (data) {
                                             if (data.toString() != "1")
                                                 alert("Erreur d'envoi " + ((data.toString() == "0") ? "" : " : " + data.toString()));
                                         });

                                         location.reload();
                                     }
                                     else
                                         alert("Erreur d'opération");

                                 });

                                 // alert("test oki");


                             }

                         });

                         $("#tableResultDoc tr td a[recepID]").not('.initialized').addClass('initialized').click(function () {
                             var _ID = $(this).attr("recepID");

                             $.post(SERVER_HTTP_HOST() + "/OT/editReception", { recepID: _ID }, function (htmlResult) {

                                 $("#DGpacK1").remove();
                                 $("#DGPACKRECEP").html("<div id='DGpacK1' title='Modification'>" + htmlResult + "</div>");

                                 $("#DGpacK1").dialog({
                                     height: 300,
                                     width: 400,
                                     modal: true, draggable: true
                                 });


                             });

                         });

                         $("#tableResultDoc tr td img[select]").not('.initialized').addClass('initialized').click(function () {

                             //alert($(this).attr("path"));

                             var _conf = confirm("Voulez vous choisir cette récéption?");
                             if (_conf) {

                                 var td = $(this).parent();
                                 _tr = $(td).parent();
                                 var _recID = $(this).attr("recepID");

                                 _valDate = $(this).attr("recepDate");
                                 _valTypeSelecte = $(this).attr("recepType");
                                 _recPoid = $(this).attr("recepPoid");
                                 _recVolume = $(this).attr("recepVolume");
                                 _recCamio = $(this).attr("recepCamio");
                                 _recChauffeur = $(this).attr("recepChauffeur");

                                 $.post($.fn.SERVER_HTTP_HOST() + '/OT/genererRec', { login: _login, etatRecep: 'En cours', recType: escape(_valTypeSelecte), recPoid: _recPoid, recVolume: _recVolume, recCamio: _recCamio, recChauffeur: _recChauffeur, recepID: $(this).attr("recepID"), recepCODE: $(this).attr("recepCODE"), dateRecep: _valDate },
                           function (htmlResult) {

                               if (htmlResult != "") {

                                   $.fn.changement(htmlResult.toString());
                                   $(_tr).css("color", _color)
                                   location.reload();
                                   //$("#divAddPackageToReception").css("visibility", "visible");
                                   //$("#btnAddPackRecep").attr("valIDRecep", _recID);
                                   //$(_tr).closest("tr").append("<td><input type='button' value='test' id='hada' recID=" + _recID + " /></td>")

                               }
                               else {
                                   alert("Opération echouée");
                               }
                           });
                             }
                         });
                     },
                     "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                     "iDisplayLength": 10
                 });
             }



             /////////////////////////////////VAR récuperées par la SESSION///////////////////
             var _login = '<%: _login %>';

             var _receptionLog = '<%: _receptionLog %>';
             var _receptionLogID = '<%: _receptionLogID %>';
             var _receptionLogDate = '<%: _receptionLogDate %>';
             var _receptionLogType = '<%: _receptionLogType %>';
             var _receptionLogPoid = '<%: _receptionLogPoid %>';
             var _receptionLogVolume = '<%: _receptionLogVolume %>';
             var _receptionLogCamio = '<%: _receptionLogCamio %>';
             var _receptionLogChauffeur = '<%: _receptionLogChauffeur %>';
             var _color = '<%: _color %>';
             var _visibility = '<%: _visibility %>';

             $("#divAddPackageToReception").css("visibility", _visibility);


             ////////////MAJ/////////////
             $(".toUPPER").keyup(function () {
                 this.value = this.value.toUpperCase();
             });


             /////////////////////////////////// FIN //////////////////////////////////


             //////////////////////////////Si la session actife afficher les info réception////////////////////////
             if (_receptionLog != "") {

                 $("#receptionCours").text(_receptionLog);
                 $("#dateCours").text(_receptionLogDate);
                 $("#typeCours").text(_receptionLogType);
                 $("#poidCours").text(_receptionLogPoid);
                 $("#volumeCours").text(_receptionLogVolume);
                 $("#camioCours").text(_receptionLogCamio);
                 $("#chauffeurCours").text(_receptionLogChauffeur);

             }
             ////////////////////////////////// FIN ////////////////////////////////////////////////////////
             var _valrec = "";
             var _valDate = "";
             var _valTypeSelecte = "";
             var _recPoid = "";
             var _recVolume = "";
             var _recCamio = "";
             var _recChauffeur = "";

             var _tr = "";

             $("#recepTabs").tabs();

             $("#dateReception").datepicker({
                 dateFormat: 'dd/mm/yy',
                 changeMonth: true,
                 changeYear: true
             });


             ///////////////////////////////////////////////// Choix d'une récéption existe /////////////////////////////////


             ////////////////////////////////////////////// Ajouter une nouvelle récéption ///////////////////
             $("#genererRec").click(function () {

                 var valueButton = $("#genererRec").attr("attrVal");

                 if (valueButton == "Begin") {

                     //info de la nouvelle récéption:
                     _valrec = $("#recValSelected").find(":selected").val();
                     _valDonn = $("#DonneurValSelected").find(":selected").val();
                     _valDate = $("#dateReception").val();
                     _valTypeSelecte = $("#recTypeSelected").find(":selected").val();
                     _recPoid = $("#recPoid").val();
                     _recVolume = $("#recVolume").val();
                     _recCamio = $("#recCamio").val();
                     _recChauffeur = $("#recChauffeur").val();

                     $.get($.fn.SERVER_HTTP_HOST() + "/OT/genererRec", { login: _login, etatRecep: '1', valrecep: _valrec, dateRecep: _valDate, recType: _valTypeSelecte,
                         recPoid: _recPoid, recVolume: _recVolume, recCamio: _recCamio, recChauffeur: _recChauffeur, recDonn: _valDonn
                     },

                             function (htmlResult) {

                                 if (htmlResult.toString() != "") {

                                     $.fn.changement(htmlResult.toString());

                                     location.reload();
                                 }
                                 else {

                                     alert('Opération échouée');
                                 }
                             });

                 }

                 //                 else if (valueButton == "Finish") {

                 //                     var _conf = confirm("Voulez vous cloturer cette récéption?");
                 //                     if (_conf) {

                 //                         $.get($.fn.SERVER_HTTP_HOST() + "/OT/destroyReception", { recepID: _receptionLogID },
                 //                             function (htmlResult) {

                 //                                 if (htmlResult.toString() != "" && htmlResult.toString() != null) {
                 //                                     alert("La récéption est fermée");
                 //                                     $(_tr).remove();
                 //                                     $("#genererRec").val("Générer récéption");
                 //                                     $("#genererRec").attr("attrVal", "Begin");
                 //                                     $("#receptionCours").text("");
                 //                                     $("#fournisseurCours").text("");
                 //                                     $("#dateCours").text("");
                 //                                     $("#typeCours").text("");
                 //                                     $("#poidCours").text("");
                 //                                     $("#volumeCours").text("");
                 //                                     location.reload();
                 //                                 }
                 //                                 else
                 //                                     alert("Erreur d'opération");

                 //                             });

                 //                     }

                 //                 }

             });


             $.fn.changement = function (valeur) {

                 var _value = valeur.split('*')
                 alert("Opération réussie, vous étes maintenant sous la récéption :   " + _value[0])
                 //$("#genererRec").val("Finir récéption");
                 //$("#genererRec").attr("attrVal", "Finish");
                 $("#receptionCours").text(_value[0]);
                 $("#dateCours").text(_value[1]);
                 $("#typeCours").text(_value[2]);
                 $("#poidCours").text(_value[3]);
                 $("#volumeCours").text(_value[4]);
                 $("#camioCours").text(_value[5]);
                 $("#chauffeurCours").text(_value[6]);
             };


             ////////////////////////////////////////////// Cloturer cette récéption ///////////////////////

            



             ////////////////////////////////////////////// Add package to this reception ///////////////////
             $("#btnAddPackRecep").click(function () {

                 var _idRecepBtn = $("#btnAddPackRecep").attr("valIDRecep");
                 //alert("id est :" + _receptionLogID);

                 if (_receptionLogID == "") {
                     alert("vous n'avez pas choisir une récéption");
                     return false;
                 }

                 $.post($.fn.SERVER_HTTP_HOST() + "/OT/addPackToRecepForm", { recepID: _receptionLogID, recepCode: _receptionLog }, function (htmlResult) {

                     $("#addPackRecDG").remove();
                     $("#addPackRecDg").html("<div id='addPackRecDG' title='Ajouter un package dans cette récéption'>" + htmlResult + "</div>");

                     $("#addPackRecDG").dialog({
                         height: 500,
                         width: 600,
                         modal: true
                     });

                 });


             });


             $.get($.fn.SERVER_HTTP_HOST() + "/OT/ListAllReception", { IDRecep: '-1' }, function (htmlResult) {
                 $("#recep_dv_AllRecep").html(htmlResult + "<br  clear='both' /><br />");
             });

         });
</script>

</asp:Content>