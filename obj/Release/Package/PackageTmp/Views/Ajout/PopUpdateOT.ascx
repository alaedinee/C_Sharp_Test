<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<TRC_GS_COMMUNICATION.Models.DOrdre>" %>

<script type="text/javascript">

   

        function submitForm(form) {
            form.submit();
            $("#divOT").remove();
        }
    
</script>
<div id="divOT">
    <% using (Html.BeginForm("PopUpdateOT", "Ajout", FormMethod.Post, new { target="_blank" , id= "frm" }))
       {%>
        <%: Html.ValidationSummary(true)%>
            
            <%: Html.HiddenFor(model => model.otid)%>
            <div class="editor-label">
                <%: Html.HiddenFor(model => model.otdestinnom)%>
            </div>
            <div class="editor-label">
                <%: Html.HiddenFor(model => model.otdestprenom)%>
            </div>
            
            <div class="editor-label">
                <%: Html.Label("Donneur d'ordre")%>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(model => model.otdestbulletin, new { rows = 6, cols = 40 })%>
                <%: Html.ValidationMessageFor(model => model.otdestbulletin)%>
            </div>
            
            <p>
                <input type="button" value="Enregister"  id="save" onclick="submitForm(this.form);"/>
            </p>
     

    <% } %>

    </div>

