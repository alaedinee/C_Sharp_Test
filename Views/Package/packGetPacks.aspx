<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>

<%  
    var _recepPackAdd = ( Session["loginReception"]!=null)? Session["loginReception"].ToString() : "";

    var _isOpen = ViewData["isOpen"];
    var _isPalannifToPast = ViewData["isPalannifToPast"];

    string AgenceID = Session["agenceID"].ToString();
%>

<div>
<% 
    if (_isOpen.ToString() != "0"){ %>
    <% if (_isPalannifToPast.ToString() != "0")
       { %>
    <div style="float:left">
         <img id="pack_btn_addP" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/addd.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
     
         <span style="color:Red"><b>Récéption en cours : <%: (_recepPackAdd.ToString() != "") ? _recepPackAdd.ToString() : "Indéfinie"%></b></span>   
    </div>
	<% } %>
	    
    <div style="float:right">
        <img id="btn_printP" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/print.png" width='32' height='32'style="cursor:pointer;" /> 
        <img id="pack_btn_aff" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/affect_icone.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />
        <img id="pack_btn_delete" src="<%: Globale_Varriables.VAR.get_URL_HREF()  %>/Images/delete-icon.png" width='32' height='32' style="cursor:pointer;margin-right:7px" />

         <%--<span>Déplacer/Supprimer</span>
            <select id="choixMoveDelete" style="width:140px;">
                <option value="zero">----</option>
                <option value="delete">Supprimer</option>
                <option value="move">Déplacer</option>
            </select>--%>
    </div>
<% } %>
</div>

<br /><br />

<div>
  
          
        <% 
            
            var _OTId = ViewData["OTID"];
            DataTable _DTPacks = (DataTable)ViewData["DTPacks"];
            int _nbrColPacks = _DTPacks.Columns.Count;
            Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(_DTPacks, "packListPacks", "cellspacing='4' width='100%'"));
       %>
   
</div>
	    
<br clear="all" />




<div id="DGpack">

</div>



<script type="text/javascript">
    $(document).ready(function () {

        var _nbrColPacks = '<%: _nbrColPacks %>';
        var _recepPackAdd = '<%: _recepPackAdd %>';
        var AgenceID = '<%: AgenceID %>';
        var nbr = $("#packListPacks tr").length;

        var _OTId = '<%: _OTId %>'

        var tabPacks = null;

        if (nbr > 1) {
            tabPacks = $("#packListPacks").not('.initialized').addClass('initialized').dataTable({
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
                    $("#packListPacks tr[index]").each(function () {


                        var _ID = $(this).attr("index");

                        var _tdcount = $(this).find("td");
                        //alert(_nbrCol);

                       if (!$(this).hasClass("affected")) {
                             var elem = $(this).find("td:eq(10)");
                             var _packPartagee = elem.html();
                             var fourni = $(this).find("td:eq(6)");
                             var _complet = $(this).find("td:eq(5)");
                             var _article = $(this).find("td:eq(11)");

                              //alert(fourni.html());
                            // alert(elem.html());
                            

                             if (_packPartagee == "1"){
                                 elem.html("<img src='" + $.fn.SERVER_HTTP_HOST() + "/Images/partagee.png' width='16' border='0' />");
                                 fourni.html("Multiples");
                                 //march.html("Multiples");
                              }

                              if (_complet.html() == "Oui"){
                                 _complet.html("<img src='" + $.fn.SERVER_HTTP_HOST() + "/Images/Complet.png' width='16' border='0' />");
                              }
                              else{
                                 _complet.html("<img src='" + $.fn.SERVER_HTTP_HOST() + "/Images/nComplet.png' width='16' border='0' />");
                              }
                              
                              

                             $(this).addClass("affected");
                             //elem.attr('tr th=xxx');
                         }


                        if (_tdcount.length == _nbrColPacks - 1) {

                            //etat = $(this).closest("tr").find("td:eq(2)").text();
                            //base = $(this).closest("tr").find("td:eq(3)").text();

                            var modifier    = "<td align='center' width='130'><a class='link' packEditPacksEvent='" + _ID       + "' style='color:#E50051;cursor:pointer'>Modifier</a></td>";
                            var Supprimer   = "<td align='center' width='130'><a class='link' packDeletePacksEvent='" + _ID     + "' style='color:#E50051;cursor:pointer'>Supprimer</a></td>";
                            var Deplacer    = "<td align='center' width='130'><a class='link' packSendPacksEvent='" + _ID       + "' style='color:#E50051;cursor:pointer'>Déplacer</a></td> ";
                            var packHistory = "<td align='center' width='130'><a class='link' packHistoryPacksEvent='" + _ID       + "' style='color:#E50051;cursor:pointer'>Historique</a></td> ";
                            var Cheack      = "<td align='center' width='130'><input type='checkbox' index='" + _ID + "'> </td>";
                            var packArticles      = "<td align='center' width='130'><a class='link' packArticlesEvent='" + _ID       + "' style='color:#E50051;cursor:pointer'>Articles("+_article.html()+")</a></td> ";

                            <% if(_isOpen.ToString() != "0" && _isPalannifToPast.ToString() != "0"){ %>
                            $(this).append(modifier + Deplacer + packHistory + Cheack);
                            <% }else{%>
                            $(this).append(packHistory);
                            <%} %>

                            _article.html(packArticles);
                        }
                    });

                    $(this).find("a[packDeletePacksEvent]").click(function () {


                        var _ID = $(this).attr("packDeletePacksEvent");

                          var _conf = confirm("Voulez vous supprimer ce package?");
                            if (_conf) {

                                $.get($.fn.SERVER_HTTP_HOST() + "/Package/deletePackage", { id: _ID },

                                     function (htmlResult) {

                                        if (htmlResult.toString() == "1"){

                                            alert("Supprimée avec succées");
                                              $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _OTId },

                                                function (htmlResult) {

                                                    $("#divPackageModifier").html(htmlResult);

                                                }); 
                                                }

                                        else 

                                            alert("Echéc de suppression");

                                     }
                           );
                           
                           }
                    });

                  $(this).find("a[packEditPacksEvent]").click(function () {


                        var _ID = $(this).attr("packEditPacksEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Package/addPackage", { id: _ID, otid: _OTId },

                             function (htmlResult) {

                                $("#DGpacK").remove();
                                 $("#DGpack").html("<div id='DGpacK' title='Modifier un package. Récéption : "+ _recepPackAdd +"'>" + htmlResult + "</div>");

                                 $("#DGpacK").dialog({
                                     height: 300,
                                     width: 350,
                                     modal: true, draggable: true
                                 });

                                 $("#DGpacK").dialog("option", "position", [200, 200]);

                             });
                        });

                         $(this).find("a[packSendPacksEvent]").click(function () {
	                            var _ID = $(this).attr("packSendPacksEvent");
	                            $.get($.fn.SERVER_HTTP_HOST() + "/Package/verifyPackServRelation", { id: _ID}, function (r) {
		                            if(r == '0')
		                            {
			                            $.get($.fn.SERVER_HTTP_HOST() + "/Package/sendPackage", { idPackage: _ID, otid: _OTId },
				                             function (htmlResult) {
					                             $("#DGpacK").remove();
					                             $("#DGpack").html("<div id='DGpacK' title='Envoyer un package. récéption : "+ _recepPackAdd +"'>" + htmlResult + "</div>");

					                             $("#DGpacK").dialog({
						                             height: 400,
						                             width: 600,
						                             modal: true
					                             });

					                             $("#DGpacK").dialog("option", "position", [400, 200]);
				                             });
		                            }
                                    else
                                        alert('Ce package est lié avec des prestations !!');
	                            });                        
                            });
                        //////////////////////////////// Afficher Historique \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                         $(this).find("a[packHistoryPacksEvent]").click(function () {

                        var _ID = $(this).attr("packHistoryPacksEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Package/getHistoryPackage", { idPackage: _ID},

                             function (htmlResult) {

                                 $("#DGpacK").remove();
                                 $("#DGpack").html("<div id='DGpacK' title='Historique Package: '>" +htmlResult+ "</div>");

                                 $("#DGpacK").dialog({
                                     height: 400,
                                     width: 800,
                                     modal: true
                                 });

                                 $("#DGpacK").dialog("option", "position", [400, 200]);

                             });
                        });
                        //////////////////////////////// Afficher Articles package \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                         $(this).find("a[packArticlesEvent]").unbind('click').click(function () {

                        var _ID = $(this).attr("packArticlesEvent");

                        $.get($.fn.SERVER_HTTP_HOST() + "/Package/packArticles", { idPackage: _ID},

                             function (htmlResult) {

                                 $("#DGpacK").remove();
                                 $("#DGpack").html("<div id='DGpacK' title='Articles Package: '>" +htmlResult+ "</div>");

                                 $("#DGpacK").dialog({
                                     height: 400,
                                     width: 800,
                                     modal: true
                                 });

                                 $("#DGpacK").dialog("option", "position", [400, 200]);

                             });
                        });
                    },
                "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],

                "iDisplayLength": 5,
                });

        }
        ///////////////////BTN ADD///////////////////////
        $("#pack_btn_addP").click(function () {
                 var _otid = _OTId;
                 
//                 if (_recepPackAdd == ""){
//                    alert("Veillez créer/choisir une récéption")
//                    return false;
//                 }

                 $.post($.fn.SERVER_HTTP_HOST() + "/Package/addPackage", { id: "0", otid: _otid }, function (htmlResult) {
                     $("#DGpacK").remove();
                     $("#DGpack").html("<div id='DGpacK' title='Ajouter un package. Récéption : "+ _recepPackAdd +"'>" + htmlResult + "</div>");

                     $("#DGpacK").dialog({
                         height: 320,
                         width: 410,
                         modal: true
                     });

                     $("#DGpacK").dialog("option", "position", [400, 200]);

                 });
         });

         //////////////////BTN AFFECTE/////////////////////
         $("#pack_btn_aff").click(function () {
                 var _otid = _OTId;

//                 if (_recepPackAdd == ""){
//                    alert("Veillez créer/choisir une récéption")
//                    return false;
//                 }

                 $.post($.fn.SERVER_HTTP_HOST() + "/Package/LstPackageInconnu", { otid: _otid }, function (htmlResult) {
                     $("#DGpacK").remove();
                     $("#DGpack").html("<div id='DGpacK' title='Affecter un package' >" + htmlResult + "</div>");

                     $("#DGpacK").dialog({
                         height: 400,
                         width: 500,
                         modal: true
                     });

                     $//("#DGpacK").dialog("option", "position", [400, 200]);

                 });
         });


         ////////////////////BTN DELETE////////////

         //$("#choixMoveDelete").on('change', function () {
           // var optionSelected = $("#choixMoveDelete option:selected").val();
           $("#pack_btn_delete").click(function () {
            var _IDS = "";

            var _conf = confirm("Voulez vous supprimer ce package?");
              if (_conf) {

                //if (optionSelected == "delete") {
                    $($("#packListPacks").dataTable().fnGetNodes()).each(function () {

                         if ($(this).find("input:checked").attr("index") != null)
                          _IDS += $(this).attr("index") + ";";

                     })

                   if (_IDS != "") {
                     _IDS = _IDS.substring(0, _IDS.length - 1);
                         $.post($.fn.SERVER_HTTP_HOST() + "/Package/deleteMultiplesPack", { IDS: _IDS }, function (htmlResult) {
                             if (htmlResult.toString() == "1"){
                                 alert("Supprimé(s) avec succès !");
                                 $.post($.fn.SERVER_HTTP_HOST() + "/Package/packGetLst", { OTID: _OTId },

                                                function (htmlResult) {

                                                    $("#divPackageModifier").html(htmlResult);

                                                }); 
                                 }
                             else
                                 alert("Erreur de suppression!");
                         });
                     }
                     else
                         alert("séléctionner un package");
                //alert(_IDS);
                }      
            });

            ////////////////// PACK IMPRIMER /////////////////////

            $("#btn_printP").click(function () {
                 var _IDS = "";
                 $("#packListPacks input:checked").each(function () {
                     _IDS += $(this).attr("index") + ";";
                 });

                 if (_IDS != "") {
                     _IDS = _IDS.substring(0, _IDS.length - 1);
                     $.post(SERVER_HTTP_HOST() + "/Package/printPackage", { values: _IDS, AgenceID: AgenceID }, function (htmlResult) {
                         if (htmlResult == "1")
                             alert("Imprimée(s) avec succès !");
                         else
                             alert("Erreur d'impression !");
                     });
                 }
             });


    });

</script>

<style>
    a[packEditPacksEvent], a[packDeletePacksEvent],a[packSendPacksEvent], a[packPicPacksEvent]
    {
        cursor:pointer;
    }
    </style>