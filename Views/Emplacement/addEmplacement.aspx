<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    System.Data.DataTable dtPack = (System.Data.DataTable)ViewData["dt"];
    System.Data.DataTable dtAgence = (System.Data.DataTable)ViewData["dt_agence"];
    System.Data.DataRow rPack = null;
    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(dtPack))
    {
        rPack = dtPack.Rows[0];
    }
    string ID = ViewData["ID"].ToString();

    
%>
<input type="hidden" id="ID" value="<%: ID  %>" />
    
<table border="0">
    <tr>
        <td>Rack</td>
        <td><input type="text" id="Aller" class="toUPPER" cp="" value="<%: (rPack != null )? rPack["Aller"].ToString() : ""  %>" />  </td>
    </tr>

    <tr>
        <td>Etage</td>
        <td><input type="text" id="Niveau" class="toUPPER" cp="" value="<%: (rPack != null )? rPack["Niveau"].ToString() : ""  %>" /></td>
    </tr>

    <tr>
        <td>Position</td>
        <td><input type="text" id="Adresse" class="toUPPER" cp="" value="<%: (rPack != null )? rPack["Adresse"].ToString() : ""  %>" /></td>
    </tr>

    <tr>
        <td>Emplacement</td>
        <td><input type="text" id="CABEmplacement" class="toUPPER" value="<%: (rPack != null )? rPack["CABEmplacement"].ToString() : ""  %>" /></td>
    </tr>
    
    <tr>
        <td>Dépot</td>
        <td>
            <select id="agence" style="width: 200px;">
                <option value=""></option>
                <% foreach (System.Data.DataRow r in dtAgence.Rows)
                   {
                       Response.Write("<option value=\"" + r["id"].ToString() + "\" " + ((rPack != null) && rPack["id_agence"].ToString() == r["id"].ToString() ? "selected" : "") + ">" + r["Nom"].ToString() + "</option>");
                   } 
                %>
            </select>
        </td>
    </tr>

    <tr>
        <td colspan="2" align="right"><input type="button"  value='<%: (ID == "0")? "Ajouter" : "Modifier" %>' id="btnSave"  /></td>
    </tr>

</table>

<style>
.Date {
    z-index:-1;
}
.D1
{
    z-index:10000000;
    position :absolute;
}
</style>

<script type="text/javascript">
    $(document).ready(function () {

        $("input[cp]").keyup(function () {
            $("#CABEmplacement").val($("#Aller").val() + "" + $("#Niveau").val() + $("#Adresse").val());
        });

        $(".toUPPER").keyup(function () {
            this.value = this.value.toUpperCase();
        });

        $("#btnSave").click(function () {
            var _ID = $("#ID").val();
            var _stockID = $("#stockID").val();
            var _codeStock = $("#codeStock").val();
            var _Aller = $("#Aller").val();
            var _Niveau = $("#Niveau").val();
            var _Adresse = $("#Adresse").val();
            var _CABEmplacement = $("#CABEmplacement").val();
            var _Agence = $("#agence option:selected").val();
            
            var _error = '';
            if (_Aller.length == 0)
                _error = "Aller invalide !\n";

            if (_Niveau.length == 3)
                _error += "Niveau invalide !\n";

            if (_Adresse.length == 3)
                _error += "Adresse invalide !\n";

            if (_Agence == "")
                _error += "Agence est vide !\n";

            if (_error == '') {
                $.post($.fn.SERVER_HTTP_HOST() + "/Emplacement/saveEmplacement", {
                    id: _ID,
                    Aller: _Aller, Niveau: _Niveau, Adresse: _Adresse, numero: _CABEmplacement, stockID: _stockID,
                    agence: _Agence
                }, function (htmlResult) {
                    if (htmlResult == "0") {
                        //alert(_stockID);
                        alert('<%: (ID == "0")? "Ajout" : "Modifi" %>é avec succès !');
                        location.reload();
                    }
                    else if (htmlResult == "-2")
                        alert("Cet emplacement existe déjà !");
                    else
                        alert("Erreur d'ajout !");
                });

            } else
                alert(_error);

            $("#dialogCFT").remove();

        });
    });
</script>