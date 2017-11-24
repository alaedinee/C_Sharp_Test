<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var _IDList = ViewData["IDList"].ToString();

    var _OTID = ViewData["OTID"].ToString();
    %>


<div>
    <table>
        <tr>
            <td>
                Type :
            </td>
            <td>
                <input type="text" id="docTypeAdd" value="" />
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
                <input type="button"  id="submitType" value="Valider" />
            </td>
        </tr>
    </table>
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var _IDList = '<%: _IDList %>';
        var _otid = '<%: _OTID %>';


        $("#submitType").click(function () {
            
            var _typeAdd = $("#docTypeAdd").val();
            

            if (_typeAdd == "0"){
                Alert("Type invalide !!")
            }


            $.post(SERVER_HTTP_HOST() + "/Ajoindre/saveTypeDoc", { idList: _IDList, type: _typeAdd }, function (htmlResult) {


                    if (htmlResult == "0") {
                        //$.fn.getPackages();
                        $("#DGADDTYPE").remove();
                        alert('Le type "' + _typeAdd + '" est ajouté');
                        $.post($.fn.SERVER_HTTP_HOST() + "/Ajoindre/ajForm", { OTID: _otid, facturer: "oui" },

                                        function (htmlResult) {

                                            $("#divAjoindre").html(htmlResult);

                                        });
                                    }

                    else if (htmlResult == "1")
                        alert("Ce type existe déja dans la liste");

                    else if (htmlResult == "2")
                        alert("Erreur d'ajout !");

                });

            
        });








    });

</script>
