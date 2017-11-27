<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<% 
    System.Data.DataTable dtF = (System.Data.DataTable)ViewData["dtDirFiles"];
    string id = ViewData["id"].ToString();
    string repture = ViewData["repture"] ==  null ? "-2" : ViewData["repture"].ToString() ;
%>
<div>
    <ul>
        <li>
            <h3>Option Impression</h3>
            <ul>
                <li><input type="checkbox" id="header-page" checked="checked" /> Feuille De Route</li>
            </ul>
        </li>
        <li>
            <h3>Fichier Joint</h3>
            <ul>
                <li>
                    <table >
                        <% if (dtF != null && dtF.Rows.Count > 0){ %>
                        <% foreach (System.Data.DataRow r in dtF.Rows) {%>
                            <tr>
                                <td><input type="checkbox" class="fichier_join" value="<%= r["id"].ToString() %>" checked="checked"/></td>
                                <td style="width:50px"><%= r["Directory"].ToString() %></td>
                                <td>[ <%= r["Description"].ToString() %> ]</td>
                            </tr>
                        <%      } %>
                        <% } %>
                    </table>                      
                </li>
            </ul>
        </li>
        <li>
            <h3>Avec Detail</h3>
            <ul>
                <li><input type="checkbox" id="withDetail"/> Fichier des dossiers groupe</li>
            </ul>
        </li>
    </ul>
    <br />
    <input type="button" class="validerBtn" id="btn_printPlan" value="Imprimer PDF" />
</div>
<script>
    var id = '<%= id %>';
    var repture = '<%= repture %>';
    $(document).ready(function () {
        $('#btn_printPlan').unbind('click').click(function () {
            var ids = '';
            var fr = $('#header-page').is(':checked') ? 1 : 0;
            var wd = $('#withDetail').is(':checked') ? 1 : 0;
            $('.fichier_join[type=checkbox]').each(function (index) {
                if ($(this).is(':checked'))
                    ids += (ids == '' ? '' : ',') + $(this).val();
            });
            if (ids != '' || fr == 1) {
                var url = SERVER_HTTP_HOST() + "/RDV/displayPlanPDF/" + id + "/?ShowHeader=" + fr + "&IdsJoinFiles=" + ids + "&withDetail=" + wd;
                if (repture != '-2')
                    url += "&repture=" + repture;
                var win = window.open(url, '_blank');
                win.focus();
                $("#contrDgArticle").dialog("close");
            }
            else
                alert('Option Invalide');

        });
    });
</script>