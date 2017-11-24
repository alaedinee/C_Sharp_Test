<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string OTID = ViewData["OTID"].ToString();
    string mode = ViewData["mode"].ToString();
    string articleID = ViewData["articleID"].ToString();
    System.Data.DataTable data = (System.Data.DataTable)ViewData["data"];
    //
    string ArticleNumber = "";
    string Description = "";
    string Quantity = "0";
    string Volume = "0";
    string Weight = "0";
    string NbrColis = "0";
    //
    if (mode == "modifier" && data != null && data.Rows.Count > 0)
    {
        System.Data.DataRow r = data.Rows[0];
        ArticleNumber = r["articleNumber"].ToString();
        Description   = r["description"].ToString();
        Quantity      = r["quantity"].ToString();
        Volume        = r["volume"].ToString();
        Weight        = r["weight"].ToString();
        NbrColis      = r["NbrColis"].ToString();
    }
    
%>
<div>
    <fieldset>
        <legend>Détails</legend> 
        <table>
            <tr>
                <td width="30%">Article</td>
                <td>:<input type="text" id="txt_ArticleNumber" value="<%:ArticleNumber %>" /></td>
            </tr>
            <tr>
                <td width="30%">Libelle</td>
                <td>:<input type="text" class="txt_desabled" id="txt_Description" value="<%:Description %>" /></td>
            </tr>
            <tr>
                <td width="30%">Qte</td>
                <td>:<input type="text" class="txt_desabled" id="txt_Quantity" value="<%:Quantity %>" /></td>
            </tr>
            <tr>
                <td width="30%">Volume</td>
                <td>:<input type="text" class="txt_desabled" id="txt_Volume" value="<%:Volume %>" /></td>
            </tr>
            <tr>
                <td width="30%">Poids</td>
                <td>:<input type="text" class="txt_desabled" id="txt_Weight" value="<%:Weight %>" /></td>
            </tr>
            <tr>
                <td width="30%">Nbr Colis</td>
                <td>:<input type="text" class="txt_desabled" id="txt_NbrColis" value="<%:NbrColis %>" /></td>
            </tr>
            <tr>
                <td width="30%"></td>
                <td><input type="button" id="btn_addArticleForm" value=" Valider " style="margin-left: 5px;"/></td>
            </tr>
        </table> 
    </fieldset>
    <%--<input type="hidden" id="articleID" value="<%: articleID%>" />--%>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var _OTID = '<%:OTID %>';
        var _mode = '<%:mode %>';
        var _articleID = '<%:articleID %>';

        if (_mode != 'modifier') {
            $(".txt_desabled").attr("disabled", "disabled");
            $("#btn_addArticleForm").hide();
        }
        else
            $("#txt_ArticleNumber").attr("disabled", "disabled");

        $("#btn_addArticleForm").click(function () {

            var _ArticleNumber = $("#txt_ArticleNumber").val();
            var _Description = $("#txt_Description").val();
            var _Quantity = $("#txt_Quantity").val();
            var _Volume = $("#txt_Volume").val();
            var _Weight = $("#txt_Weight").val();
            var _NbrColis = $("#txt_NbrColis").val();

            var msg = "";
            if (!$.isNumeric(_ArticleNumber))
                msg += "ArticleNumber est un entier \n";
            if (!$.isNumeric(_Quantity))
                msg += "Qte est un entier \n";
            if (!$.isNumeric(_Volume.replace(",", ".")))
                msg += "Volume est un reel \n";
            if (!$.isNumeric(_Weight.replace(",", ".")))
                msg += "Poids est un reel \n";
            if (!$.isNumeric(_NbrColis))
                msg += "NbrColis est un entier \n";
            if (msg != "") {
                alert(msg); return;
            }

            var url = $.fn.SERVER_HTTP_HOST() + "/Article/VerifyAddArticle/?" + $.param({ OTID: _OTID, ArticleNumber: _ArticleNumber });
            $.getJSON(url, function (data) {
                if (data != null && data.length > 0) {
                    data = data[0];
                    if (data.Result != '-1' || _mode == 'modifier') {
                        url = $.fn.SERVER_HTTP_HOST() + "/Article/AddArticle/?" + $.param({ OTID: _OTID, ArticleNumber: _ArticleNumber, Description: _Description, Quantity: _Quantity, Volume: _Volume, Weight: _Weight, NbrColis: _NbrColis, mode: _mode });
                        $.get(url, function (result) {
                            if (parseInt(result) > 0) {
                                $("#contrDgArticle").dialog('close');
                                $("#contrDgArticle").remove();
                                $.get($.fn.SERVER_HTTP_HOST() + "/Article/getLstArticles", { OTID: _OTID, isOpen: '1' }, function (art_data) {
                                    $("#divArticle").html(art_data);
                                });
                            }
                            else if (parseInt(result) > 0)
                                alert("Erreur d'dajout !!");
                            else if (parseInt(result) = -1)
                                alert("Article existe déjà");
                        });
                    }
                    else
                        alert("Erreur !");
                }
                else
                    alert("Erreur !");
            });
        });

        $("#txt_ArticleNumber").bind('keypress', function (e) {
            var code = e.keyCode || e.which;
            if (code == 13) {
                var _ArticleNumber = $(this).val();
                var url = $.fn.SERVER_HTTP_HOST() + "/Article/VerifyAddArticle/?" + $.param({ OTID: _OTID, ArticleNumber: _ArticleNumber });
                $.getJSON(url, function (data) {
                    if (data != null && data.length > 0) {
                        data = data[0];
                        if (data.Result != '-1') {
                            $("#txt_Description").val(data.Description);
                            $("#txt_Quantity").val(data.Quantity);
                            $("#txt_Volume").val(data.Volume);
                            $("#txt_Weight").val(data.Weight);
                            $("#txt_NbrColis").val(data.NbrColis);
                            //
                            $(".txt_desabled").removeAttr("disabled");
                            $("#btn_addArticleForm").show();
                        }
                        else
                            alert("Article existant !!");
                    }
                });
                //
            } else {
                $(".txt_desabled").attr("disabled", "disabled");
                $("#btn_addArticleForm").hide();
            }
        });

    });

</script>
