<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    </head>
<body>
    <div id="PopUpMAJ" style="width:400px;">
        <table border="0">
            <tr>
                <td>N° Plan</td>
                <td><input type="text" id="idPlan" /></td>
            </tr>
            <tr>
                <td>Heure</td>
                <td>
                    <select id="heure">

                        <%
                            /*
                            System.Data.DataTable lstHours = (System.Data.DataTable) ViewData["lstHours"];
                            if (Omniyat.Models.MTools.verifyDataTable(lstHours))
                            {
                                for (int i = 0; i < lstHours.Rows.Count; i++)
                                {
                                    Response.Write("<option value='" + lstHours.Rows[i][1] + "'>" + lstHours.Rows[i][1] + "</option>");
                                }
                            }  
                             */  
                         %>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="right"><input type="button" id="btnValidateRend" value="Confirmer" /></td>
            </tr>
        </table>    
    </div>
</body>
</html>

<script type="text/javascript">
    $().ready(function () {
        $('#btnValidateRend').click(function () {
            var otid = '<%: ViewData["otid"] %>';
            var idPlan = $("#idPlan").val();
            var heure = $("#heure option:selected").val();

            if (idPlan != "") {
                $.post("../../RDV/verifyRendezVous", { otid: otid, idPlan: idPlan, heure: heure }, function (htmlResult) {
                    if (htmlResult != "erreur" || htmlResult != "") {
                        var _str = htmlResult.substring(0, 10).replace("/", "-").replace("/", "-");
                        alert(_str);
                        _str = "/../RDV/ConfirmationRDV/" + idPlan + "/" + _str + "_" + heure.replace(":", "-") + "-00$" + otid;

                        document.location.href = SERVER_HTTP_HOST() + _str;
                    }
                    else
                        alert("Erreur !");
                });
            }
            else
                alert("Veuillez taper le N° Plan");
        });

        $("#idPlan").keypress(function (e) {
            var idPlan = $("#idPlan").val();
            var _Nbr = "0";
            if (e.which == 13) {
                $.post("../../RDV/getPeriodes", { PlanID: idPlan, Nbr: _Nbr }, function (htmlResult) {
                    if (htmlResult != "") {
                        $("#heure").html(htmlResult);
                    }
                });
            }
        });
    });
</script>