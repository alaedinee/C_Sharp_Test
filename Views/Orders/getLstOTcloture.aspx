<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>
<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    getLstOT
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
<% 
    string showCurrent = ViewData["showaOnlyCurrentAgence"] == null ? null : ViewData["showaOnlyCurrentAgence"].ToString();
%>


        <div style="overflow: hidden;">
                <div style="text-align:right; margin-right:20px;width: 30%;float: right;">
                    <a href="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Orders/exportLstOT/?mode=CLTR" target="_blank">
                    <img align="center" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/excel_icon.png" width="32"> Exporter Excel</a>
                </div>
        </div>
   

       <div>

           <fieldset id="magListField">  
                <p>
                    <input type="text" id="txt_SearchOTID" placeholder="Recherche TAG-DOC"/>
                    <span style="float:right;">
                        <input type="checkbox" id="ch_getCurrentAgenceOTs" <%: string.IsNullOrEmpty(showCurrent) ? "" : "checked='checked'" %>/>
                        Afficher les dossiers du dépot actuel
                    </span>
                </p>        
                <%
                    DataTable OTDataCloturee = (DataTable)ViewData["OTData"];
                    int _OTNbrCol = OTDataCloturee.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTableAJAX(OTDataCloturee, "OTListCloturee", "cellspacing='4' width='100%'", 4));  
                 %>
           </fieldset>

        </div>


     

 


<script type="text/javascript">
    $(document).ready(function () {


    var table = $("#OTListCloturee").DataTable({ //
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

                $("#OTListCloturee tbody tr[id]").each(function () {


                        var _ID = $(this).attr("id");
                        var _tdcount = $(this).find("td");
                        var href = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _ID;

                        if (!$(this).hasClass("affected")) {
                            var elem = $(this).find("td:first");
                            var val = elem.html();

                            elem.html("<a class='link' OTEditEvent='" + _ID + "' href='" + href + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                            $(this).addClass("affected");
                        }
                                                
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

//                    $(this).find("a[OTEditEvent]").click(function () {
//                        var _OTID = $(this).attr("OTEditEvent");
//                        $(this).attr("href", $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _OTID);
//                    });


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
                    "url": $.fn.SERVER_HTTP_HOST() + "/Orders/LoadLstOTDataCloture",
                    "type": "POST",
                    "dataType": "json"
                },
                "aoColumns": [
                    <% 
                        for(int counter = 4; counter < OTDataCloturee.Columns.Count; counter ++ )
                        {
                            DataColumn col = OTDataCloturee.Columns[counter];
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
                    table.columns(1).search(val[1]).draw();
                else
                    table.columns(1).search("").draw();
                
            });
            //////////////////////////////////  RECHERCHE DOSSIER AGENCE ACTUEL  //////////////////////////////
            $('#ch_getCurrentAgenceOTs').on('change', function () {                
                
                if (this.checked)
                {
                     $.get($.fn.SERVER_HTTP_HOST() + "/Orders/SetShowCurrent/", {show : '1'},function (r) {                        
                        table.draw();
                     });
                }
                else
                {
                     $.get($.fn.SERVER_HTTP_HOST() + "/Orders/SetShowCurrent/", {show : '0'},function (r) {                        
                        table.draw();
                     });                     
                }
            });
            



        


    });

</script>
</asp:Content>





  