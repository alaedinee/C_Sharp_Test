<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<TRC_GS_COMMUNICATION.Models.PrestationModele>" %>


<div id="PopUpAddPrestation">
    <% using (Html.BeginForm("PopUpPrestationPostForm", "Ajout"))
       {%>
        <%: Html.ValidationSummary(true) %>

      
            
      
           
                <%: Html.HiddenFor(model => model.otid)%>  
                <%: Html.HiddenFor(model => model.op)%>
                <%: Html.HiddenFor(model => model.type)%>  
                <%: Html.HiddenFor(model => model.oldPrestation)%>


                <% if (ViewData["titrePrestation"] != null)
                   { %>
                   <h2><%: ViewData["titrePrestation"] %></h2>
                <%} %>

                <% if (Model.op == "add" || Model.op == "update")
                   { %>
            <div class="editor-label">
               Préstation
            </div>
            <div class="editor-field">
                <%:  Html.DropDownListFor(m => m.prestation, (IEnumerable<SelectListItem>)ViewData["listPrestation"])%>
                <%: Html.ValidationMessageFor(model => model.prestation)%>
            </div>
            <%} %>


            <div class="editor-label">
            Prix de la préstation
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.prix) %>
                <%: Html.ValidationMessageFor(model => model.prix) %>
            </div>
            
            <div class="editor-label">
            Ref.Client
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.cmdRefClient) %>
            </div>
            <p>
                <input type="submit" value="Enregistrer" />
            </p>
     

    <% } %>

 
    </div>

