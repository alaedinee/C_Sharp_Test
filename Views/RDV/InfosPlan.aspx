<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.Objects.RDV.PlanInfoModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	InfosPlan
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
  <!--

    function generateTextAidesRequest(form) {

        var stringVal = '';

        if (form.elements['AidesRequest'].options.length > 0) {

            for (i = 0; i < form.elements['AidesRequest'].options.length; i++) {
                if (i == 0) {
                    stringVal = form.elements['AidesRequest'].options[i].text;
                }
                else {
                    stringVal = stringVal + "@" + form.elements['AidesRequest'].options[i].text;
                }

            }
            form.TextAidesRequest.value = stringVal;
        }
        else {
            form.TextAidesRequest.value = '';
        }

    }
    function deplacer_elements(de, vers,form) {
        var F = form;
        var elements1 = "" + de + "";
        var elements2 = "" + vers + "";

        if (F.elements[elements1].options.selectedIndex >= 0) {
            /* boucle tant qu'il reste des éléments sélectionnés */
            while (F.elements[elements1].options.selectedIndex >= 0) {
                /* index de l'élément sélectionné */
                index = F.elements[elements1].options.selectedIndex;

                /* /texte de l'élément sélectionné */
                texte = F.elements[elements1].options[index].text;

                /* valeur de l'élément sélectionné */
                valeur = F.elements[elements1].options[index].value;

                /* suppression de l'élément sélectionné dans la liste d'origine */
                F.elements[elements1].options[index] = null;
                /* création de l'élément dans la liste accueillante */
                var user = new Option(texte, valeur);
                nb_elements = F.elements[elements2].options.length; // nbre d'éléments dans la liste accueillante
                F.elements[elements2].options[nb_elements] = user;
            }
            generateTextAidesRequest(form);
        }
        else
            alert("Aucun élément sélectionné !");
        return (false);
    }
    //-->
</script>
   

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>
          <table><tr><td><h3> <%= Html.ActionLink("Retour au Plans", "RedirectToPost/0/"+ Model.PlanDate.Replace("/","-"), "RDV")%></h3></td><td><h3><% Response.Write("<a target=\"_blank\" href='../../displayPlanPDF/" +Model.PlanID + "'>PDF</a>"); %> </h3></td></tr></table> 
        <fieldset>
            <legend>Informations Plan</legend>
            
         
            <table>
            <tr>
            <td style="float:right;margin-top:0px;">Plan N° : </td><td><%: Model.PlanID %> </td><%: Html.HiddenFor(m => m.PlanID) %>
            </tr>
            <tr>
            <td style="float:right;margin-top:0px;">Date : </td><td>[<%= Model.PlanDate.ToString().Replace("/",".") %>]</td><%: Html.HiddenFor(m => m.PlanDate) %>
            </tr>
            <tr>
            <td style="float:right;margin-top:0px;">Poids : </td><td><%: Model.PoidTotal %>  </td><%: Html.HiddenFor(m => m.PoidTotal) %>
            </tr>
            <tr>
            <td style="float:right;margin-top:0px;">Somme à encaisser: </td> <td> <%: Model.Somme %></td><%: Html.HiddenFor(m => m.Somme) %>
            </tr>
            <tr>
            <td style="float:right;margin-top:0px;">Camions Disponible : </td><td> <%:  Html.DropDownListFor(m => m.CammionCode, Model.listItemCamion, new { style = "width:200px;" })%></td>
            </tr>
            <tr>
            <%--<td style="float:right;margin-top:0px;">Chauffeurs disponible : </td><td>  <%:  Html.DropDownListFor(m => m.ChauffeurCode, Model.listItemChauffeur, new { style = "width:200px;" })%></td>--%>
            </tr

            <tr>
            <td style="float:right;margin-top:0px;">Type de tournée : </td><td>  <%:  Html.DropDownListFor(m => m.type_tournee, Model.listItemTypeTournees, new { style = "width:100px;" })%></td>
            </tr

            <tr>
            <%--<td style="float:right;margin-top:0px;">Aides : </td>
                                <td>
                                <table>
                                        <tr>
                                        <td>
                                        <div class="editor-field">
                                                <%:  Html.ListBoxFor(m => m.AidesRequest, (List<SelectListItem>)ViewData["requestAide"], new { size = "8", style = "width:200px;" })%>
                                        </div>
                                         <%: Html.HiddenFor(m => m.TextAidesRequest) %>
                                        </td>
                                        
                                        <td>
                                            <input type="button" value=">>" name="gauche" onClick="return deplacer_elements('AidesRequest', 'Aides',this.form)"><br />
                                            <input type="button" value="<<" name="droite" onClick="return deplacer_elements('Aides', 'AidesRequest',this.form)">
                                            
                                        </td>
                                        <td>
                                                <%:  Html.ListBoxFor(m => m.Aides, Model.listItemAide, new { size = "8", style = "width:200px;" })%>
                                        </td>
                                        </tr>
                                 </table>
                                
                                </td>
            </tr>--%>

            <tr>
                <td style="float:right;margin-top:0px;">&nbsp;</td>
                <td>
                    <input type="checkbox" id="ch_remorque" name="ch_remorque" /> Avec remorque
                    
                    <select id="lst_remorque">
                        <option value='0'> </option>
                            <%
                                System.Data.DataTable lstRemorque = (System.Data.DataTable) ViewData["lstRemorque"];
                                if (lstRemorque != null)
                                {
                                    for (int i = 0; i < lstRemorque.Rows.Count; i++)
                                    {
                                        System.Data.DataRow row = lstRemorque.Rows[i];
                                        Response.Write("<option value='" + row["ID"].ToString() + "'>" + row["Nom"].ToString() + "</option>");
                                    }
                                }
                            %>
                    </select>

                    <%: Html.HiddenFor(m => m.Remorque)%>
                </td>
            </tr>

            <tr>
            <td style="float:right;margin-top:0px;">Remarques : </td><td><%: Html.TextAreaFor(model => model.remarque, new { rows = 5, cols = 53 })%></td>
            </tr>
            <tr><td></td><td> <input type="submit" value="Enregistrer" /></td></tr>
            </table>
         
              
        </fieldset>

    <% } %>

    <script type="text/javascript">
        $(document).ready(function () {
            var _remorque = '<%: Model.Remorque %>';
            var _CammionCode = '<%: Model.CammionCode %>';
            var _chauffeur = '<%: Model.ChauffeurCode %>';

            $("#ch_remorque").change(function () {
                if (this.checked) {
                    $("#lst_remorque").css("visibility", "visible");
                }
                else {
                    $("#lst_remorque").css("visibility", "hidden");
                }
            }).trigger("change");

            if (_remorque != "0" && _CammionCode != "") {
                $("#ch_remorque").attr('checked', true).trigger("change");
            }

            $("#lst_remorque").change(function () {
                $("#lst_remorque option:selected").each(function () {
                    $("#Remorque").val($(this).val());
                });
            });

            if ($("#type_tournee option:selected").val() == 'NULL')
            {
                $("#type_tournee").val("TAXI MEUBLES");
            }

            $("#CammionCode").change(function () {
                $("#CammionCode option:selected").each(function () {
                    var _ID = $(this).val();

                    if (_CammionCode == _ID && _remorque != "0") {
                        $("#lst_remorque").val(_remorque);
                    }
                    else {
                        $.get(SERVER_HTTP_HOST() + "/RDV/getDefault", { ID: _ID, name: 'REMORQUES' }, function (data) {
                            $("#lst_remorque").val(data);
                        });
                    }

                    if (_chauffeur != "") {
                        $("#ChauffeurCode").val(_chauffeur);
                    } else {
                        $.get(SERVER_HTTP_HOST() + "/RDV/getDefault", { ID: _ID, name: 'CHAUFFEURS' }, function (data) {
                            $("#ChauffeurCode").val(data);
                        });
                    }

                });
            }).trigger("change");

        });
    </script>
</asp:Content>

