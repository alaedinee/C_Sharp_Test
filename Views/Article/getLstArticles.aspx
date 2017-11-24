<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string _isOpen = ViewData["isOpen"] == null ? "" : ViewData["isOpen"].ToString();
    string OTID = ViewData["OTID"] == null ? "-1" : ViewData["OTID"].ToString();
%>
<div id="tabsArticles" style="width:100%; min-height: 300px">
        <ul>
        <li><a href="#tabs-articles-1">Articles</a></li>
        <%--  <li><a href="#tabs-4">Chargement</a></li>--%>
        </ul>

        <div id="tabs-articles-1" style="width:95%">  
            <%if (_isOpen.ToString() != "0"){ %>
                <div>
                    <img id="btn_addArticle" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
                </div>
            <% } %> 
            <div>
                <%
                    System.Data.DataTable articleDT = (System.Data.DataTable)ViewData["LstArticles"];
                    int _nbrCol = articleDT.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(articleDT, "LstArticles", "cellspacing='4' width='100%'"));
                %>
            </div>  
        </div>


</div>
<div id="contrDgArt">

</div>

<script type="text/javascript">
     $(document).ready(function () {

     $(function () {
            $("#tabsArticles").tabs();
        });

            var _OTID = '<%: OTID %>';
            var _nbrCol = '<%: _nbrCol %>';

             var tabComm = $("#LstArticles").not('.initialized').addClass('initialized').dataTable({
                 sPaginationType: "full_numbers"
                    , "oLanguage": {
                        "sProcessing": "Traitement en cours...",
                        "sLengthMenu": "Afficher _MENU_ éléments",
                        "sZeroRecords": "Aucun élément à afficher",
                        "sInfo": "Affichage de l'élement _START_ à _END_ sur _TOTAL_ éléments",
                        "sInfoEmpty": "Affichage de l'élement 0 à 0 sur 0 éléments",
                        "sInfoFiltered": "(filtré de _MAX_ éléments au total)",
                        "sInfoPostFix": "",
                        "sSearch": "Rechercher:",
                        
                        "sUrl": "",
                        
                         
                        "oPaginate": {
                            "sFirst": "<<",
                            "sPrevious": "<",
                            "sNext": ">",
                            "sLast": ">>"
                        }

                    },
                 "fnDrawCallback": function (oSettings) {
                    $("#LstArticles tr[index]").each(function () {
                        var _ID = $(this).attr("index");
                        var _tdcount = $(this).find("td");
                        var _ArtNum = $(this).find("td:eq( 0 )").html();

                        $(this).find("td:eq( 0 )").html("<a class='link' showChildsArticle='" + _ID + "' style='color:#E50051;cursor:pointer'>"+_ArtNum+"</a>");

                        if (_tdcount.length == _nbrCol - 1) {
                            var modifier = "<td align='center' width='120'><a class='link' updateArticleEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                            var historiqueArt = "<td align='center' width='120'><a class='link' historyArticleEvent='" + _ID + "' data-mode='STATUS' style='color:#E50051;cursor:pointer'>Hist.Statut</a></td>";
                            var historiqueRec = "<td align='center' width='120'><a class='link' historyArticleEvent='" + _ID + "' data-mode='RECEPTION' style='color:#E50051;cursor:pointer'>Hist.Reception</a></td>";
                            <%if (_isOpen.ToString() != "0"){ %>
                                $(this).append(modifier + historiqueArt + historiqueRec);
                            <% } %>
                        }
                     });
                     ////////////////////////////////////////EVENT LISTNER/////////////////////////////////////////
                     
                     $(this).find('a[updateArticleEvent]').not('.initialized').addClass('initialized').click(function(){
                        var _ID = $(this).attr("updateArticleEvent");
                        $.post($.fn.SERVER_HTTP_HOST() + "/Article/addArticleForm",
                            { OTID: _OTID, mode: "modifier", articleID: _ID },
                             function (htmlResult) {
                                $("#contrDgArticle").remove();
                                $("#contrDgArt").html("<div id='contrDgArticle' title='Ajouter Article'>" + htmlResult + "</div>");
                                $("#contrDgArticle").dialog({
                                    width: 400,
                                    height: 300,
                                    modal: true
                                });
                        });
                     });
                     $(this).find('a[historyArticleEvent]').not('.initialized').addClass('initialized').click(function(){
                        var _ID = $(this).attr("historyArticleEvent");
                        var _MODE = $(this).attr("data-mode");
                        $.post($.fn.SERVER_HTTP_HOST() + "/Article/historyArticle",
                            { OrderLineID: _ID, mode: _MODE },
                             function (htmlResult) {
                                $("#contrDgArticle").remove();
                                $("#contrDgArt").html("<div id='contrDgArticle' title='Historique Reception Article'>" + htmlResult + "</div>");
                                $("#contrDgArticle").dialog({
                                    width: 700,
                                    height: 500,
                                    modal: true
                                });
                        });
                     });

                     $(this).find('a[showChildsArticle]').not('.initialized').addClass('initialized').click(function(){
                        var _ID = $(this).attr("showChildsArticle");
                        $.post($.fn.SERVER_HTTP_HOST() + "/Article/showChildsArticle",
                            { OrderLineID: _ID },
                             function (htmlResult) {
                                $("#contrDgArticle").remove();
                                $("#contrDgArt").html("<div id='contrDgArticle' title='Article Assemblant : "+ _ID +"'>" + htmlResult + "</div>");
                                $("#contrDgArticle").dialog({
                                    width: 400,
                                    height: 300,
                                    modal: true
                                });
                        });
                     });
                 },
                 "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                 //"bLengthChange": false,   //disable change values
                  "iDisplayLength": 5, // show only five rows
             });
             /////////////////////////////////////////////////// AFFICHER AJOUTER ARTICLE FORM ///////////////////////////////////////////////////
             $('#btn_addArticle').click(function () {
                 $.post($.fn.SERVER_HTTP_HOST() + "/Article/addArticleForm",
                    { OTID: _OTID, mode: "Ajouter", articleID: '-1' },
                     function (htmlResult) {
                        $("#contrDgArticle").remove();
                        $("#contrDgArt").html("<div id='contrDgArticle' title='Ajouter Article'>" + htmlResult + "</div>");
                        $("#contrDgArticle").dialog({
                            width: 400,
                            height: 300,
                            modal: true
                        });
                });

             });
             

     });

</script>
