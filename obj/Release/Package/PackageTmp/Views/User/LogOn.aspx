<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.UserModel>" %>
<%/*
    if (ViewData["user"] == null)
     {
         
         Response.Write("nulllllllllllllllllll");
     }
     else
     {
         Response.Write("User : " + ViewData["user"].ToString() + "<br />");
         Response.Write("UserID : " + Session["userID"] + "<br />");
         Response.Write("Debug : " + ViewData["Debug"].ToString() );
         //Response.Write("no : t nullllllllllllllllllllllll");
     }
     */
 %>
  <%
    if (Session["UserAuthentifier"] == "true")
    {
        Response.Redirect("OT/Index");

    }
  %>

<html>
<head>


<%--<link href="~/Content/Site.css" rel="stylesheet" type="text/css" />--%>

<style type="text/css">
body
{
    /*background-color: #5c87b2;*/
    background-image:url('../Images/bg_modele3.jpg') ;
    background-attachment:fixed;
    background-position:bottom;
   
    font-family: Verdana, Helvetica, Sans-Serif;
    margin: 0;
    padding: 0;

    
}
#LogOnContainer
{
    width:40%;
    margin-left:30%;
    margin-top:10%;
}
#tabeleInfo
{
    width:80%;
    margin-left:10%;
}
input
{
    width: 200px;
   
    /*margin-bottom: 10px;*/
}

a:link
{
    color: #034af3;
    text-decoration: underline;
}
a:visited
{
    color: #505abc;
}
a:hover
{
    color: #1d60ff;
    text-decoration: none;
}
a:active
{
    color: #12eb87;
}

p, ul
{
    margin-bottom: 20px;
    line-height: 1.6em;
}

/* TITRES   
----------------------------------------------------------*/
h1, h2, h3, h4, h5, h6
{
    font-size: 1.5em;
    color: #000;
    font-family: Arial, Helvetica, sans-serif;
}

h1
{
    font-size: 2em;
    padding-bottom: 0;
    margin-bottom: 0;
}
h2
{
    padding: 0 0 10px 0;
}
h3
{
    font-size: 1.2em;
}
h4
{
    font-size: 1.1em;
}
h5, h6
{
    font-size: 1em;
}

/* cette règle applique les styles aux balises <h2> qui sont le 
premier enfant des colonnes de table gauche et droite*/
.rightColumn > h1, .rightColumn > h2, .leftColumn > h1, .leftColumn > h2
{
    margin-top: 0;
}
.erreur
{
    color:Red;
}
</style>
</head>
<body>
    
    <div id= "LogOnContainer">
    
    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <fieldset>
            <legend></legend>
            <center><h2>Authentification</h2></center>
            <table id="tabeleInfo">
            <tr><td>  <div class="editor-label">
                Nom d'utilisateur  
            </div></td><td>  <div class="editor-field">
                <%: Html.TextBoxFor(model => model.LogIn) %>
                <%: Html.ValidationMessageFor(model => model.LogIn) %>
            </div></td></tr>
            <tr><td><div class="editor-label">
               Mot de passe  
            </div></td><td><div class="editor-field">
                <%: Html.PasswordFor(model => model.Password) %>
                <%: Html.ValidationMessageFor(model => model.Password) %>
            </div></td></tr>
            <tr><td></td><td><input type="submit" value="Se connecter" /></td></tr>
            <tr><td colspan ="2"><h3 class="erreur"><%:ViewData["erreur"]%></h3></td></tr>
            </table>
          
          
            
           
            
            
           
           

        </fieldset>

    <% } %>

    
    </div>


    </body>
</html>
