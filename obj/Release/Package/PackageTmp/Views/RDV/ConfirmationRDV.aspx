<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.RdvConfirmationModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ConfirmationRDV
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/ecmascript">

    $(document).ready(function () {

        $("#valider").click(function () {

            var radios = document.getElementsByTagName("input");
            var erreur = false;

            for (var i = 0; i < radios.length; i++) {
                if ($(radios[i]).attr("type") == "radio") {

                    if ($(radios[i]).attr('value') == "true" && $(radios[i]).is(':checked') == true && $("#causeRetard").val() == "") {
                        erreur = true;
                    }
                }
            }

            if (erreur == true) {
                alert("Veuillez choisir une cause");
            }
            else {
                this.form.submit();
                // $("#valider").form.Submit();
            }

        });

        function getListJoinOT() {

            $.post(SERVER_HTTP_HOST() + '/OT/addGetJoinOT',
               { otid: document.getElementById("OTID").value, joinOtid: 0, op: 'listOTConfirmation' },
               function (htmlResult) {

                   var result = htmlResult.indexOf('#@#VIDE#@#');


                   if (result != -1) {

                       $("#joinOT").hide()
                   }
                   else {
                       $("#divJoinElementOT").html(htmlResult);
                   }

               });
        }
        getListJoinOT();
    });

</script>

<% using( Html.BeginForm("ConfirmationRDV","RDV")){ %>

<fieldset id="joinOT" style="width:250px;float:left;">
    <legend>Ordre</legend>
    <div id="divJoinElementOT">
    </div>
</fieldset>

 <%if (ViewData["listeCause"] != null)
    {%>


    <fieldset id="fieldCauseConfirmationRDV">
    <legend style="background-color:Red;border:1px solid black;">Livraison hors délai standard!!!</legend>
    
    <div class="editor-label">Veuillez justifier ce retard</div>
    <div class="editor-field" >
       <%:  Html.DropDownListFor(m => m.causeRetard, (IEnumerable<SelectListItem>)ViewData["listeCause"])%>
    </div>
    </fieldset>
    <%} %>
<div id="contentConfirmation">
   
  
    <div id="hautContentConfirmation">
        <center> <% Response.Write(Model.titreConfirmation); %></center>
  <%: Html.HiddenFor(m => m.OTID) %>
  <%: Html.HiddenFor(m => m.planID)%>
  <%: Html.HiddenFor(m => m.periodeID)%>
 
    </div>
    
    <div id="basContentConfirmation">
        <table id="tableCheckConfirmation">
        <tr><td>
       <input type="radio"   name="confirmation" value="true" checked="checked" />Confirmer le rendez-vous</td></tr>
        <tr><td> <input type="radio" name="confirmation" value="false" />Annuler le rendez-vous</td></tr>
         <%if (ViewData["listeCause"] != null)
           {%>
             <tr><td><input type="button" value="Valider" id="valider" /></td></tr>
         <%}
           else
           { %>
             <tr><td><input type="submit" value="Valider" /></td></tr>
         <%} %>

      
        </table>
    </div>
</div>
<%} %>
</asp:Content>