<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ImportCommande
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%
    Response.Write(@"<script language='javascript' src='" + Globale_Varriables.VAR.get_URL_HREF() + "Content/script.js'></script>");
    Response.Write(@"<link href='" + Globale_Varriables.VAR.get_URL_HREF() + "Content/styles3.css' rel='stylesheet' type='text/css' />");    
%>


                      <div style="margin-top:45px;">

                      <fieldset>
        
                      

                                
                                <%
                                    string res = (ViewData["res"] != null)? ViewData["res"].ToString() : "";
                                    

                                        if (res != "" && Int32.Parse(res) > 0)
                                        {
                                    %>
                                        <div><span  style="color:green;font-weight:bold;margin-right:10px">Importation réussie !</span> </div><br />
                                    <%                     
                                        }
                                    %>

                                 <div> 
                                    <% 
                                        using (Html.BeginForm("ImportCommande", "ImportXML", FormMethod.Post, new { enctype = "multipart/form-data" }))
                                        {
                                    %>
                                            <input type="file" name="file" />
                                            <br /><br />
                                            <input type="submit" value="Importer" />
                                    <% 
                                        } 
                                    %>
                                 </div>
                                 </fieldset>
                         </div>


</asp:Content>
