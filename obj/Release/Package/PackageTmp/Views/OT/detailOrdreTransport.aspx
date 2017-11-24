<%@ Page Title="" Language="C#" ValidateRequest="false" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.OrderTransportModelsDetail>" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	detailOrdreTransport

<style type="text/css">

</style>

</asp:Content>

		

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">


<script type="text/javascript">

  

    // in your app create uploader as soon as the DOM is ready
    // enctype="multipart/form-data"
    // don't wait for the window to load


    $().ready(function () {

        //$("#np").attr('disabled', true)


        $("#tableSelectedElementlistOT tr").mouseover(function () { $(this).addClass("trover"); });
        $("#tableSelectedElementlistOT tr").mouseout(function () { $(this).removeClass("trover"); });


        $("#charger").click(function () {

            var file = document.getElementById("File").value;

            if (file.substring(file.lastIndexOf("."), file.length) == ".pdf")
                this.form.submit();
            else
                alert("Fichier non valide");
        });




        function getListJoinOT() {

            $.post(SERVER_HTTP_HOST() + '/OT/addGetJoinOT',
               { otid: document.getElementById("otid").value, joinOtid: 0, op: 'listOT' },
               function (htmlResult) {

                   //$("#tableSelectedElement").remove();
                   $("#divJoinElementOT").html(htmlResult);


               });
        }


        function getListDoc() {

            $.post(SERVER_HTTP_HOST() + '/OT/getUploadFileOTID',
               { otid: document.getElementById("otid").value },
               function (htmlResult) {

                   //$("#tableSelectedElement").remove();
                   $("#docElement").html(htmlResult);


               });
        }

        getListJoinOT();

        getListDoc();






        $("#jointOT").click(function () {


            $.post(
                    "../../OT/selectOT",
                    { otid: document.getElementById('otid').value },

                    function (htmlResult) {
                        $("#contentOT").remove();
                        $("#container").append(htmlResult);
                        $("#contentOT").dialog({ width: 640,
                            height: 490,
                            modal: true,
                            position: 'center',
                            close: function (event, ui) {
                                getListJoinOT();
                            }
                        });
                    }
                   );
        }

         );




        $("a").click(function () {

            if ($(this).attr("otid") != null) {
                $.post(
                  "../../OT/PopUpPrestation",
                    { otid: $(this).attr('otid'),
                        op: $(this).attr("op"),
                        type: $(this).attr("type"),
                        prix: $(this).attr("prix"),
                        prestation: $(this).attr("prestation"),
                        refClient: $(this).attr("refClient")
                    },
                    function (htmlResult) {
                        $("#PopUpAddPrestation").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpAddPrestation").dialog();
                    }
                   );
            }
        });

        $("#imgtel").click(function () {
            $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: $(this).attr("mode"), otid: document.getElementById('otid').value },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();

                    }
               );
        });

        function loadTemplate() {


            var pathURL = "http://localhost/TRC_GS_COMMUNICATION/Content/template/Avis_Clients_IKEA.html";

            $.post(
                                    pathURL,
                                    { otid: document.getElementById('otid').value },
                                    function (htmlResult) {
                                        alert(htmlResult);
                                    }
                               );
        }

        function get_template_courrier(otids) {
            var pathURL = "../../OT/getTemplateCourrier";

            $.post(
                                    pathURL,
                                    { otid: otids },
                                    function (htmlResult) {
                                        CKEDITOR.instances['editeurText'].setData(htmlResult);
                                    }
                               );
        }

        function get_text_courrier(idComm) {
            var pathURL = "../../OT/getTextCourrier";

            $.post(
                                    pathURL,
                                    { comID: idComm },
                                    function (htmlResult) {
                                        CKEDITOR.instances['editeurText'].setData(htmlResult);
                                    }
                               );
        }



        $("#imgcourrier").click(function () {
            $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: $(this).attr("mode"), otid: document.getElementById('otid').value },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog({ width: 1000,
                            height: 800,
                            modal: true,
                            position: 'top',
                            close: function (event, ui) {
                                CKEDITOR.remove($("#editeurText").ckeditorGet());
                            }
                        });

                        $("#editeurText").ckeditor({ height: 600 });

                        get_template_courrier(document.getElementById("otid").value);
                        // loadTemplate();

                    }
               );
        });

        $("#imgemail").click(function () {
            $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: $(this).attr("mode"), otid: document.getElementById('otid').value },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();
                    }
               );
        });



        $('#localite').autocomplete('../../OT/villesListe', {
            delay: 0,
            max: 100,
            minLength: 1,
            minChars: 1,
            matchSubset: 4,
            matchContains: 4,
            cacheLength: 10

        });


        $("#localite").keyup(function (e) {
            if (e.keyCode == 27) {
                document.getElementById('localite').value = document.getElementById('np').value + ',' + document.getElementById('ville').value;
            }
        });


        $('#localite').result(function (event, data, formatted) {
            ///alert(data);
            // var tabValue = data.toString().split(',');
            document.getElementById('ville').value = data.toString().substring(5, (data.toString().length));
            document.getElementById('np').value = data.toString().substring(0, 4);
        });

        $('#localite').blur(function () {
            if ($('#localite').val() == '') {
                document.getElementById('localite').value = document.getElementById('np').value + ',' + document.getElementById('ville').value;
            }
        });


        $("#imgsms").click(function () {
            $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: $(this).attr("mode"), otid: document.getElementById('otid').value },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();
                    }
               );
        });

        $("#tableList tr").dblclick(function () {

            var commID = $(this).attr("recnum");
            if ($(this).attr("tp") == "COURRIER") {
                $.post(
                        "../../OT/PopUpMAJViewDetail",
                        { recnum: $(this).attr("recnum"), typecom: $(this).attr("tp") },
                        function (htmlResult) {

                            $("#PopUpMAJ").remove();
                            $("#container").append(htmlResult);
                            $("#PopUpMAJ").dialog({ width: 1000,
                                height: 800,
                                modal: true,
                                position: 'top',
                                close: function (event, ui) {
                                    CKEDITOR.remove($("#editeurText").ckeditorGet());
                                }
                            });


                            $("#editeurText").ckeditor({ height: 600 });

                            get_text_courrier(commID);
                        });

            }
            else if ($(this).attr("tp") == "SATIF") {
                $.post(
                        "../../OT/PopUpMAJViewDetail",
                        { recnum: $(this).attr("recnum"), typecom: $(this).attr("tp") },
                        function (htmlResult) {

                            $("#PopUpMAJ").remove();
                            $("#container").append(htmlResult);
                            $("#PopUpMAJ").dialog({ width: 1000,
                                height: 800,
                                modal: true,
                                position: 'top',
                                close: function (event, ui) {
                                    CKEDITOR.remove($("#editeurText").ckeditorGet());
                                }
                            });


                            $("#editeurText").ckeditor({ height: 600 });

                            get_text_courrier(commID);
                        });

            }
            else {
                $.post(
                        "../../OT/PopUpMAJViewDetail",
                        { recnum: $(this).attr("recnum"), typecom: $(this).attr("tp") },
                        function (htmlResult) {
                            $("#PopUpMAJ").remove();
                            $("#container").append(htmlResult);
                            $("#PopUpMAJ").dialog();
                        });
            }





            //             $.post(
            //                    "../../OT/PopUpMAJViewDetail",
            //                    { recnum: $(this).attr("recnum"), typecom: $(this).attr("tp") },
            //                    function (htmlResult) {
            //                       

            //                       
            //                       
            //                    }
            //               );
        });


        function get_template_Satif(otids) {
            var pathURL = "../../OT/getTemplateSatif";

            $.post(pathURL, { otid: otids }, function (htmlResult) {
                CKEDITOR.instances['editeurText'].setData(htmlResult);
            });
        }

        $("#rdv").click(function () {
            document.location.href = SERVER_HTTP_HOST() + "/../RDV/IndexRdvGet/" + document.getElementById("otid").value;
        });

        $("#satif").click(function () {
            $.post(
                                "../../OT/PopUpMAJViewMAJ",
                                { mode: $(this).attr("mode"), otid: document.getElementById('otid').value, from: 'AfficherOT' },
                                function (htmlResult) {
                                    $("#PopUpMAJ").remove();
                                    $("#container").append(htmlResult);
                                    $("#PopUpMAJ").dialog({ width: 1000,
                                        height: 800,
                                        modal: true,
                                        position: 'top',
                                        close: function (event, ui) {
                                            CKEDITOR.remove($("#editeurText").ckeditorGet());
                                        }
                                    });

                                    $("#editeurText").ckeditor({ height: 600 });

                                    get_template_Satif(document.getElementById("otid").value);
                                    // loadTemplate();

                                }
                           );
        });
    });
            
    </script>

<div id="container"> 

<% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>
        
        <h2><%: Model.client %></h2>
 
        <div>
            <a href="#" id='rdv' class="lienHyper" >Rechercher rendez-vous</a>
        </div>

        <div id = "divInformations">


        <fieldset id = "fieldCenter">
        <legend>Informations</legend>
        <table>
        <tr><td>
            <%: Html.HiddenFor(m =>m.otid) %>
            <%: Html.HiddenFor(m => m.poid)%>
            <%: Html.HiddenFor(m => m.valeurMarchandiseMonter)%>
            <%: Html.HiddenFor(m => m.periodeNecesaire)%>
            <%: Html.HiddenFor(m => m.noteInterne)%>
            <%: Html.HiddenFor(m => m.NoBl)%>
			
			<input type="hidden" id="OTNoBL" value="<%: Model.NoBl %>" />
			
            <div class="editor-label">
               Adresse
            </div></td><td>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.adresse) %>
                <%: Html.ValidationMessageFor(model => model.adresse) %>
            </div></td></tr>
             <tr><td>
            <div class="editor-label">
             Localité
            </div></td><td>
            <div class="editor-field">
            <% Response.Write("<input type='text' id='localite'  name='localite' value='" + Model.np + "," + Model.ville + "'>"); %>
            </div></td></tr>
        <tr><td>
            <div class="editor-label">
             <%--Ville--%>
            </div></td><td>
            <div class="editor-field">
                 <%: Html.TextBoxFor(model => model.ville)%>
                
                 <%: Html.ValidationMessageFor(model => model.ville) %>
            </div></td></tr>

            <tr><td>
            <div class="editor-label">
             <%--NP--%>
            </div></td><td>
            <div class="editor-field">
                 <%: Html.TextBoxFor(model => model.np)%>
                 <%: Html.ValidationMessageFor(model => model.np) %>
            </div></td></tr>

        <tr><td>
            <div class="editor-label">
         Tél 1
            </div></td><td>
            <div class="editor-field">
                 <%: Html.TextBoxFor(model => model.telephone) %>
                 <%: Html.ValidationMessageFor(model => model.telephone) %>
            </div></td></tr>

      

        <tr><td>
            <div class="editor-label">
         Tél 2
            </div></td><td>
            <div class="editor-field">
                 <%: Html.TextBoxFor(model => model.telephone2) %>
               
            </div></td></tr>

      

        
        <tr>
        <tr><td>
            <div class="editor-label">
              EMail
            </div></td><td>
            <div class="editor-field">
                 <%: Html.TextBoxFor(model => model.email) %>
             
            </div></td></tr>

           <tr><td>
            <div class="editor-label">
              D.Saisie
            </div></td><td>
            <div class="editor-field">
                <%: Model.dateSaisie %>
             
            </div></td></tr>
            <tr><td>
            <div class="editor-label">
              D.Reception
            </div></td><td>
            <div class="editor-field">
                 <%: Model.dateReception %>
             
            </div></td></tr>
            <tr><td>
            <div class="editor-label">
              D.Livraison
            </div></td><td>
            <div class="editor-field">
                 <%: Model.dateLivraison %>
             
            </div></td></tr>

           <tr><td></td><td><input type="submit" value="Modiffier" /></td></tr>
            </table>

        </fieldset>
        <% } %>
        
        <%
            TRC_GS_COMMUNICATION.Models.MajOT majOT = new TRC_GS_COMMUNICATION.Models.MajOT();
            string facturer = majOT.OtFacturer(Model.otid);
             %>
        <fieldset id="docJoint">
        <legend>A joindre</legend>
        
        <fieldset>
        <legend>Ordre</legend>
        <div id="divJoinElementOT">
        </div>
        </fieldset>
        <% if (facturer == "")
           { %>
        <input type="button" id="jointOT" value="Joindre" />
        
        <%} %>
        <fieldset>
        <legend>Documents</legend>
        <div id="docElement">
      
        </div>
        <div id="controlElemt">

     
        <% using (Html.BeginForm("UploadFile", "OT", FormMethod.Post, new  { enctype = "multipart/form-data",id="frmUpload" }))
           {%>

        
           
           <%:  Html.HiddenFor(model => model.otid)%>
           <%:  Html.TextBoxFor(model => model.File, new { type = "file" })%>
          
          <% if(facturer == ""){ %>
       <input type="button"  id="charger" value="Charger" />
            <%} %>

           <%} %>
        </div>
        
        </fieldset>
        

        </fieldset>
        </div>

        <div id="divOT"></div>

        <div id="divOTRight">
        <div id="listPrestation">
        <fieldset id="fielSetPrestation">
        <legend>Informations Ordre </legend>
           <div id="divTableauPrestation"> 
          
           <table id="tableInfoPrestation">
            <tr><th>Préstation</th><th>Ref.Client</th><th></th><th></th><th></th></tr>
            <% for (int j = 0 ; j < Model.listPrestation.Rows.Count ; j++)
               { %>
                <tr>
                
                <td><%: Model.listPrestation.Rows[j]["Produit"].ToString() %></td>
                <td><%: Model.listPrestation.Rows[j]["RefCmdClient"].ToString()%></td>
                
                <td> <% Response.Write("<a class=\"lienHyper\"  refClient=\"" + Model.listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"   prestation=\"" + Model.listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + Model.listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + Model.listPrestation.Rows[j]["type"].ToString() + "\" op=\"update\" otid=\"" + Model.otid + "\" id=\"updatePrestation\">Modifier</a>"); %></td>
                <% 
                    TRC_GS_COMMUNICATION.Models.MajOT mO = new TRC_GS_COMMUNICATION.Models.MajOT();
                    if ( mO.getConsomationEtat( Model.listPrestation.Rows[j]["Etat"].ToString()) == "0")
                   { %> 
                <td> <% Response.Write("<a class=\"lienHyper\" refClient=\"" + Model.listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"    prestation=\"" + Model.listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + Model.listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + Model.listPrestation.Rows[j]["type"].ToString() + "\" op=\"annuler\" otid=\"" + Model.otid + "\" id=\"annulerPrestation\">Annuler</a>"); %></td>
                 <%}
                   else
                   { %>

                   
                   <%
                       if (mO.getConsomationEtat(Model.listPrestation.Rows[j]["Etat"].ToString()) == "2")
                       {
                           Response.Write("<td><a class=\"lienHyper\" refClient=\"" + Model.listPrestation.Rows[j]["RefCmdClient"].ToString() + "\" prestation=\"" + Model.listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + Model.listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + Model.listPrestation.Rows[j]["type"].ToString() + "\" op=\"activer\" otid=\"" + Model.otid + "\" id=\"annulerPrestation\">Activer</a></td>");
                       }
                       else if (mO.getConsomationEtat(Model.listPrestation.Rows[j]["Etat"].ToString()) == "1")
                       {
                           Response.Write("<td>Acquitté</td>");
                       }
                                
                       else
                       {
                           Response.Write("<td></td>");
                       }
                           
                       
                   %>
                 
                 
                 <%} %>
                
                <% if (Model.listPrestation.Rows[j]["type"].ToString() != "base")
                   { %> 
                <td> <% Response.Write("<a class=\"lienHyper\"  refClient=\"" + Model.listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"    prestation=\"" + Model.listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + Model.listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + Model.listPrestation.Rows[j]["type"].ToString() + "\"  op=\"supprimer\" otid=\"" + Model.otid + "\" id=\"deletePrestation\">Supprimer</a>"); %></td>
                 <%}
                   else
                   { %>
                   <td></td>
                 <%} %>
                </tr>   
            <%} %>
            
            </table> <% Response.Write("<a class=\"lienHyper\"   type=\"none\" op=\"add\" prestation=\"\" prix=\"0\" otid=\"" + Model.otid + "\" id=\"addPrestation\">Nouvelle Préstation</a>"); %></div>
            <div id="divTableauInfoOT">
            <%using (Html.BeginForm("updateInfoFacturation","OT"))
              { %>
              <%: Html.HiddenFor(m =>m.otid) %>
            <table>
            <tr>
            <td>Poids</td><td><%: Html.TextBoxFor(m => m.poid)%></td>
            </tr>
            <tr>
            <td>V.M.M</td><td><%: Html.TextBoxFor(m => m.valeurMarchandiseMonter)%></td></tr>
            <tr>
            <td>Période</td>
            <td><% if (Model.rightUpdatePeriode == "0")
               { %>
           <%:  Html.TextBoxFor(m => m.periodeNecesaire)%>
     

            <%}
               else
               { %>
               <%: Html.Encode( Model.periodeNecesaire) %>
               <%}%> </td>
            </tr>
            <td>Code stock</td><td><%:  Html.TextBoxFor(m => m.codestock)%></td>
            <tr><td valign="top">Note interne</td><td><%: Html.TextAreaFor(m => m.noteInterne, new { rows = 5, cols = 30 })%></td></tr>
            <tr><td></td><td><input type ="submit" value="Modifier" /></td></tr>
            </table>
            <%} %>
            </div>
        </fieldset>
        </div>
        <div id="divDetail">
        <fieldset id= "fieldCommunication">
            <legend>Communications</legend>
            <div id="menuCommunication">
            
                <img  mode='SATIF' id="satif" class="imgMenu" src="../../Images/satif.jpg" height="32" />
                <img  mode='TEL' id="imgtel" class="imgMenu" src="../../Images/phone-blue-icon_32.png" />
                <img  mode='EMAIL' id="imgemail" class="imgMenu" src="../../Images/Email-icon_32.png" />
                <img  mode='SMS' id="imgsms" class="imgMenu" src="../../Images/SMS_32.png" />    
                <img  mode='COURRIER' id="imgcourrier" class="imgMenu" src="../../Images/Letter_32.png" />    
                      
          
            </div>

             <table  id ="tableList">
              
                    <th>Date</th>
                      <th>Titre</th>
                    <th>Message</th>

                    <th>Type</th>

            <% 
           
                string imgType = "";
           for (int i = 0; i < Model.listCommunication.Rows.Count; i++)
               {
                   string link = "";
                   if (Model.listCommunication.Rows[i]["Type"].ToString() == "SMS")
                   {
                       imgType = "<img  class='imgMenu' src='../../Images/SMS_32.png' />";
                   }
                   else if (Model.listCommunication.Rows[i]["Type"].ToString() == "TEL")
                   {
                       imgType = " <img class='imgMenu' src='../../Images/phone-blue-icon_32.png'/>";
                   }
                   else if(Model.listCommunication.Rows[i]["Type"].ToString() == "EMAIL")
                   {
                       imgType = "<img  class='imgMenu' src='../../Images/Email-icon_32.png' />";
                   }
                   else if (Model.listCommunication.Rows[i]["Type"].ToString() == "SATIF")
                   {
                       link = "<a actionLink='" + Model.listCommunication.Rows[i]["OTID"].ToString() + "' href='http://www.duperrex.ch/satisfaction/getSatisfaction.php?otid=" + Model.listCommunication.Rows[i]["OTID"].ToString() + "' target='_blank'>Résultat</a>";
                       imgType = "<img  class='imgMenu' src='../../Images/satif1.png'  width='32' />";
                   }
                   else
                   {
                       imgType = "<img  class='imgMenu' src='../../Images/Settings.png' />";
                      
                   }
               %>
               <% Response.Write("<tr tp='" + Model.listCommunication.Rows[i]["Type"] + "' recnum='" + Model.listCommunication.Rows[i]["ComID"].ToString() + "'>");    %>           
                    <td><%: Html.Encode(Model.listCommunication.Rows[i]["Date"].ToString())%></td>
                    <td><%: Html.Encode(Model.listCommunication.Rows[i]["Ressource"].ToString())%></td>
                    <td><% Response.Write(Model.listCommunication.Rows[i]["Message"].ToString() + " &nbsp; " + link); %></td>
                    <td>
                    <% Response.Write(imgType); 
                        %></td>
                    
                </tr>
        

            <% } %>
         
            </table>
        </fieldset>
        </div>
        </div>
    
 <div id="resDialog"></div>

        <script>
            $(document).ready(function () {
                $("a[actionLink]").click(function () {
                    var link = 'http://www.duperrex.ch/satisfaction/getSatisfaction.php?otid=' + $(this).attr("actionLink");

                    $.get(SERVER_HTTP_HOST() + "/OT/getURLString", { adr: link }, function (data) {

                        if (data.indexOf("Bad Request") >= 0) {
                            alert("Pas de résultat !");
                            return false;
                        }
                    });



                });


            });
        
        </script>
        <a href="" id="redirector" style="visibility:hidden">Click</a>
          <script type="text/javascript">
              var windowSizeArray = ["width=200,height=200",
                                    "width=300,height=400,scrollbars=yes"];

              $(document).ready(function () {
                  $('#redirector').click(function (event) {

                      var url = $(this).attr("href");
                      var windowName = "popUp"; //$(this).attr("name");
                      var windowSize = windowSizeArray[$(this).attr("rel")];

                      window.open(url, windowName, windowSize);

                      event.preventDefault();
                  });
              });
        </script>
 
</div>
</asp:Content>

