<%@ Page   Language="C#" ValidateRequest="false"  Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.ModeleCommunication>" %>


<%@ Import Namespace="TRC_GS_COMMUNICATION.Models" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" >


        var erreurForm = false;

        $().ready(function () {

            $("#typeCommunication").change(function () {

                if ($(this).val() == "SMS" || $(this).val() == "EMAIL") {
                    document.getElementById('communicationText').value = document.getElementById('DEFAULT_SMS_TEXT').value;
                }
                else {
                    document.getElementById('communicationText').value = "";
                }

            });
        });


        function sendEmail(formulaire) {

            validerChampFormulaire(formulaire);
            if (erreurForm == false) {

                $.post(SERVER_HTTP_HOST() + "/Tools/sendEmail",
                        { otid: document.getElementById('otid').value, subject: document.getElementById('sujet').value, texte: document.getElementById('communicationText').value },
                        function (htmlResult) {

                            if (htmlResult == "OK") {
                                alert("Email envoyé");
                                formulaire.submit();
                            }
                            else {
                                alert(htmlResult);
                            }
                        });

            }
        }


        function sendSMS(formulaire) {
            validerChampFormulaire(formulaire);

            if (erreurForm == false) {
                var numun = document.getElementById('NumTel1').value;
                var numdeux = document.getElementById('NumTel2').value;
                $.post(SERVER_HTTP_HOST() + "/Tools/validNumPhone",
                      { tel1: numun, tel2: numdeux },
                       function (htmlResult) {
                           var telsent = htmlResult;
                           if (telsent == "NO") {
                               alert("Téléphone incorrecte");
                               erreurForm = true;
                           }
                           else {



                               $.get(SERVER_HTTP_HOST() + "/Tools/PostRequest",
                                        { tel: telsent, text: document.getElementById('communicationText').value },
                                        function (htmlResult) {

                                            if (htmlResult.toString() == "OK") {
                                                alert("SMS envoyé");
                                                formulaire.submit();
                                            }
                                            else {
                                                alert(htmlResult);
                                            }
                                        });
                           }
                       });
            }
        }

        function validerForm(formulaire) {

            erreurForm = false;
            //var editor_data = CKEDITOR.instances['editeurText'].getData();
            //alert(editor_data);

            // document.getElementById('PopUpMAJ').className = 'erreurInputText';
            if (document.getElementById('typeCommunication').value == "SMS") {
                sendSMS(formulaire);

            }
            else if (document.getElementById('typeCommunication').value == "EMAIL") {
                sendEmail(formulaire);

            }
            else {
                validerChampFormulaire(formulaire);
                if (erreurForm == false) {
                    formulaire.submit();
                }
            }
        }


        function validerChampFormulaire(formulaire) {
            if (formulaire.communicationText.value == '') {
                formulaire.communicationText.className = 'erreurInputText';
                erreurForm = true;
            }

            if (formulaire.sujet.value == '') {
                formulaire.sujet.className = 'erreurInputText';
                erreurForm = true;
            }

            if (formulaire.typeCommunication.value == '') {
                formulaire.typeCommunication.className = 'erreurInputText';
                erreurForm = true;
            }

        }



        function getTextCourrier(frm) {
            //document.getElementById('communicationText').value = "Courrier";

            var sourceText = $('#editeurText').val().toString();
            sourceText = sourceText.split('\n').join(' ');
            sourceText = sourceText.split('\t').join(' ');

            sourceText = sourceText.replace(/</g, "|");
            sourceText = sourceText.replace(/>/g, "]");
            sourceText = sourceText.replace(/#/g, "@@");



            document.getElementById('TemplateCourrier').value = sourceText;
            frm.submit();
        }

        function getTextSatif(frm, typ) {
            //document.getElementById('communicationText').value = "Courrier";
            var sourceText = $('#editeurText').val().toString();
            sourceText = sourceText.split('\n').join(' ');
            sourceText = sourceText.split('\t').join(' ');

            sourceText = sourceText.replace(/</g, "|");
            sourceText = sourceText.replace(/>/g, "]");
            sourceText = sourceText.replace(/#/g, "@@");

            document.getElementById('TemplateCourrier').value = sourceText;

            if (typ == "print") {
                var link = SERVER_HTTP_HOST() + "/OT/getSatif?otid=" + document.getElementById('otid').value ;
                $.post(SERVER_HTTP_HOST() + "/OT/getSatif", { otid: document.getElementById('otid').value }, function (htmlResult) {

                    $("#redirector").attr('href', link);
                    $("#redirector").click();

                    frm.submit();
                });
                
            }
            else {
                sourceText = sourceText.replace("../../Content/template/", "http://www.duperrex.ch/satisfaction/img/");
                
                $.post(SERVER_HTTP_HOST() + "/Tools/sendHTMLEmail",
                        { otid: document.getElementById('otid').value, subject: "Satisfaction", texte: sourceText },
                        function (htmlResult) {
                            if (htmlResult == "OK") {
                                alert("Email envoyé");

                                frm.submit();
                            }
                            else
                                alert("Erreur !");
                        });
            }
        }


      
</script>
    </head>
<body>
<div id="PopUpMAJ" style="width:400px;">

<% using (Html.BeginForm("PopUpMajPostForm","OT")) {%>
 
     <%: Html.HiddenFor(model =>model.otid) %>
     <%: Html.HiddenFor(model =>model.idComm)  %>
     <%: Html.HiddenFor(model =>model.from)  %>
   
     <% if (Model.typeCommunication == "COURRIER")
        { %>
        <% if (ViewData["displaySave"] != null && ViewData["displaySave"].ToString() == "displaye")
               Response.Write("<input type=\"button\" value=\"Enregistrer\" onclick=\"getTextCourrier(this.form)\" />"); %>
            <textarea id="editeurText"></textarea>
            <%: Html.HiddenFor(m => m.TemplateCourrier) %>
            <%: Html.HiddenFor(m => m.typeCommunication)%>
             
     <%} else if (Model.typeCommunication == "SATIF")
        { %>
         
        <% if (ViewData["displayprint"] != null && ViewData["displayprint"].ToString() == "displaye"){
               Response.Write("<input type=\"button\" value=\"Imprimer\" onclick=\"getTextSatif(this.form,'print')\" />");
               Response.Write("<input type=\"button\" value=\"Envoyer Mail\" onclick=\"getTextSatif(this.form, 'send')\" />");
               } %>
      
            <textarea id="editeurText"></textarea>
            <%: Html.HiddenFor(m => m.TemplateCourrier) %>
            <%: Html.HiddenFor(m => m.typeCommunication)%>
           
            
      <% }
       else
        { %>
        <h1>Communications</h1>
        <% if (ViewData["DEFAULT_SMS_TEXT"] != null)
           {
               Response.Write("<input type='hidden' value='" + ViewData["DEFAULT_SMS_TEXT"].ToString() + "' id='DEFAULT_SMS_TEXT' name='DEFAULT_SMS_TEXT'>  ");
           } %>
           <%: Html.HiddenFor(model =>model.NumTel1) %>
           <%: Html.HiddenFor(model =>model.NumTel2)  %>
<br /><br />
          <div class="editor-label">Type de communication</div>
    <div class="editor-field">
        <%:  Html.DropDownListFor(m => m.typeCommunication, (IEnumerable<SelectListItem>)ViewData["typeComm"]) %>
        <%: Html.ValidationMessageFor(m => m.typeCommunication) %>
    </div>
          <div class="editor-label">Titre</div>
          <div class="editor-field" >
            <%= Html.TextBoxFor(model => model.sujet) %>
            <%: Html.ValidationMessageFor(m => m.sujet)  %>
          </div>
    <div class="editor-label">Message</div>
    <div class="editor-field" >
        <%= Html.TextAreaFor(model => model.communicationText, new { rows = 10, cols = 30 })%>
        <%: Html.ValidationMessageFor(model => model.communicationText) %>
    </div>
     <% if (Model.sujet == null )
       {
           Response.Write("<input type=\"button\" value=\"Enregistrer\" onclick=\"validerForm(this.form)\" />");
       }
           %>      
       <%} %>

    <p>
        
    </p>
    <div class="editor-field">              
    </div>

<%} %>

<script type="text/javascript">
    $(document).ready(function () {
		
        if ($("#sujet").val() == "") {
            $("#sujet").val($("#OTNoBL").val());
        }
    });
</script>

</div>
</body>
</html>
