<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>


<%
    var _OTId = ViewData["OTId"];
    var _OTPrest = ViewData["OTPrest"];
    var _isOpen = ViewData["isOpen"];
    var _isPalannifToPast = ViewData["isPalannifToPast"];
     %>

    <div id="packTabs" style="width:100%; min-height: 300px;">
                <ul>
                    <li><a href="#pack_dv_packes">Unité de livraison</a></li>
                    
                </ul>

                <div id="pack_dv_packes" style="width:95%">
                    
                </div>

                <div id="pack_dv_articles" style="width:95%">
                    
                </div>
    </div>




    <div id="packcontrDgPr" title="">


    </div>


<script type="text/javascript">
    $(document).ready(function () {


        var _OTID = '<%: _OTId %>';
        var _OTPrest = '<%: _OTPrest %>';
        var _isOpen = '<%: _isOpen %>';
        var _isPalannifToPast = '<%: _isPalannifToPast %>';

        


        $.fn.packGetPackages = function () {
            $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetPacks",
             { OTID: _OTID, isOpen: _isOpen, isPalannifToPast: _isPalannifToPast }
             , function (htmlResult) {
                $("#pack_dv_packes").html(htmlResult + "<br  clear='both' /><br />");
                          //$.fn.packGetArticles();
            });
        };

        $.fn.packGetArticles = function () {
            $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetArticles", { OTID: _OTID, OTPrest: _OTPrest }, function (htmlResult) {
                          $("#pack_dv_articles").html(htmlResult);

                      });
        };

        $.fn.packGetPackages();
        
        
        $("#packTabs").tabs();


    });
</script>



 




