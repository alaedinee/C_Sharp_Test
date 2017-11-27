﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>

<%--<h3><%: DetailID %></h3>--%>
<div>  
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
                     
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });

    });

</script>
