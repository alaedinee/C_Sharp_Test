<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<TRC_GS_COMMUNICATION.Models.ModeleCommunication>" %>


<%@ Import Namespace="TRC_GS_COMMUNICATION.Models" %>
<div id="RandomModal">
<h1>heloo</h1>
<% using (Html.BeginForm("PopUpMajPostForm","OT")) {%>
    <div class="editor-label"><%: Html.LabelFor(model => model.typeCommunication)%></div>
    <div class="editor-field" >
        <%:  Html.DropDownListFor(m => m.typeCommunication, (IEnumerable<SelectListItem>)ViewData["typeComm"]) %>
   <%: Html.ValidationMessageFor(m => m.typeCommunication) %>
    </div>
   
     <div class="editor-label"><%: Html.LabelFor(model => model.sujet )%></div>
    <div class="editor-field" >
        <%= Html.TextBoxFor(model => model.sujet) %>
        <%: Html.ValidationMessageFor(m => m.sujet) %>
    </div>
     
    <div class="editor-label"><%: Html.LabelFor(model => model.communicationText) %></div>
    <div class="editor-field" >
        <%= Html.TextBoxFor(model => model.communicationText) %>
        <%: Html.ValidationMessageFor(model => model.communicationText) %>
    </div>


    <p>
 
    <div class="editor-field">
                  
    </div>

<%} %>
</div>

