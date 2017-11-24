<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>"%>
<%@ import namespace="System.Data" %>


<% 
    var _facturer = ViewData["Factuer"].ToString();
    var _OTID = ViewData["OTID"];

    var _ListType = ViewData["ListType"];

    var _ListID = ViewData["listID"].ToString();
    string _isOpen = ViewData["isOpen"].ToString();
    string _isPalannifToPast = ViewData["isPalannifToPast"].ToString();
    DataTable groupeDT = (DataTable)ViewData["groupeList"];
    int RowCount = groupeDT != null ? groupeDT.Rows.Count : 0;
   
    %>
  
        

            <div id="tabsDocument" style="width:100%; min-height: 300px">
              <ul>
                <li><a href="#tabs-doc-1">Document joint</a></li>
                <li><a href="#tabs-doc-2">Dossier Joint (<%: RowCount %>)</a></li>
              </ul>


              <div id="tabs-doc-1">

              
                <div id="docElement">
      
                </div>
                <div id="controlElemt">
              <%if (_isOpen.ToString() != "0" && _isPalannifToPast.ToString() != "0"){ %>

                     <table>
                        <tr>
                            <td>
                                <select id="typeSelected" style="width:140px;">
                                         <%
                                             if (_ListType != null)
                                                {
                                                    DataTable _ListTypeDT = (DataTable)_ListType;
                                                    if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_ListTypeDT))
                                                    {
                                                        for (int i = 0; i < _ListTypeDT.Rows.Count; i++)
                                                        {
                                                            DataRow row = _ListTypeDT.Rows[i];

                                                            Response.Write("<option filter='" + row["filter"].ToString()  + "' value='" + row["name"].ToString() + "'>" + row["name"].ToString() + "</option>");

                                                        }
                                                        Response.Write("<option value='new'>Ajouter</option>");
                                                        Response.Write("<option value='delete'>Supprimer</option>");
                                                    }             
                                                }
                                            %>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <input id="ajDoc" type="file" size="75" name="ajDoc">
                            </td>
                        </tr>

                           <% if (_facturer == "oui")
                                { 
                                  %>
                        <tr>
                            <td>
                                <input type="button"  id="ajCharger" value=" Charger " />
                            </td>
                        </tr>
                            <%
                                } 
                           %>
                    </table>
                <% } %>
                 
                </div>
                <br />
                <br />

              </div>
              <div id="tabs-doc-2">
                <%
                    Response.Write(TRC_GS_COMMUNICATION.Models.Tools.GenerateTable(groupeDT, "groupeList", "cellspacing='4' width='100%'"));
                %>
              </div>

           </div>
           
  <div id="DGaddType">

</div>      





<script type="text/javascript">
    $().ready(function () {

        var _OTID = '<%: _OTID %>';
        var _ListID = '<%: _ListID %>';
        var _isOpen = '<%: _isOpen %>';
        var _isPalannifToPast = '<%: _isPalannifToPast %>';

        $(function () {
            $("#tabsDocument").tabs();
        });


        var tabPrest = $("#groupeList").not('.initialized').addClass('initialized').dataTable({
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
                 $("#groupeList tr[index]").each(function () {

                     if (!$(this).hasClass("affected")) {
                            var elem = $(this).find("td:first");
                            var val = elem.html();
                            var _ID = $(this).attr("index");
                            var url = $.fn.SERVER_HTTP_HOST() + '/OT/afficherOT?mode=modifier&OTID=' + _ID;

                            elem.html("<a class='link' href='" + url + "' style='color:#E50051;cursor:pointer'>" + val + "</a>");
                            $(this).addClass("affected");
                        }
                 });

             },
             "aLengthMenu": [[5, 10, 25, 50, 100], [5, 10, 25, 50, 100]],
             
             "iDisplayLength": 5, 

         });


        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////Partie A Joindre///////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////



        ////////////////////////////Charger DOC/////////////////////////

        $("#ajCharger").click(function () {
            var _type = $("#typeSelected").find(":selected").val();

            var filename = $('input[type=file]').val().replace(/C:\\fakepath\\/i, '')
            //alert(filename);

            var formdata = new FormData();
            var fileInput = document.getElementById('ajDoc');

            if (fileInput.files.length = !0) {
                for (i = 0; i < fileInput.files.length; i++) {

                    formdata.append(fileInput.files[i].name, fileInput.files[i]);
                }

                var xhr = new XMLHttpRequest();
                //alert($.fn.SERVER_HTTP_HOST() + '/Ajoindre/ajChargerFichie');
                xhr.open('POST', $.fn.SERVER_HTTP_HOST() + '/Ajoindre/ajChargerFichier?OTID=' + _OTID + '&type=' + _type, true);
                xhr.send(formdata);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        alert(xhr.responseText);
                        $.post($.fn.SERVER_HTTP_HOST() + "/Ajoindre/ajForm", { OTID: _OTID, facturer: "oui" },

                                        function (htmlResult) {

                                            $("#divAjoindre").html(htmlResult);

                                        });
                                  
                    }
                }
            }

//            $.post($.fn.SERVER_HTTP_HOST() + "/Orders/Afficher", { mode: "modifier", OTID: _OTID },

//                                        function (htmlResult) {

//                                            $("#main").html(htmlResult);

            //                                        });
           


        });


        ////////////////////////////Joidre OT/////////////////////////

            $.get($.fn.SERVER_HTTP_HOST() + "/Ajoindre/listDoc", { OTID: _OTID, Ressource: "OT", isOpen: _isOpen, isPalannifToPast: _isPalannifToPast },

                    function (htmlResult) {

                        $("#docElement").html(htmlResult);

                    }
               );


        ////////////////////////////Ajouter type/////////////////////////

        //$("typeSelected").trigger('change');

        $("#typeSelected").on('change', function () {
            var optionSelected = $("#typeSelected option:selected").val();
            if (optionSelected == "new") {

             $.get($.fn.SERVER_HTTP_HOST() + "/Ajoindre/addTypeForm", { ListID: _ListID, OTID: _OTID },

                            function (htmlResult) {

                                $("#DGADDTYPE").remove();
                                $("#DGaddType").html("<div id='DGADDTYPE' title='Ajouter type'>" + htmlResult + "</div>");

                                $("#DGADDTYPE").dialog({
                                    height: 150,
                                    width: 350,
                                    modal: true
                                });

                            });

                        }

              if (optionSelected == "delete") {

               $.get($.fn.SERVER_HTTP_HOST() + "/Ajoindre/deleteTypeForm", { OTID: _OTID },

                function (htmlResult) {

                    $("#DGADDTYPE").remove();
                    $("#DGaddType").html("<div id='DGADDTYPE' title='Supprimer type'>" + htmlResult + "</div>");

                    $("#DGADDTYPE").dialog({
                          height: 300,
                          width: 550,
                          modal: true
                      });

                   });

            }

        });

        //        $.get($.fn.SERVER_HTTP_HOST() + "/Ajoindre/addTypeForm", { ListID: _ListID, OTID: _OTID },

        //                    function (htmlResult) {

        //                        $("#DGADDTYPE").remove();
        //                        $("#DGaddType").html("<div id='DGADDTYPE' title='Ajouter type'>" + htmlResult + "</div>");

        //                        $("#DGADDTYPE").dialog({
        //                            height: 300,
        //                            width: 350,
        //                            modal: true
        //                        });

        //                    }
        //               );



        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////FIN PARTIE////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////





    });
</script>
