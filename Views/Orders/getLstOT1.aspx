<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>
<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    getLstOT
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
<% 
    string showCurrent = ViewData["showaOnlyCurrentAgence"] == null ? null : ViewData["showaOnlyCurrentAgence"].ToString();
%>


    

        <div>
                <img id="btn_OTAdd" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
                <img id="btn_print_code" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/print.png" width='32' height='32'style="cursor:pointer;" /> 
                <div style="text-align:right; margin-right:20px;width: 30%;float: right;">
                    <a href="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Orders/exportLstOT/?mode=OPEN" target="_blank">
                    <img align="center" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/excel_icon.png" width="32"> Exporter Excel</a>
                </div>
        </div>

      

        

       <div id="LstOT_Data">
        <%--<h3>Liste des communications</h3>--%>
           <fieldset id="magListField">    
                <p>
                    <input type="text" id="txt_SearchOTID" placeholder="Recherche TAG-DOC"/>
                    <span style="float:right;">
                        <input type="checkbox" id="ch_getCurrentAgenceOTs" <%: string.IsNullOrEmpty(showCurrent) ? "" : "checked='checked'" %>/>
                        Afficher les dossiers du dépot actuel
                    </span>
                </p>    
                <%
                    DataTable OTData = (DataTable)ViewData["OTData"];
                    int _OTNbrCol = OTData.Columns.Count;
                    string show = (string)ViewData["show"];
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTableAJAX(OTData, "OTList", "cellspacing='4' width='100%'", 4));                        
                 %>
           </fieldset>

        </div>

 


<script type="text/javascript">
    $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>';
        var _show = '<%: show %>';
        var nbr = $("#OTList tr").length;
        // var tabPacks = null;
        if (true) {
            var tableOTList = $("#OTList").DataTable({ //
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
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                $("#OTList tbody tr[id]").each(function () {


                        var _ID = $(this).attr("id");
                        var _tdcount = $(this).find("td");
                        var href = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _ID;

                        if (!$(this).hasClass("affected")) {
                            var elem = $(this).find("td:first");
                            var val = elem.html();

                            elem.html("<a class='link' OTEditEvent='" + _ID + "' href='" + href + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                            $(this).addClass("affected");
                        }

                        var modifier = "<td align='center' width='130'><a class='link' OTEditEvent='" + _ID + "' href='" + href + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                        var fermer = "<td align='center' width='130'><a class='link' OTClotureEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Cloturer</a></td>";

                        $(this).append(modifier + fermer);
                        
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

//                    $(this).find("a[OTEditEvent]").click(function () {
//                        var _OTID = $(this).attr("OTEditEvent");
//                         $(this).attr("href", $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _OTID);
//                    });

                    $(this).find("a[OTClotureEvent]").click(function () {

                        var _OTID = $(this).attr("OTClotureEvent");
                        var _conf = confirm("Voulez vous cloturer cet OT?");
                        if (_conf) {
                            $.get($.fn.SERVER_HTTP_HOST() + "/Orders/CloturerOT", { OTID: _OTID },
                             function (htmlResult) {
                                 if (htmlResult.toString() == "1") {
                                     location.reload();
                                 }
                             }
                           );
                        }
                    });

                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                "iDisplayLength": 10,
                "columnDefs": [
                	{
                		"targets": [1],
                		"visible": false,
                		"searchable": true
                	}
                ],
                "processing": true,
                "serverSide": true,
                "ajax": {
                    "url": $.fn.SERVER_HTTP_HOST() + "/Orders/LoadLstOTData/?show=" + _show,
                    "type": "POST",
                    "dataType": "json"
                },
                "aoColumns": [
                    <% 
                        for(int counter = 4; counter < OTData.Columns.Count; counter ++ )
                        {
                            DataColumn col = OTData.Columns[counter];
                            Response.Write( (counter == 4 ? "" : ",") + @"{ ""mDataProp"": """+ col.ColumnName +@""" }" + "\n" );
                        }
                    %>
                ]

            });
            //////////////////////////////////  RECHERCHE TAG_DOC  //////////////////////////////
            $('#txt_SearchOTID').on('keyup', function () {
                var val = this.value;
                val = val.split("-");
                if (val.length > 1)
                    tableOTList.columns(1).search(val[1]).draw();
                else
                    tableOTList.columns(1).search("").draw();
                
            });
            //////////////////////////////////  RECHERCHE DOSSIER AGENCE ACTUEL  //////////////////////////////
            $('#ch_getCurrentAgenceOTs').on('change', function () {                
                
                if (this.checked)
                {
                     $.get($.fn.SERVER_HTTP_HOST() + "/Orders/SetShowCurrent/", {show : '1'},function (r) {                        
                        tableOTList.draw();
                     });
                }
                else
                {
                     $.get($.fn.SERVER_HTTP_HOST() + "/Orders/SetShowCurrent/", {show : '0'},function (r) {                        
                        tableOTList.draw();
                     });                     
                }

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
</asp:Content>





  