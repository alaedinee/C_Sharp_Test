(function ( $ ) {	
	var defaults = {
        blocks: []
    };
	
	var methods = {
        init : function(options) {
			//alert(defaults.plans.length);
        },
        add : function(options) {  
			var settings = $.extend({
				date: new Date(),
				success: "0",
				failed: "100",
				headWidth : 60
			}, options);
			
			if($("#" + moment(settings.date).format('DD_MM_YYYY')).length > 0) return false;
			defaults.blocks.push(settings);

			let html = 	'<div class="panel panel-default">';
			html += 	'	<div class="panel-heading">';
			html += 	'		<div class="row">';
			html += 	'			<div class="col-md-4">';
			html += 	'				<a data-toggle="collapse" data-parent="#' + this.attr('id') + '" href="#' + moment(settings.date).format('DD_MM_YYYY') + '"><span begdate="' + moment(settings.date).format('DD/MM/YYYY') + '">' + moment(settings.date).format('DD/MM/YYYY') + '</span> <span enddate=""></span></a>';
			html +=		'			</div>';
			html += 	'			<div class="col-md-4">';
			html += 	'				<div class="progress" style="margin:0px">';
			html += 	'					<div class="progress-bar progress-bar-success" role="progressbar" style="width:' + settings.success + '%">' + settings.success + '%</div>';
			html += 	'					<div class="progress-bar progress-bar-danger" role="progressbar" style="width:' + settings.failed + '%">' + settings.failed + '%</div>';
			html += 	'				</div>';
			html += 	'			</div>';
			html += 	'			<div class="col-md-4 text-right">&nbsp;</div>';
			html += 	'		</div>';
			html += 	'	</div>';
			html +=     '	<div id="' + moment(settings.date).format('DD_MM_YYYY') + '" class="panel-collapse collapse">';		
			html +=     '		    <div class="panel-body">';
			html +=     '			    <div><span object="Plan" action="addNewPlan" data="\'' + moment(settings.date).format('DD/MM/YYYY') + '\'" data-toggle="tooltip" data-placement="top" title="Ajouter un nouveau plan" class="glyphicon glyphicon-plus spAct" style="color:#5bc0de"></span>  <span object="Action" action="printPlans" data="\'' + moment(settings.date).format('DD/MM/YYYY') + '\'" data-toggle="tooltip" data-placement="top" title="Imprimer plans" class="glyphicon glyphicon-print spAct" style="color:#b9e0aa"></span></div>';
            
			html +=     '               <div>';
			html +=     '                   <div indicator="" style="z-index:2;margin-top:20px;position:absolute;"></div>';
			html +=     '                   <div>';
			html +=     '                       <div class="myTopScroll"><div class="div1">&nbsp;</div></div>';
			html +=     '			            <div style="z-index:1;overflow:auto;background-color:#fff" class="MyTansP myTopScrollChild">';
			html +=     '                           <table class="table table-bordered" style="width:50px" planTable="">';
			html += 	'				                <tbody>';
			html +=     '					                <tr Plan=""><td style="height:40px;width:' + 60 + 'px">Plan N°</td></tr>';
			html +=     '					                <tr Info=""><td style="height:60px;width:' + 60 + 'px">Info</td></tr>';
            html +=     '					                <tr note=""><td style="height:40px;width:' + 60 + 'px">Remarque</td></tr>';
			html +=     (Config.hasVehicules)?'					                <tr vehicule=""><td style="height:40px;width:' + 60 + 'px">Véhicule</td></tr>': '';
			html +=     (Config.hasDrivers)? '					                <tr driver=""><td style="height:40px;width:' + 60 + 'px">Remorque</td></tr>' : '';
			html +=      (Config.hasHelpers)? '					                <tr helpers=""><td style="height:40px;width:' + 60 + 'px">Equipe</td></tr>' : '';
			html += 	'				                </tbody>';
			html +=     '			                </table>';
			html +=     '                       </div>';
			html +=     '                   </div>';
			html +=     '		        </div>';
			html +=     '		  </div>';
			html += 	'	</div>';
			html += 	'</div>';
			
			this.append(html);
		},
        show : function( ) { 
			//alert(defaults.plans.length);
		},
        update : function( content ) { 
			this.html("");
			methods.add.apply(this, defaults.blocks[0]);
		}
    };	
	
    $.fn.Block = function( options ) {  
		var t = [];
		if (methods[options]) {
            return methods[options].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || ! options) {
            return methods.init.apply(this, arguments);
        } else {
            $.error('Method ' +  options + ' does not exist on jQuery.tooltip');
        }
    };
}( jQuery ));