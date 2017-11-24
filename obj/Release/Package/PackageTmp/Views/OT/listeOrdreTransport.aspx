<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.OrderTransportModelsListe>" %>




<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	listeOrdreTransport
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    $().ready(function () {
        $('#tableList').dataTable({
            "oLanguage": {
                "sLengthMenu": "Afficher _MENU_ Lignes par page",
                "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
                "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
                "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
                "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
            },

            "sPaginationType": "full_numbers"
        });
    });
</script>


<div id="container">
    <form id="form1" runat="server" >
    

    <div id="divlListRechercheOT">
        <fieldset>
            <legend>Recherche avancée</legend>
                <table>
                <tr><td>Par : </td><td>Mot clé</td></tr>
                    <tr>
                   <td>
                   <%: Html.DropDownListFor(m => m.typeRecherche, (IEnumerable<SelectListItem>)ViewData["li"])%>
                    </td>
                        <td>
                        <div class="editor-field">
                      <%: Html.TextBoxFor(m => m.motCle) %>
                      </div>
                        </td>
                        <td>
                        <input type = "submit" value ="Rechercher" />
                        </td>
                    </tr>
                </table>
        </fieldset>
    </div>

    <div id="divlListOT">
    <fieldset>
    <legend>Liste des ordres de transport</legend>
            <div class="option"><table   id ="tableList">
                  <thead>
                    <tr>
                    <th></th>
                    <th></th>
                    <th>Magasin</th>
                    <th>N°Bulettin</th>
                    <th>Client</th>
                    <th>Numéro Postal</th>
                    <th>Ville</th>
                    <th>Téléphone</th>
                    <th>Action</th><th></th></tr>
                </thead>
            <% 
                TRC_GS_COMMUNICATION.Models.MajOT majOt = new TRC_GS_COMMUNICATION.Models.MajOT();
                System.Data.DataTable dt = majOt.selectListeOt(ViewData["whereQuery"].ToString());
            %>
                <tbody>
             <%
                 if (Omniyat.Models.MTools.verifyDataTable(dt))
                 {
                     for (int i = 0; i < dt.Rows.Count; i++)
                     {
                         string vise = "", programme = "";
                         string dateComme = "";
                         try
                         {
                             dateComme = Convert.ToDateTime(dt.Rows[i]["DerniereDateCommunication"].ToString()).ToString("dd/MM/yyyy hh:mm");
                         }
                         catch { dateComme = ""; }
                         if (dt.Rows[i]["OTSuiteEtat"].ToString() == "10")
                         {
                             vise = "<img  class='immage-fix' src='../Images/TRC_client_avise32.png' />";
                         }
                         else
                         {
                             vise = "";
                         }

                         if (dt.Rows[i]["OTPeriodesNonAttribuees"].ToString() == "0")
                         {
                             programme = "<img  class='immage-fix-16' src='../Images/rendezAPrendrecirclered16.png' />";
                         }
                         else
                         {
                             programme = "<img  class='immage-fix-16' src='../Images/rendezvouspriscirclegreen16.png' />";
                         }
              %>
    
                <tr>
                    <td><% Response.Write(programme);%></td>
                    <td><%  Response.Write(vise);%></td>
                    <td><%: Html.Encode(dt.Rows[i]["Magasin"].ToString())%></td>
                    <td><%: Html.Encode(dt.Rows[i]["NBulletin"].ToString())%></td>
                    <td><%: Html.Encode(dt.Rows[i]["Client"].ToString())%></td>
                    <td><%: Html.Encode(dt.Rows[i]["Numéro Postal"].ToString())%></td>
                    <td><%: Html.Encode(dt.Rows[i]["Ville"].ToString())%></td>
                    <td><%: Html.Encode(dt.Rows[i]["Telephone"].ToString())%></td>
                    <td><%: Html.Encode(dateComme)%></td>

                    <td>
                        <%: Html.ActionLink("Voir les détail", "detailOrdreTransport", new { id = dt.Rows[i]["OTID"].ToString() })%> 
                    </td>
                </tr>
        
              <% 
                    }
                }
              %>
          </tbody>
        </table>
        </div>
    </fieldset>

    </div>
    </form>
    </div>
</asp:Content>