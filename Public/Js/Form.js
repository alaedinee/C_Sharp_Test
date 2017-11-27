var _reloadPage = false;
jQuery.fn.single_double_click = function(single_click_callback, double_click_callback, timeout) {
  return this.each(function(){
    var clicks = 0, self = this;
    jQuery(this).click(function(event){
      clicks++;
      if (clicks == 1) {
        setTimeout(function(){
          if(clicks == 1) {
            single_click_callback.call(self, event);
          } else {
            double_click_callback.call(self, event);
          }
          clicks = 0;
        }, timeout || 300);
      }
    });
  });
}

$(document).ready(function(){
    var autoTab = new Array();

    var tracer = $("#tracer");

    $.fn.getColumnIndex = function (table, name) {
        var idx = 0;
        var cpt = 0;
        $("#" + table + " tr th").each(function () {
            // console.log($(this), name);
            if ($(this).text() == name) idx = cpt;
            cpt++;
        });
        return idx;
    };

    $.fn.URL = function () {
        return $.fn.SERVER_HTTP_HOST();
    };

    $.fn.trace = function (msg, color) {
        tracer.append("<br /><div style='border:1px solid " + color + "'>" + msg + "</div>");
    };

    $.fn.isContains = function (tab, val) {
        var res = -1;
        for(var i = 0 ; i < tab.length ; i++){
            if (tab[i] == val) res = i;
        }

        return res;
    };

    $.fn.getListForm = function (Name, Label, elemID, Type, Mode, Cond) {
        if (typeof (Type) === undefined)
            Type = '';
        if (typeof (Mode) === undefined)
            Mode = '';
        if (typeof (Cond) === undefined)
            Cond = '';

        var link = $.fn.SERVER_HTTP_HOST() + "Ressource/List";
        if (Mode != "")
            link = $.fn.SERVER_HTTP_HOST() + "Ressource/ListVignette"

        $.ajax({
            url: link,
            data: { Name: Name, Label: Label, Type: Type, Cond: Cond },
            success: function (result) {
                $("#" + elemID).html(result);
            },
            async: false
        });
    };

    $.fn.getForm = function (Name, Label, ID, elemID, url, Type, Mode) {
        //$.fn.trace(Name, 'green');        
        if (typeof (Type) === undefined)
            Type = '';
        if (typeof (Mode) === undefined)
            Mode = '';

        // alert(Type);
        $.ajax({
            url: $.fn.SERVER_HTTP_HOST() + "Ressource/getColumns",
            data: { Name: Name, ID: ID, Type: Type },
            success: function(result) {
                

                var lstFields = $.parseJSON(result);

                var contents = '<div class="panel panel-primary">' +
                                  '<div class="panel-heading"><span class="glyphicon glyphicon-' + ((ID == 0) ? 'plus' : 'pencil') + '" aria-hidden="true"></span> ' + ((ID == 0) ? ('Ajout ' + Label) : ('Modification ' + Label + ' : {0}')) + '</div>' +
                                  '<div class="panel-body">';

                for (i = 0 ; i < lstFields.length ; i++) {
                    var field = lstFields[i];
                    if (ID != 0 && field.Code == "code") {
                        contents = contents.replace('{0}', field.Value);
                        continue;
                    }
                    if (field.Type == "Calc")
                    {
                        field.Type = "Text";
                    }

                    var attr = " CCode='" + field.Code + "' ";
                    attr += " CType='" + field.Type + "' "
                    attr += " CID='" + field.ID + "' "
                    attr += " value='" + field.Value + "' "
                    attr += " srcObject='" + field.srcObject + "' "
                    attr += " Object ='" + field.Object + "' "
                    attr += " RessName ='" + Name + "' "
                    attr += " RegEx ='" + field.RegEx + "' "
                    attr += " Where ='" + field.Where + "' "

                    
                    var name = "FR_" + Name + "_" + field.Code;
                    if (field.Type == "Text" || field.Type == "Date" || field.Type == "Time" || field.Type == "Auto") {
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                                '<span class="input-group-addon" style="width:120px;text-align:left">' + field.Label + '</span>' +
                                '<input type="text" class="form-control" name="' + name + '" id="' + name + '" placeholder="' + field.Label + '" ' + attr + ' aria-describedby="basic-addon1">' +
                                ((field.Type == "Auto") ? '<span class="input-group-btn"><button class="btn btn-default" type="button" ><span class="glyphicon glyphicon-filter" aria-hidden="true"></span></button></span> ' : '') +
                              '</div>' +
                            ((field.Type == "Auto") ? '<input type="hidden" name="' + name + '_Auto" id="' + name + '_Auto">' : '') ;
                    }
                    else if (field.Type == "Ressource") {                        
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                                '<span class="input-group-addon" style="width:120px;text-align:left">' + field.Label + '</span>' +
                                '<input type="text" class="form-control" name="' + name + '_Val" id="' + name + '_Val" placeholder="' + field.Label + '" aria-describedby="basic-addon1">' +
                                '<input type="hidden" name="' + name + '" id="' + name + '" ' + attr + '>' +
                                '<span class="input-group-btn">'+
                                '    <button class="btn btn-default" type="button" Label="' + Label + '" Link="' + field.Object + '#' + field.srcObject + '#' + Name + '#' + field.Code + '" name="' + name + '_Btn" id="' + name + '_Btn"   Where="' + field.Where + '"><span class="glyphicon glyphicon-th-list" aria-hidden="true"></span></button>' +
                                '    <button class="btn btn-default" type="button" LinkView="' + field.Object + '#' + field.srcObject + '#' + Name + '#' + field.Code + '" name="' + name + '_View_Btn" id="' + name + '_View_Btn"><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span></button>' +
                                '</span>'+
                              '</div>';
                    }
                    else if (ID != "0" && field.Type == "File") {
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                                '<span class="input-group-addon"  style="width:120px;text-align:left">' + field.Label + '</span>' +
                                '<input type="text" class="form-control" name="' + name + '_Val" id="' + name + '_Val" placeholder="' + field.Label + '" aria-describedby="basic-addon1">' +
                                '<span class="input-group-btn">' +
                                '    <button class="btn btn-default" type="button" File="' + field.Object + '" name="' + name + '_Btn" id="' + name + '_Btn" destBtn="' + name + '"><span class="glyphicon glyphicon-save-file" aria-hidden="true"></span></button>' +
                                '</span>' +
                                '</div>' +
                                '<div class="progress" id="br_' + name + '" style="display:none"> <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"> 0% </div></div>'
                                + '<input type="file" multiple  name="' + name + '" id="' + name + '" ' + attr + ' style="display:none">' +

                               '<div class="panel-group" role="tablist" aria-multiselectable="true"> <div class="panel panel-default"> <div class="panel-heading" role="tab" >' +
                                            '<h4 class="panel-title"> <a role="button" data-toggle="collapse" href="#collapseOne_' + name + '" aria-expanded="true" aria-controls="collapseOne_' + name + '"> Fichiers </a>' +
                                            '</h4> </div> <div id="collapseOne_' + name + '" class="panel-collapse collapse" role="tabpanel"> <div id="lstFile_' + name + '" class="list-group"></div> </div> </div> </div>';
                    }
                    else if (ID != "0" && field.Type == "Photo") {
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                                '<span class="glyphicon cursor" File="' + field.Object + '" name="' + name + '_Btn" id="' + name + '_Btn" destBtn="' + name + '" style="font-size:60px;color:#00bfff" aria-hidden="true"><img src="' + $.fn.DL_HTTP_HOST() + 'noPic.png" height="60" width="60" border="0"/></span>' +
                                '<input type="hidden" class="form-control" name="' + name + '_Val" id="' + name + '_Val" placeholder="' + field.Label + '" aria-describedby="basic-addon1">' +
                                '</div>' +
                                '<div class="progress" id="br_' + name + '" style="display:none"> <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"> 0% </div></div>'
                                + '<input type="file" multiple  name="' + name + '" id="' + name + '" ' + attr + ' style="display:none">'
                        ;
                    }
                    else if (field.Type == "List") {
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                                '<span class="input-group-addon" style="width:120px;text-align:left">' + field.Label + '</span>' +
                                '   <div class="dropdown" >' +
                                '<input type="hidden" name="' + name + '" id="' + name + '" ' + attr + '>' +
                                '       <button class="btn btn-default dropdown-toggle" type="button" id="' + name + 'dropdownMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">' +
                                '<span class="value">' +  ((field.Value != '')? field.Value : 'Séléctionner') + '</span>' +
                                '           <span class="caret"></span>' + 
                                '       </button>' + 
                                '       <ul class="dropdown-menu" aria-labelledby="' + name + 'dropdownMenu"></ul>' + 
                                '   </div>' + 
                                '</div>' ;
                    }

                    else if (field.Type == "Radio" || field.Type == "CheckBox") {
                        var vals = field.srcObject.split('|');
                        var realValues = field.Value.split('|');
                        
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                                        '<span class="input-group-addon" id="basic-addon1" style="width:120px;text-align:left">' + field.Label + '</span>' +
                                        '    <div class="form-control">' +
                                        '       <div class="' + field.Type.toLowerCase() + '" style="margin-top:0px">';

                        for (var ick = 0 ; ick < vals.length ; ick++) {
                            contents += '           <label>' +
                                        '                <input type="' + field.Type + '" value="' + vals[ick] + '" name="' + name + '" id="' + name + '_' + ick + '" ' + ((ick == 0) ? attr : '') + ' ' + (($.fn.isContains (realValues, vals[ick]) > -1) ? 'checked' : '') + ' />' + vals[ick] +
                                        '           </label>';
                        }

                         contents +=    '       </div>' +
                                        '    </div>'+
                                        '</div>';
                    }
                    else if (field.Type == "GeoLocation") {
                        var realValues = field.Value.split('-Sep-');
                        
                        contents += '<div class="input-group" style="margin:5px 0px">' +
                         '<span class="input-group-addon" style="width:120px;text-align:left">' + 'Localisation' + '</span>' +
                         '<input type="text" class="form-control" GeoLocation="' + name + '"  name="' + name + '_Val" id="' + name + '_Val" placeholder="' + 'Location' + '" value="' + ((field.Value == '') ? 'Suisse' : realValues[0]) + '" aria-describedby="basic-addon1">' +
                         '<input type="hidden" name="' + name + '" id="' + name + '" ' + attr + '>' +
                         '<span class="input-group-btn">' +
                         '    <button class="btn btn-default" type="button" name="' + name + '_Btn" id="' + name + '_Btn"><span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></button>' +
                         '</span>' +
                       '</div>';
                        
                        contents += ' <div id="dvGeoLoc" class="clearfix">' +
                        '   <div class="input input-positioned">' +                         
                        '     <input type="hidden" id="geoLat1" value="' + ((field.Value == '') ? '' : realValues[1]) + '">' +
                        '     <input  type="hidden" id="geoLng1" value="' + ((field.Value == '') ? '' : realValues[2]) + '">' +
                        '   </div>' +
                        '   <div class="map-wrapper">' +
                        '    <div id="map"></div>' +
                        '  </div>' +
                        ' </div>';

                        /*
                        contents += '<input id="geolat" type="hidden" value="' + realValues[1] + '" />' +
                        '          <input id="geolng"  type="hidden"  value="' + realValues[2] + '" />' +
                        '        <div class="map-wrapper" id="dvGeoLoc">' +
                        '            <div id="map"></div>' +
                        '        </div>';*/
                    }
                }

                contents += '</div>' +
                            '<div class="panel-footer" style="text-align:right"><button class="btn btn-primary"  id="FR_' + Name + '_' + ID + '_btnSave" type="button" url="' + url + '"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span> ' + ((ID == 0) ? 'Ajouter' : 'Modifier') + '</button></div>' +
                          '</div>';

                $("#" + elemID).html(contents);

                $.fn.initForm(Name, ID, elemID, Type, Mode);
                // $.fn.GeoLoc();
                $("input[GeoLocation]").closest("div").find("button").unbind('click').click({ action: "showMaps" }, showMaps);
                showMaps(null);
            },
            async: false
        });

        

        /*
        $.ajax({
            url: $.fn.SERVER_HTTP_HOST() + "Ressource/getColumns",
            data: { Name: Name, ID: ID }
        }).done(function (data) {
        
        //$.post($.fn.SERVER_HTTP_HOST() + "Ressource/getColumns", { Name: Name, ID: ID }, function (data) {
            
        //$.get($.fn.SERVER_HTTP_HOST() + "Ressource/getColumns", { Name: Name, ID: ID }, function (data) {
           
        },
        async: false
        );
        */
    };

    
    function showMaps(e) {
        $("#dvGeoLoc").slideToggle("fast");
        $(this).find("span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down");
        if (e != null)
            $.fn.GeoLoc();
        // console.log(e);
        return false;
    } 

    $("#geoLoc1").change(function () {
        alert($(this).val());
    });

    $.fn.GeoLoc = function () {
        /*
        $("input[GeoLocation]").closest("div").find("button").click(function () {
            $("#dvGeoLoc").slideToggle("fast");
            $(this).find("span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down");
            return false;
        });

        var addresspicker = $("#addresspicker").addresspicker({
            componentsFilter: 'country:FR'
        });

        var addresspickerMap = $("input[GeoLocation]").addresspicker({
            regionBias: "fr",
            updateCallback: showCallback,
            mapOptions: {
                zoom: 16,
                center: new google.maps.LatLng($("#geoLat").val(), $("#geoLng").val()),
                scrollwheel: false,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            },
            elements: {
                map: "#map",
                lat: "#geolat",
                lng: "#geolng",
            }
        });

        var gmarker = addresspickerMap.addresspicker("marker");
        gmarker.setVisible(true);
        addresspickerMap.addresspicker("updatePosition");

        $('#reverseGeocode').change(function () {
            $("input[GeoLocation]").addresspicker("option", "reverseGeocode", ($(this).val() === 'true'));
        });

        function showCallback(geocodeResult, parsedGeocodeResult) {
            $('#callback_result').text(JSON.stringify(parsedGeocodeResult, null, 4));
        }

        var map = $("input[GeoLocation]").addresspicker("map");
        google.maps.event.addListener(map, 'idle', function () {
            $('#zoom').val(map.getZoom());
        });

        $("input[GeoLocation]").closest("div").find("button").click();*/
        
        if ($("#geoLat1").length != 0) {

            var lat = $("#geoLat1").val();
            var lng = $("#geoLng1").val();
            var zoomInit = 16;

            zoomInit = (lat == NaN || lat == 'NaN' || lat == '') ? 7 : zoomInit;
            lat = (lat == NaN || lat == 'NaN' || lat == '') ? 46.818188 : parseFloat(lat);
            lng = (lng == NaN || lng == 'NaN' || lng == '') ? 8.227511 : parseFloat(lng);


            

            var addresspicker = $("#addresspicker").addresspicker({
                componentsFilter: 'country:FR'
            });
            var addresspickerMap = $("input[GeoLocation]").addresspicker({ //#addresspicker_map
                regionBias: "fr",
                updateCallback: showCallback,
                mapOptions: {
                    zoom: zoomInit,
                    center: new google.maps.LatLng(lat, lng),
                    scrollwheel: false,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                },
                elements: {
                    map: "#map",
                    lat: "#geoLat1",
                    lng: "#geoLng1",
                }
            });

            var gmarker = addresspickerMap.addresspicker("marker");
            gmarker.setVisible(true);
            addresspickerMap.addresspicker("updatePosition");

            $('#reverseGeocode').change(function () {
                $("input[GeoLocation]").addresspicker("option", "reverseGeocode", ($(this).val() === 'true')); //#addresspicker_map
            });

            function showCallback(geocodeResult, parsedGeocodeResult) {
                $('#callback_result').text(JSON.stringify(parsedGeocodeResult, null, 4));
            }
            // Update zoom field
            var map = $("input[GeoLocation]").addresspicker("map"); //#addresspicker_map
            /*
            google.maps.event.addListener(map, 'idle', function () {
                $('#zoom').val(map.getZoom());
            });*/

            // $("input[GeoLocation]").closest("div").find("button").click();
        }
    };

    $.fn.validateFields = function (Name, ID, elemID, Type) {

        var res = true;

        $("#" + elemID + " input[CType]").each(function () {
            //alert($(this).attr("CType") + " = > " + $(this).attr("RegEx"));
            if ($(this).attr("type") != "file" && $(this).attr("RegEx") != '') {
                var _value = "", _type = $(this).attr("CType"), _id = $(this).attr("id");
                var _RegEx = $(this).attr("RegEx");

             
                if (_type == 'Text' || _type == 'Ressource' || _type == "Date" || _type == "List" || _type == 'GeoLocation') _value = $("#" + _id).val();
                if (_type == "Auto") _value = $("#" + _id + '_Auto').val();
                if (_type == 'Radio' || _type == 'CheckBox') {

                    var chVals = $("#" + _id).attr("srcObject").split('|');
                    var chName = $("#" + _id).attr("name");
                    for (var ick = 0 ; ick < chVals.length ; ick++) {
                        if ($("#" + chName + "_" + ick).is(":checked")) _value = (_type == 'CheckBox') ? _value + $("#" + chName + "_" + ick).val() + '|' : $("#" + chName + "_" + ick).val();
                    }
                    if (_type == 'CheckBox' && _value.length > 1) _value = _value.substring(0, _value.length - 1);
                }

             
                var re = new RegExp(_RegEx);

                res = re.test(_value);
                
                if (res)
                    $(this).closest("div.input-group").find("span.input-group-addon").css({
                        "background-color": "#F0F0F0",
                        "color": "#000"
                    });
                else
                    $(this).closest("div.input-group").find("span.input-group-addon").css({
                        "background-color": "red",
                        "color": "#fff"
                    }); //..addClass("errorF");
                
            }
        });


        return res;

    };

    $.fn.initForm = function (Name, ID, elemID, Type, Mode) {

        if (typeof (Type) === undefined)
            Type = '';

        $("#FR_" + Name + "_" + ID + "_btnSave").click(function () {
           
            if (!$.fn.validateFields(Name, ID, elemID, Type)) return false;


            if ($("input[GeoLocation]").length == 1) {
                if ($("input[GeoLocation]").val().length > 3)
                    $("#" + $("input[GeoLocation]").attr("GeoLocation")).val($("input[GeoLocation]").val() + "-Sep-" + $("#geoLat1").val() + "-Sep-" + $("#geoLng1").val());
                else
                    $("#" + $("input[GeoLocation]").attr("GeoLocation")).val("");
            }

            var _jsonData = '';
            $("#" + elemID + " input[CType]").each(function () {
                if ($(this).attr("type") != "file") {
                    var _value = "", _type = $(this).attr("CType"), _id = $(this).attr("id");

                    _jsonData += '{"ID": "' + $(this).attr("CID") + '"';
                    _jsonData += ', "Code": "' + $(this).attr("CCode") + '"';
                    if (_type == 'Text' || _type == 'Ressource' || _type == "Date" || _type == "Time" || _type == "List" || _type == 'GeoLocation') _value = $("#" + _id).val();
                    if (_type == "Auto") _value = $("#" + _id + '_Auto').val();
                    if (_type == 'Radio' || _type == 'CheckBox') {
                        // _value = ($("#" + _id).is(":checked")) ? $("#" + _id).val() : $("#" + $("#" + _id).attr("name") + "_1").val();

                        var chVals = $("#" + _id).attr("srcObject").split('|');
                        var chName = $("#" + _id).attr("name");
                        for (var ick = 0 ; ick < chVals.length ; ick++) {
                            if ($("#" + chName + "_" + ick).is(":checked")) _value = (_type == 'CheckBox') ? _value + $("#" + chName + "_" + ick).val() + '|' : $("#" + chName + "_" + ick).val();
                        }
                        if (_type == 'CheckBox' && _value.length > 1) _value = _value.substring(0, _value.length - 1);
                    }

                    _jsonData += ', "Value": "' + _value + '"}, ';
                }
            });

            if (_jsonData.length > 2) _jsonData = _jsonData.substring(0, _jsonData.length - 2);
            _jsonData = '[' + _jsonData + ']';

            var url = $(this).attr("url");
            $.ajax({
                url: $.fn.SERVER_HTTP_HOST() + "Ressource/Save",
                data: { Name: Name, ID: ID, jsonData: _jsonData, Type: Type },
                success: function (data) {
                    if (parseInt(data) > 0) {
                        if (ID == '0')
                            alert("Ajouté avec succès.");
                        else
                            alert("Modifié avec succès.");

                        if (!_reloadPage) {
                            var lk = url;
                            lk = lk.replace("&Mode=Vignette", "");
                            lk = lk.replace("&Mode=", "");

                            lk += "&Mode=" + Mode;

                            document.location.href = lk;
                        }
                        else
                            document.location.reload();
                    }
                    else if(parseInt(data)==0) {
                        alert("Erreur !");
                    }
                    else if (parseInt(data) < 0) {
                        alert("Déjà disponible sur la base de données !");
                    }
                }, async: false
            });
        });


        //$("#" + elemID + " input[CType='Date']").datepicker({ dateFormat: 'dd/mm/yy' });

        $("#" + elemID + " input[CType='Date']").datetimepicker({
            locale: 'fr',
            format: 'DD/MM/YYYY'
        });


        $("#" + elemID + " input[CType='Time']").datetimepicker({
            locale: 'fr',
            format: 'HH:mm'
        });

        $("#" + elemID + " input[CType='Auto']").each(function () {
            var _srcObject = $(this).attr("srcObject");
            var _Object = $(this).attr("Object");

            if (_Object != '') {
                var _elem = $(this);

                $.ajax({
                    url: $.fn.SERVER_HTTP_HOST() + "Ressource/Auto",
                    data: { Object: _Object, srcObject: _srcObject },
                    success: function (data) {
                        autoTab[_Object] = data.split("\n");

                        $(_elem).autocomplete({
                            source: autoTab[_Object],
                            create: function (event, ui) {

                                for (var i = 0 ; i < autoTab[_Object].length ; i++) {
                                    var tinf = autoTab[_Object][i].split('~');
                                    var value = (tinf.length > 1) ? tinf[1] : tinf[0];
                                    if (tinf[0] == $(_elem).val()) $(_elem).val(value);
                                }

                                return false;
                            },
                            select: function (e, ui) {
                                var tinf = ui.item.value.split('~');
                                this.value = (tinf.length > 1) ? tinf[1] : tinf[0];
                                $('#' + $(_elem).attr("id") + "_Auto").val(tinf[0]);
                                return false;
                            }
                        }).autocomplete("instance")._renderItem = function (ul, item) {
                            var tinf = item.value.split('~');
                            var value = (tinf.length > 1) ? tinf[1] : tinf[0];
                            return $("<li>")
                              .append("<a>" + value + "</a>")
                              .appendTo(ul);
                        };
                    }, async: false
                });
            }
        });


        $("#" + elemID + " input[CType='List']").each(function () {
            var _srcObject = $(this).attr("srcObject");
            var _Object = $(this).attr("Object");
            var _Value = $(this).attr("value");
            
            if (_Object != '') {
                var _elem = $(this);

                $.ajax({
                    url: $.fn.SERVER_HTTP_HOST() + "Ressource/Auto",
                    data: { Object: _Object, srcObject: _srcObject },
                    success: function (data) {
                        autoTab[_Object] = data.split("\n");

                        var _ul = $(_elem).closest("div").find("ul.dropdown-menu");

                        for (var i = 0 ; i < autoTab[_Object].length ; i++) {
                            var tinf = autoTab[_Object][i].split('~');
                            var value = (tinf.length > 1) ? tinf[1] : tinf[0];

                            if (_Value == tinf[0]) $(_elem).closest("div").find("span.value").html(value);
                            $(_ul).append('<li Object="' + _Object + '" Index="' + i + '" ' + ((_Value == tinf[0])? ' class="active" ' : '') + '><a href="#">' + value + '</a></li>');
                        }

                        $(_ul).find("li").click(function () {
                            var tinf = autoTab[$(this).attr('Object')][$(this).attr('Index')].split('~');
                            var value = (tinf.length > 1) ? tinf[1] : tinf[0];

                            $(_elem).val(tinf[0]);
                            $(_elem).closest("div").find("span.value").html(value);
                        });
                    }, async: false
                });
            }
        });

        /*
        $("#" + elemID + " input[CType='Auto']").result(function (event, data, formatted) {
            var lines = data.toString().split(',');
            alert(data.toString());
        });*/

        $("button[GeoLocation]").click(function () {
            $.get($.fn.SERVER_HTTP_HOST() + "Ressource/GeoLocation", function (data) {
                
                //$("#formDialogBody").html($("#dvMap").html());
                //$('#formDialog').modal().find('.modal-title').text("Location");
                
                //$("#geocomplete").val("");

                var _html = '<div class="demo" id="dvMap">' +
                        '    <div class="clearfix">' +
                        '        <div class="input input-positioned">' +
                        '          <label>Address : </label> <input id="addresspicker_map" />   <br/>' +
                        '          <label>Locality: </label> <input id="locality" disabled=disabled> <br/>' +
                        '          <label>District: </label> <input id="administrative_area_level_2" disabled=disabled> <br/>' +
                        '          <label>State/Province: </label> <input id="administrative_area_level_1" disabled=disabled> <br/>' +
                        '          <label>Country:  </label> <input id="country" disabled=disabled> <br/>' +
                        '          <label>Postal Code: </label> <input id="postal_code" disabled=disabled> <br/>' +
                        '          <label>Lat:      </label> <input id="lat" disabled=disabled> <br/>' +
                        '          <label>Lng:      </label> <input id="lng" disabled=disabled> <br/>' +
                        '          <label>Zoom:     </label> <input id="zoom" disabled=disabled> <br/>' +
                        '          <label>Type:     </label> <input id="type" disabled=disabled /> <br/>' +
                        '        </div>' +
                        '        <div class="map-wrapper">' +
                        '            <div id="map"></div>' +
                        '        </div>' +
                        '    </div>' +
                        '</div>';

                $("#formDialogBody").html(_html);
                $('#formDialog').modal().find('.modal-title').text("Location");

                $.fn.GeoLoc();

                //$("#dvMap").html(data);

            });
        });

        


        $("button[Link]").click(function () {
            var _where = $(this).attr("Where");
            var _Title = $(this).closest("div").find("span:eq(0)").html();
            var elem = $(this);
            var _link = $(elem).attr("Link");
            var _lbl = $(elem).attr("Label");
            _link = _link.replace('{0}', _lbl);
            
            $.ajax({
                url: $.fn.SERVER_HTTP_HOST() + "Ressource/Link",
                data: { Link: _link, Where: _where, parentID: Name },
                success: function (data) {
                    //$("#formDialogBody1").html(data);

                    $('#formDialog').modal().find('.modal-body').html(data);
                    $('#formDialog').modal().find('.modal-title').text(_Title );
                }, async: false
            });
        });

       


        $("button[File]").click(function () {
            $("#" + $(this).attr("destBtn")).click();
        });


        $("span[File]").single_double_click(function () {
            if (typeof ($(this).attr("link")) != "undefined")
                open($(this).attr("link"));
        }, function () {
            $("#" + $(this).attr("destBtn")).click();
        });

        $.fn.reloadFiles = function (ID, _Code, _ID, _Object, _Name, _Typef) {
            $.ajax({
                dataType: 'json',
                url: $.fn.SERVER_HTTP_HOST() + "Ressource/getFiles",
                data: { code: ID + "\\" + _Code },
                success: function (result) {

                    if (_Typef == 'File') {
                        var _elem = $("#lstFile_" + _ID);
                        for (var i = 0 ; i < result.length ; i++) {
                            $(_elem).append('<a href="' + $.fn.DL_HTTP_HOST() + ID + "/" + _Code + '/' + result[i] + '" target="blank" class="list-group-item">' + result[i] + '</a>');
                        }
                    }
                    else {
                        for (var i = 0 ; i < result.length ; i++) {
                            if (result[i] == ID + ".jpg") {
                                var lnk = $.fn.DL_HTTP_HOST()  + ID + "/" + _Code + '/' + result[0] + '?s=' + $.fn.random(0, 100);
                                $("#" + _ID + "_Btn").removeClass("glyphicon-user").attr("link", lnk).html('<a><img src="' + lnk + '" height="60" width="60" border="0"/></a>');
                            }
                        }
                    }

                },
                async: false
            });
        };


        $("input[type='file']").each(function () {
            var _Code = $(this).attr("CCode");
            var _ID = $(this).attr("id");
            var _Object = $(this).attr("Object");
            var _Name = $(this).attr("RessName");
            var typef = $(this).attr("CType");

            /*
            $.ajax({
                dataType: 'json',
                url: $.fn.SERVER_HTTP_HOST() + "Ressource/getFiles",
                data: { code: _Name + "\\" + _Code },
                success: function (result) {
                    

                    var _elem = $("#lstFile_" + _ID);
                    for (var i = 0 ; i < result.length ; i++) {
                        
                        $(_elem).append('<a href="http://localhost/dl/Tricolis/uploads/' + _Name + "/" + _Code + '/' + result[i] + '" target="blank" class="list-group-item">' + result[i] + '</a>');
                    }
                },
                async: false
            });
            */
            if (ID != "0") {
                $.fn.reloadFiles(ID, _Code, _ID, _Object, _Name, typef);
            }

            $(this).fileupload({
                dataType: 'json',
                url: $.fn.SERVER_HTTP_HOST() + 'Ressource/UploadFiles?Code=' + _Code + '&Object=' + ID + '&type=' + typef,
                autoUpload: true,
                done: function (e, data) {
                    alert("Chargé...");
                    $("#" + _ID + "_Val").val(data.files[0].name);
                    $("#br_" + _ID).css("display", "none");
                    $.fn.reloadFiles(ID, _Code, _ID, _Object, _Name, typef);
                }
            }).on('fileuploadprogressall', function (e, data) {
                $("#br_" + _ID).css("display", "block");
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $("#br_" + _ID + " div[aria-valuenow]").attr('aria-valuenow', progress).css('width', progress + '%').html(progress + '%');
            });
        });


        if (ID != "0") {
            
            $("button[Link]").each(function () {
                var _inf = $(this).attr("Link").split('#');
                var _val = $(this).closest("div").find("input[type='hidden']").val();
                var Belem = $(this);
                $.ajax({
                    url: $.fn.SERVER_HTTP_HOST() + "Ressource/Parent",
                    data: { Link: $(this).attr("Link") + '#' + _val , type: ''},
                    success: function (result) {
                        var obj = result.split('|');
                        //alert(obj);
                        $("#FR_" + obj[0] + "_" + obj[1]).val(obj[2]);
                        $(Belem).attr("_ID", obj[4]);
                        $("#FR_" + obj[0] + "_" + obj[1] + '_Val').val(obj[3]);
                    },
                    async: false
                });
            });

            $("button[LinkView]").click(function () {
                var _ID = $(this).prev().attr("_ID");
                ///alert(_ID);
                var _inf = $(this).attr("LinkView").split('#');
                var _val = $(this).closest("div").find("input[type='hidden']").val();
                if (parseInt(_ID) > 0) {
                    open($.fn.SERVER_HTTP_HOST() + "Ressource/Form?Name=" + _inf[0] + "&Label=" + _inf[0] + "&ID=" + _ID + "&Type=");
                }
            });

        }

    };

});