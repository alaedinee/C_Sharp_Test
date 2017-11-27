<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>
<%@ import namespace="System.Data" %>

<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    getLstOT
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">

       <div><h2>LISTE OT</h2>
       <div id="OTListField">
           <fieldset >    
                <p>
                    <input type="text" id="txt_SearchOTID" placeholder="Recherche TAG-DOC"/>
                </p>      
                <%
                    string idPlans = ViewData["idPlans"].ToString();
                    string idPeriode = ViewData["idPeriode"].ToString();
                    
                    DataTable OTData = (DataTable)ViewData["OTData"];
                    int _OTNbrCol = OTData.Columns.Count;
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(OTData, "OTList", "cellspacing='4' width='100%'"));
                 %>
           </fieldset>
<div id="contrDgArt">

</div>
<script type="text/javascript">
    $(document).ready(function () {

        var _OTNbrCol = '<%: _OTNbrCol %>';
        var _idPlans = '<%: idPlans %>';
        var _idPeriode = '<%: idPeriode %>';
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

                        if (!$(this).hasClass("affected")) {
                            var elem = $(this).find("td:first");
                            var val = elem.html();
                            elem.html("<a class='link' OTEditEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");
                            $(this).addClass("affected");
                            /////////////////////////////////////////////////
                            <% if(idPlans != "-1"){ %>
                            var PR = $(this).find('td:last').text();
                            var affecter = "<td align='center' width='130'><a class='link' pr='" + PR + "' OTAffectEvent='" + _ID + "' style='color:#E50051;cursor:pointer'>Affecter</a></td>";
                            $(this).append(affecter);
                            <% } %>
                        }


                    });


                    /////////////////////////////////////////MODIFIER//////////////////////////////////////////

                    $(this).find("a[OTEditEvent]").unbind('click').click(function () {
                        var _OTID = $(this).attr("OTEditEvent");
                        location.href = $.fn.SERVER_HTTP_HOST() + "/OT/afficherOT?mode=modifier&OTID=" + _OTID;
                    });
                    /*
                    $(this).find("a[OTAffectEvent]").unbind('click').click(function () {
                        var _OTID = $(this).attr("OTAffectEvent");
                        var _pr = $(this).attr("pr");
                        var per_nec = prompt("Nombre de periodes : ", _pr);
                        if (per_nec != null && !isNaN(per_nec)) {
                            $.get(
                                $.fn.SERVER_HTTP_HOST() + "/RDV/InsertToPeriode/?" + $.param({ OTID: _OTID, pr: per_nec, PeriodeID: _idPeriode, PlanID: _idPlans, AvecRemplacementOT: "", causeRetard: "" }),
                                function (result) {
                                    if (result == '1')
                                        location.href = $.fn.SERVER_HTTP_HOST() + "/RDV/detailPlan/" + _idPlans;
                                    else
                                        alert('Erreur !!');
                                }
                            );
                        }
                    });
                    */
                    $(this).find("a[OTAffectEvent]").unbind('click').click(function () {
                        var _OTID = $(this).attr("OTAffectEvent");
                        
                        $.get(
                            $.fn.SERVER_HTTP_HOST() + "/RDV/BeforInsertToPeriode/?" + $.param({ OTID: _OTID, PeriodeID: _idPeriode, PlanID: _idPlans }),
                            function (result) {
                                 $("#contrDgArticle").remove();
                                $("#contrDgArt").html("<div id='contrDgArticle' title='Affecter OT'>" + result + "</div>");
                                $("#contrDgArticle").dialog({
                                    width: 500,
                                    height: 450,
                                    modal: true
                                });
                            }
                        );
                        
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
        }





    });

</script>
</div>
</div>
</asp:Content>





  