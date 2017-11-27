<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    var _recDonneur = ViewData["recDonneur"];
    var _recepID = ViewData["recepID"];
    var _recType = ViewData["recType"];
    var _recFournisseur = ViewData["recFournisseur"];
    var _recDt = (System.Data.DataTable) ViewData["recDt"];
    
    System.Data.DataRow recRow = (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable( _recDt ))? _recDt.Rows[0] : null;
%>
                <div>
                    <table>
                        <tr>
                            <td>
                                FOURNISSEUR
                            </td>
                            <td>
                                <select id="recValSelectedMod" style="width:204px;">
                                         <%
                                             if (_recFournisseur != null)
                                                {
                                                    System.Data.DataTable _ListRecFournisseur = (System.Data.DataTable)_recFournisseur;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_ListRecFournisseur))
                                                    {
                                                        for (int i = 0; i < _ListRecFournisseur.Rows.Count; i++)
                                                        {
                                                            System.Data.DataRow row = _ListRecFournisseur.Rows[i];

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
                                <select id="DonneurValSelectedMod" style="width:204px;">
                                         <%
                                             if (_recDonneur != null)
                                                {
                                                    System.Data.DataTable _List_recDonneur = (System.Data.DataTable)_recDonneur;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_List_recDonneur))
                                                    {
                                                        for (int i = 0; i < _List_recDonneur.Rows.Count; i++)
                                                        {
                                                            System.Data.DataRow row = _List_recDonneur.Rows[i];

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
                                <input type="text" value="<%: (recRow == null) ? "" : recRow["dateReception"].ToString() %>" id="dateReceptionMod" />
                            </td>                        
                        </tr>

                        <tr>
                            <td>
                                TYPE DE MARCHANDISE
                            </td>
                            <td>
                                <select id="recTypeSelectedMod" style="width:204px;">
                                         <%
                                             if (_recType != null) {
                                                    System.Data.DataTable _ListRecType = (System.Data.DataTable)_recType;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_ListRecType))
                                                    {
                                                        for (int i = 0; i < _ListRecType.Rows.Count; i++)
                                                        {
                                                            System.Data.DataRow row = _ListRecType.Rows[i];

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
                                <input type="text" value="<%: (recRow == null) ? "" : recRow["poid"].ToString() %>" id="recPoidMod" />
                            </td>                        
                        </tr>

                        <tr>
                            <td>
                                VOLUME
                            </td>
                            <td>
                                <input type="text" value="<%: (recRow == null) ? "" : recRow["volume"].ToString() %>" id="recVolumeMod" />
                            </td>                        
                        </tr>

                        <tr>
                            <td>
                                CAMION
                            </td>
                            <td>
                                <input type="text" value="<%: (recRow == null) ? "" : recRow["Camio"].ToString() %>" id="recCamioMod" />
                            </td>                     
                        </tr>

                        <tr>
                            <td>
                                CHAUFFEURS
                            </td>
                            <td>
                                <input type="text" value="<%: (recRow == null) ? "" : recRow["chauffeur"].ToString() %>" id="recChauffeurMod" />
                            </td>                     
                        </tr>

                        <tr>
                            <td align="right" colspan="2">
                                <br />
                                <input type="button" value="Sauver" attrVal="Begin" id="btnsaveRecep" />
                            </td>
                        </tr>
                    </table>

                </div>

     <script type="text/javascript">
         $(document).ready(function () {
             var _recepID = '<%: _recepID %>';
             var _donn = '<%: (recRow == null) ? "" : recRow["CodeClient"].ToString() %>';
             var _four = '<%: (recRow == null) ? "" : recRow["Fournisseur"].ToString() %>';
             var _type = '<%: (recRow == null) ? "" : recRow["typeReception"].ToString() %>';

             $("#DGpacK1").attr("title", "Modification Réception N° " + '<%: (recRow == null) ? "" : recRow["receptionNumber"].ToString() %>');

             $("#DonneurValSelectedMod").val(_donn);
             $("#recValSelectedMod").val(_four);
             $("#recTypeSelectedMod").val(_type);

             $("#dateReceptionMod").datepicker({
                 dateFormat: 'dd/mm/yy',
                 changeMonth: true,
                 changeYear: true
             });


             $("#btnsaveRecep").click(function () {
                 var _donneur = $("#DonneurValSelectedMod").find(":selected").val();
                 _valrec = $("#recValSelectedMod").find(":selected").val();
                 _valDate = $("#dateReceptionMod").val();
                 _valTypeSelecte = $("#recTypeSelectedMod").find(":selected").val();
                 _recPoid = $("#recPoidMod").val();
                 _recVolume = $("#recVolumeMod").val();
                 _recCamio = $("#recCamioMod").val();
                 _recChauffeur = $("#recChauffeurMod").val();

                 $.post(SERVER_HTTP_HOST() + "/OT/saveRecepDonn", { recepID: _recepID, donneur: _donneur
                   ,

                     valrecep: _valrec,
                     dateRecep: _valDate,
                     recType: _valTypeSelecte,
                     recPoid: _recPoid,
                     recVolume: _recVolume,
                     recCamio: _recCamio,
                     recChauffeur: _recChauffeur

                 }, function (htmlResult) {

                     if (htmlResult != "0") {
                         $("#DGpacK1").dialog('close');
                         document.location.href = $.fn.SERVER_HTTP_HOST() + "/OT/receptionForm";
                         return false;
                     }
                     else
                         alert("Erreur !");
                 });
             });

         });
    </script>