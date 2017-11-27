<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>
<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    ListeFournisseur
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">


   

             <div>
                <img id="btn_fourniAdd" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
             </div> 

       <div>
        <%--<h3>Liste des communications</h3>--%>
           <fieldset id="magListField">        
                <%
                    DataTable DTListFournisseur = (DataTable)ViewData["dataListFournisseur"];
                    int _cliNbrCol = DTListFournisseur.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(DTListFournisseur, "FournisseurList", "cellspacing='4' width='100%'"));
                 %>
           </fieldset>

        </div>
        


<script type="text/javascript">
    $(document).ready(function () {

        var _cliNbrCol = '<%: _cliNbrCol %>'
        var nbr = $("#FournisseurList tr").length;

        var tabFournisseur = null;
        if (nbr > 1) {
            tabFournisseur = $("#FournisseurList").not('.initialized').addClass('initialized').dataTable({
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
                    $("#FournisseurList tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);

                        if (!$(this).hasClass("affected")) {
                             var elem = $(this).find("td:first");
                             var val = elem.html();
                   
                             elem.html("<a class='link' fourniEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                             $(this).addClass("affected");
                             //elem.attr('tr th=xxx');
                         }



                        if (_tdcount.length == _cliNbrCol - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var modifier = "<td align='center' width='130'><a class='link' fourniEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                            var supprimer = "<td align='center' width='130'><a class='link' fourniDeleteEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";

                            $(this).append(modifier + supprimer);

                        }
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[fourniEditEvent]").click(function () {


                        var _fourniID = $(this).attr("fourniEditEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Client/addFournisseur", { mode: "modifier", fourniID: _fourniID, IDListe : "10" },

                             function (htmlResult) {

                                 $("#main").html(htmlResult);

                             }
                           );
                    });

                    $(this).find("a[fourniDeleteEvent]").click(function () {


                        var _fourniID = $(this).attr("fourniDeleteEvent");

                         var _conf = confirm("Voulez vous supprimer ce fournisseur?");
                         if (_conf) {

                          $.get($.fn.SERVER_HTTP_HOST() + "/Client/deleteFournisseur", { fourniID: _fourniID },

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


                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 10,

            });
        }


        

        //////////////////////////////////////////AJOUTER//////////////////////////////////////////

        $("#btn_fourniAdd").click(function () {

            $.post($.fn.SERVER_HTTP_HOST() + "/Client/addFournisseur", { mode: "ajouter", IDListe : "10" },

                    function (htmlResult) {

                        $("#main").html(htmlResult);

                    }
               );

        });


    });

</script>

</asp:Content>