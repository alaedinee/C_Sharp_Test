﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>




<div>
          
        <%
            var _OTId = ViewData["OTID"];
            DataTable DTArticles = (DataTable) ViewData["DTArticles"];
            int _nbrColArticles = DTArticles.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(DTArticles, "packListArticles", "cellspacing='4' width='100%'"));
         %>
   
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColArticles = '<%: _nbrColArticles %>'
        var nbr = $("#packListArticles tr").length;

        var tabArticles = null;

        if (nbr > 1) {
            tabArticles = $("#packListArticles").not('.initialized').addClass('initialized').dataTable({
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
                    $("#packListPacks tr[index]").each(function () {




                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);
                    });

                },

                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });

        }



    });

</script>