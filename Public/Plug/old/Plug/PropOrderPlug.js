(function ( $ ) {	
	var defaults = {
        prop_Orders: [],
		prop_Orders_visible: [],
		filter: '',
		order: ''
    };
	
	function getOrderIndex(id){
		var res = -1;
		
		for(let i = 0 ; i < defaults.prop_Orders.length ; i++){
			if(defaults.prop_Orders[i].id == id){
				res = i;
				break;
			}
		}
		
		return res;
	}
	
	var ___methods = {
		getFilter : function(){
			return defaults.filter;
		},		
		getList : function(){
	        return defaults.prop_Orders;
	    },
        init : function(options) {
			defaults.prop_Orders = options;
			for(let i = 0 ; i < defaults.prop_Orders.length ; i++){
				defaults.prop_Orders_visible[i] = true;
			}
        },
        updateOrder: function(id, value){
            let _idx = getOrderIndex(id);
            if (_idx != -1) {
                defaults.prop_Orders[_idx].Period = value;
                let settings = defaults.prop_Orders[_idx];

                let backColor = "";
                if (settings.backColor != undefined) backColor = settings.backColor;

                let _data = '{"id":"' + settings.id + '", "label": "' + settings.label + '", "Period": "' + settings.Period + '", ' +
                '"info": {"city": "' + settings.info.city + '", "zip": "' + settings.info.zip + '", "country": "' + settings.info.country + '", "tel": "' + settings.info.tel + '", "oWeight": "' + settings.info.oWeight + '", "oVolume": "' + settings.info.oVolume + '"}, ' +
                '"fromDate": "", "toDate": "", "zoom":"' + settings.zoom + '"' + ((backColor != '') ? ', "backColor":"' + backColor + '"' : '') + '}';

                
                $("span[propOrderPeriodeId='" + id + "']").closest("div.PropOrder").attr("data",_data) ;
                $("span[propOrderPeriodeId='" + id + "']").html(value);
            }
        },
		Sort : function(tags, op){
			
			for(let i = 0; i < tags.length ; i++){
				let tag = tags[i].label;
				
				let sortTab = defaults.prop_Orders.sort(function(a, b) {
					if(op == "+")
						return parseFloat(a[tag]) - parseFloat(b[tag]);
					else
						return parseFloat(b[tag]) - parseFloat(a[tag]);
				});
				
				let sortTab_visible = [];
				
				////console.log("Sort : " + tag);
				for(let i = 0; i < sortTab.length ; i++){
					let idx = getOrderIndex(sortTab[i].id);
					sortTab_visible[i] = defaults.prop_Orders_visible[idx];
					let objj = sortTab[i];
					//console.log(objj[tag]);
				}
				
				defaults.prop_Orders  = sortTab;
				defaults.prop_Orders_visible = sortTab_visible;
			}
			
			___methods.show();
		},
		refresh: function () {
			/*
		    let welem = undefined

		    if (modeOrder == "outer")
		        welem = $(winOrder.document.body);
		    else
		        welem = $(document.body);
			*/
			
		    setTimeout(function () {
		        /*let tags =  welem.find('#orderTxtSearch').tagsinput('items');
				alert(modeOrder + " - " + tags);*/
		        $().PropOrder('Filter', defaults.filter);
		    }, 1000);            
		},
		Filter : function(tags){
			//alert(tags);
			defaults.filter = tags;
			for(let i = 0 ; i < defaults.prop_Orders.length ; i++){
				defaults.prop_Orders_visible[i] = true;
			}
			//alert(tags.length);
			for(let i = 0; i < tags.length ; i++){
				let tag = tags[i].toLowerCase();
				
				for(let ik = 0 ; ik < defaults.prop_Orders.length; ik++){
					let settings = defaults.prop_Orders[ik];
					let verifyCond = false;
					
					for (var property in settings) {
						if (settings.hasOwnProperty(property)) {
							let obj = settings[property];
							////console.log(property + " -> " + obj.toString() + " : " + Object.keys(obj).length + " - " + (obj.constructor === Object));
							
							if(obj.constructor === Object	){
								for (var property1 in obj) {
									if (obj.hasOwnProperty(property1)) {
										if(obj[property1].toString().toLowerCase().indexOf(tag) !== -1) verifyCond = true;
									}
								}
							}
							else{
								////console.log(property + " > " + obj.toString());
								if(obj.toString().toLowerCase().indexOf(tag) !== -1) verifyCond = true;
							}
						}
					}
					
					defaults.prop_Orders_visible[ik] = verifyCond;
				}
			}
			___methods.show();
		},
		Remove : function(id){
			let idx = getOrderIndex(id);
			if(idx > -1)
				defaults.prop_Orders.splice(idx, 1);
		},
		show : function() { 
			/*
			$("#orderPanel").html("");
			for(let i = 0 ; i < defaults.prop_Orders.length ; i++) {
				___methods.draw(i);
			}
			*/
			let welem = undefined;
            if(modeOrder=="outer")
                welem = $(winOrder.document.body).find("#orderPanel");
		    else
                welem = $(document.body).find("#orderPanel");

		    welem.html("");
		    if (defaults.prop_Orders != undefined) {
		        for (let i = 0 ; i < defaults.prop_Orders.length ; i++) {
		            ___methods.draw(i);
		        }
		    }

		    //welem.append("<br/><br/><br/><br/>");


		    $.fn.setDragFeature();

		    welem.find("span[addProp]").not('.init').addClass("init").click(function () {

		        if (selectedElem == undefined) {

		            $.fn.setError("Séléction", "Veuillez sélecionner une destination !", 2);
		            return false;
		        }

		        let index = $(selectedElem).closest("tr").find("td").index(selectedElem);
		        let id = $(selectedElem).closest("table[plantable]").find("tr[Plan] td:eq(" + index + ")").attr("id");
		        let options = $().Plan('get', id);

		        let str = $(this).closest("div").attr("data");
		        // alert(str);

		        let settings = jQuery.parseJSON(str);

		        let from = $(selectedElem).closest("tr").attr("tranche");
		        let to = getToDate(options.date, from, options.step, settings.Period);
		        
		        //alert(from + "\n" + to);
		        from = moment(from, "DD/MM/YYYY hh:mm").toDate();
		        to = moment(to, "DD/MM/YYYY hh:mm").toDate();

		        settings['plan'] = {
		            id: id, date: options.date, from: from,
		            to: to, step: options.step
		        };

		        //$(selectedElem).attr("style", "");
		        $().Action("insertOTToPlan", settings);

		    });

		    /*$*/ welem.find("span[propOrderPeriode]").dblclick(function () {

		        let _orderID = parseInt($(this).find("span[propOrderPeriodeId]").attr("propOrderPeriodeId"));

		        if (_orderID > 0) {
		            $(this).find("span[propOrderPeriodeId]").html("<input type='text' onfocus='this.value = this.value;' size='6' value='" + $(this).attr("propOrderPeriode") + "' OrderPeriodeId='" + _orderID + "' />")
		            $("input[OrderPeriodeId]").keypress(function (e) {
		                if (e.which == 13) {
		                    $().Action("updatePropOrder", $(this).attr("OrderPeriodeId"), $(this).val());
		                }
		            });

		            $("input[OrderPeriodeId]").focus();
		        }
		    });

		    $('tr[tranche] td.success').each(function () {
		        if ($(this).hasClass("ui-droppable")) {
		            $(this).droppable('enable');
		        }
		    });

		},

        doProp :function(id, date){
            
            let _date = moment(date, 'DD/MM/YYYY HH:mm').toDate();
            let tab = $('#' +  moment(_date).format('DD_MM_YYYY') + " table[plantable] tbody");
							
			let index = $(tab).find("tr[Plan] td").index($("#" + id));	
            
            let miss = tab.find("tr[tranche='" + moment(_date).format('DD/MM/YYYY HH:mm') + "'] td:eq(" + index + ") span[rub_id]").attr("rub_id");

            let nbr_Per = 0;
			for(let i = 0 ; i < 100 ; i++){
				let timeStr = moment(_date).format('DD/MM/YYYY HH:mm');
				let elem = tab.find("tr[tranche='" + timeStr + "'] td:eq(" + index + ")");
				
                if(elem == undefined) break;
                 if(miss != elem.find("span[rub_id]").attr("rub_id")){
                    break;
                 }

				 if( elem.length == 0 ){
					break;
				 }

				if(elem.hasClass("active") || elem.hasClass("info")){
					res = false;
					break;
				}
				else if(!elem.hasClass("danger")){
					nbr_Per++;
				}
				
				_date.setMinutes(_date.getMinutes() + 30);
			}

            $("div[PropPeriode]").each(function(){
                let perid = $(this).attr("PropPeriode");
                ////console.log("Periode : " + perid + " - " + nbr_Per);

                var number = 1 + Math.floor(Math.random() * 50);

                if(perid > 0 && perid <= nbr_Per)
                    $(this).find("span[setProp]").html(number).css("background-color", "#5bc0de");
                else
                    $(this).find("span[setProp]").html("").css("background-color", "#fff");
            });

        }
        ,
		add : function(settings) { 
			defaults.prop_Orders.push(settings);
			let idx = getOrderIndex(settings.id);
			defaults.prop_Orders_visible[idx] = true;
			___methods.draw(idx);
		},
        draw : function(idx) { 
			if(defaults.prop_Orders_visible[idx]){
				
				let welem = undefined;

                if (modeOrder == "outer")
                    welem = $(winOrder.document.body).find("#orderPanel");
                else
                    welem = $(document.body).find("#orderPanel");
								
				let settings =  defaults.prop_Orders[idx];
				let backColor = "";
				if(settings.backColor != undefined) backColor = settings.backColor;
				
                let _fColor = (parseInt(settings.id)>0)? "#000" : '#fff';

				welem.append('<div PropPeriode="' + ((parseInt(settings.id)>0)? settings.Period : settings.id) + '" class="well PropOrder" style="padding:7px 5px;margin:10px 0px;"' + 
					' data=\'{"id":"' + settings.id + '", "label": "' + settings.label + '", "Period": "' + settings.Period + '", ' + 
					'"info": {"city": "' + settings.info.city + '", "zip": "' + settings.info.zip + '", "country": "' + settings.info.country + '", "tel": "' + settings.info.tel + '", "oWeight": "' + settings.info.oWeight + '", "oVolume": "' + settings.info.oVolume + '"}, ' +
					'"fromDate": "", "toDate": "", "zoom":"' + settings.zoom + '"' + ((backColor!='')? ', "backColor":"' + backColor + '"' : '')  + '}\'>' +
					'<span addProp="" class="glyphicon glyphicon-plus sIcon" style="cursor:pointer;color:#bab8b0"></span> ' +
					'<span style="color:' + _fColor + ';background-color:' + backColor + ';">' + ((parseInt(settings.id) > 0)? '<span object="Action" action="OrderDetail" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Afficher" class="glyphicon glyphicon-eye-open sIcon" style="color:#000"></span> ' : '') + "<span setProp='' class='badge' style='font-size:20px'></span>" + settings.label + ' [' + settings.info.livDate + '] <b>P:</b> ' + settings.info.oWeight +  ', <b>V:</b> ' + settings.info.oVolume  +  ' (Zoom:' + settings.zoom + ', <span propOrderPeriode="' + settings.Period + '">Period : <span propOrderPeriodeId="' + settings.id + '">' + settings.Period + '</span></span>)</span>' +
					'<span class="label label-info pull-right">' + settings.info.zip + ' ' + settings.info.city + ', ' + settings.info.country + '</span></div>');
				/*
				$.fn.setDragFeature();
				
				$("span[propOrderPeriode]").dblclick(function () {
				    
				    let _orderID = parseInt($(this).find("span[propOrderPeriodeId]").attr("propOrderPeriodeId"));

				    if (_orderID > 0) {
				        $(this).find("span[propOrderPeriodeId]").html("<input type='text' onfocus='this.value = this.value;' size='6' value='" + $(this).attr("propOrderPeriode") + "' OrderPeriodeId='" + _orderID + "' />")
				        $("input[OrderPeriodeId]").keypress(function (e) {
				            if (e.which == 13) {
				                $().Action("updatePropOrder", $(this).attr("OrderPeriodeId"), $(this).val());
				            }
				        });

				        $("input[OrderPeriodeId]").focus();
				    }
				});

				$('tr[tranche] td.success').each(function() {
					if ($(this).hasClass("ui-droppable")) {
						$(this).droppable('enable');
					}
				});
				*/
			}
		}
    };	
	
    $.fn.PropOrder = function( options ) {  
		var t = [];
		if (___methods[options]) {
            return ___methods[options].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || ! options) {
            return ___methods.init.apply(this, arguments);
        }
    };
}( jQuery ));