<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>


<div style="margin-top:25px">
  
          
        <% 
            DataTable _DTAllRecep = (DataTable)ViewData["ListAllReception"];
            int _nbrColPacks = _DTAllRecep.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTAllRecep, "ListAllRecep", "cellspacing='4' width='100%'"));
       %>
   
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColPacks = '<%: _nbrColPacks %>'
        var nbr = $("#ListAllRecep tr").length;


        var tabRecep = null;

        if (nbr > 1) {
            tabRecep = $("#ListAllRecep").not('.initialized').addClass('initialized').dataTable({
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
                    $("#ListAllRecep tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);



                        if (_tdcount.length == _nbrColPacks - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var select = "<td align='center' width='130'><a class='link' selectRecep='" + _ID + "' style='color:#E50051;cursor:pointer'>List package</a></td>";


                            $(this).append(select);

                        }
                    });

                    

                     $(this).find("a[selectRecep]").click(function () {


                        var _IDselect = $(this).attr("selectRecep");

                        $.get($.fn.SERVER_HTTP_HOST() + "/OT/ListPackParReception", { IDRecep: _IDselect },

                             function (htmlResult) {

                                $("#recep_dv_AllRecep").html(htmlResult + "<br  clear='both' /><br />");
                             });
                    });

                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });
        }

        


    });

</script>
