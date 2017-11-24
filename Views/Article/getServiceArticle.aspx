<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
<%
    string DetailID = ViewData["DetailID"].ToString();    
%>

<div style="margin-top:25px">
    <div>
        <img id="btn_addServiceArticle" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
    </div>

    
  
     <div>     
        <% 

            DataTable _DTOTPoss = (DataTable)ViewData["LstArticles"];
            int _nbrColPacks = _DTOTPoss.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTOTPoss, "LstSrvArticles", "cellspacing='4' width='100%'"));
       %>
   </div>
</div>
<div id="contrDgPrArt">

</div>

<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColPacks = '<%: _nbrColPacks %>';
        var _prestDetailID = '<%: DetailID %>';
        

            tabOTPoss = $("#LstSrvArticles").not('.initialized').addClass('initialized').dataTable({
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
                    $("#LstSrvArticles tr[index]").each(function () {

                         var _ID = $(this).attr("index");
                         var _tdcount = $(this).find("td");
                     
                         if (_tdcount.length == _nbrColPacks - 1) {
                             var check = "<td align='center' width='30'><span art_id_delet='" +_ID + "' style='cursor:pointer;color:red;'> X </span> </td>";                         
                             $(this).append(check);
                         }
                         $("span[art_id_delet]").unbind().click(function(){
                            var id_article = $(this).attr("art_id_delet");
                            $.get($.fn.SERVER_HTTP_HOST() + "/Article/DeleteArticleService", { DetailID: _prestDetailID, Articles: id_article },

                              function (htmlResult) {
                                    if(htmlResult == 'OK')
                                    {              
                                        $.get($.fn.SERVER_HTTP_HOST() + "/Article/getServiceArticle/", { DetailID: _prestDetailID},
                                        function (data) {
                                            $("#magChoixx").html(data);   
                                        });    
                                    }           
                                    else
                                        alert('Erreur !!');           
                              }
                            );
                        });
                    });
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });

            $("#btn_addServiceArticle").click(function () {
              $.get($.fn.SERVER_HTTP_HOST() + "/Article/getServiceArticleToChoise/", { DetailID: _prestDetailID },
                   function (data) {
                       $("#contrDgPrArt_Content").remove();
                       $("#contrDgPrArt").html("<div id='contrDgPrArt_Content' title='Choix Articles'>" + data + "</div>");
                       $("#contrDgPrArt_Content").dialog({
                           width: 630,
                           height: 470,
                           modal: true /*,
                           position: 'top',*/
                       });
                   });
            });
            

    });

</script>
