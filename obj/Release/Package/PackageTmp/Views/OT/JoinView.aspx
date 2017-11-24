<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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