<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.AjoutColis>" %>



<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">

    $().ready(function () {
	
	$('#OTDateLivraison').datepicker({ dateFormat: 'dd/mm/yy' });
	$('#OTHeureLivraison').datepicker({ dateFormat: 'dd/mm/yy' });
	$('#OTDateMontage').datepicker({ dateFormat: 'dd/mm/yy' });
	$('#DateReception').datepicker({ dateFormat: 'dd/mm/yy' });
	
	
        $('#OTLieuChargement').autocomplete(SERVER_HTTP_HOST() + '/OT/villesListe', {
            delay: 0,
            max: 100,
            minLength: 1,
            minChars: 1,
            matchSubset: 4,
            matchContains: 4,
            cacheLength: 10
        });
        $("#nbrCarac").text(120 - $("#OTNoteInterne").val().length);

        $("#OTNoteInterne").keyup(function () {
            var rest = $("#OTNoteInterne").val().length;
            if (120 - rest > -1) {

                $("#nbrCarac").text(120 - rest);
            }
            else {
                $("#OTNoteInterne").val($("#OTNoteInterne").val().substring(0, 120));
            }
        });


        $('#OTLieuLivraison').autocomplete(SERVER_HTTP_HOST() + '/OT/villesListe', {
            delay: 0,
            max: 100,
            minLength: 1,
            minChars: 1,
            matchSubset: 4,
            matchContains: 4,
            cacheLength: 10
        });

        $("#OTLieuLivraison").keyup(function (e) {
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
    });
            
    </script>
  
   
    <h3 class="erreur"><% if (ViewData["messageError"] != null) Response.Write(ViewData["messageError"]); %></h3>
    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <fieldset>
            <legend><h2>Veuillez saisir les informations des colis </h2></legend>

           <h3 class="erreur"> <%
           if (ViewData["msgAdd"] != null)
           {
               Response.Write(ViewData["msgAdd"]); 
           }
                 %></h3>

                 
                <%: Html.HiddenFor(model => model.OTDestNP)%>
                <%: Html.HiddenFor(model => model.OTDestVille)%>
              <table border="0" style="text-align:left;width:100%;" >

            <tr>
                <th><%: Html.Label("No Bulletin") %></th>
                <th><%: Html.Label("Code stock")%>  </th>
                <th><%: Html.Label("Lieu chargement")%> </th>
                <th><%: Html.Label("Nbr périodes")%></th> 
                <th><%: Html.Label("Date livraison")%> </th>
              
            </tr>
            <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTNoBL) %>  </td>
                <td valign="top"><%: Html.TextBoxFor(model => model.CodeStock)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTLieuChargement)%></td>
                <td valign="top"> <%: Html.TextBoxFor(model => model.OTPeriodesNecessaires)%> </td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDateLivraison)%> </td>
                
            </tr>
            <tr>
                  <th><%: Html.Label("Lieu livraison")%></th> 
                 <th><%: Html.Label("Poids")%></th> 
                <th><%: Html.Label("Cubage")%></th>
                <th> <%: Html.Label("Somme")%></th>
                 <th><%: Html.Label("Valeur Marchandise à monter")%></th>
                
            </tr>
             <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTLieuLivraison)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTPoids)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTVolume)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTMontTotal)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.VMM)%></td>
                
            </tr>
            <tr>
               <th><%: Html.LabelFor(model => model.Remarques)%></th>
                <th><%: Html.Label("Nom")%></th>
                <th><%: Html.Label("Prenom")%></th>
                <th><%: Html.Label("Heure livraison")%></th>
                <th><%: Html.Label("Note interne")%></th>
                
            </tr>
            <tr>
                <td valign="top"><%: Html.TextAreaFor(model => model.Remarques, new { rows = 1 })%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDestinNom)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDestPrenom)%></td>
                <td valign="top">
                
                H <%:  Html.DropDownListFor(m => m.heureLivraison, (IEnumerable<SelectListItem>)ViewData["listHeure"])%> M <%:  Html.DropDownListFor(m => m.minLivraison, (IEnumerable<SelectListItem>)ViewData["listMin"])%>
               <%-- <%: Html.TextBoxFor(model => model.OTHeureLivraison)%>--%>
                
                </td>
                <td valign="top"><%: Html.TextAreaFor(model => model.OTNoteInterne, new { rows = 1 })%><span id="nbrCarac"></span></td>
                
            </tr>
            <tr>
                <th><%: Html.Label("Date de montage")%></th>
                <th><%: Html.Label("Date Arrivée Depot")%></th>
                <th><%: Html.Label("Mont montage")%></th>
                <th><%: Html.Label("Adresse")%></th>
                <th><%: Html.Label("Adresse suite")%></th>
               
            </tr>
             <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTDateMontage)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.DateReception)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTMontMontage)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTAdresse1)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTAdresse2)%></td>
               
            </tr>
             
             <tr>
                 <th><%: Html.Label("Téléphone 1")%></th>
              
                <th><%: Html.Label("Téléphone 2")%></th> 
                <th><%: Html.Label("Status")%></th>
                <th><%: Html.Label("Client avisé")%></th>
                <th><%: Html.Label("Expediteur")%></th>
                <td rowspan="2">
             
              </td>
            </tr>
            <tr>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTTel1)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTTel2)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTEtat)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTSuiteEtat)%></td>
                <td valign="top"><%: Html.TextBoxFor(model => model.OTExpediteur)%></td>
                
            </tr>   
            
               
            </table>
            
            <p>
            
                <input type="submit" value="Enregister" style="width:140px; background-color:#58ACFA; color:white; height:35px;  padding:7px; font-family:Verdana; font-style:oblique; font-size:small; float:right"/>
                            </p>
        </fieldset>

    <% } %>

</asp:Content>

