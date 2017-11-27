<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.AjoutColis>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	AfficherOT
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<style type="text/css">
    
 #menuOT
 {
       float:left;
       margin-left:-20px;
       margin-top:-55px;
       padding-bottom:30px;
 }
 
 ul#menuOT  {
 margin:0;
 padding:0;

 }
 ul#menuOT li {
 float:left;
 list-style: none;
 padding:0;
 text-decoration:none;
 background-color:#58ACFA;
 }
 ul#menuOT li a {
 display:block;
 width:140px;
 color:white;
 height:22px;
 text-decoration:none;
 padding:7px;
 font-family:Verdana;
 font-style:oblique;
 font-size:small;
 }
 ul#menuOT li a:hover {
 background-color:#81BEF7;
 }
</style>
<script type="text/javascript">
    function submitForm() {
        document.getElementById('frmOT').submit();
    }
    $().ready(function () {
        $("#nbrCarac").text(80 - $("#OTNoteInterne").val().length);


        $("#OTNoteInterne").keyup(function () {
            var rest = $("#OTNoteInterne").val().length;
            if (80 - rest > -1) {

                $("#nbrCarac").text(80 - rest);
            }
            else {
                $("#OTNoteInterne").val($("#OTNoteInterne").val().substring(0, 80));
            }
        });


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

            $.post(SERVER_HTTP_HOST() + '/OT/selectOT',
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
                  "../../Ajout/PopUpPrestation",
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

        $("#rdv").click(function () {
            document.location.href = SERVER_HTTP_HOST() + "/../RDV/IndexRdvGet/" + document.getElementById("otid").value;
        });

        $("#prdv").click(function () {
            document.location.href = SERVER_HTTP_HOST() + "/../RDV/IndexRdvGet/" + document.getElementById("otid").value;
        });

        $("#print").click(function () {
            $.post(SERVER_HTTP_HOST() + "/Ajout/PopUpdate",
                { otid: document.getElementById("otid").value },
                function (htmlResult) {

                    $("#divOT").remove();
                    $("#container").append(htmlResult);
                    $("#divOT").dialog({ width: 300,
                        height: 230,
                        modal: true,
                        position: 'center'
                    });
            });
        });



        $('#OTLieuChargement').autocomplete('../../OT/villesListe', {
            delay: 0,
            max: 100,
            minLength: 1,
            minChars: 1,
            matchSubset: 4,
            matchContains: 4,
            cacheLength: 10
        });

        $('#OTLieuLivraison').autocomplete('../../OT/villesListe', {
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
                document.getElementById('OTLieuLivraison').value = document.getElementById('OTDestNP').value + ',' + document.getElementById('OTDestVille').value;
            }
        });

        $('#OTLieuLivraison').result(function (event, data, formatted) {
            ///alert(data);
            // var tabValue = data.toString().split(',');
            document.getElementById('OTDestVille').value = data.toString().substring(5, (data.toString().length));
            document.getElementById('OTDestNP').value = data.toString().substring(0, 4);
        });

        $('#OTLieuLivraison').blur(function () {
            if ($('#OTLieuLivraison').val() == '') {
                document.getElementById('OTLieuLivraison').value = document.getElementById('OTDestNP').value + ',' + document.getElementById('OTDestVille').value;
            }
        });


        $("#imgtel").click(function () {
            $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: $(this).attr("mode"), otid: document.getElementById('otid').value, from: 'AfficherOT' },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();

                    }
               );
        });


        $("#imgsms").click(function () {
            $.post(
            "../../OT/PopUpMAJViewMAJ",
            { mode: $(this).attr("mode"), otid: document.getElementById('otid').value, from: 'AfficherOT' },
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
        });

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

        function get_template_Satif(otids) {
            var pathURL = "../../OT/getTemplateSatif";

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

                        get_template_courrier(document.getElementById("otid").value);
                        // loadTemplate();

                    }
               );
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

        $("#imgemail").click(function () {
            $.post(
                    "../../OT/PopUpMAJViewMAJ",
                    { mode: $(this).attr("mode"), otid: document.getElementById('otid').value, from: 'AfficherOT' },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();
                    }
               );
        });

    });
            
    </script>
     <div id="container">


       <h2 class="erreur"> <%
           if (ViewData["msgAdd"] != null)
           {
               Response.Write(ViewData["msgAdd"]); 
           }
                 %></h2>
    <h3 class="erreur"><% if (ViewData["messageError"] != null) Response.Write(ViewData["messageError"]); %></h3>
   
     <% using (Html.BeginForm("AfficherOT", "Ajout", FormMethod.Post, new {id="frmOT" }))
        {%>
     <%: Html.ValidationSummary(true)%>
      
   
    
                <%: Html.HiddenFor(model => model.otid)%>  
                <%: Html.HiddenFor(model => model.OTNoBL)%>  
                <%: Html.HiddenFor(model => model.OTDestNP)%>
                <%: Html.HiddenFor(model => model.OTDestVille)%>
   

        
        <fieldset>
        <legend><h2>N°Bulletin : <%:Html.DisplayTextFor(model => model.OTNoBL)%></h2></legend>

        <table border="0" style="text-align:left;width:100%;" >

             <tr>
                <td  align="right" style="padding-right:35px"><b><%: Html.Label("Date saisie : ") %></b> <%: this.Model.OTDateSaisie %></td> 
            </tr>

        </table>
        <ul id="menuOT">
        <li> <%: Html.ActionLink("Ajouter un ordre", "Index")%></li>
        <li><a class="lienHyper"  onclick="submitForm();">Enregistrer</a></li>
        <li> <%Response.Write("<a href='#' class=\"lienHyper\" id='print' >Imprimer un bon</a>");%></li>
        <li style="margin-left:50px"> <a href="#" id='rdv' class="lienHyper" >Rechercher rendez-vous</a></li>
        <li style="margin-left:5px"> <a href="#" id='prdv' class="lienHyper" >Prendre rendez-vous</a></li>
        </ul>
        <table border="0" style="text-align:left;width:100%;" >

            <tr>
                <th><%: Html.Label("Code stock")%>  </th>
                <th><%: Html.Label("Lieu chargement")%> </th>
                <th><%: Html.Label("Nbr Périodes")%></th> 
                <th><%: Html.Label("Date livraison")%> </th>
                <th><%: Html.Label("Lieu livraison")%></th> 
            </tr>
            <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.CodeStock)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTLieuChargement)%></td>
                <td valign="top"> <%: Html.TextBoxFor(model => model.OTPeriodesNecessaires)%> </td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDateLivraison)%> </td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTLieuLivraison)%><%--<% Response.Write("<input type='text' id='localite' name='localite' value='" + Model.OTDestNP + "," + Model.OTDestVille + "' >"); %>--%> </td>
            </tr>
            <tr>
                
                 <th><%: Html.Label("Poids")%></th> 
                <th><%: Html.Label("Cubage")%></th>
                <th> <%: Html.Label("Somme")%></th>
                 <th><%: Html.Label("Valeur Marchandise à monter")%></th>
                <th><%: Html.LabelFor(model => model.Remarques)%></th>
            </tr>
             <tr>
                
                <td valign="top"><%: Html.TextBoxFor(model => model.OTPoids)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTVolume)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTMontTotal)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.VMM)%></td>
                <td valign="top"><%: Html.TextAreaFor(model => model.Remarques, new { rows = 1 })%></td>
            </tr>
            <tr>
                <th><%: Html.Label("Nom")%></th>
                <th><%: Html.Label("Prenom")%></th>
                <th><%: Html.Label("Heure livraison")%></th>
                <th><%: Html.Label("Note interne")%></th>
                <th><%: Html.Label("Date de montage")%></th>
            </tr>
            <tr>
                
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDestinNom)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDestPrenom)%></td>
                <td valign="top">

                H <%:  Html.DropDownListFor(m => m.heureLivraison, (IEnumerable<SelectListItem>)ViewData["listHeure"])%> M <%:  Html.DropDownListFor(m => m.minLivraison, (IEnumerable<SelectListItem>)ViewData["listMin"])%>

                <%--<%: Html.TextBoxFor(model => model.OTHeureLivraison)%>--%>
                
                </td>
                <td valign="top"><%: Html.TextAreaFor(model => model.OTNoteInterne, new { rows = 1 })%><span id="nbrCarac"></span></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDateMontage)%></td>
            </tr>
            <tr>
                
                <th><%: Html.Label("Date Arrivée Depot")%></th>
                <th><%: Html.Label("Mont montage")%></th>
                <th><%: Html.Label("Adresse")%></th>
                <th><%: Html.Label("Adresse suite")%></th>
                <th><%: Html.Label("Téléphone 1")%></th>
            </tr>
            <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.DateReception)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTMontMontage)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTAdresse1)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTAdresse2)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTTel1)%></td>
            </tr>
             
            <tr>
                <th><%: Html.Label("Téléphone 2")%></th>
                <th> <%: Html.Label("Email")%></th>
                <th> <%: Html.Label("Status")%></th>
                <th><%: Html.Label("Client avisé")%></th>
                <th> <%: Html.Label("Expediteur")%></th>
            </tr>
            <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTTel2)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDestEmail)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTEtat)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTSuiteEtat)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTExpediteur)%></td>
            </tr>   
            
            </table>
            
        </fieldset>
    <% } %>
   
     <%
            TRC_GS_COMMUNICATION.Models.MajOT majOT = new TRC_GS_COMMUNICATION.Models.MajOT();
            string facturer = majOT.OtFacturer(Model.otid);
             %>

        <fieldset style="width:37%;float:left">
        <legend>Liste des préstation</legend>
      
           <% 
               TRC_GS_COMMUNICATION.Models.MajOT majT = new TRC_GS_COMMUNICATION.Models.MajOT();
               System.Data.DataTable listPrestation = majT.getListPrestation(Model.otid); %>
          
           <table id="tableInfoPrestation">
            <tr><th>Préstation</th><th>Ref.CLient</th><th></th><th></th><th></th></tr>
            <% for (int j = 0 ; j <listPrestation.Rows.Count ; j++)
               { %>
                <tr>
                <td><%: listPrestation.Rows[j]["Produit"].ToString() %></td>
                <td><%: listPrestation.Rows[j]["RefCmdClient"].ToString()%></td>
                <td> <% Response.Write("<a class=\"lienHyper\"  refClient=\"" + listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"    prestation=\"" + listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + listPrestation.Rows[j]["type"].ToString() + "\" op=\"update\" otid=\"" + Model.otid + "\" id=\"updatePrestation\">Modifier</a>"); %></td>
                <% 
                    TRC_GS_COMMUNICATION.Models.MajOT mO = new TRC_GS_COMMUNICATION.Models.MajOT();
                    if ( mO.getConsomationEtat( listPrestation.Rows[j]["Etat"].ToString()) == "0")
                   { %> 
                <td> <% Response.Write("<a class=\"lienHyper\"  refClient=\"" + listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"    prestation=\"" + listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + listPrestation.Rows[j]["type"].ToString() + "\" op=\"annuler\" otid=\"" + Model.otid + "\" id=\"annulerPrestation\">Annuler</a>"); %></td>
                 <%}
                   else
                   { %>

                   
                   <%
                       if (mO.getConsomationEtat(listPrestation.Rows[j]["Etat"].ToString()) == "2")
                       {
                           Response.Write("<td><a class=\"lienHyper\"   refClient=\"" + listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"     prestation=\"" + listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + listPrestation.Rows[j]["type"].ToString() + "\" op=\"activer\" otid=\"" + Model.otid + "\" id=\"annulerPrestation\">Activer</a></td>");
                       }
                       else if (mO.getConsomationEtat(listPrestation.Rows[j]["Etat"].ToString()) == "1")
                       {
                           Response.Write("<td>Acquitté</td>");
                       }
                                
                       else
                       {
                           Response.Write("<td></td>");
                       }
                           
                       
                   %>
                 
                 
                 <%} %>
                
                <% if (listPrestation.Rows[j]["type"].ToString() != "base")
                   { %> 
                <td> <% Response.Write("<a class=\"lienHyper\"    refClient=\"" + listPrestation.Rows[j]["RefCmdClient"].ToString() + "\"   prestation=\"" + listPrestation.Rows[j]["Produit"].ToString() + "\" prix=\"" + listPrestation.Rows[j]["prix"].ToString() + "\" type=\"" + listPrestation.Rows[j]["type"].ToString() + "\"  op=\"supprimer\" otid=\"" + Model.otid + "\" id=\"deletePrestation\">Supprimer</a>"); %></td>
                 <%}
                   else
                   { %>
                   <td></td>
                 <%} %>
                </tr>   
            <%} %>
            
            </table> <% Response.Write("<a class=\"lienHyper\"   type=\"none\" op=\"add\" prestation=\"\" prix=\"0\" otid=\"" + Model.otid + "\" id=\"addPrestation\">Nouvelle Préstation</a>"); %></div>
        </fieldset>
        


<fieldset id= "fieldCommunication"  style="width:57%;float:right">
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
                TRC_GS_COMMUNICATION.Models.MajOT mo = new TRC_GS_COMMUNICATION.Models.MajOT();
                System.Data.DataTable listCommunication = mo.getCommunicationByOTID(Model.otid);
                
                string imgType = "";
           for (int i = 0; i <listCommunication.Rows.Count; i++)
               {
                   string link = "";
                   if (listCommunication.Rows[i]["Type"].ToString() == "SMS")
                   {
                       imgType = "<img  class='imgMenu' src='../../Images/SMS_32.png' />";
                   }
                   else if (listCommunication.Rows[i]["Type"].ToString() == "TEL")
                   {
                       imgType = " <img class='imgMenu' src='../../Images/phone-blue-icon_32.png'/>";
                   }
                   else if(listCommunication.Rows[i]["Type"].ToString() == "EMAIL")
                   {
                       imgType = "<img  class='imgMenu' src='../../Images/Email-icon_32.png' />";
                   }
                   else if (listCommunication.Rows[i]["Type"].ToString() == "SATIF")
                   {
                       link = "<a actionLink='" + listCommunication.Rows[i]["OTID"].ToString() + "' href='http://www.duperrex.ch/satisfaction/getSatisfaction.php?otid=" + listCommunication.Rows[i]["OTID"].ToString() + "' target='_blank'>Résultat</a>";
                       imgType = "<img  class='imgMenu' src='../../Images/satif1.png'  width='32' />";
                   }
                   else
                   {
                       imgType = "<img  class='imgMenu' src='../../Images/Settings.png' />";
                      
                   }
               %>
               <% Response.Write("<tr tp='" + listCommunication.Rows[i]["Type"] + "' recnum='" + listCommunication.Rows[i]["ComID"].ToString() + "'>");    %>           
                    <td><%: Html.Encode(listCommunication.Rows[i]["Date"].ToString())%></td>
                    <td><%: Html.Encode(listCommunication.Rows[i]["Ressource"].ToString())%></td>
                    <td><% Response.Write(listCommunication.Rows[i]["Message"].ToString() +  " &nbsp; " + link); %></td>
                    <td>
                    <% Response.Write(imgType); 
                        %></td>
                    
                </tr>
        

            <% } %>
         
            </table>
        </fieldset>




        <fieldset id="docJoint" style="width:37%;float:left">
        <legend>A joindre</legend>
        
        <fieldset style="width:95%;float:left;">
        <legend>Ordre</legend>
        <div id="divJoinElementOT">
        </div>
       
        <% if (facturer == "")
           { %>
        <input type="button" id="jointOT" value="Joindre" />
        
        <%} %>
        </fieldset>
        <fieldset style="width:95%;float:left">
        <legend>Documents</legend>
        <div id="docElement">
      
        </div>
        <div id="controlElemt">

     
           <% using (Html.BeginForm("UploadFile", "Ajout", FormMethod.Post, new  { enctype = "multipart/form-data",id="frmUpload" }))
           {%>

        
           
           <%:  Html.HiddenFor(model => model.otid)%>
           <%:  Html.TextBoxFor(model => model.File, new { type = "file" })%>
          
          <% if(facturer == ""){ %>
       <br /><input type="button"  id="charger" value="Charger" />
            <%} %>

           <%} %>
        </div>
        
        </fieldset>
        </fieldset>

        <div id="resDialog"></div>

        <script>
            $(document).ready(function () {
			
			
			
			$('#OTDateLivraison').datepicker({ dateFormat: 'dd/mm/yy' });
			$('#DateReception').datepicker({ dateFormat: 'dd/mm/yy' });
			$('#OTHeureLivraison').datepicker({ dateFormat: 'dd/mm/yy' });
			$('#OTDateMontage').datepicker({ dateFormat: 'dd/mm/yy' });
			
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

</asp:Content>

