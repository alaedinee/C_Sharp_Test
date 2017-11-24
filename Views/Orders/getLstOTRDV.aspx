<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>

<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    getLstOT
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
<% 
    string title = ViewData["title"] != null ? ViewData["title"].ToString() : "";
    string mode = ViewData["mode"] != null ? ViewData["mode"].ToString() : ""; 
    string showCurrent = ViewData["showaOnlyCurrentAgence"] == null ? null : ViewData["showaOnlyCurrentAgence"].ToString();

%>


       <div>
            <div style="overflow: hidden;padding-top: 15px;">
                <h3 style="text-transform: uppercase; width: 50%;float: left;margin: 5px 0 0 10px;"><%:title %> : </h3>
                <div style="text-align:right; margin-right:20px;width: 30%;float: right;">
                    <a href="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Orders/exportLstOT/?mode=<%:mode %>" target="_blank">
                    <img align="center" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/excel_icon.png" width="32"> Exporter Excel</a>
                </div>
            </div>
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
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTData, "OTList", "cellspacing='4' width='100%'"));
                 %>
           </fieldset>

        </div>


     

 


<script type="text/javascript">
    $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>'
        var nbr = $("#OTList tr").length;

        if (nbr > 1) {
            var table = $("#OTList").not('.initialized').addClass('initialized').DataTable({
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

                            // $(this).append(modifier);

                        }
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[OTEditEvent]").click(function () {


                        var _OTID = $(this).attr("OTEditEvent");

                        location.href =  $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _OTID ;

                            
                    });


                   
                },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 10,
                "columnDefs": [
					{
					    "targets": [1],
					    "visible": false,
					    "searchable": true
					}
				]

	        });
	        //////////////////////////////////  RECHERCHE TAG_DOC  //////////////////////////////
	        $('#txt_SearchOTID').on('keyup', function () {
				console.log(table);
	            var val = this.value;
	            val = val.split("-");
	            if (val.length > 1)
	                table.columns(1).search(val[1]).draw();
	            else
	                table.draw();
	        });
	        //////////////////////////////////  RECHERCHE DOSSIER AGENCE ACTUEL  //////////////////////////////
	        $('#ch_getCurrentAgenceOTs').on('change', function () {
	            if (this.checked) {
	                $.get($.fn.SERVER_HTTP_HOST() + "/Orders/SetShowCurrent/", { show: '1' }, function (r) {
	                    location.reload();
	                });
	            }
	            else {
	                $.get($.fn.SERVER_HTTP_HOST() + "/Orders/SetShowCurrent/", { show: '0' }, function (r) {
	                    location.reload();
	                });
	            }
	        });
        }




        
    });

</script>
</asp:Content>





  