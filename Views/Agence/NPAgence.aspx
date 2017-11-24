<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	NPAgence
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<% 
    string agenceName = ViewData["AgenceName"] != null ?  ViewData["AgenceName"].ToString() : "";   
    
%>
    <h2>NP Agences : <b><%: agenceName %></b></h2>
    <div>
        <%
            System.Data.DataTable articleDT = (System.Data.DataTable)ViewData["data"];
            int _nbrCol = articleDT.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(articleDT, "dt_np_agence", "cellspacing='4' width='100%'"));
        %> 
    </div>
    <div id="np_dialog"></div>
    <script type="text/javascript">
    $(document).ready(function () {   
        var tabComm = $("#dt_np_agence").not('.initialized').addClass('initialized').dataTable({
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
                    $("#dt_np_agence tr[index]").not(".init").addClass("init").each(function () {
                        var _ID = $(this).attr("index");                        
                        var modifier = "<td align='center' width='130'><a class='link' Event_NP_ID='" + _ID + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                        $(this).append(modifier);
                    });
                    
                    $("a[Event_NP_ID]").unbind().click(function () {
                        var id = $(this).attr("Event_NP_ID");
                        $.get($.fn.SERVER_HTTP_HOST() + "/Agence/UpdateNPAgence/",{id: id}, function (htmlResult) {
                                $("#np_dialog_content").remove();
                                $("#np_dialog").html("<div id='np_dialog_content' title='Modifier NP Agence'>" + htmlResult + "</div>");

                                $("#np_dialog").dialog({
                                    height: 300,
                                    width: 350,
                                    modal: true
                                });
                                $("#np_dialog").dialog('option', 'title', 'Modifier NP Agence');
                        });
                    });
                 },
                 "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
                 //"bLengthChange": false,   //disable change values
                  "iDisplayLength": 25, // show only five rows
             });

        });
    </script>

</asp:Content>
