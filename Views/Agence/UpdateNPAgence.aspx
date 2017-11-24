<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<% 
    System.Data.DataTable dtNp = (System.Data.DataTable)ViewData["data"];
    System.Data.DataTable dtAgence = (System.Data.DataTable)ViewData["dt_agence"];

    System.Data.DataRow rNP = dtNp.Rows[0];
    string id = ViewData["id"].ToString();  
%>
<style>
    #table-np-content th{ width: 30%; text-align: left;}
</style>
<table border="0" id="table-np-content">
    <tr>
        <th>NP</th>
        <td>:<input type="text" disabled="disabled" value="<%:rNP["NP"]%>" /></td>
    </tr>

    <tr>
        <th>Ville</th>
        <td>:<input type="text" disabled="disabled" value="<%:rNP["Ville"]%>" /></td>
    </tr>

    <tr>
        <th>Region</th>
        <td>:<input type="text" disabled="disabled" value="<%:rNP["Region"]%>" /></td>
    </tr>

    <tr>
        <th>Zone</th>
        <td>:<input type="text" disabled="disabled" value="<%:rNP["Zone"]%>" /></td>
    </tr>
    
    <tr>
        <th>Dépot</th>
        <td>:<select id="agence" style="width: 200px;">
                <option value=""></option>
                <% foreach (System.Data.DataRow r in dtAgence.Rows)
                   {
                       Response.Write("<option value=\"" + r["id"].ToString() + "\" " + ((rNP != null) && rNP["AgenceID"].ToString() == r["id"].ToString() ? "selected" : "") + ">" + r["Nom"].ToString() + "</option>");
                   } 
                %>
            </select>
        </td>
    </tr>

    <tr>
        <td colspan="2" align="right" style="padding: 8px;"><input type="button"  value='Modifier' id="btnSave"  /></td>
    </tr>

</table>
<script>
    $(document).ready(function () {
        $("#btnSave").click(function () {
            var _Agence = $("#agence option:selected").val();
            if (_Agence == "")
                _error += "Agence est vide !\n";

            $.get($.fn.SERVER_HTTP_HOST() + "/Agence/SaveNPAgence", { id: '<%:id %>', AgenceID: _Agence }, function (r) {
                if (r == '1')
                    location.reload();
                else
                    alert('Erreur !!');
            });
        });
    });
</script>