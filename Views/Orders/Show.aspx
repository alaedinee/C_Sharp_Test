<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import namespace="System.Data" %>

 <%
            //string adr = HttpContext.Current.Request.Url.Host;
            Response.Write(@"<script language='javascript' src='../../Content/jquery.min.js'></script>");           
            Response.Write(@"<link href='../../Content/styles2.css' rel='stylesheet' type='text/css' />");
        %>

                        <div style="border:1px solid #cbc2c2;width:700px;">
							<div class="auth" style="height:auto">
								<h3 class="sTitle" style="text-align:left">N°Bulletin : 011-TR2741183</h3>

								<p style="float:left; margin:0px">
									<label for="Text1">Code stock</label><br />
									<input type="text" id="Text1" value="" def="" />
								</p>
								<p style="float:left; margin:0px;margin-left:5px">
									<label for="Text2">Nbr Périodes</label><br />
									<input type="text" id="Text2" value="" def="" />
								</p>	

                                <p style="float:left; margin:0px;margin-left:5px">
									<label for="Text1">Poids</label><br />
									<input type="text" id="Text3" value="" def="" />
								</p>

                                <br clear="all" />

                                <p style="float:left;margin:0px;">
									<label for="Text1">Nbr Colis (Palettes)</label><br />
									<input type="text" id="Text3" value="" def="" />
								</p>

                                <p style="float:left;margin:0px;margin-left:5px">
									<label for="Text1">Somme</label><br />
									<input type="text" id="Text3" value="" def="" />
								</p>

								<p style="float:left;margin:0px;margin-left:5px">
									<label for="Text2">Status</label><br />
									<input type="text" id="Text4" value="" def="" />
								</p>

                                <br clear="all" />

                                <p style="float:left;margin:0px;">
									<label for="Text1">Cubage</label><br />
									<input type="text" id="Text5" value="" def="" />
								</p>

                                <p style="float:left;margin:0px;margin-left:5px">
									<label for="Text1">Valeur Marchandise à monter</label><br />
									<input type="text" id="Text6" value="" def="" />
								</p>

								<p style="float:left;margin:0px;margin-left:5px">
									<label for="Text2">Client avisé</label><br />
									<input type="text" id="Text7" value="" def="" />
								</p>

                                <br clear="all" />

                                <p style="float:left;margin:0px;">
									<label for="Text1">Date Arrivée Dépot</label><br />
									<input type="text" id="Text8" value="" def="" />
								</p>

                                <p style="float:left;margin:0px;margin-left:5px">
									<label for="Text1">Note interne</label><br />
									<input type="text" id="Text9" value="" def="" />
								</p>

								<p style="float:left;margin:0px;margin-left:5px">
									<label for="Text2">Téléphone</label><br />
									<input type="text" id="Text10" value="" def="" />
								</p>

                                <br clear="all" />

                                <p style="float:left;margin:0px;">
									<label for="Text1">Email</label><br />
									<input type="text" id="Text11" value="" def="" />
								</p>
					            <br clear="all" />
							</div>
							
                            <div style='height:30px;padding:15px'>
                                <a href="#" class="greenBtn" style="color:White;" id="connect">Enregistrer</a>
                                <a href="#" class="greenBtn" style="color:White;" id="A1">Enregistrer</a>
                                <a href="#" class="greenBtn" style="color:White;" id="A2">Enregistrer</a>
                            </div>

							<div class="dvError" style='<%: (ViewData["erreur"] != null)? "visibility:visible" : ""%>'>&nbsp;<%:ViewData["erreur"]%></div>
						</div>

