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
        
        .element	{  
			position: fixed;
        top: 10%;
        left: 1%; 
		}
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

                    <div class="col-md-4">
                        <div class="input-group" style="margin:5px 0px">
                            <span class="input-group-addon" style="width:140px;text-align:left">BL</span>
                            <input type="text" class="form-control" name="BL_search" id="BL_search" placeholder="BL" aria-describedby="basic-addon1" />

                        </div>
                    </div>
                </div>
                <div id="lstWeeksN"></div>
                <div id="lstWeeks"></div>
                
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

				<!--
                <div class="text-right" id="dvZoomAction" style="visibility:hidden">
					<span object="Action" action="Zoom" data="'0.6'" data-toggle="tooltip" data-placement="top" title="Voir tous" class="glyphicon glyphicon-zoom-out spAct" style="color:#5bc0de"></span> 
					<span object="Action" action="Zoom" data="'0'" data-toggle="tooltip" data-placement="top" title="Voir une par une" class="glyphicon glyphicon-zoom-in spAct" style="color:#5bc0de"></span>
				</div>
				-->
				
				    <div id="dvZoomAction" style="visibility:hidden">
						<div class="row">
							<div class="col-sm-6">									
								<span object="Action" action="setMode" data="'0'" data-toggle="tooltip" data-placement="top" title="Mode client" class="glyphicon glyphicon-user spAct" style="color: #6bff9c;margin-right:7px;"></span> 
								<span object="Action" action="setMode" data="'1'" data-toggle="tooltip" data-placement="top" title="Mode Geo" class="glyphicon glyphicon-road spAct" style="color: #5bc0de; margin-right: 7px;"></span>  
								<span object="Action" action="openOrder" data="" data-toggle="tooltip" data-placement="top" title="Liste des ordres" class="glyphicon glyphicon-th-list spAct" style="color:#e8a233"></span> 

							</div>
							<div class="col-sm-6 text-right">
								<span object="Action" action="Zoom" data="'0.6'" data-toggle="tooltip" data-placement="top" title="Voir tous" class="glyphicon glyphicon-zoom-out spAct" style="color:#5bc0de"></span>
								<span object="Action" action="Zoom" data="'0'" data-toggle="tooltip" data-placement="top" title="Voir une par une" class="glyphicon glyphicon-zoom-in spAct" style="color:#5bc0de"></span>
							</div>
						</div>
					</div>
				
                
                <div class="mainAccord">
                    <div class="panel-group" id="accordion1" style="margin:20px 0px"></div>
                </div>

				<!--
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
                -->
				
			<div id="dvFlotPanel" class="element window" style="width: 350px; z-index: 600100; background: #fff; /*border:1px solid red;width:90%;*/ height: 550px; /*position:absolute;z-index:600100;background:#fff;*/ margin-auto;">
				<div class="titlebar" style="background: #ddd; text-align: center; cursor: move; border-bottom: 1px solid #ccc">Liste des ordres</div>

				<div class="row">
					<div class="col-sm-6">
						<a href="#" class="badge" cvalue="close" id="btnCloseOpen"><<</a>
					</div>

					<div class="col-sm-6" style="text-align:right">
						<span id="btnsetModeOrder" style="color: gray;cursor:pointer;" class="glyphicon glyphicon-fullscreen"></span>
					</div>
				</div>
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

					<div id="orderPanel" style="height:470px;overflow:auto;"></div>
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
			    var selectedElem = undefined;
                var _ssDay = "<%: date1 %>";
				var winOrder = undefined;
				var modeOrder = "inner";
				
				var _nbr = 0;
                Date.prototype.getWeek = function () {
                    var onejan = new Date(this.getFullYear(), 0, 1);
                    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
                }

                function getWeekNumber(d) {
                    d = new Date(+d);
                    d.setHours(0, 0, 0, 0);
                    d.setDate(d.getDate() + 4 - (d.getDay() || 7));
                    var yearStart = new Date(d.getFullYear(), 0, 1);
                    var weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
                    return weekNo;
                }

                function getDateRangeOfWeek(weekNo) {
                    var d1 = new Date();
                    numOfdaysPastSinceLastMonday = eval(d1.getDay() - 1);
                    d1.setDate(d1.getDate() - numOfdaysPastSinceLastMonday);
                    var weekNoToday = d1.getWeek();
                    var weeksInTheFuture = eval(weekNo - weekNoToday);
                    d1.setDate(d1.getDate() + eval(7 * weeksInTheFuture));
                    var rangeIsFrom = eval(d1.getMonth() + 1) + "/" + d1.getDate() + "/" + d1.getFullYear();

                    //d1.setDate(d1.getDate() + 6);
                    //var rangeIsTo = eval(d1.getMonth() + 1) + "/" + d1.getDate() + "/" + d1.getFullYear();
                    //return rangeIsFrom + " to " + rangeIsTo;
                    return d1;
                };
				
				
				function openOrder() {
					let _cont = '<link href="' + $.fn.SERVER_HTTP_HOST() + 'Public/css/bootstrap.min.css" rel="stylesheet" />' +
							'<link href="' + $.fn.SERVER_HTTP_HOST() + 'Public/css/bootstrap-theme.min.css" rel="stylesheet" />' +

							'<link href="' + $.fn.SERVER_HTTP_HOST() + 'Public/Css/jquery-ui.min.css" rel="stylesheet" />' +

							'<link rel="stylesheet" href="' + $.fn.SERVER_HTTP_HOST() + 'Public/Plug/bootstrap-tagsinput.css">' +
							'<link rel="stylesheet" href="' + $.fn.SERVER_HTTP_HOST() + 'Public/Plug/app.css">' +

						'<div style="text-align:right">'+
						'    <span id="btnsetModeOrder1" style="color: gray;cursor:pointer;" class="glyphicon glyphicon-pushpin"></span>' +
						'</div>'+
					   '<div id="dvChildPanel" style="z-index:600100;">' +
					   ' <div id="dvSearchAction" class="input-group" style=" margin:5px 0px;padding:0px;">' +
					   '     <span class="input-group-addon" style="text-align:left">Rechercher</span>' +
					   '     <input type="text" class="form-control" name="orderTxtSearch" id="orderTxtSearch" placeholder="Rechercher" aria-describedby="basic-addon1">' +
					   ' </div>' +

					   ' <div class="input-group" style="margin:5px 0px;padding:0px;" id="dvOrderSort">' +
					   '     <span class="input-group-addon" style="text-align:left">Trier </span>' +
					   '     <input type="text" class="form-control" name="orderTxtSort" id="orderTxtSort" placeholder="Trier" aria-describedby="basic-addon1">' +
					   '     <span class="input-group-btn">' +
					   '         <button class="btn btn-default" type="button">' +
					   '             <span class="glyphicon glyphicon-sort-by-order-alt" val="+" aria-hidden="true"></span>' +
					   '         </button>' +
					   '     </span>' +
					   ' </div>' +

					   ' <div id="orderPanel"></div>' +
					   '</div>';

					if ((winOrder == null) || (winOrder.closed)) winOrder = window.open("", "winOrder");
					$(winOrder.document.body).html(_cont);

					winOrder.document.title = "Liste des ordres";
					winOrder.focus();
				}
	
	
                $(document).ready(function () {
				
					$("#dvFlotPanel").css("left", $(window).width() - $("#dvFlotPanel").width() - 20 + "px");
					
					 if(modeOrder == "outer")
						openOrder();
			
					
                    $('input.DSdate').datetimepicker({
                        locale: 'fr',
                        format: 'DD/MM/YYYY'
                    });

					$("#btnsetModeOrder").click(function () {

					modeOrder = "outer";
					openOrder();


					let tags = $('#orderTxtSearch').tagsinput('items');
					$(winOrder.document.body).find("#orderTxtSearch").val(tags);

					tags = $('#orderTxtSort').tagsinput('items');
					let _tags = "";
					for (let i = 0; i < tags.length ; i++) {
						_tags += tags[i].label + ",";
					}
					if (_tags.length > 1) _tags = _tags.substring(0, _tags.length - 1);
					
					$(winOrder.document.body).find("#orderTxtSort").val(_tags);
					

					$("#dvFlotPanel").css("display", "none");

					$.fn.setActionFeature();
					$.fn.setDragFeature();
					$.fn.setOrderOptions();


					$().PropOrder("refresh");

					return false;
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
							 $("#dvFlotPanel").css("display", "none");
							/*
                            $("#dvFlotPanel").css("width", "30px");
                            $("#dvChildPanel").css("display", "none");
                            $(this).html(">>").attr("cValue", "open");
							*/
                        }
                        else {
							$("#dvFlotPanel").css("display", "");
							/*
                            $("#dvFlotPanel").css("width", "98%");
                            $("#dvChildPanel").css("display", "");
                            $(this).html("<<").attr("cValue", "close"); 
							*/
                        }

                        return false;
                    });

                    var _dToday = new Date();
					
					var _sToday = moment(_dToday).format('DD/MM/YYYY');
					
                    _dToday.setDate(_dToday.getDate() + 1);
					
                    if (_ssDay == "") _ssDay = moment(_dToday).format('DD/MM/YYYY');

                    $.fn.drawWeeks = function () {
            var nWeek = getWeekNumber(moment(_ssDay, 'DD/MM/YYYY').toDate());// moment(_ssDay, 'DD/MM/YYYY').toDate());
            var d1 = getDateRangeOfWeek(nWeek);
            var lsDay = ['lu', 'ma', 'me', 'je', 've', 'sa', 'di'];

            let _html = "<div class='row'>";

            let _html1 = "<div class='row'>";
            for (let j = 1; j <= 5; j++) {

                _html += "<div class='col-sm-2 text-center' style='border-right:1px solid red'>" + nWeek + "</div>";

                _html1 += "<div class='col-sm-2' style='border-right:1px solid red'>";

                for (let i = 0 ; i < 6 ; i++) {
                    let _wDate = moment(d1).format('DD/MM/YYYY')
                    _html1 += "<span data-toggle='tooltip' data-placement='top' title='" + _wDate + "' date='" + _wDate + "' style='" + ((_sToday == _wDate)? 'color:#0f8bc4;font-weight:bold;' : '') + "padding:2px;margin:0px 5px;cursor:pointer'>" + lsDay[i] + "</span>";
                    d1.setDate(d1.getDate() + 1);
                }

                _html1 += "</div>";

                ///$("#lstWeeks").append(" <span style='color:red'>|</span> ");

                nWeek++;
                d1 = getDateRangeOfWeek(nWeek);
            }

            _html += "<div class='col-sm-2'></div>";
            _html += "</div>";

            _html1 += "<div class='col-sm-2'></div>";
            _html1 += "</div>";

            $("#lstWeeks").html(_html1);
            $("#lstWeeksN").html(_html);
			
			$("span[date]").click(function () {
                $("#Date_Debut_search").val($(this).attr("date"));
                $('#btnSearch').click();
            });
        };

        $.fn.drawWeeks();

        $("#BL_search").keypress(function (e) {
            if (e.which == 13) {
                let val = $(this).val();
                if (val == "") {
                    $.fn.drawWeeks();
                    return false;
                }

                $.ajax({
                    url:  $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/searchBL',
                    data: { bl: val },
                    dataType: 'json',
                    type: "GET",
                    success: function (data) {
                        let _html = "<div class='row' style='margin-top:10px;padding-left:5px'>";
                        for (let i = 0; i < data.length ; i++) {
                            _html += " <span data-toggle='tooltip' data-placement='top' title='" + data[i].date + "' date='" + data[i].date + "' idx='" + data[i].id + "' style='border:1px solid #c9cccb;border-radius:5px;padding:5px;margin:0px 7px 0px 10px;cursor:pointer'>" + data[i].id + "</span>";
                        }

                        _html += "</div>";

                        $("#lstWeeks").html(_html);
                        $("#lstWeeksN").html("");

                        $("span[date]").click(function () {

                            $("span[date]").css("background", "#fff");
                            $(this).css("background", "#eaddaf");

                            let _id = $(this).attr("idx");
                            let _date = $(this).attr("date");

                            points = [];
                            waypts = [];
                            wayptsIds = [];

                            $("#accordion1").html("");
                            $().Action('getPlan', _id);

							//console.log(result.plans[0].date);
							
							
							
                            if ($('table[plantable]').length > 0) {
                                $("#dvOrderSort").css("visibility", "visible");
                                $("#dvZoomAction").css("visibility", "visible");
                                $("#dvSearchAction").css("visibility", "visible");
                                $().Action('getPropOrders', 'date:' + $("#Date_Debut_search").val());
                                $('a[data-toggle="collapse"]:eq(0)').click();
                                $.fn.setDragFeature();
                                $.fn.setActionFeature();
								if (_nbr == 0) 
									$.fn.setOrderOptions();
								else
									$().PropOrder('refresh');
                            }
                            else {
                                $("#dvOrderSort").css("visibility", "hidden");
                                $("#dvZoomAction").css("visibility", "hidden");
                                $("#dvSearchAction").css("visibility", "hidden");
                                $("#accordion1").html("Aucune résultat !");
                            }

                        });
						
						_nbr++;

                    },
                    async: false
                });
            }
        });


  
		
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
                        $this.button('loading');
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
                                if (_nbr == 0) 
									$.fn.setOrderOptions();
								else
									$().PropOrder('refresh');
                            }
                            else {
                                $("#dvOrderSort").css("visibility", "hidden");
                                $("#dvZoomAction").css("visibility", "hidden");
                                $("#dvSearchAction").css("visibility", "hidden");
                                $("#accordion1").html("Aucune résultat !");
                            }

                            $this.button('reset');
							_nbr++;
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
                    urls['getUpdatePlanStatus'] = $.fn.SERVER_HTTP_HOST() + 'PlanningPlug/getUpdatePlanStatus';


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
					
					//$("#btnCloseOpen").click();
					
				var windows = document.querySelectorAll('.window');
					[].forEach.call(windows, function (win) {
						var title = win.querySelector('.titlebar');
						title.addEventListener('mousedown', function (evt) {

							var real = window.getComputedStyle(win),
								winX = parseFloat(real.left),
								winY = parseFloat(real.top);

							var mX = evt.clientX,
								mY = evt.clientY;

							document.body.addEventListener('mousemove', drag, false);
							document.body.addEventListener('mouseup', function () {
								document.body.removeEventListener('mousemove', drag, false);
							}, false);

							function drag(evt) {
								win.style.left = winX + evt.clientX - mX + 'px';
								win.style.top = winY + evt.clientY - mY + 'px';
							};

						}, false);
					});
                });
            </script>


            
</asp:Content>
