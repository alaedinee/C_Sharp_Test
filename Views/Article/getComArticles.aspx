<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
<%
    //string DetailID = ViewData["DetailID"].ToString();    
%>

<div style="margin-top:25px;">
    <div style="margin-bottom: 10px;overflow: hidden;">
        <input type="button" id="btn_addComArticle" value=" Valider " style="float: right;" />
    </div>

    
  
     <div>     
        <% 

            DataTable _DTOTPoss = (DataTable)ViewData["LstArticles"];
            int _nbrColPacks = _DTOTPoss.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTOTPoss, "LstComArticles", "cellspacing='4' width='100%'"));
       %>
   </div>
</div>
<div id="contrDgPrArt">

</div>

<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColPacks = '<%: _nbrColPacks %>';
        

        var  tabLstComArticles = $("#LstComArticles").not('.initialized').addClass('initialized').dataTable({
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
                    $("#LstComArticles tr[index]").each(function () {

                         var _ID = $(this).attr("index");
                         var _Number = $(this).find("td:eq(0)").text();
                         var _tdcount = $(this).find("td");
                         // console.log(_tdcount.length, "/", _nbrColPacks - 1, "/" , _tdcount.length == _nbrColPacks - 1);
                         if (_tdcount.length == _nbrColPacks - 1) {
                             var check = "<td align='center' width='130'><input type='checkbox' itemID='" +_ID + "' itemNumber='" +_Number + "' class='art_item' /></td>";                         
                            $(this).append(check);
                         }
                        });
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });
            //
            $("#btn_addComArticle").click(function(){
                var allIDs = '';
                var allVals = '';
                 $('#LstComArticles input[itemID]:checked').each(function() {
                   allIDs += (allIDs == '' ? '' : ',') + $(this).attr("itemID");
                   allVals += (allVals == '' ? '' : ',') + $(this).attr("itemNumber");
                 });
                 if(allVals == '')
                 {
                    alert('Aucun article selectionné !!');
                    return;
                 }
                 else
                 {
                    //'[' + allVals + ']'
                    var msg = $('textarea[id=Message]').val(); 
                    $('textarea[id=Message]').val('[' + allVals + ']\n' + msg);
                    $('textarea[id=Message]').attr("articles_id", allIDs);
                    $("#ComlstArticle_Content").dialog('close');
                 }
                 

                 
            });

    });

</script>
