<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Planning
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    string date1 = (Session["Plug_date1"] != null)? Session["Plug_date1"].ToString() : "";
    string showCurrent = Session["showaOnlyCurrentAgence"] == null ? null : Session["showaOnlyCurrentAgence"].ToString();
    string s = "";
 %>
    <link rel="stylesheet" href="../Public/Plug/bootstrap-tagsinput.css">
    <link rel="stylesheet" href="../Public/Plug/app.css">

    <style>
        .btn-circle {
            width: 30px;
            height: 30px;
            text-align: center;
            padding: 6px 0;
            font-size: 12px;
            line-height: 1.42;
            border-radius: 15px;
        }

        .flash {
            background: orange;
        }

        span[action] {
            cursor: pointer;
            color: #000;
        }

        span[data-toggle="tooltip"], span.spAct {
            cursor: pointer;
        }

        span.specSpanAction {
            color: #5bc0de;
        }
        
        .element	{ position:fixed; top:60%; left:1%; }
    </style>
    <div class="container-fluid">

        <div class="panel panel-primary">
            <!-- Default panel contents -->
            <div class="panel-heading" id="dv_head_search">
                <span class="glyphicon glyphicon-search" aria-hidden="true"></span> Recherche
                <span style="float:right" id="btnCloseSearch" class="glyphicon glyphicon glyphicon-chevron-up cursor" aria-hidden="true"></span>
            </div>

            <div style="padding:10px" class="panel-body">

                <div class="row">

                    <div class="col-md-4">
                        <div class="input-group" style="margin:5px 0px">
                            <span class="input-group-addon" style="width:140px;text-align:left">Date</span>
                            <input type="text" class="form-control DSdate" name="Date_Debut_search" id="Date_Debut_search" placeholder="Date début" aria-describedby="basic-addon1" />
                        </div>
                    </div>

                </div>
                
            </div>
            <div class="panel-footer">

                <div style="text-align:right">
                    <button class="btn btn-primary" id="btnSearch" type="button" data-loading-text="<i class='fa fa-spinner fa-spin '></i> En cours"><span class="glyphicon glyphicon-search" aria-hidden="true"></span> Rechercher </button>
                </div>

            </div>
        </div>
                <div>
                        <input type="checkbox" id="ch_getCurrentAgenceOTs" <%: string.IsNullOrEmpty(showCurrent) ? "" : "checked='checked'" %>/>  Afficher les dossiers du dépot actuel 
                </div>

                <div id="dvErrors" class="alert alert-danger alert-dismissable fade in">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>title : </strong> <span aContent=''>content error</span>
                </div>

                <div class="text-right" id="dvZoomAction" style="visibility:hidden"><span object="Action" action="Zoom" data="'0.6'" data-toggle="tooltip" data-placement="top" title="Voir tous" class="glyphicon glyphicon-zoom-out spAct" style="color:#5bc0de"></span> <span object="Action" action="Zoom" data="'0'" data-toggle="tooltip" data-placement="top" title="Voir une par une" class="glyphicon glyphicon-zoom-in spAct" style="color:#5bc0de"></span></div>
                
                <div class="mainAccord">
                    <div class="panel-group" id="accordion1" style="margin:20px 0px"></div>
                </div>

                <div id="dvFlotPanel" class="element" style="z-index:600100;background:#fff; /*border:1px solid red;width:90%;*/height:250px;/*position:absolute;z-index:600100;background:#fff;*/margin-auto">
                    <a href="#" class="badge" cValue="close" id="btnCloseOpen"><<</a>
                    <div id="dvChildPanel" style="z-index:600100;">
                        <div id="dvSearchAction" class="input-group" style="visibility:hidden; margin:5px 0px;padding:0px;">
                            <span class="input-group-addon" style="text-align:left">Rechercher</span>
                            <input type="text" class="form-control" name="orderTxtSearch" id="orderTxtSearch" placeholder="Rechercher" aria-describedby="basic-addon1">
                        </div>

                        <div class="input-group" style="margin:5px 0px;padding:0px;visibility:hidden" id="dvOrderSort">
                            <span class="input-group-addon" style="text-align:left">Trier </span>
                            <input type="text" class="form-control" name="orderTxtSort" id="orderTxtSort" placeholder="Trier" aria-describedby="basic-addon1">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button">
                                    <span class="glyphicon glyphicon-sort-by-order-alt" val="+" aria-hidden="true"></span>
                                </button>
                            </span>
                        </div>

                        <div id="orderPanel" style="height:170px;overflow:auto;"></div>
                    </div>
                </div>
                
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <div id="debugPanel"></div>

            </div>

            <!-- <input type="button" class="mission" value="rupture" /> -->
            <br />


            <script src="../Public/Plug/moment-with-locales.js"></script>

            <script src="../Public/Plug/typeahead.bundle.min.js"></script>
            <script src="../Public/Plug/bootstrap-tagsinput.min.js"></script>

            <script src="../Public/Plug/configPlug.js"></script>
            <script src="../Public/Plug/ActionPlug.js"></script>
            <script src="../Public/Plug/featurePlug.js"></script>
            <script src="../Public/Plug/BlockPlug.js"></script>
            <script src="../Public/Plug/PlanPlug.js"></script>
            <script src="../Public/Plug/OrderPlug.js"></script>
            <script src="../Public/Plug/PropOrderPlug.js"></script>
            <script src="../Public/Plug/Tools.js"></script>
            <script src="../Public/Js/jquery-ui.min.js"></script>
            <script src="../Public/Plug/diacritics.js"></script>
            <script src="../Public/Plug/bootstrap-dropdown-filter.js"></script>


            <style>
                .myTopScroll {
                    border: none 0px RED;
                    overflow: auto;
                    height: 20px;
                }

                .MyTansP {
                    opacity: 1;
                    filter: Alpha(opacity=100);
                }

                .sIcon {
                    font-size: 11px;
                }
                
                .popover{
                    max-width: 300px; 
                }
            </style>

            <script>
                var _ssDay = "<%: date1 %>";
                $(document).ready(function () {
                    $('input.DSdate').datetimepicker({
                        locale: 'fr',
                        format: 'DD/MM/YYYY'
                    });


                    $('#ch_getCurrentAgenceOTs').on('change', function () {
                        if (this.checked) {
                            $.get($.fn.SERVER_HTTP_HOST() + "Orders/SetShowCurrent/", { show: '1' }, function (r) {
                                $().Action('getPropOrders', 'date:' + $("#Date_Debut_search").val());
                            });
                        }
                        else {
                            $.get($.fn.SERVER_HTTP_HOST() + "Orders/SetShowCurrent/", { show: '0' }, function (r) {
                                $().Action('getPropOrders', 'date:' + $("#Date_Debut_search").val());
                            });
                        }
                    }); 


                    $("#btnCloseOpen").click(function () {
                        var _vv = $(this).attr("cValue");
                        if (_vv == "close") {
                            $("#dvFlotPanel").css("width", "30px");
                            $("#dvChildPanel").css("display", "none");
                            $(this).html(">>").attr("cValue", "open");
                        }
                        else {
                            $("#dvFlotPanel").css("width", "98%");
                            $("#dvChildPanel").css("display", "");
                            $(this).html("<<").attr("cValue", "close"); ;
                        }

                        return false;
                    });

                    var _dToday = new Date();
                    _dToday.setDate(_dToday.getDate() + 1);

                    if (_ssDay == "") _ssDay = moment(_dToday).format('DD/MM/YYYY');

                    $("#Date_Debut_search").val(_ssDay);
                    //$("#Date_Debut_search").val('25/10/2016');

                    $("#dv_head_search").css("cursor", "pointer");
                    $("#dv_head_search").click(function () {
                        $(this).closest("div.panel-primary").find("div.panel-body").slideToggle("fast");
                        $(this).closest("div.panel-primary").find("div.panel-footer").toggle("fast");

                        $("#btnCloseSearch").toggleClass("glyphicon-chevron-up glyphicon-chevron-down");
                    });

                    $('#btnSearch').on('click', function () {
                        var $this = $(this);
                        //$this.button('loading');
                        setTimeout(function () {
                            $("#accordion1").html("");
                            $().Action('getPlans', $("#Date_Debut_search").val(), $("#Date_Debut_search").val());

                            if ($('table[plantable]').length > 0) {
                                $("#dvOrderSort").css("visibility", "visible");
                                $("#dvZoomAction").css("visibility", "visible");
                                $("#dvSearchAction").css("visibility", "visible");
                                $().Action('getPropOrders', 'date:' + $("#Date_Debut_search").val());
                                $('a[data-toggle="collapse"]:eq(0)').click();
                                $.fn.setDragFeature();
                                $.fn.setActionFeature();
                                $.fn.setOrderOptions();
                            }
                            else {
                                $("#dvOrderSort").css("visibility", "hidden");
                                $("#dvZoomAction").css("visibility", "hidden");
                                $("#dvSearchAction").css("visibility", "hidden");
                                $("#accordion1").html("Aucune résultat !");
                            }

                            $this.button('reset');
                        }, 300);
                    });

                    $('#btnSearch').click();

                    var urls = [];
                    urls['addPlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/addPlan';
                    urls['getPlanOrders'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getPlanOrders';
                    urls['updatePlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/updatePlan';
                    urls['removePlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/removePlan';
                    urls['insertOTToPlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/insertOTToPlan';
                    urls['removeOTfromPlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/removeOTfromPlan';
                    urls['getPlans'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getPlans';
                    urls['getPlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getPlan';
                    urls['getPropOrders'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getPropOrders';
                    urls['detailOT'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/AfficherOT';
                    urls['getChangeVehicule'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getChangeVehicule';
                    urls['getChangeDriver'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getChangeDriver';
                    urls['getChangeHelpers'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getChangeHelpers';
                    urls['printPlanPDF'] = $.fn.SERVER_HTTP_HOST() + 'RDV/optionPrintPlan';
                    urls['printPlans'] = $.fn.SERVER_HTTP_HOST() + 'RDV/RdvExportPalnning';
                    urls['OrderPreview'] = $.fn.SERVER_HTTP_HOST() + 'OT/afficherOT';
                    urls['OrderDetail'] = $.fn.SERVER_HTTP_HOST() + 'OT/afficherOT';
                    urls['setMission'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/setMission';
                    urls['PrintMission'] = $.fn.SERVER_HTTP_HOST() + 'RDV/optionPrintPlan';
                    urls['updatePropOrder'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/updatePropOrder';
                    urls['getStatus'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getStatus';
                    urls['sendPlan'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/sendPlanGps';
                    urls['sendPlanJobs'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/sendPlanJobs';
                    urls['getPlanInf'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getPlanInf';
                    urls['updatePlanStatus'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/updatePlanStatus';
                    urls['showMissionInf'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/showMissionInf';
                    $().Action("init", urls);

                    //$().Action('getPlan', 41);                    
                    /*
                    $(".mission").click(function () {
                    $().Plan("Rup", moment('25/10/2016', 'DD/MM/YYYY').toDate())
                    });
                    */
                    /*
                    $(window).scroll(function () {
                    console.log($(window).scrollTop() + " - " + $(window).height());
                    $("#dvFlotPanel").css("top", ($(window).scrollTop() + $(window).height() - 250) + "px");
                    });
                    */
					
					$("#btnCloseOpen").click();
                });
            </script>


            
</asp:Content>
