<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>


<%
    string _prestOTID = ViewData["prestOTID"].ToString();
    string _isOpen = ViewData["isOpen"].ToString();
    string _isPalannifToPast = ViewData["isPalannifToPast"] != null ? ViewData["isPalannifToPast"].ToString() : "1";
   
%>


<div id="tabsPrestation" style="width:100%; min-height: 300px">
              <ul>
                <li><a href="#tabs-prest-1">Prestation</a></li>
              <%--  <li><a href="#tabs-4">Chargement</a></li>--%>
              </ul>


              <div id="tabs-prest-1">
                <div>     
                        <%
                            DataTable prestDT = (DataTable)ViewData["prestList"];
                           int _nbrCol = prestDT.Columns.Count;
                            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(prestDT, "prestList", "cellspacing='4' width='100%'"));
                            %>
                </div>


              </div>


       </div>


    


<div id="contrDgPr">

</div>

        

 <script type="text/javascript">
     $(document).ready(function () {

     $(function () {
            $("#tabsPrestation").tabs();
        });

         var _prestOTID = "<%:  _prestOTID %>";
         
         var data = "<%: prestDT %>";

         var _nbrCol = "<%: _nbrCol %>";

         var td1 = "", td2 = "";
         var etat = "", type = "";

         //if ($("#lstComm tr[index]").length > 0) {
         var tabPrest = $("#prestList").not('.initialized').addClass('initialized').dataTable({
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
                 $("#prestList tr[index]").each(function () {

                     var _ID = $(this).attr("index");
                     var _tdcount = $(this).find("td");
                     
                     var _TDEtat = $(this).find("td").eq(4);
                     $(_TDEtat).html("<a class='link' historyPrestEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>"+ $(_TDEtat).html() +"</a>");

                     if (_tdcount.length == _nbrCol - 1) {

                         var modifier = "<td align='center' width='130'><a class='link' detailPrestEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                         var Supprimer = "<td align='center' width='130'><a class='link' supprimerPrestEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";
                         var Articles = "<td align='center' width='130'><a class='link' articlesEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Articles</a></td>";
                         
                         
                         var BL = "<td align='center' width='130'><a class='link' BLEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>BL</a></td>";
                         //
                         var Annuler = "<td align='center' width='130'><a class='link' annulerPrestEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Annuler</a></td>";
                         var Envoyer = "<td align='center' width='130'><a class='link' envoyerEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Envoyer</a></td>";
                         var Activer = "<td align='center' width='130'><a class='link' activerEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Activer</a></td>";
                         
                         $(this).append(modifier);
                         
                     }
                 });

             },
             "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
             
             "iDisplayLength": 5, 

         });

         var wt = 600;
         var ht = 300;

                                                    //////////////////////////DETAIL//////////////////////////////

         $(this).find("a[detailPrestEvent]").click(function () {


             var _prestDetailID = $(this).attr("detailPrestEvent");

             $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/detailPrest", { prestOTID: _prestOTID, mode: "Modifier", prestDetailID: _prestDetailID },

                  function (htmlResult) {

                      $("#contrDgPrest").remove();
                      $("#contrDgPr").html("<div id='contrDgPrest' title='Détail Prestations'>" + htmlResult + "</div>");
                      $("#contrDgPrest").dialog({
                          width: wt,
                          height: ht,
                          modal: true,
                          // position: 'top',

                      });
                  }
                );
         });

                                                    //////////////////////////HISTORI//////////////////////////////

         $(this).find("a[histoPrestEvent]").click(function () {


             var _prestDetailID = $(this).attr("histoPrestEvent");

             //alert($.fn.SERVER_HTTP_HOST() + "/Prestation/prestDetailHisStatus");

             $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/prestDetailHisStatus",
                 { prestID: _prestDetailID },

                  function (htmlResult) {

                      $("#contrDgPrest").remove();
                      $("#contrDgPr").html("<div id='contrDgPrest' title='Historiques'>" + htmlResult + "</div>");
                      $("#contrDgPrest").dialog({
                          width: wt,
                          height: 350,
                          modal: true,
                          // position: 'top',

                      });
                  }
                );
               
             
         });

                                                    //////////////////////////ANNULER//////////////////////////////

         $(this).find("a[annulerPrestEvent]").click(function () {


             var _prestDetailID = $(this).attr("annulerPrestEvent");

             $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/operationPrestation", { prestOTID: _prestOTID, prestMode: "Annuler", prestID: _prestDetailID },

                  function (htmlResult) {

                      alert(htmlResult);
                  }
                );
         });

                                                //////////////////////////ACTIVER//////////////////////////////

         $(this).find("a[activerEvent]").click(function () {


             var _prestDetailID = $(this).attr("activerEvent");

             $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/operationPrestation", { prestOTID: _prestOTID, prestMode: "Annuler", prestID: _prestDetailID },

                  function (htmlResult) {

                      alert(htmlResult);
                  }
                );
         });

                                            //////////////////////////SUPPRIMER//////////////////////////////

         $(this).find("a[supprimerPrestEvent]").click(function () {


             var _prestDetailID = $(this).attr("supprimerPrestEvent");

             var _conf = confirm("Voulez vous supprimer ce service ?");
             if (_conf) {

                 $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/operationPrestation", { prestOTID: _prestOTID, prestMode: "Supprimer", prestID: _prestDetailID },

                      function (htmlResult) {

                          if (htmlResult != "") {
                              alert('Opération réussie');

                                $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/getLstPrestation", { prestOTID: _prestOTID },

                                        function (htmlResult) {

                                            $("#divPrestation").html(htmlResult);

                                        }); 

                          }
                          else
                              alert('Opération échouée')

                      }
                    );
             }
         });

                                        //////////////////////////ENVOYER//////////////////////////////

         $(this).find("a[envoyerEvent]").click(function () {


             var _prestDetailID = $(this).attr("envoyerEvent");

             var _conf = confirm("Voulez vous envoyer ce service ?");
             if (_conf) {

                 $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/prestSendService", { prestID: _prestDetailID },

                      function (htmlResult) {

                          if (htmlResult != "") {
                              alert('Opération réussie');

                          }
                          else
                              alert('Opération échouée')

                      }
                    );
             }
         });
                       //////////////////////////HISTORY//////////////////////////////

         $(this).find("a[historyPrestEvent]").click(function () {


             var _prestDetailID = $(this).attr("historyPrestEvent");

             //alert(_prestDetailID);
             /**/
              $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/historyPrestation", { DetailID: _prestDetailID},
                   function (data) {
                       $("#magChoixx").remove();
                       $("#magChoix").html("<div id='magChoixx' title='Historique'>" + data + "</div>");
                       $("#magChoixx").dialog({
                           width: 650,
                           height: 500,
                           modal: true /*,
                           position: 'top',*/
                       });

                   });
         });
                                        //////////////////////////ARTICLES//////////////////////////////

         $(this).find("a[articlesEvent]").click(function () {


             var _prestDetailID = $(this).attr("articlesEvent");

             //alert(_prestDetailID);
             /**/
              $.get($.fn.SERVER_HTTP_HOST() + "/Article/getServiceArticle/", { DetailID: _prestDetailID},
                   function (data) {
                       $("#magChoixx").remove();
                       $("#magChoix").html("<div id='magChoixx' title='Liste Des Articles'>" + data + "</div>");
                       $("#magChoixx").dialog({
                           width: 650,
                           height: 500,
                           modal: true /*,
                           position: 'top',*/
                       });

                   });
         });

                                        //////////////////////////ARTICLES//////////////////////////////

         $(this).find("a[BLEvent]").click(function () {


             var _prestDetailID = $(this).attr("BLEvent");
             // alert(_prestDetailID);
             var url = $.fn.SERVER_HTTP_HOST() + "/Ajoindre/ImprimeBL/?OTID=" + _prestOTID + "&DetailID="+_prestDetailID;
                window.open(url, '_blank');
         });

         $(this).find("a[BLEvent]").each(function () {
                var _prestDetailID = $(this).attr("BLEvent");
                var Element = $(this);
                                         
                $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/isPrinted", { DetailID: _prestDetailID }, function (htmlResult) {
                   if(htmlResult != 'YES')
                   {
                        $(Element).hide();
                   }
                       
                });
             
         });

                                        //////////////////////////ajouter prestation//////////////////////////////

         $("#btn_addPrest").click(function(){

             $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/detailPrest",
                    { prestOTID: _prestOTID, mode: "Ajouter", prestDetailID: '-1' },

                     function (htmlResult) {

                         $("#contrDgPrest").remove();
                         $("#contrDgPr").html("<div id='contrDgPrest' title='Ajouter préstation'>" + htmlResult + "</div>");
                         $("#contrDgPrest").dialog({
                             width: wt,
                             height: ht,
                             modal: true,
                             // position: 'top',

                         });
                     }
                );

         });


         ////////////////////////////////////////Changement d'icons////////////////////////////////////
         $.fn.prestSetIcons = function () {
             $("#prestList tr[index]").each(function () {

                 var _ID = $(this).attr("index");
               
                 var _elem = $(this);
                 var _html = "";

                 //$(_elem).find("td[icons]").html("<img src='" + $.fn.SERVER_HTTP_HOST() + "/Images/indicator.gif'>");

                 $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/prestgetIcons", { prestIDDetail: _ID }, function (htmlResult) {
                     //htmlResult = htmlResult.replace("{red}", "");
                     //htmlResult = htmlResult.replace("{green}", "");
                     var path = "<a class='link' histoEvent='" + _ID + "' style='color:#E50051;cursor:pointer'><img id='event' src=" + htmlResult.toString() + " /></a>";
                     $(_elem).find("td[icons]").html(path);

                     $(_elem).find("a[histoEvent]").click(function () {

                         var _prestDetailID = $(this).attr("histoEvent");

                         //alert($.fn.SERVER_HTTP_HOST() + "/Prestation/prestDetailHisStatus");

                         $.get($.fn.SERVER_HTTP_HOST() + "/Prestation/prestDetailHisStatus",
                             { prestID: _prestDetailID },

                              function (htmlResult) {

                                  $("#contrDgPrest").remove();
                                  $("#contrDgPr").html("<div id='contrDgPrest' title='Historiques'>" + htmlResult + "</div>");
                                  $("#contrDgPrest").dialog({
                                      width: wt,
                                      height: 350,
                                      modal: true,
                                      // position: 'top',
                                  });
                              }
                            );
                     });

                 });
             });

             
         };

         $.fn.prestSetIcons();

     });

 </script>

