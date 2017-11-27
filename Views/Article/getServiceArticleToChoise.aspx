<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
<%
    string DetailID = ViewData["DetailID"].ToString();    
%>
<%--<h1>Dialog</h1>--%>
<div>  
    <div style="float:right">
        <input type="button" id="ArticleToChoise_btnSave" class="validerBtn" value="  Sauver  " />
    </div><br />
     <div style="margin-top:25px">     
        <% 

            DataTable _DTOTPoss = (DataTable)ViewData["LstArticles"];
            int _nbrColPacks = _DTOTPoss.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTOTPoss, "LstArticleToChoise", "cellspacing='4' width='100%'"));
       %>
   </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var _prestDetailID = '<%: DetailID %>';
        var _nbrColArt = '<%: _nbrColPacks %>';
        

            $("#LstArticleToChoise").not('.initialized').addClass('initialized').dataTable({
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
                     $("#LstArticleToChoise tr[index]").each(function () {

                        var _ID = $(this).attr("index");
                        var _tdcount = $(this).find("td");
                     
                        if (_tdcount.length == _nbrColArt - 1) {
                            var qte_val = $(this).find("td:eq(2)").text();
                            var qte = "<td align='center'><input style='width: 30px;' type='text' art_qte_id='" +_ID + "' value="+ qte_val +" disabled/></td>";                         
                            var check = "<td align='center' width='130'><input type='checkbox' art_id='" +_ID + "' class='art_item' /></td>";                         
                            $(this).append(qte + check);
                        }
                    });

                    $('#LstArticleToChoise input[art_id]').unbind().click(function () {
                        if(this.checked)
                        {
                            $(this).closest("tr").find('input[art_qte_id]').removeAttr('disabled');
                        }
                        else
                        {
                            $(this).closest("tr").find('input[art_qte_id]').attr('disabled', 'disabled');
                        }
                    });
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });
            $("#ArticleToChoise_btnSave").click(function(){
                var allVals = '';
                 $('#LstArticleToChoise input[art_id]:checked').each(function() {
                    var qte =  $(this).closest("tr").find('input[art_qte_id]').val();
                    allVals += (allVals == '' ? '' : ',') + $(this).attr("art_id") + "#" + qte;
                 });
                 if(allVals == '')
                 {
                    alert('Aucun article selectionné !!');
                    return;
                 }

                 $.get($.fn.SERVER_HTTP_HOST() + "/Article/AddArticleService", { DetailID: _prestDetailID, Articles: allVals },

                  function (htmlResult) {
                        if(htmlResult == 'OK')
                        {              
                            $.get($.fn.SERVER_HTTP_HOST() + "/Article/getServiceArticle/", { DetailID: _prestDetailID},
                            function (data) {
                                $("#magChoixx").html(data);   
                            });    
                                   
                            $("#contrDgPrArt_Content").dialog('close');
                        }           
                        else
                            alert('Erreur !!');           
                  }
                );                 
            });

    });

</script>
