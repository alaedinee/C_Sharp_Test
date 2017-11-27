<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PlanningSys
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<style type="text/css">
    
    .Date {
        z-index:-1;
    }
    
    .D1
    {
        z-index:10000000;
        position :absolute;
    }
    
</style>

<div id="tabBord" style="position:absolute; left:800px;top : 210px;background:pink; z-index:1000" >
    <table border='0' width="250" cellpadding="4" cellspacing="3">
        <tr>
            <td width="44%"><b>Total Poids </b></td>
            <td vPoids="" align="right">0</td>
        </tr>
        <tr>
            <td><b>Total Volumes </b></td>
            <td vVolumes="" align="right">0</td>
        </tr>
        <tr>
            <td><b>Total Périodes </b></td>
            <td vPeriodes="" align="right">0</td>
        </tr>
        <tr>
            <td><b>Total Ordres </b></td>
            <td vOts="" align="right">0</td>
        </tr>

    </table>
</div>

<div>
     <%: Html.ActionLink("Ajouter un ordre", "Index")%><br /><br />

         <% using (Html.BeginForm("PlanningSys","Ajout")) {%>
        <fieldset>
            <legend>Critéres de recherche</legend>
            <table>
            <tr valign="top">

                
            <td> <div class="editor-label">
              Date 
                </div>
            </td>
            
            <td>
                
                <div class="editor-field">
                    <input type="text" id="date"  name="date" value="<%: (ViewData["date"]!=null)? ViewData["date"].ToString() : "" %>" />
                </div>

            </td>
            
                <td> 
                    <div class="editor-label">
                        Critère
                    </div>
                </td>
            
                <td>
                    <div class="editor-field">
                        <select id="fields">
                            <option value="Region" type="string">Région</option>
                            <option value="NBulletin"  type="string">N° Bulletin</option>
                            <option value="produit"  type="string">Prestation</option>
                        </select>
                        <input type="text" id="fields_value" />
                        <input type="hidden" id="fieldValue" name="fieldValue" value="<%: (ViewData["fieldValue"]!=null)? ViewData["fieldValue"].ToString() : "" %>" />
                        <input type="button" id="btnAdd" value="Ajouter" />
                       <!-- <input type="text" id="region"  name="region" value="<%: (ViewData["region"]!=null)? ViewData["region"].ToString(): "" %>" /> -->
                    </div>

                    <div id="lstFields"></div>
               </td>


                <td> 
                    <div class="editor-label">
                        Tri par
                    </div>
                </td>

                <td>
                    <div class="editor-field">
                        <select id="orders">
                            <option value="Region" type="string">Région</option>
                            <option value="OTDateLivraison"  type="date">Date</option>
                        </select>
                        <input type="hidden" id="orderValue" name="orderValue" value="<%: (ViewData["orderValue"]!=null)? ViewData["orderValue"].ToString() : "" %>" />
                        <input type="button" id="btnorderAdd" value="Ajouter" />
                    </div>

                    <div id="lstorders"></div>
               </td>

               <td>
                    <input type="submit" id="submitBtn" value="Chercher" />
               </td>
            </tr>
        </table>
            
        </fieldset>

            <% } %>
        <br />
    <fieldset>
         <legend>Liste des ordres</legend>
    

            <%
                System.Data.DataTable dt = (System.Data.DataTable)ViewData["listOT"];
                string returnValue = "<div><table id =\"tableList\">";
                returnValue = returnValue + "<thead><tr>"
                                           +"<th>Magasin</th>"
                                           + "<th>NBulletin</th>"
                                           + "<th >Client</th>"
                                           + "<th>Région</th>"
                                           + "<th>Telephone</th>"
                                           
                                           + "<th>DateLivraison</th>"
                                           + "<th>NP</th>"
                                           + "<th>Ville</th>"
                                           + "<th>Poids</th>"
                                           + "<th>Volumes</th>"
                                           + "<th>Périodes</th>"
                                           + "<th>Remarque</th>"
                                           + "<th>Prestation</th>"
                                           + "<th>&nbsp;</th>"
                                           + "<th>Détails</th>"
                                           + "</tr></thead><tbody>";
                if (dt != null)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        string to = dt.Rows[i]["toHour"].ToString(); 
                        string from = dt.Rows[i]["OTDateLivraison"].ToString();
                        from = (from.Length > 2)? from.Substring(0,10) : "";
                        returnValue = returnValue + "<tr index='" + dt.Rows[i]["OTID"].ToString() +
                            "' volumes='" + dt.Rows[i]["OTVolume"].ToString()
                            + "' poids='" + dt.Rows[i]["OTPoids"].ToString()
                            + "' periodes='" + dt.Rows[i]["OTPeriodesNonAttribuees"].ToString()
                            + "'>"
                        + "<td>" + dt.Rows[i]["Magasin"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["NBulletin"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["Client"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["Region"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["Telephone"].ToString() + "</td>"
                        
                        + "<td>" + dt.Rows[i]["FROMTO"].ToString() + " - " + ((to.Length > 2) ? ((to.Substring(0, 10) == from)? to.Substring(11, 8) : to) : "") + "</td>"
                        + "<td>" + dt.Rows[i]["OTDESTNP"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["OTDestVille"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["OTPoids"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["OTVolume"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["OTPeriodesNonAttribuees"].ToString() + "</td>"
                        + "<td>" + dt.Rows[i]["Remarques"].ToString() + "</td>"
                        + "<td style='font-size:8px'>" + dt.Rows[i]["produit"].ToString() + "</td>"
                        + "<td icons='' style='width:130px'>&nbsp;</td>"
                        + "<td><a href=\"AfficherOTPlus/" + dt.Rows[i]["OTID"].ToString() + "\">Voir détail</a></td>"
                        + "</tr>";
                    }
                }

                returnValue = returnValue + "</tbody></table></div>";

                Response.Write(returnValue);
              %>

      </fieldset>

<br />

        <fieldset>
            
            <table width="100%">
            <tr>

                <td align="right"><input type="button" id="btn_validate" value="Ajouter dans un plan" /></td>
            </tr>
            </table>
            
        </fieldset>

    <div id="contr" title=""></div>

</div>


     <script type="text/javascript">
         var rows = null;

         $().ready(function () {

             var _lstFields = [];
             var _lstVals = [];
             var _lstTypes = [];

             var _lstOrders = [];

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

             jQuery.fn.verifyVal = function (array, array2, field, val) {
                 var ok = -1;
                 for (var i = 0; i < array.length; i++) {
                     if (array[i] == field && array2[i] == val) {
                         ok = i;
                         break;
                     }
                 }
                 return ok;
             }

             jQuery.fn.addItem = function (field, val, txt, type) {
                 if (jQuery.fn.verifyVal(_lstFields, _lstVals, field, val) != -1)
                     alert("Existe déjà !");
                 else {

                     _lstFields.push(field);
                     _lstVals.push(val);
                     _lstTypes.push(type);

                     $("#lstFields").append("<div><a del='" + field + "' val='" + val + "' style='color:red;cursor:pointer'>X</a> &nbsp;<span>" + txt + " : " + val + "</span></div>");
                     jQuery.fn.removerFn();

                     $("#fieldValue").val(jQuery.fn.getLst());
                 }
             };

             jQuery.fn.addItem1 = function (field, txt) {
                 if (jQuery.fn.verify(_lstOrders, field) != -1)
                     alert("Existe déjà !");
                 else {
                     _lstOrders.push(field);

                     $("#lstorders").append("<div><a del1='" + field + "' style='color:red;cursor:pointer'>X</a> &nbsp;<span>" + txt + "</span></div>");
                     jQuery.fn.removerFn1();

                     $("#orderValue").val(jQuery.fn.getLst1());
                 }
             };

             jQuery.fn.removerFn = function () {
                 $("a[del]").not('.initialized').addClass('initialized').click(function () {
                     var _txt = $(this).attr("del");
                     var _val = $(this).attr("val");
                     var idx = jQuery.fn.verifyVal(_lstFields, _lstVals, _txt, _val);
                     $(this).closest("div").remove();
                     _lstFields[idx] = "";

                     $("#fieldValue").val(jQuery.fn.getLst());
                 });
             };

             jQuery.fn.removerFn1 = function () {
                 $("a[del1]").not('.initialized').addClass('initialized').click(function () {
                     var _txt = $(this).attr("del1");
                     var idx = jQuery.fn.verify(_lstOrders, _txt);
                     $(this).closest("div").remove();
                     _lstOrders[idx] = "";

                     $("#orderValue").val(jQuery.fn.getLst1());
                 });
             };

             jQuery.fn.getLst = function () {
                 var str = "";
                 for (i = 0; i < _lstFields.length; i++) {
                     if (_lstFields[i] == "") continue;

                     str += _lstFields[i] + "-FSEP-" + _lstVals[i] + "-FSEP-" + _lstTypes[i] + "|";
                 }

                 if (str != "") str = str.substring(0, str.length - 1);
                 return str;
             };

             jQuery.fn.getTxt = function (obj, field) {
                 var str = null;

                 $("#" + obj + " option").each(function () {
                     
                     if ($(this).val() == field) {
                         str =  $(this);

                     }

                 });


                 return str;
             };

             jQuery.fn.getLst1 = function () {
                 var str = "";
                 for (i = 0; i < _lstOrders.length; i++) {
                     if (_lstOrders[i] == "") continue;

                     str += _lstOrders[i] + "|";
                 }

                 if (str != "") str = str.substring(0, str.length - 1);
                 return str;
             };

             var _Fields = $("#fieldValue").val().split('|');
             for (var i in _Fields) {
                 if (_Fields[i] == "") continue;

                 var _FieldsVals = _Fields[i].split('-FSEP-');

                 if (_FieldsVals[0] == "") continue;

                 var field = _FieldsVals[0];
                 var objj = jQuery.fn.getTxt("fields", field);

                 var type = $(objj).attr("type");
                 var txt = $(objj).text();
                 var val = _FieldsVals[1];

                 jQuery.fn.addItem(field, val, txt, type);
             }

             var _Orders = $("#orderValue").val().split('|');
             for (var i in _Orders) {
                 if (_Orders[i] == "") continue;

                 var objj = jQuery.fn.getTxt("orders", _Orders[i]);
                 //$("#orders").val(_Orders[i]);
                 var txt = $(objj).text(); //$("#orders option:selected").text();

                 jQuery.fn.addItem1(_Orders[i], txt);
             }



             var _nbr = 1;

             $("#btnAdd").click(function () {
                 var field = $("#fields option:selected").val();
                 var type = $("#fields option:selected").attr("type");
                 var txt = $("#fields option:selected").text();
                 var val = $("#fields_value").val();
                 if (val == "") {
                     alert("Veuillez saisir une valeur !");
                     return false;
                 }


                 jQuery.fn.addItem(field, val, txt, type);
             });

             $("#btnorderAdd").click(function () {
                 var field = $("#orders option:selected").val();
                 var txt = $("#orders option:selected").text();

                 jQuery.fn.addItem1(field, txt);
             });

             $('#date').datepicker({ dateFormat: 'dd/mm/yy' });

             $("#btn_validate").click(function () {


                 var _IDS = "";

                 for (var i = 0; i < rows.length; i++) {
                     if ($(rows[i]).find("td input[type='checkbox'").attr("checked") == true) {

                         _IDS += $(rows[i]).attr("index") + ";";
                     }
                 }

                 if (_IDS.length > 0) _IDS = _IDS.substring(0, _IDS.length - 1);

                 //alert(_IDS + " , " + rows.length);


                 if (_IDS == "") {
                     alert("Veuillez séléctionner des ordres !");
                     return false;
                 }

                 $("#dialog").remove();
                 $("#contr").html("<div id='dialog' title='Ajouter dans un plan'> " +

                     "<div class='editor-field'>" +
                        "<input type='checkbox' id='newPlan' checked='checked'  /> Nouveau Plan" +
                     "</div><br />" +

                     "<div id='dvinf'>" +
                        "<div class='editor-label'> Date Plan </div>" +
                         "<div class='editor-field'>" +
                            "<input type='text' id='datePlan'  /> " +
                         "</div><br />" +
                            "<div class='editor-label'> Du <input type='text' id='txt_from' style='width:70px' value='07:30' />" +
                            " Au <input type='text' id='txt_to' style='width:70px' value='16:30' /> " +

                            "</div>" +

                             "<div class='editor-label'> Remarque </div>" +
                             "<div class='editor-field'>" +
                             "<input type='text' id='txt_rem' value='PLANIFICATION RENDEZ VOUS' /> " +
                             "</div>" +
                     "</div>" +


                     "<div id='dv_plan' style='visibility:hidden'><div class='editor-label'> N° Plan </div>" +
                     "<div class='editor-field'>" +
                     "<input type='text' id='planID'  value='' /> " +
                     "</div></div>" +

                     "<br />" +
                     "<input type='button' id='btn_validate_plan' value='Ajouter' />" +
                     "</div>");


                 $('#datePlan').datepicker({ dateFormat: 'dd/mm/yy' });
                 $("#ui-datepicker-div").addClass("D1");
                 $("#dialog").addClass("Date");

                 $("#dialog").dialog({
                     height: 300,
                     width: 250,
                     modal: true
                 });

                 $("#newPlan").change(function () {
                     if ($(this).attr('checked') == true) {
                         $("#dv_plan").css("visibility", "hidden");
                         $("#dvinf").css("visibility", "visible");
                     }
                     else {
                         $("#dv_plan").css("visibility", "visible");
                         $("#dvinf").css("visibility", "hidden");
                     }
                 });

                 $("#btn_validate_plan").click(function () {

                     if ($("#newPlan").attr('checked') == false && parseInt($("#newPlan").val()) <= 0) {
                         alert("Veuillez saisir N° Plan  !");
                         return false;
                     }
                     var _planID = "0";

                     if ($("#newPlan").attr('checked') == false) {
                         _planID = $("#planID").val();
                     }

                     var _poids = $("#tabBord table tr td[vPoids]:eq(0)").html();
                     var _date = $("#datePlan").val();
                     var _from = $("#txt_from").val();
                     var _to = $("#txt_to").val();
                     var _rem = $("#txt_rem").val();

                     $.post(SERVER_HTTP_HOST() + "Ajout/savePlanSys", { planid: _planID, Ids: _IDS, poids: _poids, date: _date, from: _from, to: _to, rem: _rem }, function (data) {

                         if (data == "")
                             alert("Opération réussite.");
                         else if (data == "-1")
                             alert("Veuillez vérifier le poids total !");
                         else if (data == "-2")
                             alert("Erreur création du plan !");
                         else {
                             alert("Opération faite avec des erreurs !");

                             for (var i = 0; i < rows.length; i++) {
                                 if ($(rows[i]).find("td input[type='checkbox'").attr("checked") == true) {

                                     if (data.indexOf($(rows[i]).attr("index")) >= 0) {
                                         $(rows[i]).css("background-color", "red");
                                     }
                                     else
                                         $(rows[i]).remove();
                                 }
                             }

                         }

                         $("#dialog").remove();

                     });

                 });

             });

             $.fn.InitTR = function () {

                 $("#tableList tr[index]").each(function () {
                     if ($(this).find("td").length == nbr - 2) {
                         $(this).find("td:first").before("<td nbr=''>&nbsp;</td>");
                         $(this).find("td:last").after("<td><input type='checkbox' /></td>");
                     }
                 });

                 $("#tableList tr[index] td input[type='checkbox']").not(".init").addClass("init").change(function () {
                     if ($(this).attr("checked") == true) {
                         $(this).closest("tr").find("td:first").html("<h2 style='color:#6666FF'>" + _nbr + "</h2>");
                         _nbr++;
                     }
                     else
                         $(this).closest("tr").find("td:first").html("&nbsp;");

                     $.fn.Calculate(rows);
                 });
             };

             $('#tableList').dataTable({
                 "bSort": false,

                 "oLanguage": {
                     "sLengthMenu": "Afficher _MENU_ Lignes par page",
                     "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
                     "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
                     "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
                     "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
                 },

                 "sPaginationType": "full_numbers"
                     ,
                 "fnDrawCallback": function (oSettings) {

                     $.fn.InitTR();



                 }
             }); //.fnSort([[3, 'asc'], [7, 'asc']]); ;

             $.fn.Calculate = function (_rows) {
                 var poids = 0, volumes = 0, periodes = 0; ots = 0;
                 for (var i = 0; i < rows.length; i++) {
                     if ($(rows[i]).find("td input[type='checkbox'").attr("checked") == true) {
                         volumes += parseFloat($(rows[i]).attr("volumes"));
                         poids += parseFloat($(rows[i]).attr("poids"));
                         periodes += parseInt($(rows[i]).attr("periodes"));
                         ots++;
                     }
                 }

                 $("#tabBord table tr td[vPoids]:eq(0)").html(poids);
                 $("#tabBord table tr td[vVolumes]:eq(0)").html(volumes);
                 $("#tabBord table tr td[vPeriodes]:eq(0)").html(periodes);
                 $("#tabBord table tr td[vOts]").html(ots);
             };



             rows = $("#tableList").dataTable().fnGetNodes();

             $("#tableList tr:eq(0)").find("th:first").before("<th>#</th>");
             $("#tableList tr:eq(0)").find("th:last").before("<th>&nbsp;</th>");

             var nbr = $("#tableList tr th").length;
             $.fn.InitTR();
             $(window).scroll(function (event) {
                 var st = $(this).scrollTop();
                 if (st < 20) st = 120;
                 $('#tabBord').css("top", (parseInt(st) + 100) + "px");
             });

             $("#tabBord").draggable();

         });
    </script>

</asp:Content>
