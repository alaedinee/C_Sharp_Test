(function ($) {	
	var defaults = { urls: {} };
	
	var methods = {
		init : function(settings){
			if(settings != undefined) 
			    defaults = { urls: settings };
			else {
				defaults.urls['addPlan'] = 'http://localhost/plan/addPlan';
				defaults.urls['getPlan'] = 'http://localhost/plan/getPlan';
				defaults.urls['updatePlan'] = 'http://localhost/plan/updatePlan';
				defaults.urls['removePlan'] = 'http://localhost/plan/removePlan';
				defaults.urls['insertOTToPlan'] = 'http://localhost/plan/insertOTToPlan';
				defaults.urls['removeOTfromPlan'] = 'http://localhost/plan/removeOTfromPlan';
				defaults.urls['getPlans'] = 'http://localhost/plan/getPlans';
				defaults.urls['getPropOrders'] = 'http://localhost/plan/getPropOrders';
				defaults.urls['detailOT'] = 'http://localhost/plan/AfficherOT';
				defaults.urls['getChangeVehicule'] = 'http://localhost/plan/getVehicules';
				defaults.urls['getChangeDriver'] = 'http://localhost/plan/getDrivers';
				defaults.urls['getChangeHelpers'] = 'http://localhost/plan/getHelpers';
				defaults.urls['saveEditPlan'] = 'http://localhost/plan/saveEditPlan';
			}
		},
		addPlan : function(settings){
			/*
			$.ajax({ url: defaults.urls['addPlan'], data: {
				datefrom : settings.from , dateto : settings.to 
			}, dataType: 'json',
				success: function (result) {
					//console.log(result);
				    //var result = {id: 1666};
				    methods.getPlan(result.id);						
				},
				error: function(){
					alert("Error addPlan!")
				},
				async: false
			});		*/

		    $.ajax({
		        url: defaults.urls['addPlan'],
		        data: { datefrom: settings.from, dateto: settings.to },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            var result = data;
		            if (result.msg == 'Ok'){
		                //methods.getPlan(result.id);
						$("#Date_Debut_search").val(settings.from.substring(0, 10));
		                $('#btnSearch').click();
					}
		            else
		                alert("Erreur : " + msg);
		        },
		        async: false
		   });
		},
		saveEditPlan: function (settings) {
		    
		    $.ajax({
		        url: defaults.urls['saveEditPlan'],
		        data: {id: settings.id,  datefrom: settings.from, dateto: settings.to },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            var result = data;
		            if (result.msg == 'Ok') {
		                $("#Date_Debut_search").val(settings.from.substring(0, 10));
		                $('#btnSearch').click();
		            }
		            else
		                alert("Erreur : " + result.msg);
		        },
		        async: false
		   });
		},
		printPlan : function(planId){
            
		    $.ajax({
		        url: defaults.urls['printPlanPDF'],
		        data: { id: planId},		        
		        type: "GET",
		        success: function (data) {
		            
		            let htmlDialog = '<div class="modal fade" id="dialogPrintPlan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' +
					'	<div class="modal-dialog modal-sm">' +
					'		<div class="modal-content">		' +
					'			<div class="modal-header">' +
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
					'				<h4 class="modal-title" id="myModalLabel">Imprimer plan</h4>' +
					'			</div>' +
					'			<div class="modal-body">' + data + '</div>'  +                                    
					'			<div class="modal-footer">' +
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>' +
					'			</div>' +
					'		</div>' +
					'	</div>' +
					'</div>';

		            $("#dialogPrintPlan").remove();
		            $("body").append(htmlDialog);
		            $('#dialogPrintPlan').modal('show');
		        },
		        async: false
		    });
		},
		OrderDetail : function( id ){
		    open(defaults.urls['OrderDetail'] + '?mode=modifier&OTID=' + id);
		},
		printPlans: function (date) {
            open(defaults.urls['printPlans'] + '?date=' + date);
            /*
		    $.ajax({
		        url: defaults.urls['printPlans'],
		        data: { date: date },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {

		            let htmlDialog = '<div class="modal fade" id="dialogPrintPlans" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' +
					'	<div class="modal-dialog modal-sm">' +
					'		<div class="modal-content">		' +
					'			<div class="modal-header">' +
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
					'				<h4 class="modal-title" id="myModalLabel">Imprimer plans</h4>' +
					'			</div>' +
					'			<div class="modal-body">' +
					'			</div>' + data +

					'			<div class="modal-footer">' +
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>' +
					'			</div>' +
					'		</div>' +
					'	</div>' +
					'</div>';

		            $("#dialogPrintPlans").remove();
		            $("body").append(htmlDialog);
		            $('#dialogPrintPlans').modal('show');
		        },
		        async: false
		    });*/
		},
		Preview: function (id) {    //: '', country: '', address: '', zip: ''}
		    let options = $().Order("Get", id);
            //console.log(options);
            if(options.id != undefined){
             $("span[pop][data=\"'" + id + "'\"]").attr("data-content", "<div style='width:500px'><div><b>" + options.label + "</b></div>"+ 
                                                                           
                                                                          "<div>" + options.info.zip + " " + options.info.city + " " + options.info.country + "</div>" +
                                                                            "<div><small>Tél : " + options.info.tel + "</small></div></div>");
                                                                         //"<div><small>Zoom : " + options.zoom + "</small></div></div>");
             $("span[pop][data=\"'" + id + "'\"]").popover('show');

             /*
		        $.ajax({
		            url: defaults.urls['OrderPreview'],
		            data: { id: id },
		            dataType: 'json',
		            type: "GET",
		            success: function (data) {

		                $("span[pop][data=\"'" + id + "'\"]").attr("data", data);
		                $("span[pop][data=\"'" + id + "'\"]").popover('show');
                        
		                //$("#dialogPreviewOrder").remove();
		                //$("body").append(htmlDialog);
		                //$('#dialogPreviewOrder').modal('show');
		            },
		            async: false
		        });
              */

            }
		}, 
		showMissionInf: function (id, miss) {
		        $.ajax({
		            url: defaults.urls['showMissionInf'],
		            data: { id: id, miss: miss },
		            dataType: 'json',
		            type: "GET",
		            success: function (data) {
                        $("span[popMiss][pId='" + id + "'][mId='" + miss + "']").attr("data-content", "<div style='color:#000;width:100px'>"+                                                                            
                                                                            '<div><span data-toggle="tooltip" data-placement="top" title="Poids" class="glyphicon glyphicon-scale"></span> <span class="badge" style="font-size:14px;background:#d8d7d7">' + data.weight + "</span></div>" +
                                                                            '<div><span data-toggle="tooltip" data-placement="top" title="Volume" class="glyphicon glyphicon-resize-vertical"  ></span> <span class="badge" style="font-size:14px;background:#b9e0aa">' +  data.volume + "</span></div>" + 
                                                                            '<div><span data-toggle="tooltip" data-placement="top" title="Palette" class="glyphicon glyphicon-menu-hamburger" ></span> <span class="badge" style="font-size:14px;background:#f5dc9f">' +  data.palette + "</span></div>" + 
                                                                   "</div>");
                                                                         
                        $("span[popMiss][pId='" + id + "'][mId='" + miss + "']").popover('show');
		            },
		            async: false
		        });
		},
        Zoom: function (zoom) {
		    $("div.mainAccord").css("zoom", zoom);
		    $("div.mainAccord").css("-moz-transform", 'scale(' + zoom + ')');
		    $("div.mainAccord").css("-moz-transform-origin", '0 0');
		},
        setMode: function (value) {
		    
            if (value == "0") {
                $("span[infLabel]").css("visibility", "visible");
                /*Config.zoom = {
                    "1": "<div class='row'><div class='col-md-3'>{misIcons}</div><div {cData} class='col-md-6' style='font-size:9px'>{settings.label}</div><div class='col-md-3 pull-right text-right'>{icons}</div></div>",
                    "2": "<div class='row'><div class='col-md-2'>{misIcons}</div><div {cData} class='col-md-8' style='font-size:9px'>{settings.label}<br />{settings.info.zip} {settings.info.city}</div><div class='col-md-1'>{icons}</div></div>",
                    "3": "<div class='row'><div class='col-md-10' {cData}>{settings.info.country}</div><div class='col-md-2'>{icons}</div></div>"
                };*/
            }
            else {
                $("span[infLabel]").css("visibility", "hidden");
                /*
                Config.zoom = {
                    "1": "<div class='row'><div class='col-md-3'>{misIcons}</div><div {cData} class='col-md-6' style='font-size:9px'>{settings.info.zip} {settings.info.city}</div><div class='col-md-3 pull-right text-right'>{icons}</div></div>",
                    "2": "<div class='row'><div class='col-md-3'>{misIcons}</div><div {cData} class='col-md-6' style='font-size:9px'>{settings.info.zip} {settings.info.city}</div><div class='col-md-3 pull-right text-right'>{icons}</div></div>",
                    "3": "<div class='row'><div class='col-md-3'>{misIcons}</div><div {cData} class='col-md-6' style='font-size:9px'>{settings.info.zip} {settings.info.city}</div><div class='col-md-3 pull-right text-right'>{icons}</div></div>"
                };*/

            }

            //$("#btnSearch").click();

        },
		getPlan: function (planId) {
		    //alert(defaults.urls['getPlan']);
		    $.ajax({
		        url: defaults.urls['getPlan'],
		        data: { planId: planId },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            var result = data;
		            //var result = jQuery.parseJSON(data);

		            //alert(result.plans[0].date);
		            //alert(result.plans[0].from);
		            //alert(result.plans[0].to);

		            result.plans[0].date = moment(result.plans[0].date, "DD/MM/YYYY hh:mm").toDate();
		            result.plans[0].from = moment(result.plans[0].from, "DD/MM/YYYY hh:mm").toDate();
		            result.plans[0].to = moment(result.plans[0].to, "DD/MM/YYYY hh:mm").toDate();

		            let _tabM = result.plans[0].missions.split('|');
		            let missions = [];
		            for (let i = 0 ; i < _tabM.length ; i++) {
		                let _lineM = _tabM[i].split('-');
		                let _action = (_lineM[1] == "0")? "add" : "delete";
		                let _miss = { date: _lineM[0], id: _lineM[1], action: _action };
		                missions.push(_miss);
		            }
		            result.plans[0].missions = missions;
		            ////console.log(result.plans[0].missions);

		            $("#accordion1").Block();
		            $("#accordion1").Block('add', { date: result.plans[0].date, success: result.success, failed: result.failed });

		            ////console.log("ok");

		            
		            $().Plan('init', result.plans);
                    $().Plan('update', result.plans[0].date);
					
					methods.getPlanOrders(result.plans[0].id);
                    $().Action("getPlanInf", result.plans[0].id);
					
					$().Plan('updateScore', moment(result.plans[0].date, 'DD/MM/YYYY'));
					
                    setTimeout($.fn.setDragFeature(), 3);
                    //$().Plan('Rup', result.plans[0].date);
                    
					

		            

		        },
		        async: false
		    });

            /*
		    $.get(defaults.urls['getPlan'], { planId: planId }, function (result) {
		        
		        //console.log(result);
		    });
            */

            /*
		    $.ajax({
		        url: defaults.urls['getPlan'],
		        data: { planId: planId },
		        //dataType: 'json',
		        async: false,
				success: function (result) {
					//console.log(result);
			*/
                    /*
				    var result = {	success : 0, failed:100,
							    plans : [{id:planId, date: '04/10/2016', 
										    vehicule: '', driver: '', helpers: '',
										    from: '04/10/2016 10:00', to: '04/10/2016 11:00', step: 30,
										    weight : 300, volume : 50, score : 10, palette : 3}
									    ]
				    };
				    */
            /*
				    result.plans[0].date = moment(result.plans[0].date , "DD/MM/YYYY hh:mm").toDate();
				    result.plans[0].from = moment(result.plans[0].from , "DD/MM/YYYY hh:mm").toDate();
				    result.plans[0].to = moment(result.plans[0].to , "DD/MM/YYYY hh:mm").toDate();
				
				    $("#accordion1").Block();				
				    $("#accordion1").Block('add', {date: result.plans[0].date , success: result.success, failed: result.failed});
				
				    $().Plan('init', result.plans);			
				    $().Plan('update', result.plans[0].date);
				
				    methods.getPlanOrders(result.plans[0].id);		
				},
				error: function(){
					alert("Error getPlan!")
				}
			});
			*/
		},
        updatePlan : function(planId, fields, doAction) { 
			/*
			$.ajax({ url: defaults.urls['updatePlan'], data: {planId: planId
									, fields: fields}, dataType: 'json',
				success: function (result) {
					//console.log(result);
			*/

            $.ajax({
                url: defaults.urls['updatePlan'],
                data: {
                    planId: planId , fields: fields
                },
                dataType: 'json',
                type: "GET",
                success: function (data) {
                    var result = data; //{msg: 'Ok'};
                    if(result.msg == 'Ok')
                        setTimeout(doAction, 1);
                    else
                        alert("Erreur :\n" + result.msg);

                },
                async: false
            });
			/*	},
				error: function(){
					alert("Error updatePlan!")
				},
				async: false
			});
			*/
		},
        removePlan : function(planId) { 
			/*
			$.ajax({ url: defaults.urls['removePlan'], data: {planId: planId}, dataType: 'json',
				success: function (result) {
					//console.log(result);
			*/
            if(!$().Plan("isEdit", planId)) return false;
            $.ajax({
                url: defaults.urls['removePlan'],
                data: {
                    planId: planId
                },
                dataType: 'json',
                type: "GET",
                success: function (data) {
                    var result = data; //{msg : "Ok"};
                    if(result.msg == "Ok"){
                        $().Plan("removePlanfroBoard", planId);
                    }
                    else
                        alert("Erreur :\n" + result.msg);
                },
                async: false
            });
			/*
				},
				error: function(){
					alert("Error removePlan!")
				},
				async: false
			});
			*/
		},
		updatePlanStatus: function(planId){
			if(!$().Plan("isEdit", planId)) return false;
		    $.ajax({
		        url: defaults.urls['updatePlanStatus'],
		        data: { id: planId },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
				    
		            var result = data; //{msg : "Ok"};
                    if (result.msg == "Ok") {
                        $().Plan("changePlanStatus", result);
                    }
                    else if(result.msg != "")
                        alert(result.msg);
		            

		        },
		        async: false
		    });

		},
		getChangeDriver: function(planId){
			if(!$().Plan("isEdit", planId)) return false;

		    $.ajax({
		        url: defaults.urls['getChangeDriver'],
		        data: { planId: planId },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
				    
		            lDrivers = data;
		            $().Plan("changeDriver", planId);

		        },
		        async: false
		    });

		},getPlanInf: function (planId) {
                if(!$().Plan("isEdit", planId)) return false;

				$.ajax({
				    url: defaults.urls['getPlanInf'],
				    data: { id: planId },
				    dataType: 'json',
				    type: "GET",
				    success: function (data) {                       
				        $().Plan("changeInf", data);

				    },
				    async: false
				});
		},
		getStatus: function (planId) {
			if(!$().Plan("isEdit", planId)) return false;

				$.ajax({
				    url: defaults.urls['getStatus'],
				    data: { planId: planId },
				    dataType: 'json',
				    type: "GET",
				    success: function (data) {

				        lStatus = data;
				        $().Plan("changeStatus", planId);

				    },
				    async: false
				});

		},
		getChangeVehicule: function(planId){
			    if(!$().Plan("isEdit", planId)) return false;

				$.ajax({
				    url: defaults.urls['getChangeVehicule'],
				    data: { planId: planId },
				    dataType: 'json',
				    type: "GET",
				    success: function (data) {

				        lVehicules = data;
				        $().Plan("changeVehicule", planId);

				    },
				    async: false
				});

			
		},
		editPlan: function (planId, from, to) {
		    if (!$().Plan("isEdit", planId)) return false;

		    $().Plan("editPlan", planId, from, to);


		},
		getChangeHelpers: function(planId){
			if(!$().Plan("isEdit", planId)) return false;

		    $.ajax({
		        url: defaults.urls['getChangeHelpers'],
		        data: { planId: planId },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            //console.log(data);
		            lHelpers = data;
		            helpers = new Bloodhound({
		                datumTokenizer: Bloodhound.tokenizers.obj.whitespace('label'),
		                queryTokenizer: Bloodhound.tokenizers.whitespace,
		                local: lHelpers
		            });
		            helpers.initialize();

		            $().Plan("changeHelpers", planId);

		        },
		        async: false
		    });
		},sendMission : function(id, date){            
            let dd = moment(date, 'DD/MM/YYYY');
            let dd1 = moment(new Date(), 'DD/MM/YYYY');
            
            if(dd.diff(dd1, 'days')>=0)
            {
                $.ajax({ url: defaults.urls['sendPlanJobs'],
                         data: {d : moment(dd).format('D'), m: moment(dd).format('M') } 
                    , type: "GET"
                    , success: function (data) {
                        //console.log(data);
		                alert("Envoyé !");
                        gpsWin = window.open("http://37.187.168.96/logitrak/VehicleTracker/logToGPS.aspx?log=TAM16&pass=1234");
		            }
                    , async: false
		        });
            }
            else
            {   
                gpsWin = window.open("http://37.187.168.96/logitrak/VehicleTracker/logToGPS.aspx?log=TAM16&pass=1234");
                setTimeout(function () {
                    gpsWin.focus();
                    gpsWin.blur();
                    gpsWin.location.href = "http://37.187.168.96/logitrak/VehicleTracker/VehicleTracker.aspx?appid=94&planDate=" + date.replace('/', '.').replace('/', '.') + "&vehName=" + "202";
                }, 3000);
            }
        }, openOrder: function () {

		    let welem = undefined;

		    if (modeOrder == "outer")
		        welem = $(winOrder.document.body);
		    else
		        welem = $(document.body);

		    if (modeOrder == "outer") {
		        $("#btnsetModeOrder").click();
		    }
		    else {
		        modeOrder = "inner";

		        $("#dvFlotPanel").css("display", "");

		        let tags = welem.find('#orderTxtSearch').tagsinput('items');
		        $("#orderTxtSearch").val(tags);

		        tags = welem.find('#orderTxtSort').tagsinput('items');
		        $("#orderTxtSort").val(tags);

		        $.fn.setActionFeature();
		        $.fn.setDragFeature();
		        $.fn.setOrderOptions();

		        $().PropOrder("refresh");
		        if (winOrder != undefined)
		            winOrder.close();
		    }
		}
        , sendPlan: function(id, date){    
            let dd = moment(date, 'DD/MM/YYYY');
            let dd1 = moment(new Date(), 'DD/MM/YYYY');
            
            if(dd.diff(dd1, 'days')>=0){
               $.ajax({
		        url: defaults.urls['sendPlanJobs'],
                    data: {d : moment(dd).format('D'), m: moment(dd).format('M') }
                ,
		        type: "GET",
		        success: function (data) {
                    //console.log(data);
		            alert("Envoyé !");
                    gpsWin = window.open("http://37.187.168.96/logitrak/VehicleTracker/logToGPS.aspx?log=TAM16&pass=1234");
		        },
		        async: false
		    });


               //gpsWin = window.open("http://37.187.168.96/TRC_gps_API/Service.asmx/DemoCreateRoute?note=demo");
             }
            else
            {
            //$.get(defaults.urls['sendPlan'], { id: id }, function (htmlResult) {
               
                gpsWin = window.open("http://37.187.168.96/logitrak/VehicleTracker/logToGPS.aspx?log=TAM16&pass=1234");

                setTimeout(function () {
                    gpsWin.focus();
                    gpsWin.blur();
                    gpsWin.location.href = "http://37.187.168.96/logitrak/VehicleTracker/VehicleTracker.aspx?appid=94&planDate=" + date.replace('/', '.').replace('/', '.') + "&vehName=" + "202";

                }, 3000);
                
            //});
            }
        }
        ,RemoveinsertOTToPlan: function (settings, ui, obj) {

            let options = {Period:settings.Period, 
                date: settings.plan.date, 
                from: settings.plan.from ,
                to: settings.plan.to ,
                id:settings.plan.id, 
                step:settings.plan.step};


            if(!$().Plan("isEdit", options.id)) {                
                 ui.draggable.draggable('option', 'revert', true);
                 return false;
            }
            
           
            let _rVerify = $().Order("verify", options);
            if(!_rVerify){
                $.fn.setError('Planifier un ordre : ', 'Action réfusée !', 8);
                ui.draggable.draggable('option', 'revert', true);
                return false;
            }


            $.ajax({
		        url: defaults.urls['removeOTfromPlan'],
		        data: { orderId: settings.id, planId: settings.plan.oldPlanId, date: settings.plan.oldFromDate },
		        dataType: 'json',   //oldPlanId : settings.planId, oldFromDate
		        type: "GET",
		        success: function (data) {
                    //alert(settings.id + "\n" + settings.plan.oldPlanId + "\n" +  settings.plan.oldFromDate);
		            var result = data; //{msg : "Ok"};
			        if(result.msg == "Ok"){
			            $().Order("Remove", settings.id, settings.plan.oldPlanId, settings.plan.oldFromDate);
			            $().Plan("Rup", moment(settings.plan.oldFromDate, 'DD/MM/YYYY').toDate());
                        $().Action("getPlanInf", settings.plan.oldPlanId);
                       
                       

                        $.ajax({
                            url: defaults.urls['insertOTToPlan'],
                            data: {
                                planId: settings.plan.id,
                                orderId: settings.id, datefrom: moment(settings.plan.from).format('DD/MM/YYYY HH:mm')
                            },
                            dataType: 'json',
                            type: "GET",
                            success: function (data) {

                                var result = data; //{msg : "Ok"};
                                if (result.msg == "Ok") {
                                    //console.log("Add");
                                    //console.log(settings);

                                    let res = $().Order('add', settings);
                                    //if (!res) {
                                        /*ui.draggable.remove();
                                        $('tr[tranche] td.info').each(function () {
                                            if ($(obj).hasClass("ui-droppable")) {
                                                $(obj).droppable('disable');
                                            }
                                        });*/
                                    //}
                                    //else 
                                    
                                    if (!res){
                                        ui.draggable.draggable('option', 'revert', true);
                                    }
                                    
									$().Action('getPropOrders', 'date:'+ options.date);
                                   // $().Action("getPlanInf", settings.plan.id);
									//$().PropOrder("refresh");
                                }
                                else {
                                    alert("Erreur :\n" + result.msg);
                                    ui.draggable.draggable('option', 'revert', true);
                                }
			        
                            },
                            async: false
                        });
                        
			        }
			        else
			            alert("Erreur :\n" + result.msg);
		        },
		        async: false
		    });         
		},
		insertOTToPlan: function (settings, ui, obj) {

            let options = {Period:settings.Period, 
                date: settings.plan.date, 
                from: settings.plan.from ,
                to: settings.plan.to ,
                id:settings.plan.id, 
                step:settings.plan.step};


            if(!$().Plan("isEdit", options.id)) {
                
                 ui.draggable.draggable('option', 'revert', true);
                 $(ui).css("height", "40px");
                 return false;
            }
            
		    ////console.log(settings);
			/*
			$.ajax({ url: defaults.urls['insertOTToPlan'], data: {planId: planId, 
										orderId: orderId, datefrom: datefrom}, dataType: 'json',
				success: function (result) {
			*/
			/*
			var result = {
				id: 222,
				label: 'NEWWWWW',
				period: 3,
				info: {city: 'Casablanca', country: 'Morocco', address: 'Omniyat', zip: '15004'},
				plan: {id: 0, date: '04/10/2016', from: '04/10/2016 08:30', to: '04/10/2016 10:00', step: 30 },
				fromDate: '',
				toDate: '',
				zoom: 1
			};
			
			result.plan.date = moment(result.plan.date , "DD/MM/YYYY hh:mm").toDate();
			result.plan.from = moment(result.plan.from , "DD/MM/YYYY hh:mm").toDate();
			result.plan.to = moment(result.plan.to , "DD/MM/YYYY hh:mm").toDate();
			
			$().Order("add", result);
			*/
			

            
    
           
            let _rVerify = $().Order("verify", options);
            if(!_rVerify){
                $.fn.setError('Planifier un ordre : ', 'Action réfusée !', 8);
                ui.draggable.draggable('option', 'revert', true);
                $(ui).css("height", "40px");
                return false;
            }

            $.ajax({
                url: defaults.urls['insertOTToPlan'],
                data: {
                    planId: settings.plan.id,
                    orderId: settings.id, datefrom: moment(settings.plan.from).format('DD/MM/YYYY HH:mm')
                },
                dataType: 'json',
                type: "GET",
                success: function (data) {

                    var result = data; //{msg : "Ok"};
                    if (result.msg == "Ok") {
                        //console.log("Add");
                        //console.log(settings);

                        let res = $().Order('add', settings, true, true);


                       // $().Plan('updateScore', settings.plan.from);		
                        //$.fn.setActionFeature();
						/*
                        if (res) {
                            ui.draggable.remove();


                            $('tr[tranche] td.info').each(function () {
                                if ($(obj).hasClass("ui-droppable")) {
                                    $(obj).droppable('disable');
                                }
                            });
                            //$("tr[tranche] td.info").is(".info").

                        }
                        else {
                            //ui.draggable.position( { of: $(this), my: 'left top', at: 'left top' } );
                            ui.draggable.draggable('option', 'revert', true);
                            $(ui).css("height", "40px");
                        }
						*/
						if (res) {
                            if (ui != undefined) {
                                ui.draggable.remove();
                            }
                            else {
                                $(selectedElem).css("background", "");
                                selectedElem = undefined;
                            }

                            if (obj != undefined) {
                                $('tr[tranche] td.info').each(function () {
                                    if ($(obj).hasClass("ui-droppable")) {
                                        $(obj).droppable('disable');
                                    }
                                });
                            }
            
                        }
                        else {
                            if (ui != undefined) {
                                ui.draggable.draggable('option', 'revert', true);
                                $(ui).css("height", "40px");
                            }
                        }

                        $().Action('getPropOrders', 'date:'+ options.date);
						
                        //$().Action("getPlanInf", settings.plan.id);
						//$().PropOrder("refresh");
                    }
                    else {
                        alert("Erreur :\n" + result.msg);
                        ui.draggable.draggable('option', 'revert', true);
                        $(ui).css("height", "40px");
                    }
			        
                },
                async: false
            });
			
			/*
					//console.log(result);
				},
				error: function(){
					alert("Error insertOTToPlan!")
				},
				async: false
			});
			*/
		},
		updatePropOrder: function (orderId, value) {
		    //alert(orderId + " - " + value);
		    $.ajax({
		        url: defaults.urls['updatePropOrder'],
		        data: { orderId: orderId, value: value},
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            var result = data; //{msg : "Ok"};
		            if (result.msg == "Ok") {
		                
		                $().PropOrder("updateOrder", orderId, value);
		            }
		            else
		                alert("Erreur :\n" + result.msg);
		        },
		        async: false
		    });
		}
        ,
		Remove : function(orderId, planId, date) {             
			/*
			    $.ajax({ url: defaults.urls['removeOTfromPlan'], data: {planId: planId, orderId:orderId}, dataType: 'json',
				    success: function (result) {
					    //console.log(result);
                    }
                });
			*/

            if(!$().Plan("isEdit", planId)) return false;

		    $.ajax({
		        url: defaults.urls['removeOTfromPlan'],
		        data: { orderId: orderId, planId: planId, date: date },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            var result = data; //{msg : "Ok"};
			        if(result.msg == "Ok"){
			            $().Order("Remove", orderId, planId, date);
			            //alert(date);
			            //$().Plan("Rup", moment(date, 'DD/MM/YYYY').toDate());
						
						$().Action('getPropOrders', 'date:'+ date);
						
                        //$().Action("getPlanInf", planId);
			        }
			        else
			            alert("Erreur :\n" + result.msg);
		        },
		        async: false
		    });
			/*
				},
				error: function(){
					alert("Error removeOTfromPlan!")
				},
				async: false
			});
			*/
		},
		setMission: function (planId, date, action) {
			
            if(!$().Plan("isEdit", planId)) return false;
			
		    //alert(action);
		    $.ajax({
		        url: defaults.urls['setMission'],
		        data: { planId: planId, date: date, act: action },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
					
		            var result = data;
		            if (result.msg == "Ok") {
		                
		                let _tabM = result.missions.split('|');
		                let missions = [];
		                for (let i = 0 ; i < _tabM.length ; i++) {
		                    let _lineM = _tabM[i].split('-');
		                    let _action = (_lineM[1] == "0") ? "add" : "delete";
		                    let _miss = { date: _lineM[0], id: _lineM[1], action: _action };
		                    missions.push(_miss);
		                }
		                result.missions = missions;						

		                $().Plan('setPlanMission', { id: planId, missions: missions });

		            }
		            else
		                alert("Erreur :\n" + result.msg);
		        },
		        async: false
		    });
			
			return false;
		},
		PrintMission: function (planId, date, missId) {
		    $.ajax({
		        url: defaults.urls['PrintMission'],
		        data: { id: planId, repture: missId },
		        type: "GET",
		        success: function (data) {
		            var result = data;
		            let htmlDialog = '<div class="modal fade" id="dialogMissionPlan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' +
					'	<div class="modal-dialog modal-sm">' +
					'		<div class="modal-content">		' +
					'			<div class="modal-header">' +
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
					'				<h4 class="modal-title" id="myModalLabel">Imprimer mission</h4>' +
					'			</div>' +
					'			<div class="modal-body">' +  data +
					'			</div>' 
					'			<div class="modal-footer">' +
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>' +
					'			</div>' +
					'		</div>' +
					'	</div>' +
					'</div>';

		            $("#dialogMissionPlan").remove();
		            $("body").append(htmlDialog);
		            $('#dialogMissionPlan').modal('show');
		        },
		        async: false
		    });
		},
		getPlans: function(date, date2) { 
			/*
			$.ajax({ url: defaults.urls['getPlans'], data: {
				date: date, date2: date2
			}, dataType: 'json',
				success: function (result) {
					//console.log(result);
			*/
			

		    $.ajax({
		        url: defaults.urls['getPlans'],
		        data: { date: date, date2: date2 },
		        dataType: 'json',
		        type: "GET",
		        success: function (data) {
		            var result = data;
		            ////console.log(result);
		            
                     $("#accordion1").Block();

		            if (result.plans != undefined) {
		               
		                for (let i = 0; i < result.plans.length ; i++) {
		                    result.plans[i].date = moment(result.plans[i].date, "DD/MM/YYYY hh:mm").toDate();
		                    result.plans[i].from = moment(result.plans[i].from, "DD/MM/YYYY hh:mm").toDate();
		                    result.plans[i].to = moment(result.plans[i].to, "DD/MM/YYYY hh:mm").toDate();

		                    let _tabM = result.plans[i].missions.split('|');
		                    let missions = [];
		                    for (let ik = 0 ; ik < _tabM.length ; ik++) {
		                        let _lineM = _tabM[ik].split('-');
		                        let _action = (_lineM[1] == "0") ? "add" : "delete";
		                        let _miss = { date: _lineM[0], id: _lineM[1], action: _action, time : parseFloat(_lineM[0].substring(11, 16).replace(':', '.')) };
		                        missions.push(_miss);
		                    }
		                    result.plans[i].missions = missions;

							console.log("Mission " + i );
							console.log(result.plans[i].missions);
		                    ////console.log(result.plans[0].missions);
		                }
						
						if(result.plans.length > 0){
							$("#accordion1").Block('add', { date: result.plans[0].date, success: 0, failed: 100 });
						}

		                $().Plan('init', result.plans);

		                for (let i = 0; i < result.plans.length ; i++) {
		                    //$().Plan('update', result.plans[i].date);
		                    methods.getPlanOrders(result.plans[i].id);
                            //$().Action("getPlanInf", result.plans[i].id);
		                }
						/*
		                $().Plan('updateScore', moment(date, 'DD/MM/YYYY'));
                        $.fn.setActionFeature();*/
						 setTimeout(function () {
		                    if (result.plans.length > 0)
		                        $().Plan('update', result.plans[0].date);


		                    for (let i = 0; i < result.plans.length ; i++) {
		                        $().Action("getPlanInf", result.plans[i].id);
		                    }

		                    $().Plan('updateScore', moment(date, 'DD/MM/YYYY'));
		                }, 500);
						
		            }
                    else{
                        $("#accordion1").Block('add', { date: moment(date, "DD/MM/YYYY hh:mm").toDate(), success: 0, failed: 100 });
                    }
                    //else
		             //   alert("Empty !");
		            //methods.getPlanOrders(result.plans[0].id);

		        },
		        async: false
		    });

            /*
				var result = {	success : 0, failed:100,
							plans : [{id:12, date: '04/10/2016', 
										vehicule: '', driver: '', helpers: '',
										from: '04/10/2016 10:00', to: '04/10/2016 11:00', step: 30,
										weight : 300, volume : 50, score : 10, palette : 3
									 },
									 {id:13, date: '04/10/2016', 
										vehicule: '', driver: '', helpers: '',
										from: '04/10/2016 08:00', to: '04/10/2016 15:00', step: 30,
										weight : 300, volume : 50, score : 10, palette : 3
									 },
									 {id:14, date: '05/10/2016', 
										vehicule: '', driver: '', helpers: '',
										from: '05/10/2016 07:00', to: '05/10/2016 16:30', step: 30,
										weight : 300, volume : 50, score : 10, palette : 3
									 }
									]
				};
				
				*/
				
			/*
				},
				error: function(){
					alert("Error getPlans!")
				},
				async: false
			});
			*/
		},
		getPlanOrders: function(planId) { 
			/*
			$.ajax({ url: defaults.urls['getPlans'], data: {
				date: date
			}, dataType: 'json',
				success: function (result) {
					
					//console.log(result);
			
		
			var result = {
				orders : [{ 	id:120001, label: 'BL00001', Period: 1, info:{city: 'Geneve', zip: '21000', country: 'Suisse'},
								plan:{id: 12, date: "04/10/2016", from: "04/10/2016 10:00", to: "04/10/2016 10:30", step: 30},
								fromDate: '', toDate: '', zoom:1, backColor: 'red'
						},
						{ 	id:120053, label: '01-000-00033', Period: 1, info:{city: 'Lausanne', zip: '12000', country: 'Suisse'},
								plan:{id:12, date: "04/10/2016", from: "04/10/2016 10:30", to: '04/10/2016 11:00', step: 30},
								fromDate: '', toDate: '', zoom:2
						}]
			};
			*/

		    $.ajax({
		        url: defaults.urls['getPlanOrders'],
		        data: { planId: planId},
		        dataType: 'json',   
		        type: "GET",
		        success: function (data) {
		            var result = data;
		            //alert("ok");

		            //alert(result.orders.length);
		            
		            if (result.orders != undefined) {
		                for (let i = 0; i < result.orders.length ; i++) {
		                    result.orders[i].plan.date = moment(result.orders[i].plan.date, "DD/MM/YYYY hh:mm").toDate();
		                    result.orders[i].plan.from = moment(result.orders[i].plan.from, "DD/MM/YYYY hh:mm").toDate();
		                    result.orders[i].plan.to = moment(result.orders[i].plan.to, "DD/MM/YYYY hh:mm").toDate();

		                    $().Order('add', result.orders[i] , true);
		                }

		                //$().Order('init', result.orders);
		                //$().Order('show');
		            }
		        },
		       async: false
		    });
			/*	},
				error: function(){
					alert("Error getPlans!")
				},
				async: false
			});
			*/
		},
		getPropOrders: function(filter) { 
			/*
			$.ajax({ url: defaults.urls['getPropOrders'], data: {
				filter: filter
			}, dataType: 'json',
				success: function (result) {
			*/
			//open(defaults.urls['getPropOrders']);
			//alert(filter);
		    $.ajax({
		        url: defaults.urls['getPropOrders'],
		        data: { filter: filter },
		        dataType: 'json',   
		        type: "GET",
		        success: function (data) {
		            
		            var result = data;
                    //console.log("Data Prop : ");
                    //console.log(result);

                    /*
			        var result = {propOrders : [{"id":"31201", "label": "02-080-30001", "Period": "2", "info": {"city": "Génève", "zip": "21000", "country": "Suisse"}, "fromDate": "", "toDate": "", "zoom":"3"}
				        ,{"id":"31200", "label": "05-01-430001", "Period": "4", "info": {"city": "Paris", "zip": "11000", "country": "France"}, "fromDate": "", "toDate": "", "zoom":"1"}
				        ,{"id":"301", "label": "01-078-14530001", "Period": "1", "info": {"city": "Génève", "zip": "13000", "country": "Suisse"}, "fromDate": "", "toDate": "", "zoom":"2"}
				        ]};
			        */
			        $().PropOrder('init', result.propOrders);
			        $().PropOrder('show');
		        },
		        async: false
		    });
			/*
					//console.log(result);
				},
				error: function(){
					alert("Error getPropOrders!")
				},
				async: false
			});
			*/
		}
    };	
	
    $.fn.Action = function( options ) {  
		var t = [];
		if (methods[options]) {
            return methods[options].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || ! options) {
            return methods.init.apply(this, arguments);
        }
    };
}( jQuery ));