<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>


<div id="divAdd" style="float:right">

    <input type="button" value="Nouveau dossier" id="createNewFolder" />

</div>

<div style="margin-top:25px">
  
          
        <% 
            var _otid = ViewData["otid"].ToString();
            var _idPackage = ViewData["idPackage"].ToString();
            
            
            DataTable _DTOTPoss = (DataTable)ViewData["OTPossible"];
            int _nbrColPacks = _DTOTPoss.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTOTPoss, "ListOTPoss", "cellspacing='4' width='100%'"));
       %>
   
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColPacks = '<%: _nbrColPacks %>';
        var _idPackage = '<%: _idPackage %>';
        var _otid = '<%: _otid %>';

        var nbr = $("#ListOTPoss tr").length;


        var tabOTPoss = null;

        //if (nbr > 1) {
            tabOTPoss = $("#ListOTPoss").not('.initialized').addClass('initialized').dataTable({
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
                    $("#ListOTPoss tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);



                        if (_tdcount.length == _nbrColPacks - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var select = "<td align='center' width='130'><a class='link' choixOT='" + _ID + "' style='color:#E50051;cursor:pointer'>Séléctionner</a></td>";


                            $(this).append(select);
                            
                        }
                    });

                    

                     $(this).find("a[choixOT]").click(function () {


                        var _IDchoix = $(this).attr("choixOT");
                        var _conf = confirm("Voulez vous confirmer ce dossier?");
                        if (_conf) {

                            $.get($.fn.SERVER_HTTP_HOST() + "/Package/ValiderOTChoix", { IDChoix: _IDchoix, idPackage: _idPackage},

                                 function (htmlResult) {

                                    if(htmlResult.toString() == "0")

                                        alert("Opération échouée");

                                    else{
                                        // alert("Opération réussie");
                                        $("#DGpacK").remove();
                                             $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _otid },

                                                function (htmlResult) {

                                                    $("#divPackageModifier").html(htmlResult);

                                                }); 
                                        }
                               
                                 });
                               }//fin IF
                    });

                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,

            });
       // }

       $("#createNewFolder").click( function(){

             //alert(_otid);
       
            $.post($.fn.SERVER_HTTP_HOST() + "/Orders/Afficher", { mode: 'ajouter', OTID: '0', valBase: _otid, idPackage: _idPackage },
             function (htmlResult) {

                 $("#DGpacK").remove();
               $("#main").html(htmlResult);

             }); 
       
       
       });

        


    });

</script>
