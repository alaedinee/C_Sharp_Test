<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>
<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    getLstOT
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
<%
    string _stockID = ViewData["stockID"].ToString();
    string _codeStock = ViewData["codeStock"].ToString();
     %>
      <div style="width:100%"> 
           
          <br />
            <div style="float:left">
                <img id="btn_addP" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
                <img id="btn_printP" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/print.png" width='32' height='32'style="cursor:pointer;" /> 
            </div>
            <div style="float:right">
               <%-- Séléctionner Tous <input type='checkbox' id="selAll" style="margin-right:7px" />--%>
            </div>
            <br clear="all" />
          <br />
             <div>
        <%--<h3>Liste des communications</h3>--%>
           <fieldset id="magListField">        
                <%
                    DataTable OTData = (DataTable)ViewData["dt"];
                    int _OTNbrCol = OTData.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTData, "OTList", "cellspacing='4' width='100%'"));
                 %>
           </fieldset>

        </div>

<div id="contrSP" title=""></div>

     <script type="text/javascript">
         $(document).ready(function () {

             var _StockID = "<%: _stockID %>";
             var _codeStock = "<%: _codeStock %>";
var _OTNbrCol = '<%: _OTNbrCol %>'


             var nbr = $("#OTList tr").length;

             $("#OTList tr[index]").each(function () {
                 var _ID = $(this).attr("index");
                 var _elem = $(this);
             });

             var tabPacks = null;
//        if (nbr > 1) {
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

                        if (_tdcount.length == _OTNbrCol - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                             var modifier = "<td align='center' width='130'><a class='link' mod='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                             var supprimer = "<td align='center' width='130'><a class='link' del='" + _ID + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";
                             var Cheack = "<td align='center' width='130'><input type='checkbox' index='" + _ID + "'> </td>";

                            $(this).append(modifier + supprimer + Cheack);

                        }
                    });
                    ///////////////////////////////////////////////////////////////////////////////////////////

                    $(this).find("a[del]").click(function () {

                                 var _conf = confirm("Voulez vous vraiment supprimer cet emplacement ?");
                                 if (_conf) {
                                     var _ID = $(this).attr("del");

                                     $.post($.fn.SERVER_HTTP_HOST() + "/Emplacement/deleteEmplacement", { id: _ID }, function (htmlResult) {
                                         if (htmlResult == "0") {
                                             //$.fn.getPackages();
                                             alert("supprimé avec succès !");
                                             location.reload();
                                         }
                                         else
                                             alert("Erreur de suppression !");
                                     });

                                 }
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[mod]").click(function () {
                                
                                 var _ID = $(this).attr("mod");
                           
                                 $.post($.fn.SERVER_HTTP_HOST() + "/Emplacement/addEmplacement", { id: _ID, idStock: _StockID, codeStock: _codeStock }, function (htmlResult) {
                                     
                                     $("#dialogCFT").remove();
                                     $("#contrSP").html("<div id='dialogCFT' title='Modifier un emplacement'>" + htmlResult + "</div>");

                                     $("#dialogCFT").dialog({
                                         height: 300,
                                         width: 350,
                                         modal: true
                                     });

                                     $("#dialogCFT").dialog("option", "position", [600, 500]);

                                });
                       });

                   
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 10,

            });
//        }



             $("#btn_addP").click(function () {
               

                 $.post($.fn.SERVER_HTTP_HOST() + "/Emplacement/addEmplacement", { id: "0", idStock: _StockID, codeStock: _codeStock }, function (htmlResult) {
                     $("#dialogCFT").remove();
                     $("#contrSP").html("<div id='dialogCFT' title='Ajouter un emplacement'>" + htmlResult + "</div>");

                     $("#dialogCFT").dialog({
                         height: 300,
                         width: 350,
                         modal: true
                     });

                 });
             });

            $("#selAll").change(function () {
                 $("#OTList input[type=checkbox]").attr("checked", $("#selAll").attr("checked"));
             });


			$("#btn_printP").click(function () {
                 var _IDS = "";
                 $("#OTList input:checked").each(function () {
                     _IDS += $(this).attr("index") + ";";
                 });

                 if (_IDS != "") {
                     _IDS = _IDS.substring(0, _IDS.length - 1);
                     $.post(SERVER_HTTP_HOST() + "/Emplacement/printEmplacements", { values: _IDS }, function (htmlResult) {
                         if (htmlResult == "1")
                             alert("Imprimée(s) avec succès !");
                         else
                             alert("Erreur d'impression !");
                     });
                 }
             });

            
           

         });

    </script>
    </asp:Content>
