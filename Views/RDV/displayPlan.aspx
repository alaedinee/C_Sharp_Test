<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title>Google Maps JavaScript API v3 Example: Directions Waypoints</title>
<link href="http://code.google.com/apis/maps/documentation/javascript/examples/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.6&sensor=false"></script>
<!--<script src="http://maps.gstatic.com/intl/fr_ALL/mapfiles/api-3/7/11/main.js" type="text/javascript"></script>-->
<script type="text/javascript" src="../../Content/infobox.js"></script>
<style type="text/css">
	#adr{ text-align:left; 
						width: 200px;
						height:20px;
						border-radius: 5px;
						margin-bottom:10px;
						margin-top:20px;
					}
	
</style>
<script type="text/javascript">
  var directionDisplay;
  var directionsService = new google.maps.DirectionsService();
  var geocoder = new google.maps.Geocoder();
  var map;
  var waypts = [];
  var markers = [];
  var directionsVisible = false;
  var markerArray = [];
  var stepDisplay;
  
  // Fonction d'initialisation de la carte
  function initialize() {
    directionsDisplay = new google.maps.DirectionsRenderer();
	var suisse = new google.maps.LatLng(46.53333,6.66667);
    var myOptions = {
      zoom: 8,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: suisse
    }
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    directionsDisplay.setMap(map);
	stepDisplay = new InfoBox();
	var rendererOptions = {
      map: map,
      suppressMarkers : true,
	  suppressInfoWindows: true,
    }
    calcRoute();
	directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);

  }
  
  // Fonction de transformation d'un string en tableau
  function stringSplit(ch)
	 {
		var reg=new RegExp("[#]+", "g");
		var tab=new Array();
		tab=ch.split(reg);
		
		return tab;
	 }
  function clientSplit(ch)
	 {
		var reg=new RegExp("[$]+", "g");
		var tab=new Array();
		tab=ch.split(reg);
		
		return tab;
	 }
  
  //Infobox function
  function attachInstructionText(marker, text) {
	  
			 var myOptions = {
                         content: text
                        ,disableAutoPan: false
                        ,maxWidth: 0
                        ,pixelOffset: new google.maps.Size(20, -80)                    
                        ,zIndex: 2
                        ,boxStyle: {
                          background: '#ffffff'
                          ,opacity: 0.75
                          ,width: "250px"
						  ,margin:"0px"
						  ,border: "2px solid #fff"
				 		  ,borderRadius:"5px"
				 		  ,textAlign:"center"
						  ,minHeight:"90px"
                         }
                        ,closeBoxMargin: "5px 2px 5px 2px"
                        ,closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif"
                        ,infoBoxClearance: new google.maps.Size(1, 2)
                        ,isHidden: false
                        ,pane: "floatPane"
						,cursor: "url('http://maps.gstatic.com/mapfiles/openhand_8_8.cur'), default"
						,enableEventPropagation: true
                };
   google.maps.event.addListener(marker, 'click', function() {
	   
		stepDisplay.setOptions(myOptions);
     	stepDisplay.open(map, marker);
		map.setCenter(marker.getPosition()); 
    });
  }
  
  // AddMarker events
 function showInfoWindow(directionResult, clients) {
 
    var Route = directionResult.routes[0];
    var marker;
	var content; 
	var alphabet=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	//var icon = "https://chart.googleapis.com/chart?chst=d_map_xpin_icon&chld=pin_star|car-dealer|00FFFF|FF0000";
	//edge_lt
    marker=new google.maps.Marker({
									position: Route.legs[0].start_location, 
									map: map,
									icon: "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=" + alphabet[0] + "|FF0000|000000"
								 });
	content='<div style="color:#FFF;font:13px tahoma;margin: 5px;margin-right:18px; margin-top:2px;padding: 0px; background-color: #6F6A71;border-radius:2px;">' + '<b>' + clients[0] + '</b></div>' + '<div style="font:12px verdana;color:darkgreen;margin: 5px;padding: 5px; background-color: #ffffff;">' + '<b style="color: black;"> Adresse :  </b>'+ Route.legs[0].start_address + '</div>';
	
					attachInstructionText(marker, content);
					markerArray.push(marker);
					
	 var i=0;
	 
	do{	
		var icon = "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=" + alphabet[i+1] + "|FF0000|000000";
	  	marker=new google.maps.Marker({
										position: Route.legs[i].end_location, 
										map: map,
										icon: icon
								   });
	
	  content='<div style="color:#FFF;font:13px tahoma;margin: 5px;margin-right:18px; margin-top:2px;padding: 0px; background-color: #6F6A71;border-radius:2px;">' +'<b>' + clients[i+1] +'</b></div>' + '<div style="font:13px verdana;color:darkgreen;margin: 5px;padding: 5px;">' + '<b style="color: black;"> Adresse : </b>' + Route.legs[i].end_address + '</div>';
	  
		attachInstructionText(marker, content);	
			 markerArray.push(marker);
				i++;
	} while(i < Route.legs.length)
	google.maps.event.trigger(markerArray[0], "click");
 } //End function

  //Calcul itinéraire entre plusieurs adresses
  function calcRoute() {
    //var waypts = [];
	var tabl=document.getElementById('adr').value;
	var list=new Array();	
	var reg=RegExp("[#]+", "g");
		list=stringSplit(tabl); 
	var listAdress = new Array();
	var listClients=new Array();
	var listInter=new Array();
    var destinationCoord=new Array();
	var str;
	
	//Liste de clients et liste d'adresses 
 	for(var i=0; i<list.length; i++)
	{
		var str=list[i];
		if(str!="")
		{
			var temp=clientSplit(str);
			
			listClients[i]=temp[0];
			listAdress[i] = temp[1];
		}
	}
	var count=listAdress.length;
		 //Création du contenu du point de départ
			var opt1=document.createElement('option');
			opt1.value=listAdress[0];
			opt1.label=listAdress[0];
			document.getElementById("start").appendChild(opt1);
		//Création du contenu du point d'arrivé
			var opt2 = document.createElement('option');
			opt2.value=listAdress[count-1];
			opt2.label=listAdress[count-1];
   		 document.getElementById("end").appendChild(opt2);
		 
   		var start = document.getElementById("start").value;
    	var end = document.getElementById("end").value;
		
		//Liste d'adresse intermédiares: les waypoints
	  for (var i=1; i<listAdress.length-1; i++)
	  {
		  destinationCoord[i-1] = listAdress[i];	
	  } 
	
	//Création des balise filles de Waypoints
	for(var i=0; i<destinationCoord.length; i++)
	{
		var inp = document.createElement('option');
			inp.value=destinationCoord[i];
			inp.label=destinationCoord[i];
			document.getElementById('waypoints').appendChild(inp);
	}
	
	var checkboxArray = document.getElementById("waypoints");
	//Remplissage waypoints
    for (var i = 0; i < checkboxArray.length; i++) {
      
        waypts.push({
            location:checkboxArray[i].value,
            stopover:true});
         }
		 
	 //Itinéraire request
   var request = {
        origin: start, 
        destination: end,
        waypoints: waypts,
        optimizeWaypoints: false,
        travelMode: google.maps.DirectionsTravelMode.DRIVING
    };
    directionsService.route(request, function(response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(response);
		directionsDisplay.setPanel(document.getElementById("directions_panel")); 
		showInfoWindow(response, listClients);
      }
    });
	directionsVisible = true;
  }
  
  //Suppression de Markers
  function clearMarkers() {
    for (var i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
    }
	for (var i = 0; i < markerArray.length; i++) {
      markerArray[i].setMap(null);
    }
  }
  
  //Suppression de waypoinyts
  function clearWaypoints() {
    markers = [];
	markerArray = [];
    start = null;
    end = null;
    waypoints = [];
    directionsVisible = false;
  }
  
  //Suppression de l'itinéraire
  function reset() {
    clearMarkers();
    clearWaypoints();
    directionsDisplay.setMap(null);
    directionsDisplay.setPanel(null);
    directionsDisplay = new google.maps.DirectionsRenderer();
    directionsDisplay.setMap(map);
    directionsDisplay.setPanel(document.getElementById("directions_panel"));    
  }
</script>
</head>
<body onload="initialize()">
<div id="map_canvas" style="float:left;width:69%;height:100%;"></div>

<input type="hidden" id="adr" value="<%: ViewData["id"] %>">


<div id="directions_panel" style="float:right;width:30%;height:100%;background-color:#FFEE77;overflow:scroll;"></div>

<input type="hidden" id="Hidden1" value="<%: ViewData["id"] %>">
<!--début-->
  <select id="start" style="visibility:hidden;">
  </select>
  <!-- Waypoints -->
  <select multiple id="waypoints" style="visibility:hidden;">
  </select>
  <!-- end -->
<select id="end" style="visibility:hidden;">
</select>
</body>
</html>
