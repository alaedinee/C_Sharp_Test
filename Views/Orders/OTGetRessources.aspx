<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>
        <%
            string taille = "";
            string element = "";
            string _RessourceFamille = (string)ViewData["_RessourceFamille"];
            string[] _lbl = ViewData["lbl"].ToString().Split('|');
            //string[] _tLbl = ViewData["lbl"].ToString().Split('|');
            //if (_lbl.Length == 3)
            //{
            //    taille = "3";
            //    element = _lbl[2];
            //}
            //else
            //    taille = "2";
            string _txt = ViewData["txt"].ToString();
            
            
            DataTable clientDT = (DataTable)ViewData["_RessourceContents"];

         %>


<div style="width:100%;">
    

   

    <fieldset>
    <legend>Liste des donneurs</legend>
        <%
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(clientDT, "clientLstRessources", "cellspacing='4' width='100%'"));
         %>
     </fieldset>
</div>
 <script type="text/javascript">
     $(document).ready(function () {

         var _RessourceFamille = '<%: _RessourceFamille %>';

         //var tailleLbl = '<%: taille %>';


         //var _element = '<%: element %>';

         var _lbl = '<%: _lbl[0] %>';

         var _txt = '<%: _txt %>';


         $.fn.donneurGetColumnIndex = function (name) {
             var idx = 0;
             var cpt = 0;
             $("#clientLstRessources tr th").each(function () {
                 if ($(this).html() == name) idx = cpt;
                 cpt++;
             });
             return idx;
         };

         //alert(tailleLbl);

         var _clbl = $.fn.donneurGetColumnIndex('<%: _lbl[1] %>');
         //alert(_lbl[1]);
         //var _clbll;
         //if (tailleLbl == "3")
         //    var _clbll = $.fn.donneurGetColumnIndex(_element);
         //else
         //    var _clbll = "";




         if ($("#clientLstRessources tr[index]").length > 0) {
             var tabRess = $("#clientLstRessources").not('.initialized').addClass('initialized').dataTable({
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
                     $("#clientLstRessources tr[index]").not('.initialized').addClass('initialized').click(function () {
                         var _index = $(this).attr("index");
                         //var _clbll = $(this).find("td:eq(Nom)").html();
                         //alert($(this).find("td:eq(" + _clbl + ")").html() );
                         $("#" + _lbl).html($(this).find("td:eq(" + _clbl + ")").html());

                         $("#" + _txt).val($(this).attr("index")).trigger('change'); //find("td:eq(" + _ctxt + ")").html());

                         $("#magChoixx").remove();

                     });
                 },
                 "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                 //"iDisplayLength": 5, 
             });
         }
     });
</script>