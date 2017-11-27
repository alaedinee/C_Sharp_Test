(function ( $ ) {	
	var defaults = {
	    orders: [],
        infos : []
    };
	
	function getOrderIndex(id){
		var res = -1;
		
		for(let i = 0 ; i < defaults.orders.length ; i++){
			if(defaults.orders[i].id == id){
				res = i;
				break;
			}
		}
		
		return res;
	}
	

	function existStop(order) {
	    var res = -1;
	    //.info.zip, city, fname, lname
	    for (let i = 0 ; i < defaults.infos.length ; i++) {
	        if (defaults.infos[i].plan.id == order.plan.id /*
                && defaults.infos[i].id != order.id
                && defaults.infos[i].info.zip == order.info.zip
                && defaults.infos[i].info.city == order.info.city
                && defaults.infos[i].info.fname == order.info.fname
                && defaults.infos[i].info.lname == order.info.lname*/) {
	            res = i;
	            break;
	        }
	    }

	    return res;
	}

	function isEquals(obj1, obj2, id) {

        if(131736 == id){
			console.log(obj1.id + "!=" + obj2.id + ", " + obj1.info.zip + "==" + obj2.info.zip +
                obj1.info.city + "==" + obj2.info.city + ", " +
                obj1.info.fname + "==" + obj2.info.fname + ", " +
                obj1.info.lname + "==" + obj2.info.lname
            );
		}
            
	    return obj1.id != obj2.id
                && obj1.info.zip == obj2.info.zip
                && obj1.info.city == obj2.info.city
                && obj1.info.fname == obj2.info.fname
                && obj1.info.lname == obj2.info.lname
	}	

	function getOrderPlanIndex(id, planId, date){
		var res = -1;
		
		for (let i = 0 ; i < defaults.orders.length ; i++) {
		    //console.log(id + " > " + planId + " > " + date);
		    //console.log(defaults.orders[i]);
		    if (defaults.orders[i].id == id && defaults.orders[i].plan.id == planId && moment(defaults.orders[i].plan.from).format('DD/MM/YYYY HH:mm') == date) {
				res = i;
				break;
			}
		}
		
		return res;
	}
	
	function getOrder(id){
	    var res = -1;
		
	    for (let i = 0 ; i < defaults.orders.length ; i++) {
	        if (defaults.orders[i].id == id ) {
	            res = defaults.orders[i];
	            break;
	        }
	    }
		
	    return res;
	}	

	var __methods = {
		getOrdersByPlanID: function (id) {
	        let tab = [];
	        for (let i = 0 ; i < defaults.orders.length ; i++) {
	            if (defaults.orders[i].plan.id == id && defaults.orders[i].id > 0) {
	                tab.push(defaults.orders[i]);
	            }
	        }

	        return tab;
	    }, drawStop: function () {            
	        let orders = $("td[orderid]");

	        defaults.infos = [];	        
	        $("td[orderid]").each(function () {
	            let _idOrder = $(this).attr("orderid");
	            let settings = getOrder(_idOrder);

	            if (settings.id != undefined && settings.id > 0) {
	                    let _elem = $("td[orderid='" + settings.id + "'] span.stop");
	                    _elem.removeClass("glyphicon glyphicon-ruble");
	                    let stopIcon = "";
	                    if (settings.id > 0) {
	                        let hasStop = existStop(settings);
	                        if (hasStop == -1) {
	                            _elem.addClass("glyphicon glyphicon-ruble");
	                            defaults.infos.push(settings);
	                        }
	                        else {
	                            let obj = defaults.infos[hasStop];
	                            let vry = isEquals(obj, settings, settings.plan.id);
	                            if (!vry) {
	                                _elem.addClass("glyphicon glyphicon-ruble");
	                                defaults.infos[hasStop] = settings;
	                            }

	                        }
	                    }
	            }
	        });            
	    }

        ,
        init : function(options) {
			defaults.orders = options;
        },
        Get : function(id){
            return defaults.orders[getOrderIndex(id)];
        }
        ,
		Preview : function( id ){
			//alert("Redirecting");
			open('/previewOrder?id' + id);
		},
		Remove: function (id, planId, date) {
		    let idx = getOrderPlanIndex(id, planId, date);
		    
			if(idx > -1){
				var settings = defaults.orders[idx];
				////console.log("Rem ");
				////console.log(settings);
                

				let timeDiff = settings.Period;
				let dateLoop = moment(date, 'DD/MM/YYYY HH:mm').toDate();
				//alert(settings.Period);

                let tab = $('#' +  moment(dateLoop).format('DD_MM_YYYY') + " table[plantable] tbody");
                let index = $(tab).find("tr[Plan] td").index($("#" + planId));	

				for (let i = 1 ; i <= timeDiff ; i++) {
				    let timeStr = moment(dateLoop).format('DD/MM/YYYY HH:mm'); 
				    //alert(timeStr + " - " + settings.id + " - " + settings.plan.step);
				    let misIcons = "<div rub='" + timeStr + "' rPlanId='" + planId + "'></div>";

                    
				    $("tr[tranche='" + timeStr + "'] td:eq(" + index + ")[orderId='" + settings.id + "']")
				    .html(misIcons)
                        .attr("orderId", "")
                         .attr("color", "")
				        .css("background", "")
				        .removeClass("info active danger")
				        .addClass("success");

				    dateLoop.setMinutes(dateLoop.getMinutes() + settings.plan.step);
				}

				//$("tr[tranche] td.success").draggable( 'enable' );
				//$("tr[tranche] td.success").droppable('enable');
				
				if (parseInt(settings.id) > 0) // != "-1" && settings.id != "-2")
				    $().PropOrder('add', settings);
				/*
				let backColor = "";
				if(settings.backColor != undefined) backColor = settings.backColor;
				
				$("#orderPanel").append('<div class="well" style="padding:7px 5px;margin:10px 0px"' + 
					' data=\'{"id":"' + settings.id + '", "label": "' + settings.label + '", "Period": "' + settings.Period + '", ' + 
					'"info": {"city": "' + settings.info.city + '", "zip": "' + settings.info.zip + '", "country": "' + settings.info.country + '"}, ' +
					'"fromDate": "", "toDate": "", "zoom":"' + settings.zoom + '"' + ((backColor!='')? ', "backColor":"' + backColor + '"' : '')  + '}\'>' +
					'<span style="background:' + backColor + '">' + settings.label + ' <small>(Zoom:' + settings.zoom + ', Period : ' + settings.Period + ')</small></span>' + 
					'<span class="label label-info pull-right">' + settings.info.zip + ' ' + settings.info.city + ', ' + settings.info.country + '</span></div>');
				
				$.fn.setDragFeature();
				*/
				
				defaults.orders.splice(idx, 1);
				
				/*$().Plan('updateScore', settings.plan.date);
				$().PropOrder('refresh');*/
				
				setTimeout(function () {
				    $().Plan('update', date);

				    $().Action("getPlanInf", planId);
				    
				    $().Plan('updateScore', date);

				    $().PropOrder("refresh");
				}, 50);
				
				/*
				let tags = $('#orderTxtSearch').tagsinput('items');
				$().PropOrder('Filter', tags);
				*/
			}
			else
			    _Debug("Order", "Delete error !\nError #0002")
		},
		verify: function( options ){
		    ////console.log(options);  //options.date.toString("dd_mm_yyyy")
		    let tab = $('#' +  moment(options.date).format('DD_MM_YYYY') + " table[plantable] tbody");
			let id = options.id;				
			let index = $(tab).find("tr[Plan] td").index($("#" + id));	
			
			let timeDiff = options.Period;
            /*
			let timeDiff = Math.abs(options.to.getTime() - options.from.getTime());				
			timeDiff = timeDiff / (1000 * 60);		
			timeDiff = Math.round(timeDiff / options.step);
			if (timeDiff == 0 || timeDiff != options.Period) timeDiff = options.Period;
            */

            
			let dateLoop = new Date(options.from.getTime());

            let miss = tab.find("tr[tranche='" + moment(dateLoop).format('DD/MM/YYYY HH:mm') + "'] td:eq(" + index + ") span[rub_id]").attr("rub_id");

			let res = true;
			let nbr_Per = 0;
			for(let i = 0 ; i < 100 ; i++){
				let timeStr = moment(dateLoop).format('DD/MM/YYYY HH:mm'); //dateLoop.toString("h:m");
				let elem = tab.find("tr[tranche='" + timeStr + "'] td:eq(" + index + ")");
				
                if(miss != elem.find("span[rub_id]").attr("rub_id")){
                    break;
                 }

				if(elem.length ==0 || nbr_Per == timeDiff){
					break;
				}

				if(elem.hasClass("active") || elem.hasClass("info")){
					res = false;
					break;
				}
				else if(!elem.hasClass("danger")){
					nbr_Per++;
				}
				
				dateLoop.setMinutes(dateLoop.getMinutes() + options.step);
			}
			//console.log("Verify >> " +  nbr_Per + " == " +  timeDiff);
			res = nbr_Per == timeDiff;
			
			return res;
		},
		add: function (options, updateScore, verify) {
			var settings = $.extend({
				id: 0,
				label: '',
				period: 0,
				info: {city: '', country: '', address: '', zip: ''},
				plan: {id: 0, date: '', from: '', to: '', step: 30 },
				fromDate: '',
				toDate: '',
				zoom: 1
			}, options);		
            
			let res  = __methods.draw(settings, updateScore, verify);
			if(res)
				defaults.orders.push(settings);            
            
			return res;
		},
        show : function() { 
			for(let i = 0 ; i < defaults.orders.length ; i++){
				__methods.draw(defaults.orders[i]);
			}
        },
        show1: function (from, to) {
            for (let i = from ; i < to ; i++) {
	        __methods.draw(defaults.orders[i]);
	        }
	    },
        draw: function (settings, updateScore, verify) {
            
            let options = {Period:settings.Period, date: settings.plan.date, from: settings.plan.from ,to: settings.plan.to ,id:settings.plan.id, step:settings.plan.step};
			var res  = (verify == undefined)? true : __methods.verify(options);
			if(res){			
			    let tab = $('#' + moment(settings.plan.date).format('DD_MM_YYYY') + " table[plantable] tbody");
				let id = settings.plan.id;				
				let index = $(tab).find("tr[Plan] td").index($("#" + id));				
				
				let timeDiff = options.Period;
				let dateLoop = new Date(options.from.getTime());
				
				let str = Config.zoom[settings.zoom];
				
				let stopIcon = " <span class='stop' style='font-size:12px;color:#f46242'></span> ";
                
				let tmps = getTemplates(str);
				for (let i = 0 ; i < tmps.length ; i++) {
				    let temp = tmps[i].replace("{", "").replace("}", "");
				    temp = temp.split(".");
				    if (temp.length > 2) {
				        let _temp = temp[1];
				        let obj = settings[_temp];				        
				        _temp = temp[2];
                        str = str.replace('{settings.' + temp[1] + '.' + _temp + '}',  obj[_temp]);
				    }
				    else {
				        temp = temp[1];
				        if (temp == "label")
				            str = str.replace('{settings.' + temp + '}', stopIcon + (settings[temp]).substring(0, 15) + '...');
				        else
				            str = str.replace('{settings.' + temp + '}', settings[temp]);
				    }
				}
				
				/*
				for (var property in settings) {
					if (settings.hasOwnProperty(property)) {
						if('settings.' + property == 'settings.label')
                            str = str.replace('{settings.' + property +'}', settings[property].substring(0, 20) + ((settings[property].length > 20)? '...' : ''));
                        else
						    str = str.replace('{settings.' + property +'}', settings[property]);
						let obj = settings[property];
						for (var property1 in obj) {
							if (obj.hasOwnProperty(property1)) {
								str = str.replace('{settings.' + property +'.' + property1 + '}', obj[property1]);
							}
						}
					}
				}*/
				
				let icons = ((parseInt(settings.id) > 0)? ' <span object="Action" action="Preview" data="\'' + settings.id + '\'" data-toggle="popover" data-content="hello" data-placement="top" title="Info" pop="pop" class="glyphicon glyphicon-info-sign sIcon" style="font-size:9px;color:#5bc0de"></span>' : '') +
                            ((parseInt(settings.id) > 0)? ' <span object="Action" action="OrderDetail" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Afficher" class="glyphicon glyphicon-eye-open sIcon" style="font-size:9px;color:#000"></span>' : '') +
							' <span object="Action" action="Remove" data="\'' + settings.id + '\', \'' + id + '\', \'' + moment(dateLoop).format('DD/MM/YYYY HH:mm') + '\'" data-toggle="tooltip" data-placement="top" title="Supprimer" class="glyphicon glyphicon-remove sIcon" style="font-size:9px;color:red"></span>';
				str = str.replace('{icons}', icons);
				
				let nbr_Per = 0;
				
				for (let i = 0 ; i < 100 ; i++) {
                    let backColor = "";
				    if(settings.backColor != undefined) backColor = settings.backColor;
                    let timeStr = moment(dateLoop).format('DD/MM/YYYY HH:mm'); //dateLoop.toString("h:m");

				    let _cData = ' cdata=\'{"id":"' + settings.id + '", "label": "' + settings.label + '", "Period": "' + settings.Period + '", ' + 
					'"info": {"city": "' + settings.info.city + '", "zip": "' + settings.info.zip + '", "country": "' + settings.info.country + '", "tel": "' + settings.info.tel + '", "oWeight": "' + settings.info.oWeight + '", "oVolume": "' + settings.info.oVolume + '"}, ' +
					'"planId": "' + settings.plan.id + '","fromDate": "' + timeStr + '", "toDate": "", "zoom":"' + settings.zoom + '"' + ((backColor!='')? ', "backColor":"' + backColor + '"' : '')  + '}\' ';
				    let __str = str;
				   
				    let misIcons = /*(parseInt(settings.id) > 0) ? */ "<div rub='" + timeStr + "' rPlanId='" + id + "'></div>"; // : '';
				    __str = __str.replace('{misIcons}', misIcons);
                    __str = __str.replace('{cData}', _cData);

					let elem = tab.find("tr[tranche='" + timeStr + "'] td:eq(" + index + ")");	
					let _content = (i == 0) ? __str : "<div class='row'><div class='col-md-2'>" + misIcons + "</div><div class='col-md-10 text-center'><span class='glyphicon glyphicon-chevron-up' style='color:#5bc0de'></span><span class='glyphicon glyphicon-lock' style='color:#5bc0de'></span></div></div> ";
					if (elem.hasClass("success")) {
                        
					    //_Debug("Info >", timeStr);
					    elem.html(_content)
						.removeClass("active danger success")
						.addClass("info")
						.attr("orderId", settings.id)
                        .attr("color", settings.backColor);

						nbr_Per++;
						if(settings.backColor != undefined){						
							elem.css('color', ((parseInt(settings.id)> 0)? '#000' : '#fff'));
							elem.css('background', settings.backColor);
						}
					}
					
					if(nbr_Per == timeDiff) break;
					
					dateLoop.setMinutes(dateLoop.getMinutes() + settings.plan.step);
				}
				
				if (verify != undefined) {
				    //$().PropOrder('Remove', settings.id);
				    
				    let date = moment(settings.plan.date).format('DD/MM/YYYY');
				    setTimeout(function () {
				        
				        $().Plan('update', date);

				        $().Action("getPlanInf", id);

				        $().Plan('updateScore', date);

				        $().PropOrder("refresh");
				        $.fn.setActionFeature();

				    }, 50);
				}

				
                //if(updateScore == undefined)
				    //FIX FIX $().Plan('updateScore', settings.plan.date);		
			}
			else
			    _Debug("Order", "Can't add BL : " + settings.label + " in plan N° : " + settings.plan.id + " !\nError : #001");
			
			return res;
		}
    };	
	
    $.fn.Order = function( options ) {  
		var t = [];
		if (__methods[options]) {
            return __methods[options].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || ! options) {
            return __methods.init.apply(this, arguments);
        } else {
            $.error('Method ' +  options + ' does not exist ');
        }
    };
}( jQuery ));