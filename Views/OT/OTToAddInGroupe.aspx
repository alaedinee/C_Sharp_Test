<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="System.Data" %>
<div id="LstOT_Data">
        <%--<h3>Liste des communications</h3>--%>
           <fieldset id="magListField">    
                <p>
                    <input type="text" id="txt_SearchOTID" placeholder="Recherche TAG-DOC"/>
                </p>    
                <%
                    DataTable OTData = (DataTable)ViewData["OTData"];
                    int _OTNbrCol = OTData.Columns.Count;
                    string show = (string)ViewData["show"];
                    string OTID = (string)ViewData["OTID"];
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTableAJAX(OTData, "OTListTOAddInGroupe", "cellspacing='4' width='100%'", 4));                        
                 %>
           </fieldset>

        </div>

 


<script type="text/javascript">
    $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>'
        var _show = '<%: show %>'
        var _OTID = '<%: OTID %>'
        var nbr = $("#OTList tr").length;

        
            var tableOTListTOAddInGroupe = $("#OTListTOAddInGroupe").DataTable({ //
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

                $("#OTListTOAddInGroupe tbody tr[id]").each(function () {


                        var _ID = $(this).attr("id");
                        var _tdcount = $(this).find("td");

                        if (!$(this).hasClass("affected")) {
                            var elem = $(this).find("td:first");
                            var val = elem.html();

                            elem.html("<a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");

                            $(this).addClass("affected");
                        }

                        var ajouter = "<td align='center' width='130'><a class='link' OTAddToGroupe='" + _ID + "' style='color:#E50051;cursor:pointer'>Ajouter</a></td>";

                        $(this).append(ajouter);
                        
                    });

                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[OTAddToGroupe]").unbind().click(function () {
                        var id = $(this).attr("OTAddToGroupe");
                        $.get($.fn.SERVER_HTTP_HOST() + "/OT/AddOTTOGroupe/", { OTGroupe: _OTID, OTID: id }, function(r){
                            if(r == '1')
                            {
//                                $.get($.fn.SERVER_HTTP_HOST() + "/OT/OTToAddInGroupe", { OTID: OTIDG }, function (rRefresh) {
//                                    $("#div-modal-content").html(rRefresh);
//                                });
                                tableOTListTOAddInGroupe.row( $(this).parents('tr') ).remove().draw();
                                // dossier groupe list
                                $.get($.fn.SERVER_HTTP_HOST() + "/OT/ListOTByGroup/", { OTIDGroup: OTIDG }, function (result) {
                                    $('#div-tab-ot-group').html(result);
                                });
                                // dossier groupe info
                                $.get($.fn.SERVER_HTTP_HOST() + "/OT/InfoGroupe/", { OTIDGroup: OTIDG }, function (result) {
                                    $('#div-tab-ot-info').html(result);
                                });
                            }
                            else
                                alert('Erreur');
                        });
                        
                    });
                    $(this).find("a[OTEditEvent]").unbind().click(function () {
                        var id = $(this).attr("OTEditEvent");
                        var win = window.open($.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + id, '_blank');
                        if (win) {
                            //Browser has allowed it to be opened
                            win.focus();
                        } else {
                            //Browser has blocked it
                            alert('Please allow popups for this website');
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
                    "url": $.fn.SERVER_HTTP_HOST() + "/OT/LoadLstOTData_OTToAddInGroupe/?OTID=" + _OTID,
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
                    tableOTListTOAddInGroupe.columns(1).search(val[1]).draw();
                else
                    tableOTListTOAddInGroupe.columns(1).search("").draw();
                
            });
        

    });

</script>