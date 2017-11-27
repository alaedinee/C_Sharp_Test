<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="System.Data" %>

<%
    var _prestRefCmdClient = ViewData["RefCmdClient"];
    var _prestEtat = ViewData["Etat"] ;
    var _prestType = ViewData["Type"] ;
    var _prestProduit = ViewData["Produit"];

    DataTable _prestList = (DataTable)ViewData["prestListPrestation"];
    DataTable _prestStatut = (DataTable)ViewData["presStatus"];
    
    
    var _prestPrix = ViewData["Prix"];
    var _prestMode = ViewData["Mode"];
    var _prestOTID = ViewData["OTID"];
    var _prestDetailID = ViewData["prestDetailID"];
    var _prestNbrPeriode = ViewData["prestNbrPeriode"];
    var _IsPrestGroupe = (bool)ViewData["IsPrestGroupe"];

    string[] tab = _prestRefCmdClient.ToString().Split(new char[] { '-' });
    if (tab.Length > 1)
        _prestRefCmdClient = tab[1];

    int nbrH = 0, nbrM = 0, nbrPr;
    if (Int32.TryParse(_prestNbrPeriode.ToString(), out nbrPr))
    {
        nbrH = ((int)(nbrPr / 2));
        nbrM = nbrPr % 2;
    }
     %>

<br />
<br />

<fieldset>
    <legend><%: (_prestProduit == null || _prestProduit == "" )? "Nouvelle préstation" : _prestProduit  %> </legend>
    <table border="0" cellspacing='2' cellpadding='2'>

           
            <tr>
                <td>Préstation</td>
                <td>
                   <select id="prestListP" style="width:250px;">
                    <%
                        if (!_IsPrestGroupe)
                        {
                            DataTable prestList = (DataTable)_prestList;
                            if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(prestList))
                            {
                                for (int i = 0; i < prestList.Rows.Count; i++)
                                {
                                    DataRow row = prestList.Rows[i];

                                    if (row["Produit"].ToString() == _prestProduit.ToString())
                                    {
                                        Response.Write("<option value='" + row["Produit"].ToString() + "' selected='selected'>" + row["Produit"].ToString() + "</option>");
                                    }
                                    else
                                    {
                                        Response.Write("<option value='" + row["Produit"].ToString() + "'>" + row["Produit"].ToString() + "</option>");
                                    }
                                }
                            }
                        }
                        else
                            Response.Write("<option value='" + _prestProduit + "'>" + _prestProduit + "</option>");
                        %>
                       </select>
                </td>
            </tr>
            
            <tr>
                <td>Heur préstation</td>
                
                <td>
                       <select id="prestHeur" style="width:125px;">
                       <% for(int i=0;i < 25;i++){ %>
                            <option value="<%: i.ToString("00") %>" <%: (nbrH==i) ? "selected='selected'" : "" %>><%: i.ToString("00") %></option>
                       <% } %>
                       </select>
                       H : 
                       <select id="prestMin" style="width:125px;">
                            <option value="00" <%: (nbrM==0) ? "selected='selected'" : "" %>>00</option>
                            <option value="30" <%: (nbrM==1) ? "selected='selected'" : "" %>>30</option>
                       </select> 
                        min
               </td>
            </tr>

            <%----%>
            <tr>
                <td>Prix de la préstation</td>
                
                <td>
                       <input type="text" id="prestPrix"  value="<%: (_prestPrix == "")? "0" : _prestPrix  %>" style="width: 200px;"/>
               </td>
            </tr>

            

            <tr>
                <td>Ref. Client</td>
                
                <td>
                       <input type="text" id="prestRefClient" value="<%: (_prestRefCmdClient == null)? "" : _prestRefCmdClient  %>" style="width: 200px;" />
               </td>
            </tr>

            <tr>
                <td>Statut</td>
                
                <td>
                    <select id="prestStatut" style="width:250px;">
                     <%
                         if (_prestStatut != null)
                            {
                                DataTable prestStatut = (DataTable)_prestStatut;
                                if (TRC_GS_COMMUNICATION.Models.Tools.verifyDataTable(prestStatut))
                                {
                                    for (int i = 0; i < prestStatut.Rows.Count; i++)
                                    {
                                        DataRow row = prestStatut.Rows[i];


                                        Response.Write("<option value='" + row["Etat_Destination"].ToString() + "' " + (_prestEtat.ToString() == row["Etat_Destination"].ToString() ? " selected='selected' " : "") + ">" 
                                                        + row["Description"].ToString() + "(" + row["Etat_Destination"].ToString() + ")" 
                                                     + "</option>");
                                        
                                    }
                                }
                            }
                        %>
                       </select>
               </td>
            </tr>
        <tr>
            <td>
                <input type="button" id="addPrest" value=" Valider " />
            </td>
        </tr>

</table>
</fieldset>

<script>
    $().ready(function () {

        var _prestOtID = '<%: _prestOTID %>';
        var _prestMode = '<%: _prestMode %>';
        var _prestDetailID = '<%: _prestDetailID %>';


        var _prestEtat = '<%: _prestEtat %>';
        var _prestType = '<%: _prestType %>';
        var _prestOldServ = '<%: _prestProduit %>';






        $("#Type").prop("disabled", true);

        //var _Type = $("#Type").val();

        //var _Date = $("#DateTimePicker").val();



        $("#addPrest").click(function () {
//            alert("yeah");
//            return false;

            var _prestPrix = $("#prestPrix").val();
            var _prestRefClient = $("#prestRefClient").val();

            var _prestValList = $("#prestListP option:selected").val();
            var _prestValStatut = $("#prestStatut option:selected").val();

            var _prestHeur = $("#prestHeur option:selected").val();
            var _prestMin = $("#prestMin option:selected").val();

            //alert(_prestValList);


            $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/operationPrestation",
                    {
                        prestOTID: _prestOtID, prestMode: _prestMode, prestPrix: _prestPrix, prestRefClient: _prestRefClient, prestValList: _prestValList, prestValStatut: _prestValStatut, prestEtat: _prestEtat, prestID: _prestDetailID
                        , prestHeur: _prestHeur, prestMin: _prestMin
                    }, function (data) {

                        //$("#dv_loading_detail").css("display", "none");
                        //$('#dv_main_step2').html(data);
                        if (data != "") {
                            // alert('Opération réussie');

                            $("#contrDgPrest").remove();
                            $.post($.fn.SERVER_HTTP_HOST() + "/Prestation/getLstPrestation", { prestOTID: _prestOtID },

                                        function (htmlResult) {

                                            $("#divPrestation").html(htmlResult);

                                        });

                            //location.reload();

                        }
                        else
                            alert('Opération échouée')
                    });

        });


        //$('#DateTimePicker').datetimepicker({
        //    addSliderAccess: true,
        //    dateFormat: 'dd/mm/yy',
        //    stepHour: 1,
        //    hourMin: 1,
        //    hourMax: 23,
        //    sliderAccessArgs: { touchonly: false }
        //});


    });
</script>