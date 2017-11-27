<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>


<div>
  
        <fieldset>   
        <% 
            var otid = ViewData["otid"].ToString();
            DataTable _DTPacksInconnu = (DataTable)ViewData["PackInconnu"];
            int _nbrColPacksInconnu= _DTPacksInconnu.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTPacksInconnu, "packListPacksInconnu", "cellspacing='4' width='100%'"));
       %>
       </fieldset>

        <fieldset>
            <table>
                <tr>
                    <td>
                        Num. package
                    </td>
            
                    <td>
                        <input type="text" id="numPackage" />
                    </td>
                </tr>
                <tr>
                    <td>
                        
                    </td>
                    <td>
                        <input type="button" id="validerAffect" value="Affecter package" />
                    </td>
                </tr>
            </table>
        </fieldset>
   
</div>
	    
<br clear="all" />


<div id="DGpackInconnu">

</div>



<script type="text/javascript">
    $(document).ready(function () {

        var _otid = '<%: otid %>';
        var _nbrColPacksInconnu = '<%: _nbrColPacksInconnu %>';
        var nbr = $("#packListPacksInconnu tr").length;

        var tabPacksInconnu = null;

        if (nbr > 1) {
            tabPacksInconnu = $("#packListPacksInconnu").not('.initialized').addClass('initialized').dataTable({
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
                    $("#packListPacksInconnu tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);

                       

                        if (_tdcount.length == _nbrColPacksInconnu - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var affecter = "<td align='center' width='130'><a class='link' packAffPacks ='" + _ID + "' style='color:#E50051;cursor:pointer'>Affecter</a></td>";
                            //var desaffecter = "<td align='center' width='130'><a class='link' packDesaffPacks ='" + _ID + "' style='color:#E50051;cursor:pointer'>Désaffecter</a></td>";
                            
      

                            $(this).append(affecter);

                            }
                        });

                            $(this).find("a[packAffPacks]").click(function () {

                                var _ID = $(this).attr("packAffPacks");

                                 var _conf = confirm("Voulez vous confirmer ce package?");

                                      if (_conf) {

                                        $.post($.fn.SERVER_HTTP_HOST() + "/Package/updatePackInconnu", { IDPack: _ID, OTID : _otid }, function (htmlResult) {
                                           if (htmlResult.toString() == "1"){
                                              alert("Affecté avec succès !");
                                              $("#DGpacK").remove();
                                                 $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _otid },
                                                 function (htmlResult) {

                                                       $("#divPackageModifier").html(htmlResult);

                                                 });            
                                             }

                                             else
                                                 alert("Erreur d'affectation");
                                        });
                                        
                                     }      
                            });

                             

                    },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,
                });

        }


        $("#validerAffect").click(function () {
                var _valCode = $("#numPackage").val(); 

                if(_valCode == ""){
                    alert("le num package est vide");
                    return false;
                }

                 var _conf = confirm("Voulez vous affecter ce package?");

                 if (_conf) {
                
                 $.post($.fn.SERVER_HTTP_HOST() + "/Package/scannPackInconnu", { otid: _otid, valCode : _valCode }, function (htmlResult) {

                            if(htmlResult.toString() == "1"){
                                alert("Affecté avec succès !");
                                              $("#DGpacK").remove();
                                                 $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _otid },
                                                 function (htmlResult) {

                                                       $("#divPackageModifier").html(htmlResult);

                                                 }); 
                            }
                            else if(htmlResult.toString() == "0")
                                alert("Echéc d'affectation");
                            else if(htmlResult.toString() == "-1")
                                alert("ce num package n'existe pas");
                     
                     });

                }

       

        });

       


    });

</script>


