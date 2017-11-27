var gpsWin = null;
var Config = {
	orderPanelBackColor : '#dff0d8',
	orderPanelDragBackColor : '#F7E779',
	PlanStep : 30,
    panelWidth : 300,
	zoom:  {"1" : "<div class='row'><div class='col-md-2'>{misIcons}</div><div {cData} class='col-md-7' style='font-size:9px'><span infLabel=''>{settings.label}</span></div><div class='col-md-3 pull-right text-right'>{icons}</div></div>",
	    "2": "<div class='row'><div class='col-md-2'>{misIcons}</div><div {cData} class='col-md-7' style='font-size:9px'><span infLabel=''>{settings.label}</span><br />{settings.info.zip} {settings.info.city}</div><div class='col-md-3'>{icons}</div></div>",
			"3" : "<div class='row'><div class='col-md-2'>{misIcons}</div><div class='col-md-7' style='font-size:9px' {cData}>{settings.info.country}</div><div class='col-md-3'>{icons}</div></div>"
	}
    , hasDrivers: true
    , hasHelpers : true
    , hasVehicules: true
    , missionBackColor: ['#005FCC', '#26507F', '#0077FF', '#4CA0FF', "#91A0FF", "#5D377F", "#9622FF", "#A11BCC"]
    , missionColor:     ['#fff', '#fff', '#fff', '#fff', '#fff', '#fff','#fff', '#fff']
 };
 
var lDrivers = [
	{label: "Alex", value: "11"},
	{label: "Marcos", value: "21"},
	{label: "Aide1", value: "31"},
	{label: "Aide2", value: "41"},
];

var lVehicules = [
	{label: "Alex", value: "11"},
	{label: "Marcos", value: "21"},
	{label: "Aide1", value: "31"},
	{label: "Aide2", value: "41"},
];

var lHelpers = [
	{label: "Alex", value: "11"},
	{label: "Marcos", value: "21"},
	{label: "Aide1", value: "31"},
	{label: "Aide2", value: "41"},
];

var lStatus = [
	{label: "Status1", value: "1"},
	{ label: "Status2", value: "23" },
	{ label: "Status3", value: "31" },
	{ label: "Status4", value: "51" },
];

	function isContainValue(obj, value) {
        let res = false;

        for(let i = 0; i < obj.length ; i++){
            if(obj[i].label == value){
                res = true;
                break;
            }
        }

        return res;
	}


var helpers = new Bloodhound({
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('label'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  local: lHelpers
});
helpers.initialize();