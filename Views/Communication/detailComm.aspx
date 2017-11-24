<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="System.Data" %>

<%
    // Prestation, NameEvent
    var _Sujet = ViewData["Sujet"];
    var _Type = ViewData["Type"];
    var _Date = ViewData["Date"];
    var _Msg = ViewData["Msg"];
    var _User = ViewData["User"];
    var _Prestation = ViewData["Prestation"];
    var _NameEvent = ViewData["NameEvent"];

    
    
     %>
     <style>
        .imgMenuLegend
        {
            cursor: pointer;
            float: left;
            width: 20px;
            margin: 0 5px 0 0;
        }
     </style>

<fieldset>
    <legend id="CommLegend">Détails</legend>
    <table border="0" cellspacing='2' cellpadding='2'>

           
            <tr>
                <td>Sujet </td>
                <td>
                        <input type="text" value="<%: (_Sujet == null)? "" : _Sujet  %>" />
                </td>
            </tr>

            <tr>
                <td>Prestation </td>
                <td>
                        <input type="text" value="<%: (_Prestation == null)? "--" : _Prestation  %>" />
                </td>
            </tr>

            <tr>
                <td>Evenement </td>
                <td>
                        <input type="text" value="<%: (_NameEvent == null)? "--" : _NameEvent  %>" />
                </td>
            </tr>

            <%--<tr>
                <td>Type :</td>
                
                <td>
                       <input type="text" value="<%: (_Sujet == null)? "Inconnu" : _Sujet  %>" />
               </td>
            </tr>--%>

            <tr>
                <td>Message </td>
                
                <td>
                       <textarea type="text" style="width: 300px; height: 150px;"><%: (_Msg == null)? "" : _Msg  %></textarea>
               </td>
            </tr>

            <tr>
                <td>Date action </td>
                
                <td>
                       <input type="text" value="<%: (_Date == null)? "" : _Date  %>" style="width: 200px;" />
               </td>
            </tr>

            <tr>
                <td>Ajoutée par</td>
                
                <td>
                       <input type="text" value="<%: (_User == null)? "" : _User  %>" style="width: 200px;" />
               </td>
            </tr>

           <%-- <tr>
                <td>Date communication</td>
                
                <td>
                       <input type="text" id="DateTimePicker" />
               </td>
            </tr>--%>

</table>
</fieldset>
<script>
    $(document).ready(function () {
        var _TypeCommunication = '<%:_Type %>';
        var elem = $("#CommLegend");
        var content = elem.html();

        if (_TypeCommunication == "TEL")
            elem.html("<img  class='imgMenuLegend' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/phone-blue-icon_32.png' width='20' border='0' />" + content);

        else if (_TypeCommunication == "EMAIL")
            elem.html("<img  class='imgMenuLegend' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/email_32.png' width='20' border='0' />" + content);

        else if (_TypeCommunication == "SMS")
            elem.html("<img  class='imgMenuLegend' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/SMS_32.png' width='20' border='0' />" + content);

        else if (_TypeCommunication == "MDM_COM")
            elem.html("<img  class='imgMenuLegend' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/MDM_COM.png' width='20' border='0' />" + content);

        else if (_TypeCommunication.startsWith("ALERT_"))
            elem.html("<img  class='imgMenuLegend' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/" + _TypeCommunication + "_32.png' width='20' border='0' />" + content);

        else
            elem.html("<img  class='imgMenuLegend' src='" + $.fn.SERVER_HTTP_HOST() + "/Images/email_icon_32.png' width='20' border='0' />" + content);

    });
</script>