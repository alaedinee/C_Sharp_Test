<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PlanningSystem
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        h3
        {
            color:#38b0d7;
        }
    </style>

<style type="text/css">
 
#vars li 
{
    cursor:pointer;
}  
  
#vars li:hover
{
    color:blue;
}
  
 
 #menuOT
 {
       float:left;
       margin-left:-20px;
       margin-top:-55px;
       padding-bottom:30px;
 }
 
 ul#menuOT  {
 margin:0;
 padding:0;

 }
 ul#menuOT li {
 float:left;
 list-style: none;
 padding:0;
 text-decoration:none;
 background-color:#58ACFA;
 }
 ul#menuOT li a {
 display:block;
 width:80px;
 color:white;
 height:22px;
 text-decoration:none;
 padding:7px;
 font-family:Verdana;
 font-style:oblique;
 font-size:small;
 }
 ul#menuOT li a:hover {
 background-color:#81BEF7;
 }
</style>

    <br />
    <div >


    <div style="float:left">

            <b>Type Camion</b> <select id="lstTypes" style="width:204px">

            <%
                System.Data.DataTable dt = (System.Data.DataTable)ViewData["Types"];
                if(Omniyat.Models.MTools.verifyDataTable(dt)){
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
             %>
                            <option value='<%: dt.Rows[i]["poids"].ToString() %>'><%: dt.Rows[i]["type"].ToString() %> (<%: dt.Rows[i]["poids"].ToString()%>)</option>
            <%
                    }
                }
             %>
            </select>

        <table border="1" cellpadding="2" cellspacing='0' style="margin-top:5px;"  bordercolor='#71c14e'>
            <tr bgcolor="#f7faae"> 
                <th width='80'>Nbr OT</th>
                <th width='100'>Nbr Colis</th>
                <th width='120'>Total Poids</th>
                <th width='120'>Total Volumes</th>
                <th width='120'>Total Km</th>
            </tr>


            <tr align="center"> <td> <span id="nbr_ots">0</td> 
            <td> <span id="nbr_colis">0</td> 
            <td> <span id="total_poids">0</td> 
            <td> <span id="total_volumes">0</td>
            <td> <span id="total_km">0</td></tr>
        </table>
        </div>

        <ul id="menuOT" style="float:right">
            <li><a class="lienHyper" id="btnPlan">Planifier</a></li>
        </ul>
    </div>
    
    <br clear="all" />

    <div style="overflow:overflow: auto;overflow-y: hidden;">
      <div id="dv_res" style='width:1450px;'>
        <% Response.Write(ViewData["table"].ToString()); %>

        <div style='float:left;width:450px;' >
                        <h3>Sans Tranche</h3>
                        <table width='100%' tbTrans=''>
                            <thead><tr>
                                <th>Heure</th>
                                <th>Dates</th>
                                <th>N° Bulletin</th>
                                <th>Client</th>
                                <th>NP, Ville</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </tr></thead>
                            <tbody>
                                <tr index='' colis='' weight='' volume='' Nbr='' date1='' date2='' pays=''>
                                    <td hours=''>&nbsp;</td>
                                    <td> <br /></td>
                                    <td> </td>
                                    <td> </td>
                                    <td> , </td>
                                    <td style='width:32px' icons=''>&nbsp;</td>
                                    <td><input type='checkbox' class='take' /></td>
                               </tr>
                            </tbody>
                </table>
         </div>
        <br clear="all" />
        <br />
        <br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
        </div>
    </div>

    <script type="text/javascript">
        var _poidsAutorise = 100;
        var _periodesNbr = parseInt('<%: ViewData["nbr"].ToString() %>') - 2;

        var old_res;
        var old_values = [];
        var tot_Poids = 0;



        $().ready(function () {

            $('#lstTypes').change(function () {
                _poidsAutorise = parseInt($(this).find("option:selected").val());
            });

            $('#lstTypes').change();

            $('.take').change(function () {
                var _res = $.fn.Calculate();
                if (_res) {
                    $.fn.setChecks();
                    $.fn.Calculate();
                }
            });

            $.fn.formatDate = function (h, m) {
                return ((h < 10) ? "0" + h : h) + ":" + ((m < 10) ? "0" + m : m);
            };

            $.fn.parseDate = function parseDate(input) {
                var part1 = input.split(' ');
                var p1 = part1[0].split("/");
                var p2 = part1[1].split(":");
                return new Date(parseInt(p1[2]), parseInt(p1[1]) - 1, parseInt(p1[0]), parseInt(p2[0]), parseInt(p2[1])); // Note: months are 0-based
            };

            $.fn.Calculate = function () {
                var weight = 0;
                var volume = 0;
                var nbr = 0;
                var km = 0;
                var colis = 0;
                var tab_values = [];
                var init = false;
                var nbr_periode_cons = 0;
                var dateBegin;

                $("#nbr_colis").html("0");
                $("#total_poids").html("0");
                $("#total_volumes").html("0");
                $("#total_km").html("0");


                $("table[from]").each(function () {

                    var tab = $(this);
                    $(tab).find("tr td[hours]").html("");
                    $(tab).find("tr td[icons]").html("");

                    var date1 = $(tab).attr("from");
                    var date2 = $(tab).attr("to");

                    var dateBegin1 = $.fn.parseDate(date1);

                    if (nbr_periode_cons == 0)
                        dateBegin = $.fn.parseDate(date1);
                    else {
                        if (dateBegin < dateBegin1)
                            dateBegin = dateBegin1;
                    }


                    var dateEnd = $.fn.parseDate(date2); // new Date(1999, 11, 11, parseInt(date2[0]), parseInt(date2[1]));

                    $(tab).find("input:checked'").each(function () {
                        var _elem = $(this).closest("tr");
                        var d1 = $.fn.formatDate(dateBegin.getHours(), dateBegin.getMinutes());

                        var _nbr = parseFloat($(_elem).attr("Nbr"));
                        var tmpTemps = dateBegin;
                        var tNbr = _nbr;

                        while (tNbr > 0) {
                            tmpTemps.setMinutes(tmpTemps.getMinutes() + 30);
                            if (tmpTemps.getHours() != 12)
                                tNbr--;
                        }

                        if (nbr_periode_cons + _nbr <= _periodesNbr) { //if (tmpTemps <= dateEnd) {

                            tab_values.push($(_elem).attr("index"));

                            dateBegin = tmpTemps;
                            var d2 = $.fn.formatDate(dateBegin.getHours(), dateBegin.getMinutes());
                            $(_elem).find("td:eq(0)").html(d1 + "<br />" + d2);

                            var _otid = $(_elem).attr("index");
                            var _volume = parseFloat($(_elem).attr("volume"));
                            var _weight = parseFloat($(_elem).attr("weight"));
                            var _colis = parseFloat($(_elem).attr("colis"));

                            var _date1 = $.fn.parseDate($(_elem).attr("date1"));
                            var _date2 = $.fn.parseDate($(_elem).attr("date2"));
                            var _adr = $(_elem).find("td:eq(4)").html() + ", " + $(_elem).attr("pays");
                            //alert(_adr);

                            $.post(SERVER_HTTP_HOST() + "RDV/getDistance", { adr: _adr }, function (htmlResult) {
                                km += parseFloat(htmlResult.replace(",", "."));
                                $("#total_km").html(km);
                            });

                            if ((_date1 >= dateBegin1 && _date1 <= dateEnd) || (_date2 >= dateBegin1 && _date2 <= dateEnd)) {
                                $(_elem).find("td[icons]").html("<img src='" + SERVER_HTTP_HOST()  + "Images/Respect_green.png' border='0' />");
                            }
                            else {
                                $(_elem).find("td[icons]").html("<img src='" + SERVER_HTTP_HOST() + "Images/Respect_red.png' border='0' />");
                            }

                            weight += _weight;
                            volume += _volume;
                            colis += _colis;
                            nbr++;
                            nbr_periode_cons += _nbr;
                        }
                        else {
                            //$(this).attr('checked', false);
                            alert("Dépassement de periodes");
                            init = true;
                        }

                    });

                });

                if (init == false && weight > _poidsAutorise) {
                    init = true;
                    alert("dépassement de poids (" + weight + ") max (" + _poidsAutorise + ")!");
                }


                if (init == false) {
                    tot_Poids = weight;
                    $("#nbr_ots").html(nbr);
                    $("#nbr_colis").html(colis);
                    $("#total_poids").html(weight);
                    $("#total_volumes").html(volume);

                    old_values = tab_values;
                }

                return init;
            };


            $.fn.setChecks = function () {
                $("table[from]").each(function () {
                    var tab = $(this);

                    $(tab).find("input:checked'").each(function () {
                        $(this).attr("checked", false);
                        var _id = $(this).closest("tr").attr("index");
                        if (jQuery.inArray(_id, old_values) > -1) {
                            $(this).attr("checked", true);
                        }
                    });
                });

            };


            $('table[tbTrans]').dataTable({
                "oLanguage": {
                    "sLengthMenu": "Afficher _MENU_ Lignes",
                    "sZeroRecords": "Aucu'un element ne correspond a votre recherche",
                    "sInfo": "Voir _START_ a _END_ de _TOTAL_ Lignes",
                    "sInfoEmpty": "Voir 0 a 0 de 0 Lignes",
                    "sInfoFiltered": "(Filtrer de _MAX_ Lignes)"
                },
                "sPaginationType": "full_numbers"
            });

            $("#btnPlan").click(function () {
                var nbr = 0;
                var _effNbr = 0;
                $("table[from]").each(function () {

                    $(this).find("input:checked'").each(function () {
                        nbr++;

                        var _elem = $(this).closest("tr");
                        var _otid = $(_elem).attr("index");
                        var _periode = $(_elem).find("td:eq(0)").html().substring(0, 5);



                        $.post(SERVER_HTTP_HOST() + "Ajout/addPlan", function (htmlResult) {
                            if (htmlResult != "0") {
                                $.post(SERVER_HTTP_HOST() + "Ajout/addPeriode", { planID: htmlResult, periode: _periode, otid: _otid }, function (data) {
                                    if (data != "0") {
                                        _effNbr++;

                                        if (nbr == _effNbr) {
                                            document.location.href = SERVER_HTTP_HOST()  + "RDV/detailPlan/" + htmlResult;
                                        }
                                    }
                                });
                            }
                            else
                                alert("Erreur !");
                        });
                    });

                });

                /*
                
                });*/
            });

        });

    </script>

</asp:Content>
