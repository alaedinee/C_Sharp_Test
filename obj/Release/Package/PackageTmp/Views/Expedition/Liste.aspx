<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<TRC_GS_COMMUNICATION.Models.ChargementModels>" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxControl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liste
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

 <div id="container"> 
        <%
            if (ViewData["dt"] != null)
            {
                System.Data.DataTable  dt = (System.Data.DataTable) ViewData["dt"];

                Response.Write("<br /><fieldset><legend>Liste des expéditions</legend>" +
                    "<div style='text-align:right'><a href='" + Globale_Varriables.VAR.get_URL_HREF() + "/Expedition/ExportListeExpedition' target='blank'><img align='center' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/excel_icon.png' width='32' /> Exportez vers Excel</a></div><br />" +
                    "<table id='tableList' align='left'>" +
                                "<thead><tr>" +
                                "<th>codestock</th>" +
                                "<th>NO DOSSIER</th>" +
                                "<th>NBR COLIS</th>" +
                                
                                "<th>DATE LIVRAISON</th>" +
                                
                                "<th>CLIENT NOM</th>" +
                                "<th>PRENOM</th>" +
                                "<th>NP</th>" +
                                "<th>VILLE</th><th>#</th></thead>");
                               
                for(int i = 0 ; i < dt.Rows.Count ; i++){
                    Response.Write("<tr index='" + dt.Rows[i]["OTID"].ToString() + "'>" +
                                    "<td>" + dt.Rows[i]["codestock"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["OTNoBL"].ToString() + "</td>" +
                                    "<td>" + dt.Rows[i]["OTNbrColis"].ToString() + "</td>" +

                                    "<td>" + dt.Rows[i]["OTDateLivraison"].ToString() + "</td>" +
                                    
                                   "<td>" + dt.Rows[i]["OTDestinNom"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["OTDestPrenom"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["OTDESTNP"].ToString() + "</td>" +
                                   "<td>" + dt.Rows[i]["OTDestVille"].ToString() + "</td>"+
                                   "<td><input type='checkbox' index='" + dt.Rows[i]["OTID"].ToString() + "' checked='checked' /></td></tr>");
                }

                Response.Write("</table>" + "<br clear='both' /><br /><br /><div style='text-align:right'><a id='validate'><img align='center' src='" + Globale_Varriables.VAR.get_URL_HREF() + "/Images/valid_icon.png' width='32' /> Valider</a></div><br />" + "</fieldset>");
            }     
         %>
    

    <script type="text/javascript">

        $().ready(function () {
            var oTable = $("#tableList").dataTable({
                "oLanguage": {
                    "sLengthMenu": "Afficher _MENU_ Lignes par page",
                    "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
                    "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
                    "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
                    "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
                },

                "sPaginationType": "full_numbers"
                ,

            });


            $("#validate").click(function () {
                var rows = oTable.fnGetNodes();
                var _codes = "";
                for(var i=0;i < rows.length;i++)
                {
                    var n = $(rows[i]).find("input:checked").length; 
                    if(n!=0){
                        _codes += $(rows[i]).find("input").attr("index") + "-";
                    }
                }

                if(_codes.length > 1){
                    _codes = _codes.substring(0, _codes.length - 1);

                    $.get("../Expedition/Confirmer", { codes: _codes }, function (data) {
                        if(data=="-1") 
                            alert("Erreur !");
                        else
                            alert("Validé(s)");
                    });        
                }   

            });

        });

    </script>
    

</asp:Content>
