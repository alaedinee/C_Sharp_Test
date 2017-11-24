<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Statuer Les Dossiers
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


<style>
    .sp-input{ width: 140px;margin-left: 5px;}
  #myTableData {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    border-spacing: 2px;
    
    width: 100%;
}

#myTableData td, #myTableData th {
    border-bottom: 1px solid #ddd;
    padding: 3px;
}

#myTableData tr:nth-child(even){background-color: #f2f2f2;}

#myTableData tr:hover {background-color: #ddd;}

#myTableData tr {
    height: 10px;
    text-align: left;
    background-color: #CED8F6;
    color: black;
}
</style>


<form id="form1" runat="server">
<div id="sp_content">
    <!-- champs de filtrer -->
    <fieldset>
        <legend>Filter</legend>
        <table>
            <tr>
                <th>Code Nobl </th>
               
                <td>
                    <input type="text" id="txt_OtNobl" value="" />
                    <input type="button" id="btn_statuer" class="validerBtn sp-input" value="  Charger  " /></td>
            </tr>
        </table>
    </fieldset>
    <br />

    <!-- resultat champs -->
    <fieldset >
          <legend>Résultat</legend>
          <h1 style="color : #2E9AFE ; text-align : center ; "> Le résultat sera affichée lors de la saisie du OTNoBL </h1>
          <div id="tabs-OT" style="width:95%">  
           <!-- la resultat sera affiché dans cette partie  -->
          </div>
          <div>
            <table id="myTableData"  style="border-color: white; border : 2px" cellpadding="2">
               <tr style=" background-color:#F2F2F2">
                   <td>&nbsp;</td>
                   <td><b>OTNoBL</b></td>
                   <td><b>Donneur</b></td>
                   <td><b>Type</b></td>
                   <td><b>Date création</b></td>
                   <td><b>Date livraison</b></td>
                   <td><b>Nbr package</b></td>
                   <td><b>Poids TTL</b></td>
                   <td><b>Volume TTL</b></td>
                   <td><b>Prestation</b></td>
                   <td><b>Livraison</b></td>
                   <td><b>NP</b></td>
                   <td><b>Ville</b></td>
                   <td><b>Dépot Mère</b></td>
                   <td style="display:none;"><b>OTID</b></td>  <!--style="display:none;"-->

               </tr>
</table>
          </div>
 <br />
 <br />
    </fieldset>

    <br />

</div>



<div id="contrDgPr">

</div>
</form>

<script>
    $(document).ready(function (){
        $("#myTableData").hide();
        var List_OTID=[];
        var wt = 1000;
        var ht = 500;
        //button statuer event 

        $("#btn_statuer").click(function(){
             
             var _OtId = Ot_Ids();
             if(_OtId=="")
             {
                alert("aucun dossier ");
                return false;
             }
             $.post($.fn.SERVER_HTTP_HOST() + "/OT/SelectPrestAStatuer"
                     ,{ OTIDGroup: _OtId , isGroup : 1}
                     , function (htmlResult) {

                         $("#contrDgPrest").remove();
                         $("#contrDgPr").html("<div id='contrDgPrest' title='Ajouter préstation'>" + htmlResult + "</div>");
                         $("#contrDgPrest").dialog({
                             width: wt,
                             height: ht,
                             modal: true,
                             // position: 'top',

                         });
                     }
                );

         });
       

        $("#txt_OtNobl").bind('keypress', function (e) {
            var code = e.keyCode || e.which;
            var pp = "0";
            if (code == 13) {
                var _OtNobl = $(this).val();
                $.getJSON($.fn.SERVER_HTTP_HOST() + "/OT/GetAllOtStatuer2/"
                , { OTNOBL: _OtNobl+"" }
                , function (data) {
                //parcour table
                 
                // end parcour   
                    if (data.length > 1) {
                        alert("OTNoBL return plus d'un seule resultat vieullez entrer une autre ..");
                    }
                    else {
                        var OTS = eval(data);
                        if (Check_if_exist(OTS[0].OTID) === false) {
                            addRow(OTS);
                            $("H1").hide();
                            $("table").show();
                        }
                        else { alert("la ligne déja existe "); }
                    }
                });
                 $(this).val("");
                return false;
            }
        });
        //end json
        function Check_if_exist(id)
        {   var exist=false;
            $('#myTableData').find('tr[index]').each(function() 
            {
                if($(this).attr('index') == id)
                {
                   exist= true;
                   return;
                }
            });
            return exist;
        }

        function Ot_Ids()
        {
         var allids=[];
           $('#myTableData').find('tr[index]').each(function() 
            {
                allids.push($(this).attr('index'));
            });
            return allids.join(',');
        }
        
        // methode for create du table 
        function addRow(dtOtLst) {
            var table = document.getElementById("myTableData");
            var rowCount = table.rows.length;
            var row = table.insertRow(rowCount);
            $(row).attr("index", dtOtLst[0].OTID);

            var list = [ dtOtLst[0].OTNoBL, dtOtLst[0].Donneur,dtOtLst[0].type ,dtOtLst[0].Datecréation, dtOtLst[0].Datelivraison, dtOtLst[0].NbrPackages,dtOtLst[0].PoidsTTL, dtOtLst[0].VolumeTTL, dtOtLst[0].Prestation, dtOtLst[0].Livraison, dtOtLst[0].NP, dtOtLst[0].Ville,dtOtLst[0].DepotMere ,dtOtLst[0].OTID];
            //delete event 
            var _delete = $('<input type="button" style="height: 23px" value = "Retirer">');
            _delete.click(function () {
                var index = $("tabs-OT").index($(this));
                table.deleteRow(index);
             });
            //delete end
            $(row.insertCell(0)).append(_delete);
            for (var j = 1; j < list.length; j++) {
                
                row.insertCell(j).innerHTML = list[j-1];
            }
            
         }

        // Methode end 

    });
</script>

</asp:Content>
