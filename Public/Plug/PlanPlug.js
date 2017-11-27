(function ( $ ) {	
	var defaults = {
        plans: []
    };
	
	function _getPlanPosIndex(id){
		var res = -1;
		
		//for (x in defaults.plans) {
			var pls = defaults.plans;//[x];
			for(let i = 0 ; i < pls.length ; i++){
				if(pls[i].id == id){
					res = i;
					break;
				}
			}
		//}
	
		return res;
	}

	function _getTotalPeriodes(date) {
	    var minutes = 0;
	    var pls = defaults.plans[date];
	    for (let i = 0 ; i < pls.length ; i++) {
	        minutes += moment(pls[i].to, 'DD/MM/YYYY HH:mm').diff(moment(pls[i].from, 'DD/MM/YYYY HH:mm'), 'minutes')
	    }

	    return minutes;
	}
	
	function _getPlanIndex(id){
		var res = undefined;
		
		//for (x in defaults.plans) {
		var pls = defaults.plans;//[x];
			for(let i = 0 ; i < pls.length ; i++){
				if(pls[i].id == id){
					res = pls[i];
					break;
				}
			}
		//}
	
		return res;
	}
	
	function _removePlanIndex(id){
		//for (x in defaults.plans) {
			//console.log(">" + x);
	    var pls = defaults.plans;//[x];
			for(let i = 0 ; i < pls.length ; i++){
				//console.log("	>" + i);
				if(pls[i].id == id){
					//console.log(defaults.plans[x].length);
					defaults.plans[x].splice(i, 1);
					//console.log(defaults.plans[x].length);
					//break;
				}
			}
		//}
	}	
	
   function _setPlanEdit(id, value){
		//for (x in defaults.plans) {
       var pls = defaults.plans;//[x];
			for(let i = 0 ; i < pls.length ; i++){
				if(pls[i].id == id){
					defaults.plans[i].isEdit = value;
				}
			}
		//}
	}	

	function getPlanIndex(id){
		var res = -1;
		
		for(let i = 0 ; i < defaults.plans.length ; i++){
			if(defaults.plans[i].id == id){
				res = i;
				break;
			}
		}
		
		return res;
	}
	
	function getTds(date, timeStr) {
		let _str = "";
		for (let i = 0 ; i < defaults.plans[date].length ; i++) {
		    let misIcons = /*(parseInt(settings.id) > 0) ? */ "<div rub='" + timeStr + "' rPlanId='" + defaults.plans[date][i].id + "'></div>"; // : '';
		    _str += "<td class='active' style='font-size:11px;height:40px'>" + misIcons + " </td>";
		}
		return _str;
	};
	
	function getNbrTds(nbr, date, beg){
	    let _str = "";
	    let cpt = beg;

	    let cDate = moment(date, "DD/MM/YYYY").toDate();
	    let tab = $("#" + moment(cDate).format('DD_MM_YYYY') + " table[plantable]");
	    
        
        //aaaa
	    ////console.log("Time : " + date + " - " + defaults.plans[moment(cDate).format('DD_MM_YYYY')].length + " - " + cpt + " - " + nbr);
	    //let pl = defaults.plans[moment(cDate).format('DD_MM_YYYY')][cpt];

	    for (let i = 1 ; i <= nbr ; i++) {
	        let _idPl = $(tab).find("tr[Plan] td:eq(" + cpt + ")").attr("id");
	        let misIcons = /*(parseInt(settings.id) > 0) ? */ "<div rub='" + date + "' rPlanId='" + _idPl + "'></div>"; // : '';
		    _str += "<td class='active' style='font-size:11px;height:40px'>" +  misIcons + "</td>";
		    cpt++;
		}
		return _str;
	};	
	
	function formatTimeToStr(obj) {
		/*
	    obj = obj.toString().split('.');
	    let _maxStr = ((obj[0].length == 1) ? '0' + obj[0] : obj[0]);
	    _maxStr += ':' + ((obj.length > 1) ? (((obj[1].length == 1) ? '0' : obj[1]) + obj[1]) : '00');
		*/
		obj = obj.toString().split('.');
	    let _maxStr = (obj[0].length > 1) ? obj[0] : ('0' + obj[0]);
	    _maxStr += ':';

	    if (obj.length > 1) {
	        _maxStr += (obj[1].length > 1) ? obj[1] : ( obj[1] + '0');
	    }
	    else {
	        _maxStr += "00";
	    }
		//console.log(" obj >> "  + obj + " >>> " + _maxStr);
		
	    return _maxStr;
	};
	
	function getMaxInf() {
	    let min = 0;
	    let arrFrom = [];
	    let arrTo = [];
        
	    for (let i = 0 ; i < defaults.plans.length ; i++) {
	        arrFrom.push(parseFloat(moment(defaults.plans[i].from).format('HH.mm')));
	        arrTo.push(parseFloat(moment(defaults.plans[i].to).format('HH.mm')));
	    }

		
		/*console.log("arrFrom : ");
		console.log(arrFrom);
		
		console.log("arrTo : ");
		console.log(arrTo);*/
		
	    return { min: arrFrom.min(), max: arrTo.max() };
	};
	
	function splitFormat(str, sep, begTag, endTag){
		let res = "";
		
		if(str != ""){			
			let tabS = str.split(sep);
			
			for(let i = 0 ; i < tabS.length ; i++){
				res += begTag + tabS[i] + endTag;
			}
		}
		
		return res;
	};

	
	var _methods = {
        init : function(options) {
			//defaults.plans.length = options[i];

            defaults.plans = options;           
            _methods.draw();

            /*
			if(options != undefined){
				for(let i = 0 ;  i < options.length ; i++){
					_methods.add(options[i]);
				}
			}*/
        }, draw: function () {
            if (defaults.plans.length == 0) return false;
            let maxInf = getMaxInf();

            let maxTimeFrom = formatTimeToStr(maxInf.min);
            let minTimeTo = formatTimeToStr(maxInf.max);
			
			//console.log("maxInf : " + maxTimeFrom + " - " + minTimeTo);

            let date_Plan = moment(defaults.plans[0].date).format('DD_MM_YYYY');
            let spDate = moment(defaults.plans[0].date).format('DD/MM/YYYY');
            let maxFrom = moment(spDate + ' ' + maxTimeFrom, "DD/MM/YYYY hh:mm").toDate();
            let maxTo = moment(spDate + ' ' + minTimeTo, "DD/MM/YYYY hh:mm").toDate();
            let step = defaults.plans[0].step;
            let timeDiff = Math.abs(maxTo.getTime() - maxFrom.getTime());
            timeDiff = timeDiff / (1000 * 60);
            timeDiff = Math.round(timeDiff / step);

            tab = $('#' + date_Plan + " table[plantable] tbody");
            
			console.log("maxFrom : " + maxFrom);
                     

            for (let l = 0 ; l < defaults.plans.length ; l++) {
				   
                let settings = defaults.plans[l];
				//if(settings.id == "192511"){
									
					let d_send = moment(settings.date).format('DD/MM/YYYY');                

					let html = '';
					let _nTo = settings.to.setMinutes(settings.to.getMinutes() + Config.PlanStep);
					tab.find("tr[Plan]").append('<td id="' + settings.id + '" width="' + Config.panelWidth + '" style="height:40px;"><div class="row" style="width:' + Config.panelWidth + 'px"> <div class="col-sm-6">' + settings.id + '</div><div class="col-sm-6 text-right">' +
							 ' <span object="Action" action="editPlan" data="\'' + settings.id + '\', \'' + moment(settings.from).format('DD/MM/YYYY HH:mm') + '\', \'' + moment(_nTo).format('DD/MM/YYYY HH:mm') + '\'" data-toggle="tooltip" data-placement="top" title="Modifier le plan" class="glyphicon glyphicon-pencil spAct" style="color:#5bc0de"></span>' +

							 //' <span object="Action" action="updatePlanStatus" data="\'' + settings.id + '\'" PlanStatus="' + settings.Status + '"><img src="' + settings.linkStatus + '" alt="' + settings.labelStatus + '" title="' + settings.labelStatus + '" height="16" width="16" border="0" /></span>' +
							  ' <span object="Action" action="getUpdatePlanStatus" data="\'' + settings.id + '\'" PlanStatus="' + settings.Status + '"><img src="' + settings.linkStatus + '" alt="' + settings.labelStatus + '" title="' + settings.labelStatus + '" height="16" width="16" border="0" /></span>' +
							  
							 ' <span object="Action" action="sendPlan" data="\'' + settings.id + '\', \'' + d_send + '\'" data-toggle="tooltip" data-placement="top" title="Envoyer le plan" class="fa fa-map-marker spAct" style="color:#f44250;font-size:16px"></span>' +
							 ' <span object="Action" action="printPlan" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer le plan" class="glyphicon glyphicon-print spAct" style="color:#5bc0de"></span>' +
							 ' <span object="Plan" action="removePlan" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Supprimer le plan" class="glyphicon glyphicon-remove spAct" style="color:red"></span>' +
							 '</div></div></td>');
					
					tab.find("tr[info]").append('<td  style="height:50px;"><div class="row"> '
																						+ ' 	<div class="col-sm-3">' + ((settings.score != undefined && settings.score != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Score" class="glyphicon glyphicon-filter"></span> <span class="badge" style="font-size:14px;background:#5bc0de" piType="score">' + settings.score + '</span>') : ' ') + '</div>'
											+ ' 	<div class="col-sm-3">' + ((settings.weight != undefined && settings.weight != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Poids" class="glyphicon glyphicon-scale"></span> <span class="badge" style="font-size:14px;background:#d8d7d7"  piType="weight">' + settings.weight + '</span>') : ' ') + '</div>'
											+ ' 	<div class="col-sm-3">' + ((settings.volume != undefined && settings.volume != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Volume" class="glyphicon glyphicon-resize-vertical"></span> <span class="badge" style="font-size:14px;background:#b9e0aa" piType="volume">' + settings.volume + '</span>') : ' ') + '</div>'
											+ ' 	<div class="col-sm-3">' + ((settings.palette != undefined && settings.palette != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Nbr palette" class="glyphicon glyphicon-menu-hamburger"></span> <span class="badge" style="font-size:14px;background:#f5dc9f" piType="palette">' + settings.palette + '</span>') : ' ') + '</div>'
												+ '</div>'

												+ '</td>');
					tab.find("tr[note]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10' value=''> " + settings.note + '</div><div class="col-md-2 text-right "><span object="Plan" action="getModifNote" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Modifier la remarque" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
					if (Config.hasVehicules) tab.find("tr[vehicule]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10' value=''> " + settings.vehicule + '</div><div class="col-md-2 text-right "><span object="Action" action="getChangeVehicule" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer véhicule" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
					if (Config.hasDrivers) tab.find("tr[driver]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10'  value=''> " + settings.driver + '</div><div class="col-md-2 text-right "><span object="Action" action="getChangeDriver" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer chauffeur" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
					if (Config.hasHelpers) tab.find("tr[helpers]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10'  value=''> " + splitFormat(settings.helpers, ',', '<span class="label label-info">', '</span> ') + '</div><div class="col-md-2 text-right"><span object="Action" action="getChangeHelpers" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer aides" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');

					let tag = (Config.hasHelpers) ? "helpers" : "vehicule";

					var _width = (($(tab).find("tr:eq(0) td").length - 1) * Config.panelWidth) + 100;
					$('#' + date_Plan + " div.myTopScroll div").width(_width);
				//}
            }

            let _lines = "";
			
			let dateLoop = new Date(maxFrom.getTime());
            for (let i = 0 ; i < timeDiff ; i++) {
                let timeStr = moment(dateLoop).format('DD/MM/YYYY HH:mm'); //FX
                let timeStrOnly = moment(dateLoop).format('HH:mm'); //FX
                let dateLoopEnd = new Date(dateLoop.getTime());
				
                dateLoopEnd.setMinutes(dateLoopEnd.getMinutes() + step);
                let timeStrEnd = moment(dateLoopEnd).format('HH:mm');
                let timeStrVal = parseFloat(moment(dateLoop).format('HH.mm'));
				let timeStrEndVal = parseFloat(moment(dateLoopEnd).format('HH.mm'));
                

                _lines += "<tr tranche='" + timeStr + "' tyle='height:40px;'><td style='width:60px;color:red;'>" + timeStrOnly + " - " + timeStrEnd + "</td>";

                for (let l = 0 ; l < defaults.plans.length ; l++) {
                    let settings = defaults.plans[l];
						if(l==0){
							console.log("timeStr : " + timeStr);
						}
						
						let planTimeMax = parseFloat(moment(settings.from).format('HH.mm'));
						let planTimeMin = parseFloat(moment(settings.to).format('HH.mm'));
						let _class = (timeStrVal >= planTimeMax && timeStrEndVal <= planTimeMin) ? "success" : "active";

						if(settings.id == "192511")
						{
							console.log("_class : "  + timeStrVal + " >= " + planTimeMax  + " && "  + timeStrEndVal + " <= " + planTimeMin + " >>> "  + _class);
						}
					
					
						let misIcons = "<div rub='" + timeStr + "' rPlanId='" + settings.id + "'></div>";
						let _str = "<td class='" + _class + "' style='font-size:11px;height:40px'>" + misIcons + "</td>";

						_lines += _str;
						
					
					//}
                }

                _lines += "</tr>";

                oldTime = timeStr;
                dateLoop.setMinutes(dateLoop.getMinutes() + step);
            }

            tab.append(_lines);
        }
        , isEdit : function(id){
            let _pl = _getPlanIndex(id);
            return (_pl !=undefined && _pl.isEdit == 1)? true : false;
        }
        ,
		addNewPlan: function(date){
					let htmlDialog = '<div class="modal fade" id="dialogAddPlan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Ajouter un nouveau plan</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+
					'				<input type="hidden" value="' + date + '" id="AddPlan_date" name="AddPlan_date" />' + 
					'				<div class="input-group" style="margin:5px 0px">' +
					'					<span class="input-group-addon" style="width:120px;text-align:left">Date début</span>' + 
					'					<input type="text" class="form-control Hdate"  value="' + date + ' 08:00" name="AddPlan_from" id="AddPlan_from" placeholder="Date début" aria-describedby="basic-addon1" />' +
					'				</div>'+
					'				<div class="input-group" style="margin:5px 0px">'+
					'					<span class="input-group-addon" style="width:120px;text-align:left">Date fin</span>'+
					'					<input type="text" class="form-control Hdate" value="' + date + ' 18:00" name="AddPlan_to" id="AddPlan_to" placeholder="Date fin" aria-describedby="basic-addon1" />' +
					'				</div>'+
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-info btn-ok" id="btnDialogAddPlan">Ajouter</a>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogAddPlan").remove();
					$("body").append(htmlDialog);
					$('#dialogAddPlan').modal('show');		

					$('#dialogAddPlan input.Hdate').datetimepicker({
						locale: 'fr',
						format: 'DD/MM/YYYY HH:mm'
					});

					$("#AddPlan_from").blur(function () {
					    let _dfrom = ($(this).val().length > 10) ? $(this).val().substring(0, 10) : '';
					    $("#AddPlan_to").val(_dfrom + ' 18:00');
					});
					
					$('#dialogAddPlan').on("click", "#btnDialogAddPlan", function(event){
						let _date = $('#AddPlan_date').val();
						let _from = /*date + " " +*/ $('#AddPlan_from').val();
						let _to = /* date + " " + */ $('#AddPlan_to').val();
						let _tToday = moment(new Date(), 'DD/MM/YYYY HH:mm');
						let _fdate = moment(_from, 'DD/MM/YYYY HH:mm');
						let _tdate = moment(_to, 'DD/MM/YYYY HH:mm');
						
						if (_fdate.diff(_tToday, 'days') >= 0 && _tdate.diff(_fdate, 'minutes') > 30 ) { 

						    /*let settings = */ $().Action("addPlan", { date: date, from: _from, to: _to });
						    /*if(settings != undefined){
                                
                            }
                            */
						    $('#dialogAddPlan').modal('hide');
						}
						else
						    alert("Erreur date !");
					});						
		},
		editPlan: function (id, from , to ) {
		    let htmlDialog = '<div class="modal fade" id="dialogAddPlan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' +
            '	<div class="modal-dialog modal-sm">' +
            '		<div class="modal-content">		' +
            '			<div class="modal-header">' +
            '				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
            '				<h4 class="modal-title" id="myModalLabel">Modifier plan</h4>' +
            '			</div>' +
            '			<div class="modal-body">' +
            
            '				<div class="input-group" style="margin:5px 0px">' +
            '					<span class="input-group-addon" style="width:120px;text-align:left">Date début</span>' +
            '					<input type="text" class="form-control Hdate"  value="' + from + '" name="AddPlan_from" id="AddPlan_from" placeholder="Date début" aria-describedby="basic-addon1" />' +
            '				</div>' +
            '				<div class="input-group" style="margin:5px 0px">' +
            '					<span class="input-group-addon" style="width:120px;text-align:left">Date fin</span>' +
            '					<input type="text" class="form-control Hdate" value="' + to + '" name="AddPlan_to" id="AddPlan_to" placeholder="Date fin" aria-describedby="basic-addon1" />' +
            '				</div>' +
            '			</div>' +
            '			<div class="modal-footer">' +
            '				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>' +
            '				<a class="btn btn-info btn-ok" id="btnDialogAddPlan">Modifier</a>' +
            '			</div>' +
            '		</div>' +
            '	</div>' +
            '</div>';

		    $("#dialogAddPlan").remove();
		    $("body").append(htmlDialog);
		    $('#dialogAddPlan').modal('show');

		    $('#dialogAddPlan input.Hdate').datetimepicker({
		        locale: 'fr',
		        format: 'DD/MM/YYYY HH:mm'
		    });

		    $("#AddPlan_from").blur(function () {
		        let _dfrom = ($(this).val().length > 10) ? $(this).val().substring(0, 10) : '';
		        //$("#AddPlan_to").val(_dfrom + ' 18:00');
		    });

		    $('#dialogAddPlan').on("click", "#btnDialogAddPlan", function (event) {
		        
		        let _from = /*date + " " +*/ $('#AddPlan_from').val();
		        let _to = /* date + " " + */ $('#AddPlan_to').val();
		        
		        let _tToday = moment(new Date(), 'DD/MM/YYYY HH:mm');
		        let _fdate = moment(_from, 'DD/MM/YYYY HH:mm');
		        let _tdate = moment(_to, 'DD/MM/YYYY HH:mm');

		        if (_fdate.diff(_tToday, 'days') >= 0 && _tdate.diff(_fdate, 'minutes') > Config.PlanStep) {

		             $().Action("saveEditPlan", { id : id, from: _from, to: _to });		           
		            $('#dialogAddPlan').modal('hide');
		        }
		        else
		            alert("Erreur date !");
		    });
		},
		removePlan: function(planId){
            if(!$().Plan("isEdit", planId)) return false;
					let htmlDialog = '<div class="modal fade" id="dialogRemovePlan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Confirmation de suppression</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+
					'				<input type="hidden" value="' + planId + '" id="AddPlan_Id" name="AddPlan_Id" />' + 					
					'				Voulez-vous vraiment supprimer <br />le plan N° ' + planId + ' ?' + 
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-danger btn-ok" id="btnDialogRemovePlan">Supprimer</a>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogRemovePlan").remove();
					$("body").append(htmlDialog);
					$('#dialogRemovePlan').modal('show');		
					
					$('#dialogRemovePlan').on("click", "#btnDialogRemovePlan", function(event){
						let _id = $('#AddPlan_Id').val();
						
						$().Action("removePlan", _id);
						$('#dialogRemovePlan').modal('hide');
					});						
		},
		removePlanfroBoard : function(id){
			//let settings = defaults.plans[getPlanIndex(id)];
			var pl = _getPlanIndex(id);
			let tabDate = moment(pl.date).format('DD_MM_YYYY');
			let tab = $("#" + tabDate + " table[plantable]");
			let index = $(tab).find("tr[Plan] td").index($("#" + id));
			$("#" + tabDate + " table tr").each(function(){
				$(this).find("td:eq(" + index + ")").remove();
			});
			
			_removePlanIndex(id);
			//var _Planidx = getPlanIndex(id);
			//alert(defaults.plans.length + "\n" + id + "\n" + _Planidx);
		},
		changeStatus: function (id) {
				
				let settings = _getPlanIndex(id);//defaults.plans[getPlanIndex(id)];

				let htmlDialog = '<div class="modal fade" id="dialogChangeStatus" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Changement Statut</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+
					'				<div class="input-group" style="margin:5px 0px;padding:0px;">'+
					'					<span class="input-group-addon" style="text-align:left">Statut</span>' +
					'					<div class="btn-group" id="dialogStatusList">' +
					'					 	<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">'+
					'					   		<span data-bind="label">Séléctionner</span>&nbsp;<span class="caret"></span>'+
					'					 	</button>'+
					'					 	<ul class="dropdown-menu" role="menu"  data-filter>';
					
					for(let ic = 0 ; ic < lStatus.length ; ic++){
					    htmlDialog += '<li role="presentation" value="' + lStatus[ic].value + '" link="' + lStatus[ic].link + '"  status=""><a  role="menuitem" tabindex="-1" href="#">' + lStatus[ic].label + '</a></li>'
					}
					
	            htmlDialog += '						</ul>'+
					'					</div>'+
					'				</div>'+
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-info btn-ok" id="btnDialogChangeStatus">Changer</a>' +
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
	                $("#dialogChangeStatus").remove();
					$("body").append(htmlDialog);
					$('#dialogChangeStatus').modal('show');
					
					$('#dialogStatusList ul').bsDropDownFilter();

					    $(document.body).on('click', '#dialogStatusList ul.dropdown-menu li', function (event) {
						  var $target = $( event.currentTarget );
						    $target.closest("ul").find("li").removeClass("active");
						  $target.addClass("active");
						  
						  $target.closest( '.btn-group' )
							 .find('[data-bind="label"]').text($target.text()).attr("value", $target.closest("li").attr("value"))
                              .attr("link", $target.closest("li").attr("link"))
								.end()
							 .children( '.dropdown-toggle' ).dropdown( 'toggle' );
						  return false;	
					   });
					
					    $("#dialogStatusList").find("li[value='" + settings.vehicule + "']").click(); //$("#dialogVehiculeList").find('[data-bind="label"]').text( settings.vehicule);
					
					    $('#dialogChangeStatus').on("click", "#btnDialogChangeStatus", function (event) {
						//alert('ok > ' + $("#dialogVehiculeList").find('[data-bind="label"]').text());
						
						let _idex = _getPlanPosIndex(id);
						let _date = moment(settings.date).format('DD_MM_YYYY');
						let _text = $("#dialogStatusList").find('[data-bind="label"]');
						let _value = $("#dialogStatusList").find('[data-bind="label"]').attr("value");
						let _link = $("#dialogStatusList").find('[data-bind="label"]').attr("link");
						
						$().Action("updatePlan", id, 'status:' + _value , function(){
						    defaults.plans[_idex].Status = _value; //$("#dialogVehiculeList").find('[data-bind="label"]').text();													
						    defaults.plans[_idex].linkStatus = _link;
							let tab = $('#' + _date + " table[plantable] tbody");
							let index = $(tab).find("tr[Plan] td").index($("#" + settings.id));
							//alert(_link);
							$(tab).find("td[id='" + id + "'] span[planstatus] img").attr("src", _link); //defaults.plans[_date][_idex].vehicule);							
							
							$('#dialogChangeStatus').modal('hide');
						});					
					});			
			
		}
		,
		changeVehicule : function(id) {
			//alert("changeVehicule");
				
				let settings = _getPlanIndex(id);//defaults.plans[getPlanIndex(id)];

				let htmlDialog = '<div class="modal fade" id="dialogChangeVehicule" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Changement véhicule</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+
					'				<div class="input-group" style="margin:5px 0px;padding:0px;">'+
					'					<span class="input-group-addon" style="text-align:left">Véhicule</span>'+
					'					<div class="btn-group" id="dialogVehiculeList">'+
					'					 	<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">'+
					'					   		<span data-bind="label">Séléctionner</span>&nbsp;<span class="caret"></span>'+
					'					 	</button>'+
					'					 	<ul class="dropdown-menu" role="menu"  data-filter>';
					
					for(let ic = 0 ; ic < lVehicules.length ; ic++){
					    htmlDialog += '<li role="presentation" value="' + lVehicules[ic].value + '" vehicule="driver1"><a  role="menuitem" tabindex="-1" href="#">' + lVehicules[ic].label + '</a></li>'
					}
					
	            htmlDialog += '						</ul>'+
					'					</div>'+
					'				</div>'+
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-info btn-ok" id="btnDialogChangeVehicule">Changer</a>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogChangeVehicule").remove();
					$("body").append(htmlDialog);
					$('#dialogChangeVehicule').modal('show');
					
					$('#dialogVehiculeList ul').bsDropDownFilter();

					$( document.body ).on( 'click', '#dialogVehiculeList ul.dropdown-menu li', function( event ) {						
						  var $target = $( event.currentTarget );
						    $target.closest("ul").find("li").removeClass("active");
						  $target.addClass("active");
						  
						  $target.closest( '.btn-group' )
							 .find( '[data-bind="label"]' ).text( $target.text() ).attr("value", $target.closest("li").attr("value"))
								.end()
							 .children( '.dropdown-toggle' ).dropdown( 'toggle' );
						  return false;	
					   });
					
					$("#dialogVehiculeList").find("li[value='" + settings.vehicule + "']").click(); //$("#dialogVehiculeList").find('[data-bind="label"]').text( settings.vehicule);
					
					$('#dialogChangeVehicule').on("click", "#btnDialogChangeVehicule", function(event){
						//alert('ok > ' + $("#dialogVehiculeList").find('[data-bind="label"]').text());
						
						let _idex = _getPlanPosIndex(id);
						let _date = moment(settings.date).format('DD_MM_YYYY');
						let _text = $("#dialogVehiculeList").find('[data-bind="label"]');
						let _value = $("#dialogVehiculeList").find('[data-bind="label"]').attr("value");
						
						$().Action("updatePlan", id, 'vehicule:' + _value , function(){
							defaults.plans[_idex].vehicule = _value;												
							let tab = $('#' + _date + " table[plantable] tbody");
							let index = $(tab).find("tr[Plan] td").index($("#" + settings.id));
							$(tab).find("tr[vehicule] td:eq(" + index + ") div[value]").html(_text); //defaults.plans[_date][_idex].vehicule);
							
							
							$('#dialogChangeVehicule').modal('hide');
						});					
					});			
			
		},		
		changeDriver : function(id){					
				let settings = _getPlanIndex(id); //defaults.plans[getPlanIndex(id)];

				let htmlDialog = '<div class="modal fade" id="dialogChangeDriver" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Changement remorque</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+
					'				<div class="input-group" style="margin:5px 0px;padding:0px;">'+
					'					<span class="input-group-addon" style="text-align:left">Remorque</span>'+					
					'					<div class="btn-group" id="dialogDriverList">'+
					'					 	<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">'+
					'					  	 	<span data-bind="label">Séléctionner</span>&nbsp;<span class="caret"></span>'+
					'					 	</button>'+
					'					 	<ul class="dropdown-menu" role="menu" data-filter>';
					
					for(let ic = 0 ; ic < lDrivers.length ; ic++){
					    htmlDialog += '<li  role="presentation" value="' + lDrivers[ic].value + '" role="menuitem" tabindex="-1" vehicule="driver1"><a href="#">' + lDrivers[ic].label + '</a></li>'
					}
					
	  htmlDialog += '						</ul>'+
					'					</div>'+
					'				</div>'+					
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-info btn-ok" id="btnDialogChangeDriver">Changer</a>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogChangeDriver").remove();
					$("body").append(htmlDialog);
					$('#dialogChangeDriver').modal('show');

					$('#dialogDriverList ul').bsDropDownFilter();
					
					$( document.body ).on( 'click', '#dialogDriverList ul.dropdown-menu li', function( event ) {						
						  
						  var $target = $(event.currentTarget);
						  $target.closest("ul").find("li").removeClass("active");
						  $target.addClass("active");
						  
						  $target.closest( '.btn-group' )
							 .find( '[data-bind="label"]' ).text( $target.text() ).attr("value", $target.closest("li").attr("value"))
								.end()
							 .children( '.dropdown-toggle' ).dropdown( 'toggle' );
						  return false;
						  
					   });
					
					$("#dialogDriverList").find("li[value='" + settings.driver + "']").click(); //"[data-bind="label"]').text( settings.driver);
					
					$('#dialogChangeDriver').on("click", "#btnDialogChangeDriver", function(event){
						//alert('ok > ' + $("#dialogVehiculeList").find('[data-bind="label"]').text());
						
						let _idex = _getPlanPosIndex(id);
						let _date = moment(settings.date).format('DD_MM_YYYY');
					
						let _text = $("#dialogDriverList").find('[data-bind="label"]');
						let _value = $("#dialogDriverList").find('[data-bind="label"]').attr("value");
						
						$().Action("updatePlan", id, 'driver:' + _value , function(){
							
							defaults.plans[_idex].driver = _value;
							
							let tab = $('#' + _date + " table[plantable] tbody");
							let index = $(tab).find("tr[Plan] td").index($("#" + settings.id));
							$(tab).find("tr[driver] td:eq(" + index + ") div[value]").html(_text);

							$('#dialogChangeDriver').modal('hide');
						});
					});	
		},

		changeHelpers : function(id){
				let settings = _getPlanIndex(id); //defaults.plans[getPlanIndex(id)];
				
				let htmlDialog = '<div class="modal fade" id="dialogChangeHelpers" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Changement Equipe</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+	
					'				<div class="input-group" style="margin:5px 0px;padding:0px;">'+
					'					<span class="input-group-addon" style="text-align:left">Equipe</span>'+										
					'					<input type="text" value="' + settings.helpers + '" data-role="tagsinput" />' +
					'				</div>'+
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-info btn-ok" id="btnDialogChangeHelpers">Changer</a>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogChangeHelpers").remove();
					$("body").append(htmlDialog);
					$('#dialogChangeHelpers').modal('show');
					
					let elt = $('input[data-role="tagsinput"]');
					elt.tagsinput({
					  typeaheadjs: {
						name: 'helpers',
						displayKey: 'label',
						source: helpers.ttAdapter() 
					  }
					});

                    $('input[data-role="tagsinput"]').on('beforeItemAdd', function(event) {
                        let res = isContainValue(lVehicules, event.item);
                        //console.log(event.item + "-" + res);
                        event.cancel = !res;
                    });
					
					//settings.helpers;
					
					
					$('#dialogChangeHelpers').on("click", "#btnDialogChangeHelpers", function(event){
						let Hvalues = $('input[data-role="tagsinput"]').tagsinput('items');
						let _Hstr = "";
						for(let i = 0 ; i < Hvalues.length ; i++){
							if(Hvalues[i] != "")
								_Hstr += Hvalues[i] + ",";
						}
						if(_Hstr.length > 0) _Hstr = _Hstr.substring(0, _Hstr.length-1);
						
						let _date = moment(settings.date).format('DD_MM_YYYY');	
						let _idex = _getPlanPosIndex(id);
						
						$().Action("updatePlan", id, 'helper:' + _Hstr , function(){
							
							defaults.plans[_idex].helpers = _Hstr;
							
							let tab = $('#' + _date + " table[plantable] tbody");
							let index = $(tab).find("tr[Plan] td").index($("#" + settings.id));
							$(tab).find("tr[helpers] td:eq(" + index + ") div[value]").html(
								splitFormat(defaults.plans[_idex].helpers, ',', '<span class="label label-info">', '</span> ') 
							);

							$('#dialogChangeHelpers').modal('hide');
						});
					});	
		},
		getModifNote : function(id){
                if(!$().Plan("isEdit", id)) return false;

				let settings = _getPlanIndex(id); //defaults.plans[getPlanIndex(id)];
				
				let htmlDialog = '<div class="modal fade" id="dialogChangeNote" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Modification remarque</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+	
					'				<div class="input-group" style="margin:5px 0px;padding:0px;">'+
					'					<span class="input-group-addon" style="text-align:left">Remarque</span>'+										
					'					<input type="text" value="' + settings.note + '" id="txt_note" class="form-control" />' +
					'				</div>'+
					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
					'				<a class="btn btn-info btn-ok" id="btnDialogChangeNote">Modifier</a>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogChangeNote").remove();
					$("body").append(htmlDialog);
					$('#dialogChangeNote').modal('show');
																	
					$('#dialogChangeNote').on("click", "#btnDialogChangeNote", function(event){
						let txtval = $('#txt_note').val();
												
						let _date = moment(settings.date).format('DD_MM_YYYY');	
						let _idex = _getPlanPosIndex(id);
						
						$().Action("updatePlan", id, 'note:' + txtval , function(){
							
							defaults.plans[_idex].note = txtval;
							
							let tab = $('#' + _date + " table[plantable] tbody");
							let index = $(tab).find("tr[Plan] td").index($("#" + settings.id));
							$(tab).find("tr[note] td:eq(" + index + ") div[value]").html(txtval);

							$('#dialogChangeNote').modal('hide');
						});
					});	
		},
		getModifStatus : function(id){
                if(!$().Plan("isEdit", id)) return false;

				let settings = _getPlanIndex(id); //defaults.plans[getPlanIndex(id)];
                let _options = '<div class="dropdown">'+ 
                      '<button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown"><span id="statusLabel" value="">' + settings.labelStatus + '</span>' +
                      '<span class="caret"></span></button>' + 
                      '<ul class="dropdown-menu">';
                        
                      

                for(let i = 0 ;  i < Config.planStatus.length ; i++){
                   _options += "<li value='" + Config.planStatus[i].value + "'><a href='#'>" + Config.planStatus[i].label + "</a></li>";
                } 

                _options += '</ul>'+
                    '</div>';

				let htmlDialog = '<div class="modal fade" id="dialogChangeStatus" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
					'	<div class="modal-dialog modal-sm">'+
					'		<div class="modal-content">		'+
					'			<div class="modal-header">'+
					'				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'+
					'				<h4 class="modal-title" id="myModalLabel">Modification Statut</h4>'+
					'			</div>'+
					'			<div class="modal-body">'+	


					'				<div class="input-group" style="margin:5px 0px;padding:0px;">' +
					'					<span class="input-group-addon" style="text-align:left">Statut</span>' +										
					                    _options +
					'				</div>' +


					'			</div>'+							
					'			<div class="modal-footer">'+
					'				<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>'+
                    '				<button type="button" class="btn btn-info btn-ok" id="btnDialogChangeStatus1">Valider</button>'+
					'			</div>'+
					'		</div>'+
					'	</div>'+
					'</div>';
					
					$("#dialogChangeStatus").remove();
					$("body").append(htmlDialog);
					$('#dialogChangeStatus').modal('show');

                    $("li[value]").click(function(event){
                        //event.preventDefault();
                        //event.stopPropagation();

                        let  _statustxt = $(this).find("a").html();
                        let _statusCode =  $(this).attr("value");
                        $("#statusLabel").attr("value", _statusCode).html(_statustxt);
                        //return false;
                        event.preventDefault();
                    });
																	
					$('#dialogChangeStatus').on("click", "#btnDialogChangeStatus1", function(event){												
						let _date = moment(settings.date).format('DD_MM_YYYY');	
						let _idex = _getPlanPosIndex(id);
						
                        let statusCode = $("#statusLabel").attr("value"); //$("#lstPlanStatus option:selected").val();

                        if(statusCode != '') {
                            statusCode = 'status:' + statusCode;

						    $().Action("updatePlan", id, statusCode , function(){		
                                $().Action("getPlanInf", id);							
							    $('#dialogChangeStatus').modal('hide');
						    });
                        }
					});

                    

		},
		get : function(id){
			let options = {};
			//let keys = Object.keys(defaults.plans);
			//for(let i = 0 ; i < keys.length ; i++){
			let plans = defaults.plans;//[keys[i]];
				for(let ik = 0 ; ik < plans.length ; ik++){
					if(plans[ik].id == id){
						options = plans[ik];
						break;
					}
				}
			//}
			return options;
		}, changePlanStatus :  function( options) {
            
            let _tab = $("tr[Plan] td[id='" + options.id + "']").closest("table tbody");

            let index = $(_tab).find("tr[Plan] td").index($("#" + options.id));	
            
			$("tr[plan] td:eq(" + index + ") span[planstatus] img").attr("src", options.status).attr("alt", options.label).attr("title",  options.label);
            
            _setPlanEdit(options.id, options.isEdit);
            
            //piType
        }, changeInf :  function( options) {
            let idxPlan = _getPlanPosIndex(options.id);
            let _tab = $("tr[Plan] td[id='" + options.id + "']").closest("table tbody");

            let index = $(_tab).find("tr[Plan] td").index($("#" + options.id));	
            
			$("tr[info] td:eq(" + index + ") span[piType='score']").html(options.score);
            $("tr[info] td:eq(" + index + ") span[piType='weight']").html(options.weight);
            $("tr[info] td:eq(" + index + ") span[piType='volume']").html(options.volume);
            $("tr[info] td:eq(" + index + ") span[piType='palette']").html(options.palette);
            
			if(options.isEdit != undefined) {				
                defaults.plans[idxPlan].labelStatus = options.labelStatus;
                $("tr[plan] td:eq(" + index + ") span[planstatus] img").attr("src", options.linkStatus).attr("alt", options.labelStatus).attr("title",  options.labelStatus);            
                _setPlanEdit(options.id, options.isEdit);
            }
            //piType
        },
        add : function(options) {  
			var settings = $.extend({
				id:0,
				date: new Date(),
				vehicule: '',
				driver: '',
				helpers: '',
				from: '07:30',
				to: '15:00',
				step: 30,
				breaks : []
			}, options);
			/*
			let date_Plan = moment(settings.date).format('DD_MM_YYYY'); //FX
			let d_send = moment(settings.date).format('DD/MM/YYYY');
			//if(defaults.plans[date_Plan] == undefined) defaults.plans[date_Plan] = [];
			//defaults.plans[date_Plan].push(settings);			
			
			defaults.plans.push(settings);
			
			let html = 	'';
			let timeDiff = Math.abs(settings.to.getTime() - settings.from.getTime());
			timeDiff = timeDiff / (1000 * 60);
			timeDiff = Math.round(timeDiff / settings.step);
			
			tab = $('#' + date_Plan + " table[plantable] tbody");
						
			tab.find("tr[Plan]").append('<td id="' + settings.id + '" width="' + Config.panelWidth + '" style="height:40px;"><div class="row" style="width:' +  Config.panelWidth + 'px"> <div class="col-sm-6">' + settings.id + '</div><div class="col-sm-6 text-right">' +
                     
                     ' <span object="Action" action="updatePlanStatus" data="\'' + settings.id + '\'" PlanStatus="' + settings.Status + '"><img src="' + settings.linkStatus + '" alt="' + settings.labelStatus + '" title="' + settings.labelStatus + '" height="16" width="16" border="0" /></span>' + 
                     ' <span object="Action" action="sendPlan" data="\'' + settings.id + '\', \'' + d_send + '\'" data-toggle="tooltip" data-placement="top" title="Envoyer le plan" class="fa fa-map-marker spAct" style="color:#f44250;font-size:16px"></span>' + 
                     ' <span object="Action" action="printPlan" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer le plan" class="glyphicon glyphicon-print spAct" style="color:#5bc0de"></span>' + 
                     ' <span object="Plan" action="removePlan" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Supprimer le plan" class="glyphicon glyphicon-remove spAct" style="color:red"></span>' + 
                     '</div></div></td>');
			//tab.find("tr[vehicule]").append("<td><div class='row'><div class='col-md-9'> " + settings.vehicule + '</div><div class=""col-md-3" style="text-align:right"><span object="Plan" action="changeVehicule" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer véhicule" class="glyphicon glyphicon-pencil"></span></div></div></td>');
			tab.find("tr[info]").append('<td  style="height:50px;"><div class="row"> <div class="col-sm-3">' + ((settings.score != undefined && settings.score != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Score" class="glyphicon glyphicon-filter"></span> <span class="badge" style="font-size:14px;background:#5bc0de" piType="score">' + settings.score + '</span>') : ' ') + '</div>'
										+ ' <div class="col-sm-3">' + ((settings.weight != undefined && settings.weight != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Poids" class="glyphicon glyphicon-scale"></span> <span class="badge" style="font-size:14px;background:#d8d7d7"  piType="weight">' + settings.weight + '</span>') : ' ') + '</div>'
										+ ' <div class="col-sm-3">' + ((settings.volume != undefined && settings.volume != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Volume" class="glyphicon glyphicon-resize-vertical"></span> <span class="badge" style="font-size:14px;background:#b9e0aa" piType="volume">' + settings.volume + '</span>') : ' ') + '</div>'
										+ ' <div class="col-sm-3">' + ((settings.palette != undefined && settings.palette != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Nbr palette" class="glyphicon glyphicon-menu-hamburger"></span> <span class="badge" style="font-size:14px;background:#f5dc9f" piType="palette">' + settings.palette + '</span>') : ' ') + '</div>'
										+ '</div>'
                                        
                                        + '</td>');
										
										
            tab.find("tr[note]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10' value=''> " + settings.note + '</div><div class="col-md-2 text-right "><span object="Plan" action="getModifNote" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Modifier la remarque" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			if (Config.hasVehicules) tab.find("tr[vehicule]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10' value=''> " + settings.vehicule + '</div><div class="col-md-2 text-right "><span object="Action" action="getChangeVehicule" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer véhicule" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			if(Config.hasDrivers) tab.find("tr[driver]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10'  value=''> " + settings.driver + '</div><div class="col-md-2 text-right "><span object="Action" action="getChangeDriver" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer chauffeur" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			if (Config.hasHelpers) tab.find("tr[helpers]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10'  value=''> " + splitFormat(settings.helpers, ',', '<span class="label label-info">', '</span> ') + '</div><div class="col-md-2 text-right"><span object="Action" action="getChangeHelpers" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer aides" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			
			let tag = (Config.hasHelpers) ? "helpers" : "vehicule";
			let oldTime = "";
			let dateLoop = new Date(settings.from.getTime());
			for(let i = 0 ; i < timeDiff ; i++){
				let timeStr = moment(dateLoop).format('DD/MM/YYYY HH:mm'); //FX
				let timeStrOnly = moment(dateLoop).format('HH:mm'); //FX
				let dateLoopEnd = new Date(dateLoop.getTime());
				dateLoopEnd.setMinutes(dateLoopEnd.getMinutes() + settings.step);
				
				let timeStrEnd = moment(dateLoopEnd).format('HH:mm'); //FX
				
				if (tab.find("tr[tranche='" + timeStr + "']").length > 0) {
				    let misIcons = "<div rub='" + timeStr + "' rPlanId='" + settings.id + "'>FIX DD</div>"; // : '';
				    let _str = "<td class='active' style='font-size:11px;height:40px'>" + misIcons + "</td>";

				    tab.find("tr[tranche='" + timeStr + "']").append(_str); //getNbrTds(1, dateLoop, 1));
				}
				else {
					if(oldTime == ""){
					    tab.find("tr[" + tag + "]").after("<tr style='height:40px;' tranche='" + timeStr + "'><td style='width:60px;color:red;'>" + timeStrOnly + " - " + timeStrEnd + "</td>" + getTds(date_Plan, timeStr) + "</tr>");
					}
					else {
					    tab.find("tr[tranche='" + oldTime + "']").after("<tr style='height:40px;' tranche='" + timeStr + "'><td style='width:60px;color:red;'>" + timeStrOnly + " - " + timeStrEnd + "</td>" + getTds(date_Plan, timeStr) + "</tr>");
					}
				}
				
				oldTime = timeStr;
				dateLoop.setMinutes(dateLoop.getMinutes() + settings.step);
			}

			var _width = (($(tab).find("tr:eq(0) td").length - 1) * Config.panelWidth) + 100;
			$('#' + date_Plan + " div.myTopScroll div").width(_width);
			*/
			
			let date_Plan = moment(settings.date).format('DD_MM_YYYY');
			let d_send = moment(settings.date).format('DD/MM/YYYY');
			/*if(defaults.plans[date_Plan] == undefined) defaults.plans[date_Plan] = [];
			defaults.plans[date_Plan].push(settings);*/

			defaults.plans.push(settings);
			
			let html = 	'';
			let timeDiff = Math.abs(settings.to.getTime() - settings.from.getTime());
			timeDiff = timeDiff / (1000 * 60);
			timeDiff = Math.round(timeDiff / settings.step);
			
			tab = $('#' + date_Plan + " table[plantable] tbody");
			let _nTo = settings.to.setMinutes(settings.to.getMinutes() + Config.PlanStep);
						
			tab.find("tr[Plan]").append('<td id="' + settings.id + '" width="' + Config.panelWidth + '" style="height:40px;"><div class="row" style="width:' +  Config.panelWidth + 'px"> <div class="col-sm-6">' + settings.id + '</div><div class="col-sm-6 text-right">' +
                     
                     ' <span object="Action" action="updatePlanStatus" data="\'' + settings.id + '\'" PlanStatus="' + settings.Status + '"><img src="' + settings.linkStatus + '" alt="' + settings.labelStatus + '" title="' + settings.labelStatus + '" height="16" width="16" border="0" /></span>' + 
                     ' <span object="Action" action="sendPlan" data="\'' + settings.id + '\', \'' + d_send + '\'" data-toggle="tooltip" data-placement="top" title="Envoyer le plan" class="fa fa-map-marker spAct" style="color:#f44250;font-size:16px"></span>' + 
                     ' <span object="Action" action="printPlan" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer le plan" class="glyphicon glyphicon-print spAct" style="color:#5bc0de"></span>' + 
                     ' <span object="Plan" action="removePlan" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Supprimer le plan" class="glyphicon glyphicon-remove spAct" style="color:red"></span>' + 
                     '</div></div></td>');
			//tab.find("tr[vehicule]").append("<td><div class='row'><div class='col-md-9'> " + settings.vehicule + '</div><div class=""col-md-3" style="text-align:right"><span object="Plan" action="changeVehicule" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer véhicule" class="glyphicon glyphicon-pencil"></span></div></div></td>');
			tab.find("tr[info]").append('<td  style="height:50px;">' 
										+ '<div class="row"> ' 
										+ ' 	<div class="col-sm-3">' + ((settings.score != undefined && settings.score != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Score" class="glyphicon glyphicon-filter"></span> <span class="badge" style="font-size:14px;background:#5bc0de" piType="score">' + settings.score + '</span>') : ' ') + '</div>'
										+ ' 	<div class="col-sm-3">' + ((settings.weight != undefined && settings.weight != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Poids" class="glyphicon glyphicon-scale"></span> <span class="badge" style="font-size:14px;background:#d8d7d7"  piType="weight">' + settings.weight + '</span>') : ' ') + '</div>'
										+ ' 	<div class="col-sm-3">' + ((settings.volume != undefined && settings.volume != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Volume" class="glyphicon glyphicon-resize-vertical"></span> <span class="badge" style="font-size:14px;background:#b9e0aa" piType="volume">' + settings.volume + '</span>') : ' ') + '</div>'
										+ ' 	<div class="col-sm-3">' + ((settings.palette != undefined && settings.palette != '') ? ('<span data-toggle="tooltip" data-placement="top" title="Nbr palette" class="glyphicon glyphicon-menu-hamburger"></span> <span class="badge" style="font-size:14px;background:#f5dc9f" piType="palette">' + settings.palette + '</span>') : ' ') + '</div>'
										+ '</div>'
                                        
                                        + '</td>');
										
										
            tab.find("tr[note]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10' value=''> " + settings.note + '</div><div class="col-md-2 text-right "><span object="Plan" action="getModifNote" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Modifier la remarque" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			if (Config.hasVehicules) tab.find("tr[vehicule]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10' value=''> " + settings.vehicule + '</div><div class="col-md-2 text-right "><span object="Action" action="getChangeVehicule" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer véhicule" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			if(Config.hasDrivers) tab.find("tr[driver]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10'  value=''> " + settings.driver + '</div><div class="col-md-2 text-right "><span object="Action" action="getChangeDriver" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer chauffeur" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			if (Config.hasHelpers) tab.find("tr[helpers]").append("<td  style='height:40px;'><div class='row'><div class='col-md-10'  value=''> " + splitFormat(settings.helpers, ',', '<span class="label label-info">', '</span> ') + '</div><div class="col-md-2 text-right"><span object="Action" action="getChangeHelpers" data="\'' + settings.id + '\'" data-toggle="tooltip" data-placement="top" title="Changer aides" class="glyphicon glyphicon-pencil specSpanAction"></span></div></div></td>');
			
			let tag = (Config.hasHelpers) ? "helpers" : "vehicule";
			let oldTime = "";
			let dateLoop = new Date(settings.from.getTime());
			for(let i = 0 ; i < timeDiff ; i++){
				let timeStr = moment(dateLoop).format('DD/MM/YYYY HH:mm'); //FX
				let timeStrOnly = moment(dateLoop).format('HH:mm'); //FX
				let dateLoopEnd = new Date(dateLoop.getTime());
				dateLoopEnd.setMinutes(dateLoopEnd.getMinutes() + settings.step);
				
				let timeStrEnd = moment(dateLoopEnd).format('HH:mm'); //FX
				
				if (tab.find("tr[tranche='" + timeStr + "']").length > 0) {
				    let misIcons = /*(parseInt(settings.id) > 0) ? */ "<div rub='" + timeStr + "' rPlanId='" + settings.id + "'></div>"; // : '';
				    let _str = "<td class='active' style='font-size:11px;height:40px'>" + misIcons + "</td>";

				    tab.find("tr[tranche='" + timeStr + "']").append(_str); //getNbrTds(1, dateLoop, 1));
				}
				else {
					if(oldTime == ""){
					    tab.find("tr[" + tag + "]").after("<tr style='height:40px;' tranche='" + timeStr + "'><td style='width:60px;color:red;'>" + timeStrOnly + " - " + timeStrEnd + "</td>" + getTds(date_Plan, timeStr) + "</tr>");
					}
					else {
					    tab.find("tr[tranche='" + oldTime + "']").after("<tr style='height:40px;' tranche='" + timeStr + "'><td style='width:60px;color:red;'>" + timeStrOnly + " - " + timeStrEnd + "</td>" + getTds(date_Plan, timeStr) + "</tr>");
					}
				}
				
				oldTime = timeStr;
				dateLoop.setMinutes(dateLoop.getMinutes() + settings.step);
			}

			var _width = (($(tab).find("tr:eq(0) td").length - 1) * Config.panelWidth) + 100;
			$('#' + date_Plan + " div.myTopScroll div").width(_width);
			
		},
        updateScore : function(date){ 
            
            // alert($('#' + moment(date).format('DD_MM_YYYY')).length);
            // alert(_getTotalPeriodes(moment(date).format('DD_MM_YYYY')))

            let tab = $('#' + moment(date).format('DD_MM_YYYY') + " div.panel-body div table[plantable] tbody");
            // alert(tab.length);
			let _empty = $(tab).find("td.success").length;
			let _full = $(tab).find("td.info").length;
			
			let _total = _empty + _full;
			// alert(_empty + "\n" + _full + "\n" + _total);
			// alert(_full + " - " + _empty + "-" + ((_empty / _total) * 100) + ((_full / _total) * 100));
			let diffPercent = ((_empty / _total) * 100).toFixed(2);			
			
			$(tab).closest("div.panel").find("div.progress-bar-danger").css("width", diffPercent + "%");
			$(tab).closest("div.panel").find("div.progress-bar-danger").html(diffPercent + "%");
			diffPercent = ((_full / _total) * 100).toFixed(2);
			
			$(tab).closest("div.panel").find("div.progress-bar-success").css("width", diffPercent + "%");
			$(tab).closest("div.panel").find("div.progress-bar-success").html(diffPercent + "%");

			// alert(date);
			_methods.Rup(date);
		},
        update : function( date ) { 
			/*
			let plans = defaults.plans[moment(date).format('DD_MM_YYYY')]; //FX
			let tab = $('#' + moment(date).format('DD_MM_YYYY') + " table[plantable] tbody");
			$(tab).find("tr[tranche]").each(function(){	
				if(plans.length != $(this).find("td").length - 1){					
					let diff = Math.abs(plans.length - ($(this).find("td").length - 1)); 					
					$(this).append(getNbrTds(diff, $(this).attr("tranche"), $(this).find("td").length));
				}
			});
            
            					
			for(let i = 0 ; i < plans.length ; i++){
				let id = plans[i].id;
				let index = $(tab).find("tr[Plan] td").index($("#" + id));
				
				let timeDiff = Math.abs(plans[i].to.getTime() - plans[i].from.getTime());				
				timeDiff = timeDiff / (1000 * 60);			
				timeDiff = Math.round(timeDiff / plans[i].step);
				let dateLoop = new Date(plans[i].from.getTime());
                console.log(id + " >>>>" + timeDiff);
				
				for(let ik = 0 ; ik < timeDiff ; ik++){
                    
					let timeStr =  moment(dateLoop).format('DD/MM/YYYY HH:mm');
					let elem = $(tab).find("tr[tranche='" + timeStr + "'] td:eq(" + index + ")");
					let prev = $(elem).closest("tr").prev();
                    
					if(prev.length !=0 && prev.attr("tranche")!= undefined && prev.attr("tranche").substring(0,10) != timeStr.substring(0,10)){
							$(elem).closest("tr").css("border-top","4px solid red");							
							$("span[begdate='" + prev.attr("tranche").substring(0,10) + "']").next().html("- " + timeStr.substring(0,10));
					}
					
					if (!elem.hasClass("info")) {
					    elem.removeClass("active")
                        .removeClass("danger")
                        .removeClass("info")
                        .addClass("success");
					}

					dateLoop.setMinutes(dateLoop.getMinutes() + plans[i].step);
				}
			}
            
			
			for(let i = 0 ; i < plans.length ; i++){
				let breaks = plans[i].breaks;
				let id = plans[i].id;				
				let index = $(tab).find("tr[Plan] td").index($("#" + id));
				
				for (let ik = 0 ; ik < breaks.length ; ik++) {				    
					$(tab).find("tr[tranche='" + breaks[ik] + "'] td:eq(" + index + ")")
					.removeClass("active")
					.removeClass("success")
					.removeClass("info")
					.addClass("danger");
				}
			}

			let _htmlInd = '<div style="background-color:#fff"><table class="table table-bordered" style="width:60px;">';
			tab.find("tr").each(function () {
			    if ($(this).find("td:eq(0)").html() == "Info")
			        _htmlInd += "<tr style='width:60px;height:60px;'><td>" + $(this).find("td:eq(0)").html() + "</td></tr>";
			    else
			        _htmlInd += "<tr style='width:60px;height:40px;'><td>" + $(this).find("td:eq(0)").html() + "</td></tr>";
			});
			_htmlInd += "</table></div>";
			$(tab).closest("div.panel-body").find("div[indicator]").html(_htmlInd);
			*/
			
			let plans = defaults.plans; //[moment(date).format('DD_MM_YYYY')]; //FX
            if (defaults.plans.length == 0) return false;

			let tab = $('#' + moment(date).format('DD_MM_YYYY') + " table[plantable] tbody");
			let _htmlInd = '<div style="background-color:#fff"><table class="table table-bordered" style="width:60px;">';
			tab.find("tr").each(function () {

			    if ($(this).find("td:eq(0)").html() == "Info")
			        _htmlInd += "<tr style='width:60px;height:60px;'><td>" + $(this).find("td:eq(0)").html() + "</td></tr>";
			    else
			        _htmlInd += "<tr style='width:60px;height:40px;'><td>" + $(this).find("td:eq(0)").html() + "</td></tr>";
			});
			_htmlInd += "</table></div>";
			$(tab).closest("div.panel-body").find("div[indicator]").html(_htmlInd);
            	

			_methods.Rup(date);
			
			$().Order("drawStop");
			
			//$.fn.setActionFeature();
			
            $("td.active").find("div[rub]").remove();
			
			
			
        }
        ,
        drawRupture: function (planId) {
            
            //if (planId != "10062") return false;
            let settings = _getPlanIndex(planId);
            ////console.log(settings);

            let _date = moment(settings.from).format('DD/MM/YYYY HH:mm');

            let _setPrintIcon = "";

            ////console.log("Pl : " + planId);
            for (let ik = 0; ik < settings.missions.length ; ik++) {
                /*
                    if ($("span[rub_planId='" + settings.id + "'][rub_Id='" + settings.missions[ik].id + "']").length == 0)
                        misIcons += (settings.id = planId && settings.missions[ik].id != _setPrintIcon) ? '<div><span object="Action" action="PrintMission" data=" \'' + settings.id + '\', \'' + settings.missions[ik].date + '\', \'' + settings.missions[ik].id + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer" class="glyphicon glyphicon-print sIcon" style="color:#5bc0de"></span></div>' : '';
                */
                
                let _miss = settings.missions[ik].id;
                let _mId = "";
                if(ik < settings.missions.length - 1)
                    _mId = settings.missions[ik + 1].id

                let _actItem = "";
                let _actItemLabel = "";
                if ((settings.missions[ik].id != "0" && _mId == "0") || settings.missions[ik].id == "0") {
                    _actItem = ' object="Action" action="setMission" data=" \'' + planId + '\', \'' + settings.missions[ik].date + '\', \'' + settings.missions[ik].action + '\'" data-toggle="tooltip" data-placement="top" title="' + ((settings.missions[ik].action == 'add') ? 'Ajouter' : 'Supprimer') + ' mission" ';
                    _actItemLabel = '<span class="glyphicon glyphicon-' + ((settings.missions[ik].action == 'add') ? 'plus' : 'minus') + '" style="font-size:5px;color:' + Config.missionColor[settings.missions[ik].id] + '"></span>';
                }

                let misIcons = '<div style="background:' + Config.missionBackColor[settings.missions[ik].id] + ';color:' + Config.missionColor[settings.missions[ik].id] + ';width:37px;height:35px" class="text-center"><span rub_planId="' + settings.id + '" rub_Id="' + settings.missions[ik].id + '"  class="sIcon" ' + _actItem + ' style="font-size:9px;color:' + Config.missionColor[settings.missions[ik].id] + ';">' + _actItemLabel + 'M' + _miss + '</span>';
                misIcons += '<div>' + 
                            '   <span pId="' + settings.id + '" mId="' + settings.missions[ik].id + '" object="Action" action="showMissionInf" data-toggle="popover" popMiss="pop" data-content="hello" data=" \'' + settings.id + '\', \'' + settings.missions[ik].id + '\'" data-toggle="tooltip" data-placement="top" title="" class="glyphicon glyphicon-info-sign sIcon" style="font-size:9px;color:' + Config.missionColor[settings.missions[ik].id] + '"></span>' + 
                            '   <span object="Action" action="PrintMission" data=" \'' + settings.id + '\', \'' + settings.missions[ik].date + '\', \'' + settings.missions[ik].id + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer mission" class="glyphicon glyphicon-print sIcon" style="font-size:9px;color:' + Config.missionColor[settings.missions[ik].id] + '"></span>' + 
                            '   <span object="Action" action="sendMission" data=" \'' + settings.id + '\', \'' + settings.missions[ik].date + '\', \'' + settings.missions[ik].id + '\'" data-toggle="tooltip" data-placement="top" title="Envoyer mission" class="fa fa-map-marker sIcon" style="font-size:9px;color:' + Config.missionColor[settings.missions[ik].id] + '"></span>' + 
                            '</div>';
                if(settings.missions[ik].id == _setPrintIcon)
                    misIcons = '<div style="background:' + Config.missionBackColor[settings.missions[ik].id] + ';font-size:1px;width:7px;height:35px" class="text-center"><span rub_planId="' + settings.id + '" rub_Id="' + settings.missions[ik].id + '"  class="sIcon" ' + _actItem + 'style="width:100%;height:100%;display:block"></span>';
                //_other = (settings.missions[ik].id != _setPrintIcon) ? '<div><span object="Action" action="PrintMission" data=" \'' + settings.id + '\', \'' + settings.missions[ik].date + '\', \'' + settings.missions[ik].id + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer" class="glyphicon glyphicon-print sIcon" style="color:' + Config.missionColor[settings.missions[ik].id] + '"></span></div>' : " ";

                $("div[Rub='" + settings.missions[ik].date + "'][rPlanId='" + planId + "']").html(misIcons  + "</div>");

                _setPrintIcon = settings.missions[ik].id;
                
                /*
                //console.log("   > " + _setPrintIcon + " != " + planId + " > " +  settings.missions[ik].date + "    " + Math.random());
                if (_setPrintIcon != planId)
                    $("div[Rub='" + settings.missions[ik].date + "'][rPlanId='" + planId + "']").html("<span rrb=''>" + settings.id + "</span>");

                _setPrintIcon = planId;*/
            }

        }
        , setPlanMission: function (options) {
            /*let settings = _getPlanIndex(options.id);
            let _idx = _getPlanPosIndex(options.id);
            if (_idx >= 0) {
                defaults.plans[moment(settings.date).format('DD_MM_YYYY')][_idx].missions = options.missions;
                _methods.Rup(settings.date);
            }*/
			
			
			let settings = _getPlanIndex(options.id);
			console.log(settings);
            let _idx = _getPlanPosIndex(options.id);
			
            if (_idx >= 0) {
				
                defaults.plans[_idx].missions = options.missions;
                //_methods.Rup(settings.date);
            }
			
			_methods.update(settings.date);
			

        }
        , Rup: function (date) {
			/*
            let plans = defaults.plans[moment(date).format('DD_MM_YYYY')];

            $("td.active").find("div[rub]").remove();

            for (let i = 0 ; i < plans.length; i++) {
                if (plans[i].id !== false) {
                    _methods.drawRupture(plans[i].id);
                }
            }

            $.fn.setActionFeature();*/
			
			let plans = defaults.plans;            

            for (let i = 0 ; i < plans.length; i++) {
                if (plans[i].id !== false) {
                    _methods.drawRupture(plans[i].id);
                }
            }
            
            //$("tr[tranche] td.active").remove();        

			$.fn.setActionFeature(); 			
        }
    };	
	
    $.fn.Plan = function( options ) {  
		var t = [];
		if (_methods[options]) {
            return _methods[options].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || ! options) {
            return _methods.init.apply(this, arguments);
        } else {
            $.error('Method ' +  options + ' does not exist ');
        }
    };
}( jQuery ));