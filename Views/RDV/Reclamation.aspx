<%@ Page  Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content3" ContentPlaceHolderID="TitleContent" runat="server">
	Reclamation
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">    
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
             width:140px;
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
         
         table tr td
         {
             font-weight :bold;
         }
    </style>

    <div id="container">

        <br />
        <ul id="menuOT" style="margin-left:80px">
            <li style="width:60px"><a id="validate" style="cursor:pointer" >Valider</a></li>
            <li style="width:60px; margin-left:125px;"><a id="btn_PDF" style="cursor:pointer;visibility:hidden" >PDF</a></li>
        </ul>

        <input type="hidden" id="otid" value="<%: (ViewData["otid"] != null)? ViewData["otid"] : "" %>" />
        <input type="hidden" id="planid" value="<%: (ViewData["planid"] != null)? ViewData["planid"] : "" %>" />

        <br clear="both" />
        <table border="0" cellpadding="3" style="margin-left:80px">
            <tr>
                <td>FICHE DE RECLAMATION N°</td>
                <td><input type="text" id="id" value="<%: (ViewData["id"] != null)? ViewData["id"] : "" %>" style="width:250px" /></td>
            </tr>
            <tr valign="top">
                <td>N° Bulletin</td>
                <td><input type="text" id="nobl" value="<%: (ViewData["nobl"] != null)? ViewData["nobl"] : "" %>" readonly="readonly" style="width:250px" /></td>
            </tr>
            <tr>
                <td>Date de la livraison </td>
                <td><input type="text" id="date" value="<%: (ViewData["date"] != null)? ViewData["date"] : "" %>" readonly="readonly" style="width:250px" /></td>
            </tr>
            <tr valign="top">
                <td>Chauffeur</td>
                <td><input type="text" id="chauffeur" value="<%:  ((ViewData["chauffeur"] != null)? ViewData["chauffeur"] : "") + " (" + ViewData["planid"] + ")" %>" readonly="readonly" style="width:250px" /></td>
            </tr>
            <tr valign="top">
                <td>Aides</td>
                <td><input type="text" id="Text2" value="<%: (ViewData["aides"] != null)? ViewData["aides"] : "" %>" readonly="readonly" style="width:250px" /></td>
            </tr>
            <tr>
                <td>Donneur d'ordre</td>
                <td><input type="text" id="donneur" value="<%: (ViewData["donneur"] != null)? ViewData["donneur"] : "" %>" readonly="readonly" style="width:250px" /></td>
            </tr>

            <tr>
                <td>N° SAMS</td>
                <td><input type="text" id="sams" value="<%: (ViewData["sams"] != null)? ViewData["sams"] : "" %>" style="width:250px" /></td>
            </tr>

            <tr>
                <td>Nom & prénom du Client</td>
                <td><input type="text" id="client" value="<%: (ViewData["client"] != null)? ViewData["client"] : "" %>" readonly="readonly" style="width:250px" /></td>
            </tr>

            <tr>
                <td>NP & Ville</td>
                <td><input type="text" id="ville" value="<%: (ViewData["ville"] != null)? ViewData["ville"] : "" %>" readonly="readonly" style="width:250px" /></td>
            </tr>

            <tr>
                <td>Description du problème</td>
                <td><textarea cols="" rows="" id="description" style="width:250px"><%: (ViewData["description"] != null) ? ViewData["description"] : ""%></textarea></td>
            </tr>

            <tr>
                <td>Décision du fournisseur</td>
                <td><textarea cols="" rows="" id="decision" style="width:250px"><%: (ViewData["decision"] != null) ? ViewData["decision"] : ""%></textarea></td>
            </tr>

            <tr valign="top">
                <td>statistique</td>
                <td>

                    <select id="statistique" style="width:250px">
                    <% 
                        System.Data.DataTable _statistiques = (System.Data.DataTable) ViewData["_statistique"];
                        string _values = ""; 
                        if(_statistiques != null){
                            for (int i = 0; i < _statistiques.Rows.Count; i++)
                            {
                                _values += "<option>" + _statistiques.Rows[i]["name"] + "</option>";
                            }
                        }
                        
                    %>
                    <% Response.Write(_values); %>
                    </select>
                    <a id="btn_add" style="cursor:pointer">Ajouter</a>

                    <div id="lstStatistique">

                    </div>
                </td>
            </tr>

            <tr>
                <td>Si 2<sup>ème</sup> livraison <input type="checkbox" id="liv2" <%: (ViewData["liv2"] != null) ? ((ViewData["liv2"].ToString() == "1")? "checked='checked'" : "") : "checked='checked'"%>  /></td>
                <td>
                    Montage 
                    <%
                        string type = (ViewData["type"] != null) ? ViewData["type"].ToString() : "";
                    %>
                    <select id="type" style="width:195px">
                        <option value="0"> </option>
                         <% 
                             System.Data.DataTable _montages = (System.Data.DataTable)ViewData["_montages"];
                            _values = "";
                            if (_montages != null)
                            {
                                for (int i = 0; i < _montages.Rows.Count; i++)
                                {
                                    _values += "<option " + ((type == _montages.Rows[i]["name"].ToString()) ? "selected='selected'" : "") + ">" + _montages.Rows[i]["name"] + "</option>";
                                }
                            }
                        %>
                       <% Response.Write(_values); %>

                    </select><br />
                    <input style="width:190px" type="text" id="periode" value="<%: (ViewData["periode"] != null)? ViewData["periode"] : "" %>" /> Périodes.
                </td>
            </tr>

            <tr>
                <td>Contact chez Dupperrex</td>
                <td><input style="width:250px" type="text" id="contact1" value="<%: (ViewData["contact1"] != null)? ViewData["contact1"] : Session["login"]  %>" /></td>
            </tr>

            <tr>
                <td>Contact chez le Fournisseur</td>
                <td><input style="width:250px" type="text" id="contact2" value="<%: (ViewData["contact2"] != null)? ViewData["contact2"] : "" %>" /></td>
            </tr>

            <tr>
                <td>Suivi du dossier</td>
                <td><textarea style="width:250px" cols="" rows="" id="suivi"><%: (ViewData["suivi"] != null) ? ViewData["suivi"] : ""%></textarea></td>
            </tr>

            <tr>
                <td>Comportement de l'équipe (livraison ou montage)</td>
                <td><textarea style="width:250px" cols="" rows="" id="comportement"><%: (ViewData["comportement"] != null) ? ViewData["comportement"] : ""%></textarea></td>
            </tr>
            
            <tr>
                <td colspan="2">
                    <br />
                        <hr bgcolor="green" width="100%">
                    <br />
                </td>

            </tr>

            <tr>
                <td>Résultat</td>
                <td>
                    <%
                        string resultat = (ViewData["resultat"] != null) ? ViewData["resultat"].ToString() : "";
                    %>
                    <select id="resultat" style="width:195px">
                        <option <%: (resultat=="")? "selected='selected'" : "" %>></option>
                         <% 
                             System.Data.DataTable _resultats = (System.Data.DataTable)ViewData["_resultats"];
                            _values = "";
                            if (_resultats != null)
                            {
                                for (int i = 0; i < _resultats.Rows.Count; i++)
                                {
                                    _values += "<option " + ((resultat == _resultats.Rows[i]["name"].ToString()) ? "selected='selected'" : "") + ">" + _resultats.Rows[i]["name"] + "</option>";
                                }
                            }
                        
                        %>
                        <% Response.Write(_values); %>

                    </select><br />
                </td>
            </tr>

            <tr>
                <td>Coût</td>
                <td><input type="text" id="cout" value="<%: (ViewData["cout"] != null)? ViewData["cout"] : "" %>"  style="width:250px" /></td>
            </tr>

            <tr>
                <td>Periodes</td>
                <td><input type="text" id="periodes" value="<%: (ViewData["periodes"] != null)? ViewData["periodes"] : "" %>" style="width:250px" /></td>
            </tr>
          <tr>
                <td colspan="2">                    
                    <a style="margin-right:10px;" href="<%:  (ViewData["image1"] == null)? "" : ViewData["image1"] %>" target="_blank"><img id="imgRec" src="<%:  (ViewData["image1"] == null)? "" : ViewData["image1"] %>" width="150" /></a>
                    <a href="<%:  (ViewData["image2"] == null)? "" : ViewData["image2"] %>" target="_blank"><img id="imgRec2" src="<%:  (ViewData["image2"] == null)? "" : ViewData["image2"] %>" width="150" /></a>
                </td>
            </tr>
        </table>

         <%
                string sp = (ViewData["statistique"] != null) ? ViewData["statistique"].ToString() : "";
             %>
        <div style="visibility:hidden" id="sp"><%: sp %></div>
    </div>
    <script type="text/javascript" charset="ISO-8859-1">

        $().ready(function () {

            if ($("#id").val() != "0") {
                $("#btn_PDF").css("visibility", "visible");
            }

            $("#btn_PDF").click(function () {
                window.open(SERVER_HTTP_HOST() + "RDV/printReclamation?id=" + $("#id").val());
            });

            $("#imgRec")
            .error(function () { $("#imgRec").hide(); });

            $("#imgRec2")
            .error(function () { $("#imgRec2").hide(); });

            var _lstStat = [];
            var _sp = $("#sp").html();
            jQuery.fn.verify = function (array, val) {
                var ok = -1;
                for (var i = 0; i < array.length; i++) {
                    if (array[i] == val) {
                        ok = i;
                        break;
                    }
                }
                return ok;
            };

            jQuery.fn.getStat = function (array) {
                var str = "";
                for (var i in array) {
                    if (array[i] == "") continue;

                    str += array[i] + "|";
                }

                if (str != "") str = str.substring(0, str.length - 1);
                return str;
            };

            $("#btn_add").click(function () {
                var _statistique = $("#statistique option:selected").text();
                jQuery.fn.addItem(_statistique);
            });

            jQuery.fn.addItem = function (val) {
                if (jQuery.fn.verify(_lstStat, val) != -1)
                    alert("Existe déjà !");
                else {
                    _lstStat.push(val);
                    $("#lstStatistique").append("<div><a del='' style='color:red;cursor:pointer'>X</a> &nbsp;<span>" + val + "</span></div>");
                    jQuery.fn.removerFn();
                }
            };

            jQuery.fn.removerFn = function () {
                $("a[del]").not('.initialized').addClass('initialized').click(function () {
                    var _txt = $(this).closest("div").find("span").html()
                    var idx = jQuery.fn.verify(_lstStat, _txt);
                    $(this).closest("div").remove();
                    _lstStat[idx] = "";
                });
            };

            $("#validate").click(function () {

                var _id = $("#id").val();
                var _otid = $("#otid").val();
                var _planid = $("#planid").val();
                var _sams = $("#sams").val();
                var _description = $("#description").val();
                var _decision = $("#decision").val();
                var _statistique = jQuery.fn.getStat(_lstStat);
                var _liv2 = ($("#liv2").attr('checked')) ? "1" : "0";
                var _type = $("#type option:selected").text();
                var _periode = $("#periode").val();
                var _contact1 = $("#contact1").val();
                var _contact2 = $("#contact2").val();
                var _suivi = $("#suivi").val();
                var _comportement = $("#comportement").val();

                if (_statistique.length < 2) {
                    alert("Veuillez ajouter une statistique !");
                    return;
                }

                if (_liv2 == "1") {
                    if (_type == "0" || _type == "" || _type == " ") {
                        alert("Veuillez choisir type montage !");
                        return;
                    }
                    else if (_type == "Avec Montage") {
                        if (_periode == "") {
                            alert("Veuillez saisir les périodes !");
                            return;
                        }
                    }
                }


                var _resultat = $("#resultat option:selected").text();
                var _cout = $("#cout").val();
                var _periodes = $("#periodes").val();



                $.get(SERVER_HTTP_HOST() + 'RDV/saveReclamation', {
                    id: _id,
                    otid: _otid,
                    planid: _planid,
                    sams: _sams,
                    description: _description,
                    decision: _decision,
                    statistique: _statistique,
                    type: _type,
                    periode: _periode,
                    contact1: _contact1,
                    contact2: _contact2,
                    suivi: _suivi,
                    liv2: _liv2,
                    comportement: _comportement,
                    resultat: _resultat,
                    cout: _cout,
                    periodes: _periodes,
                    oldNbr: _oldNbr,
                    oldStr: _sp
                }, function (data) {
                    if (data != "0") {
                        alert("Opération réussite !");
                         $("#btn_PDF").css("visibility", "visible");
                         $("#id").val(data);
                    } else
                        alert("Erreur !");
                });
            });


            var sta = $("#sp").html().split('|');
            for (var i in sta) {
                if (sta[i] == "") continue;
                jQuery.fn.addItem(sta[i]);
            }

            var _oldNbr = _lstStat.length;
            //alert(_oldNbr);

        });
            
    </script>
 
</asp:Content>