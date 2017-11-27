
Date.prototype.toString = function(format) {
  var mm = ((this.getMonth() + 1 < 10)? '0' : '') + (this.getMonth() + 1);
  var dd = ((this.getDate() < 10)? '0' : '') + this.getDate();
  var yy = this.getFullYear();
  
  var h = ((this.getHours() < 10)? '0' : '') + this.getHours();
  var m = ((this.getMinutes() < 10)? '0' : '') + this.getMinutes();
  var s = ((this.getSeconds() < 10)? '0' : '') + this.getSeconds();
  
  var str = format;
  if (str != undefined) {
      
      str = str.replace('dd', dd);
      str = str.replace('mm', mm);
      str = str.replace('yyyy', yy);
  
      str = str.replace('h', h);
      str = str.replace('m', m);
      str = str.replace('s', s);     
  }
  else
      str = moment(this).format('DD/MM/YYYY HH:mm');

  return str;
  
  //return [this.getFullYear(), (mm < 10)? '0' + mm : mm , (dd < 10)? '0' + dd : dd].join('/');
  //return [ dd[1] && '0', dd , '/', !mm[1] && '0', mm,'/', this.getFullYear()].join('');
};

function _Debug(title, obj) {
    //alert(title + "\n" + obj);
    $("#debugPanel").append("<div><b>" + title + " : </b> " + obj + "</div>");
}

function clone(obj) {
    if (null == obj || "object" != typeof obj) return obj;
    var copy = obj.constructor();
    for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
    }
    return copy;
}

function getToDate(date, from, step, Period) {
    let res ="";
	
	let start_date = moment(from, "DD/MM/YYYY hh:mm").toDate();;			
	//start_date.setHours(parseInt(from.split(':')[0]));
	//start_date.setMinutes(parseInt(from.split(':')[1]));
	
	let dateLoop = new Date(start_date.getTime());
	for(let i = 0 ; i < Period ; i++){
		dateLoop.setMinutes(dateLoop.getMinutes() + step);
	}
	res = moment(dateLoop).format('DD/MM/YYYY hh:mm'); //dateLoop.toString("hh:mm");
	
	return res;
}

