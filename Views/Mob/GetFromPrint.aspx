<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>GetFromPrint</title>
</head>
<body>
    <div>
    <table>
        <tr>
            <td>
                Nombre d'impression
            </td>
            <td>
                <input type="text" id="nbrFois" />
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
                <input type="button" id="validerPrint" value="Confirmer"  />
            </td>
        </tr>
    </table>
    
    </div>
</body>
</html>


<script type="text/javascript">
    $(document).ready(function () {
        var _OTNoBL = '<%: ViewData["OTID"] %>';



        $("#validerPrint").click(function () {

            var _nbrFois = $("#nbrFois").val();
//            alert(_nbrFois);
//            alert(_OTNoBL);
                        if (_OTNoBL == "") {
                            alert("Le numéro de bulletin est vide");
                            return false;
                        }

                        $.get($.fn.SERVER_HTTP_HOST() + "/Mob/printTag", { OTID: _OTNoBL, nbr: _nbrFois, name: "ticket_tag" }, function (data) {
                             if (data == "-1") {
                                alert("Erreur !");
                             }
                             else {
                                alert("Imprimé(s) avec succès !");
                             }
                         });
        });

    });
</script>