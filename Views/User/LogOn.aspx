<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.UserModel>" %>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <%
            if (Session["UserAuthentifier"] == "true")
            {
                string page = Omniyat.Models.Configs.getDefPage(Session["login"].ToString());
                Response.Redirect(Globale_Varriables.VAR.get_URL_HREF() + page);
            }
        %>
		<title>Tricolis</title>


        <%
            Response.Write(@"<script language='javascript' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Content/jquery.min.js'></script>");
            Response.Write(@"<link href='" + Globale_Varriables.VAR.get_URL_HREF() + "/Content/styles.css' rel='stylesheet' type='text/css' />");
        %>

		<script type="text/javascript">
		    $(document).ready(function () {

		        $.fn.Connect = function () {
		            var _username = $("#LogIn");
		            var _password = $("#Password");

		            if (_username.val() != _username.attr("def") && _username.val().length > 2 && _password.val() != _password.attr("def") && _password.val().length > 2)
		                $("#fr").submit();
		            else {
		                $(".dvError").html("Veuillez remplir les champs !").css("visibility", "visible");
		            }
		            return false;
		        };

		        $("#connect").click(function () {
		            $.fn.Connect();
		        });

		        $('input').focus(
					function () {
					    if ($(this).val() == $(this).attr("def")) {
					        $(this).val('');
					        $(this).css("color", "#000");
					    }
					})
				.blur(function () {
				    if ($(this).val() == '') {
				        $(this).val($(this).attr("def"));
				        $(this).css("color", "#b1b1b1");
				    }
				}).keypress(function (e) {
				    var code = e.keyCode || e.which;
				    if (code == 13)
				        $.fn.Connect();
				});


		    });
		</script>
	
	</head>
	
	<body>
		<br />
		<% using (Html.BeginForm(null, null, FormMethod.Post, new { name = "fr", id = "fr" }))
     {%>
			<table border="0" align="center" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" class="banner">&nbsp;</td>
				</tr>
				<tr>
					<td  class="img_back">&nbsp;</td>
					<td width="260p">
						<br />
						<div style="border:1px solid #cbc2c2; width:260px">
							<div class="auth">
								<h3 class="sTitle">Authentification</h3>
								<p>
									<label for="username">Nom d'utilisateur</label><br />
									<input type="text" name="LogIn" id="LogIn" value="Taper votre nom d'utilisateur" def="Taper votre nom d'utilisateur" />
								</p>
								<p>
									<label for="password">Mot de passe</label><br />
									<input type="password" name="Password" sType="password" id="Password" value="Taper votre mot de passe" def="Taper votre mot de passe" />
								</p>							
							</div>
							<a href="#" class="greenBtn" id="connect">Connexion</a>
							<div class="dvError" style='<%: (ViewData["erreur"] != null)? "visibility:visible" : ""%>'>&nbsp;<%:ViewData["erreur"]%></div>
						</div>
					</td>
				</tr>			
			</table>
            
            <div style="margin:auto;padding:6px;width:641px;margin-top:150px;background:#00809d;color:#fff;font-size:13px;text-align:center"> © Copyright 2014</div>
            <div style="margin:auto;padding:6px;width:641px;margin-top:2px;background:#00809d;color:#fff;font-size:13px;text-align:center"> IP : <%: TRC_GS_COMMUNICATION.Models.Tools.GetIP4Address() %></div>
		<% } %>
	</body>
</html>