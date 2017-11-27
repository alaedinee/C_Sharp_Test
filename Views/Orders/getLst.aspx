<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>


    

        <div>
                <img id="btn_OTAdd" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
                <img id="btn_print_code" src="/Images/print.png" width='32' height='32'style="cursor:pointer;" /> 
        </div>

      

        

       <div>
        <%--<h3>Liste des communications</h3>--%>
           <fieldset id="magListField">        
                <%
                    DataTable OTData = (DataTable)ViewData["OTData"];
                    int _OTNbrCol = OTData.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTData, "OTList", "cellspacing='4' width='100%'"));
                 %>
           </fieldset>

        </div>


     

 


<script type="text/javascript">
    $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>'
        var nbr = $("#OTList tr").length;

        var tabPacks = null;
        if (nbr > 1) {
            tabPacks = $("#OTList").not('.initialized').addClass('initialized').dataTable({
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
                    $("#OTList tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);

                        if (!$(this).hasClass("affected")) {
                             var elem = $(this).find("td:first");
                             var val = elem.html();
                   
                             elem.html("<a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                             $(this).addClass("affected");
                             //elem.attr('tr th=xxx');
                         }



                        if (_tdcount.length == _OTNbrCol - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var modifier = "<td align='center' width='130'><a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";

                            $(this).append(modifier);

                        }
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[OTEditEvent]").click(function () {


                        var _OTID = $(this).attr("OTEditEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Orders/Afficher", { mode: "modifier", OTID: _OTID },

                             function (htmlResult) {

                                 $("#main").html(htmlResult);

                             }
                           );
                    });

                   
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 10,

            });
        }




        //////////////////////////////////////////AJOUTER//////////////////////////////////////////

        $("#btn_OTAdd").click(function () {

            $.post($.fn.SERVER_HTTP_HOST() + "/Orders/Afficher", { mode: "ajouter" },

                    function (htmlResult) {

                        $("#main").html(htmlResult);

                    }
               );

        });

        ///////////////////////////////////IMPRESSION/////////////////////////////////////////

        $("#btn_print_code").click(function () {
             var _IDS = "";
             //var rows = $("#lstStockPieces").dataTable().fnGetNodes();
             //for (var i = 0; i < rows.length; i++) {
             //    _IDS += $(rows[i]).find("input:checked").attr("index") + ";";
             //}

//             $($("#OTList").dataTable().fnGetNodes()).each(function () {

//                 if ($(this).find("input:checked").attr("index") != null)
//                  _IDS += $(this).attr("index") + ";";

//             })

             alert("Imprimante introuvable");

             //alert(_IDS);

//             if (_IDS != "") {
//                 _IDS = _IDS.substring(0, _IDS.length - 1);
//                 $.post($.fn.SERVER_HTTP_HOST() + "/Orders/printPackages", { values: _IDS }, function (htmlResult) {
//                     if (htmlResult == "0")
//                         alert("Imprimée(s) avec succès !");
//                     else
//                         alert("Erreur d'impression !");
//                 });
//             }
//             else
//                 alert("séléctionner un produit");
         });



    });

</script>






  