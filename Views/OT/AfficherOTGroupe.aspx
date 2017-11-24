<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListOTGroupe
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%
        string OTID = ViewData["OTID"].ToString();     
    %>
    <!-- HEADER -->
    <div id="div-info-ot" style="overflow: hidden;">
        
    </div>
    <!-- HEADER -->
    <div id="div-tab-ot" style="width:100%; min-height: 300px;overflow: hidden;">    
        <ul>
            <li><a href="#div-tab-ot-group">Liste Dossier</a></li>
            <li><a href="#div-tab-ot-info">Info Dossier</a></li>
        </ul>
        <div id="div-tab-ot-group">        
        </div>
        <div id="div-tab-ot-info">        
        </div>
    </div>
    <br />
    <div>
        <div id="div-tab-ot-prestation" class="div-tab-inline">
            
        </div>
        <div id="div-tab-ot-document" class="div-tab-inline">        
        </div>
    </div>
    
    <script type="text/javascript">
        var _OTID = '<%:OTID %>';
        $(document).ready(function () {
            //
            $('#div-tab-ot').tabs();
            var URL_SERVER = $.fn.SERVER_HTTP_HOST();
            var url = URL_SERVER + "/OT/AfficherOT/?" + $.param({ mode: 'modifier', OTID: _OTID, callFromGroup: '1' });
            url += "#div_info_ot_header";
            $.ajax({
                url: url,
                success: function (result) {
                    $('#div-info-ot').hide();
                    $('#div-info-ot').html(result);
                    window.setTimeout(findHeaderInfOT, 500);
                },
                async: false
            });
            function findHeaderInfOT() {
                var result = $('#div-info-ot').find("#div_info_ot_body");
                if (result) {
                    $('#div-info-ot').find("#div_info_ot_body").remove();
                    $('#div-info-ot').find("#header").remove();
                    $('#div-info-ot').find("div.page").css("width", "100%");
                    $('#div-info-ot').show();
                }
                else
                    window.setTimeout(findHeaderInfOT, 500);
            }
            // dossier groupe list
            $.get(URL_SERVER + "/OT/ListOTByGroup/", { OTIDGroup: _OTID }, function (result) {
                $('#div-tab-ot-group').html(result);
            });
            // dossier groupe info
            $.get(URL_SERVER + "/OT/InfoGroupe/", { OTIDGroup: _OTID }, function (result) {
                $('#div-tab-ot-info').html(result);
            });
            // document joint
            $.get(URL_SERVER + "/Prestation/getLstPrestation", { prestOTID: _OTID}, function (data) {
                $("#div-tab-ot-prestation").html(data);
            });
            // document joint
            $.get(URL_SERVER + "/Ajoindre/ajForm", { OTID: _OTID, facturer: "oui" }, function (data) {
                $("#div-tab-ot-document").html(data);
            });

        });
    </script>
</asp:Content>
