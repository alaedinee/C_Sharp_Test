<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="System.Data" %>

<%
    
    var _magasinID = ViewData["ID"];
    var _magasin = ViewData["Magasin"];
    var _magasinCode = ViewData["MagasinCode"];
    var _magasinMere = ViewData["MagasinMere"].ToString();

    var _clientID = ViewData["ClientID"];
    var _donneurID = ViewData["DonneurID"];
    var _chargementID = ViewData["ChargementId"];
    var _livraisonID = ViewData["LivraisonID"];

    DataTable _magList = (DataTable)ViewData["ListMagasin"];

    var _mode = ViewData["Mode"].ToString();
    
     %>

     
     
     </style>

     


        

          <div id="tabs">
              <ul>
                <li><a href="#tabs-1">Magasin</a></li>
                <li><a href="#tabs-2">Donneur</a></li>
                <li><a href="#tabs-3">Livraison</a></li>
              <%--  <li><a href="#tabs-4">Chargement</a></li>--%>
              </ul>


              <div id="tabs-1">
                

               <fieldset style='width:50%'>
                <legend><%: (_magasin == null || _magasin == "" )? "Nouvelle magasin" : _magasin  %> </legend>
           
                <table border="0" cellspacing='2' cellpadding='2'>
                    
                        <tr>
                            <td>Magasin</td>
                
                            <td>
                                   <input type="text" id="magName" class="toUPPER"  value="<%: (_magasin == "")? "" : _magasin  %>" style="width: 200px;"/>
                           </td>
                        </tr>

                        <tr>
                            <td>Code magasin</td>
                
                            <td>
                                   <input type="text" id="magCode" class="toUPPER" value="<%: (_magasinCode == null)? "" : _magasinCode  %>" style="width: 200px;" />
                           </td>
                        </tr>
           
                        <tr>
                            <td>Magasin Principale</td>
                            <td>
                               <select id="magMere" style="width:250px;">
                               <option value="0">---</option>
                                <%
                                    if (_magList != null)
                                        {
                                            DataTable prestList = (DataTable)_magList;
                                            if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(_magList))
                                            {
                                                for (int i = 0; i < _magList.Rows.Count; i++)
                                                {
                                                    DataRow row = _magList.Rows[i];

                                                    if (row["ID"].ToString() == _magasinMere)
                                                    {
                                                        Response.Write("<option value='" + row["ID"].ToString() + "' selected='selected'>" + row["Magasin"].ToString() + "</option>");
                                                    }
                                                    else
                                                    {
                                                        Response.Write("<option value='" + row["ID"].ToString() + "'>" + row["Magasin"].ToString() + "</option>");
                                                    }
                                                }
                                            }
                                        }
                                    %>
                                   </select>
                            </td>
                        </tr>

                </table>
                </fieldset>
              
                 
              </div>

               <div id="tabs-2">
                <div id="donneurMagAccordion">
        
                </div>
              </div>

              <div id="tabs-3">
                <div id="livraisonMagAccordion">
             
                </div>
              </div>

              <%--<div id="tabs-4">
                 <div id="chargementMagAccordion">
              
                 </div>
              </div>--%>

              

             
          </div>

       <%-- <div id="magAccordion">

              <h3 id="cliChargAcc">Chargement</h3>
              <div id="chargementMagAccordion">
              
              </div>

              <h3 id="cliLivAcc">Livraison</h3>
              <div id="livriasonMagAccordion">
             
              </div>

              <h3 id="cliDonnAcc">Donneur d'ordre</h3>
              <div id="donneurMagAccordion">
        
              </div>
              
        </div>--%>

        <% if (_mode == "modifier") { %>
            
        
            <input type="button" id="magUpdate" value="Modifier" />
       

        <%}
          else if (_mode == "ajouter") { %>

     
            <input type="button" id="magAdd" class="customBtn" value="Valider" />
       

        <% } %>


<div id="cliDG">

</div>


  
<script type="text/javascript">
    $(document).ready(function () {

        /////////////////////////////Declaraion////////////////////////
        var _magID = '<%: _magasinID %>';

        var _donneurID = '<%: _donneurID %>';
        var _clientID = '<%: _clientID %>';
        var _chargementID = '<%: _chargementID %>';
        var _livraisonID = '<%: _livraisonID %>';

        var _mode = '<%: _mode %>';

        ///////////////////////////////////////////////////////////////

        /////////////////////////////Accordion/////////////////////////
//        $(function () {
//            $("#magAccordion").accordion({
//                //collapsible: true,
//            heightStyle: "content"
//            });
        //        });

        $(function () {
            $("#tabs").tabs();
        });

        $(".toUPPER").keyup(function () {
            this.value = this.value.toUpperCase();
        });
        ///////////////////////////////////////////////////////////////

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////Partie Magasin///////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////

        //////////////////////////View Livraison, Chargement, Donneur//////////////////

        $.fn.magGetChargement = function () {
            $.post($.fn.SERVER_HTTP_HOST() + "/Client/getInfosChargement", { chargID: _chargementID, mode: _mode }, function (htmlResultChargement) {

                $("#tabs-4").html(htmlResultChargement);
                

            });
        };

        $.fn.magGetLivraison = function () {
            $.post($.fn.SERVER_HTTP_HOST() + "/Client/getInfosLivraison", { livrID: _livraisonID, mode: _mode }, function (htmlResultLivraison) {

                $("#tabs-3").html(htmlResultLivraison );
                

            });
        };

        $.fn.magGetDonneur = function () {
            $.post($.fn.SERVER_HTTP_HOST() + "/Client/getInfosDonneur", { donnID: _donneurID, mode: _mode }, function (htmlResultDonneur) {

                $("#tabs-2").html(htmlResultDonneur);
                
            });
        };

        $.fn.magGetDonneur();
        $.fn.magGetLivraison();
//        $.fn.magGetChargement();

        /////////////////////////////////////

        ////////////////////////UPDATE / ADD//////////////////////////

        /////UPDATE/////

        $("#magUpdate").click(function () {

            var _mode = "Modifier";

            var _magNameUpdate = $("#magName").val();
            var _magCodeUpdate = $("#magCode").val();
            var _magMereUpdate = $("#magMere option:selected").val();

            var _magCharIDUpdate = $("#CliChargID").val();
            var _magLivIDUpdate = $("#CliLivID").val();
            var _magDonneurIDUpdate = $("#CliDonneurID").val();

            $.post($.fn.SERVER_HTTP_HOST() + "/Magasin/MAJMagasin", { mode:_mode, magID: _magID , magName: _magNameUpdate, magCode: _magCodeUpdate ,
                magMere: _magMereUpdate, magChargID: _magCharIDUpdate, magLivID: _magLivIDUpdate, magDonnID: _magDonneurIDUpdate},
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");
                    if (data != "0" && data != ""){

                        alert("Opération réussite");

                        $.post($.fn.SERVER_HTTP_HOST() + "/Magasin/getMagsinForm", { mode: "detail", magID: _magID },
                           function (data) {
                               $("#main").html(data);
                           });
                  
                    }
                    else{

                        alert("échec de modification");

                    }
                    });
                });
 

        /////UPDATE/////

        $("#magAdd").click(function () {

            var _mode = "Ajouter";

            var _magNameUpdate = $("#magName").val();
            var _magCodeUpdate = $("#magCode").val();
            var _magMereUpdate = $("#magMere option:selected").val();

            var _magCharIDUpdate = $("#CliChargTxtCltID").val();
            var _magLivIDUpdate = $("#CliLivTxtCltID").val();
            var _magDonneurIDUpdate = $("#CliDonneurTxtCltID").val();

            $.post($.fn.SERVER_HTTP_HOST() + "/Magasin/MAJMagasin", {
                mode: _mode, magID: _magID, magName: _magNameUpdate, magCode: _magCodeUpdate,
                magMere: _magMereUpdate, magChargID: _magCharIDUpdate, magLivID: _magLivIDUpdate, magDonnID: _magDonneurIDUpdate
            },
                function (data) {
                    //$("#dv_loading_detail").css("display", "none");
                    if (data != "0") {

                        alert("Opération réussite");
                        $.post($.fn.SERVER_HTTP_HOST() + "/Magasin/getMagsinForm", { mode: "detail", magID: data },
                           function (data) {
                               $("#main").html(data);
                           });

                    }
                    else {

                        alert("échec de modification");

                    }


                });


        });



        ////////////////////////////////////


        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////FIN PARTIE////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////

    });
</script>