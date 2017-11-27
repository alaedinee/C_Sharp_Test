<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <script type="text/javascript">
        $().ready(function () {

            $("#save").click(function () {

                var pathURL = document.getElementById('pathURL').value + "OT/setRemarqueOT";
                
                $.post(
                                    pathURL,
                                    { otid: $(this).attr("otid"), remarque: document.getElementById('remarque').value },
                                    function (htmlResult) {

                                        if (htmlResult == '1') {

                                            var table = document.getElementById('remarquesTable');
                                            var row = $("<tr><td>" + document.getElementById('log').value + ' : ' + document.getElementById('remarque').value + "</td></tr>");
                                            $(table).append(row);

                                        }
                                        else {
                                            alert("Erreure");
                                        }

                                    }
                               );
            });
        });


        
    </script>
</head>
<body>
<div id="RemarqueOT">
    <div id="liste" style="max-height:300px;overflow:scroll;">
    <% Response.Write(ViewData["remarques"].ToString()); %>
    </div>
    <div id="field" >
    <table width="100%">
    <tr>
    <input type="hidden" id="log" value="<%= Session["login"] %>" />
    <input type="hidden" id="pathURL" value="<%= ViewData["path"] %>" />
    <td width="90%"><textarea rows = "4"  style="width:100%;" id="remarque"></textarea></td>
    <td valign="bottom"><input type="button" otid="<%= ViewData["otid"] %>" id="save"  value="Enregistrer"/></td>
    </tr>
    </table>
    </div>
    </div>
</body>
</html>
