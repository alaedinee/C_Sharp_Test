<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>

<div style="float:left">
     <input type="button" id="btn_return_recep" value="Retour" />   
</div>


<div>
         
        <% 
            DataTable _DTAllPackRecep = (DataTable)ViewData["ListPackParReception"];
            int _nbrColPacks = _DTAllPackRecep.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTAllPackRecep, "ListAllPackRecep", "cellspacing='4' width='100%'"));
       %>
   
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColPacks = '<%: _nbrColPacks %>'
        var nbr = $("#ListAllPackRecep tr").length;


        var tabRecep = null;

       // if (nbr > 1) {
            tabRecep = $("#ListAllPackRecep").not('.initialized').addClass('initialized').dataTable({
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
                    $("#ListAllPackRecep tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);
                    });

                    
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });
        //}


        $("#btn_return_recep").click(function() {
        
             $.post($.fn.SERVER_HTTP_HOST() + "/OT/ListAllReception", { IDRecep: '-1' }, 
             
             function (htmlResult) {

                    $("#recep_dv_AllRecep").html(htmlResult + "<br  clear='both' /><br />");

                 });
        
        
        });

        


    });

</script>
