<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>

<%
    var _id = ViewData["id"].ToString();
    var _etat1 = ViewData["etat1"].ToString();
    var _type = ViewData["type"].ToString();
    
    var _date1 = ViewData["date1"].ToString();
    var _date2 = ViewData["date2"].ToString();
    
    DataTable _dtStatus = (DataTable) ViewData["dtStatus"];
    
     %>
        <input type="hidden" id="id" value='<%:_id %>' />
        <input type="hidden" id="etat1" value='<%: _etat1 %>' />
        <br />
        <input type="hidden" id="typeF" value='<%: _type %>' />
    <table>
        <tr>
            <td width='50'>Etat</td>
            <td>
                <select id="lstEtat" style="width:204px">
                <%
                  if (_dtStatus != null)
                                {

                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_dtStatus))
                                    {
                                        for (int i = 0; i < _dtStatus.Rows.Count; i++)
                                        {
                                            DataRow row = _dtStatus.Rows[i];

                                            //if (row["Valeur"].ToString() == "Crée")
                                            //{
                                            //    Response.Write("<option value='" + row["ID"].ToString() + "' selected='selected'>" + row["Valeur"].ToString() + "</option>");
                                            //}
                                            //else
                                            //{
                                            Response.Write("<option value='" + row["Etat"].ToString() + "'>" + row["Description"].ToString() + "(" + row["Etat"].ToString() + ")" + "</option>");
                                            //}
                                        }
                                    }
                                }
                 %>

                </select>
            </td>
        </tr>

        <tr>
            <td>Date</td>
            <td>
               <span id='date1'><%: _date1 %></span> - <span id='date2'><%: _date2 %></span>
                <input type="text" id="date" />
            </td>
        </tr>

        <tr>
            <td>Qui  </td>
            <td><input type="text" id="qui" /></td>
        </tr>

        <tr>
            <td colspan="2" align="right"><input type="button" id="btnSave" value="Sauvegarder" /></td>
        </tr>

    </table>

    <div id="dvError" style="color:red; font-weight:bold;text-align:center">&nbsp;</div>

     <script type="text/javascript">
         $(document).ready(function () {

             $.fn.parseDate = function (input) {
                 if (input != '') {
                     var parts = input.split(' ');
                     var part1 = parts[0].split('/');
                     var part2 = parts[1].split(':');
                     // new Date(year, month [, day [, hours[, minutes[, seconds[, ms]]]]])
                     return new Date(part1[2], part1[1] - 1, part1[0], part2[0], part2[1], part2[2]); // Note: months are 0-based
                 } else
                     return new Date(1901, 1, 1);
             }

             /*
             $("#lstEtat").change(function () {
                 var _id = $("#id").val();
                 var _etat = $(this).find("option:selected").val();
                 $.post("../../Ajout/verifyOTEtatUpdate", { id: _id, etat: _etat }, function (htmlResult) {
                     if (htmlResult == 'false')
                        $("#dvError").html("Attention cet opération n'est pas autorisée !");
                     else if (htmlResult == 'true')
                        $("#dvError").html(' ');
                     else
                        alert("Erreur !");
                 });
             });
             */
             //$("#lstEtat").change();

             $('#date').datetimepicker({
                 addSliderAccess: true,
                 stepHour: 1,
                 hourMin: 1,
                 hourMax: 23,
                 sliderAccessArgs: { touchonly: false }
             });

             $("#btnSave").click(function () {
                 var _id = $("#id").val();
                 var _etat = $("#lstEtat option:selected").val();
                 var _date = $("#date").val();
                 var _etat1 = $("#etat1").val();
                 var _type = $("#typeF").val();
                 var _date1 = $.fn.parseDate($("#date1").html());
                 var _date2 = $.fn.parseDate($("#date2").html());
                 var curDate = $.fn.parseDate(_date);

                 if (curDate > _date1 && curDate < _date2) {
                     var _qui = $("#qui").val();

                     $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/prestAddStatus", { id: _id, etat: _etat, date: _date, qui: _qui, type: _type }, function (htmlResult) {

                         if (htmlResult == '0') {
                             $("#contrDgPrest").remove();
                             alert("Modifié avec succès !");
                         }
                         else
                             alert("Erreur !");
                     });
                 } else
                     alert("Invalide date !");
             });

         });
    </script>