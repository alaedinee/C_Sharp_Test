<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>
<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    getLstMagasin
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">


        <div>
                <img id="btn_magAdd" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
        </div>

        

       <div>
        <%--<h3>Liste des communications</h3>--%>
           <fieldset id="magListField">        
                <%
                    DataTable DTListMag = (DataTable)ViewData["dataListMagasin"];
                    int _magNbrCol = DTListMag.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(DTListMag, "magList", "cellspacing='4' width='100%'"));
                 %>
           </fieldset>

        </div>


      
        


<script type="text/javascript">
    $(document).ready(function () {

        var _magNbrCol = '<%: _magNbrCol %>'
        var nbr = $("#magList tr").length;

        var tabPacks = null;
        if (nbr > 1) {
            tabPacks = $("#magList").not('.initialized').addClass('initialized').dataTable({
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
                    $("#magList tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);

                         if (!$(this).hasClass("affected")) {
                             var elem = $(this).find("td:first");
                             var val = elem.html();
                   
                             elem.html("<a class='link' magEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                             $(this).addClass("affected");
                             //elem.attr('tr th=xxx');
                         }




                        if (_tdcount.length == _magNbrCol - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var modifier = "<td align='center' width='130'><a class='link' magEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                            var detail = "<td align='center' width='130'><a class='link' magDetailEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Détail</a></td>";
                            var supprimer = "<td align='center' width='130'><a class='link' magDeleteEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";
                            
                            $(this).append(modifier + detail + supprimer);

                        }
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[magEditEvent]").click(function () {


                        var _magID = $(this).attr("magEditEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Magasin/getMagsinForm", { mode: "modifier", magID: _magID },

                             function (htmlResult) {

                                 $("#main").html(htmlResult);

                             }
                           );
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[magDeleteEvent]").click(function () {


                        var _magID = $(this).attr("magDeleteEvent");

                        var _conf = confirm("Voulez vous supprimer ce magasin?");
                         if (_conf) {

                        $.get($.fn.SERVER_HTTP_HOST() + "/Magasin/deleteMagasin", {magID: _magID },

                             function (htmlResult) {

                                 if (htmlResult.toString() == "1"){

                                    alert("Opération réussie")

                                   location.reload();
                                   }

                                    else
                                    alert("Echéc d'opération")

                             }
                           );

                           }
                    });

                    /////////////////////////////////////////DETAILS//////////////////////////////////////////

                    $(this).find("a[magDetailEvent]").click(function () {


                        var _magID = $(this).attr("magDetailEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Magasin/getMagsinForm", { mode: "detail", magID: _magID },

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

        $("#btn_magAdd").click(function () {

            $.post($.fn.SERVER_HTTP_HOST() + "/Magasin/getMagsinForm", { mode: "ajouter"},

                    function (htmlResult) {

                        $("#main").html(htmlResult);

                    }
               );

        });

        //////////////////////////////////////////AJOUTER Client a supprimer//////////////////////////////////////////

        //$("#clientAjouter").click(function () {

        //    $.post($.fn.SERVER_HTTP_HOST() + "/Client/addClient", { type: "c", mode: "ajouter" },

        //            function (htmlResult) {

        //                $("#bodyAffichage").html(htmlResult);

        //            }
        //       );

        //});



    });

</script>

</asp:Content>