var lat = 33.556273;
var lon = -7.587662;
var map;
var marker = null;
var markersArray = new Array();
var infowindow = null;

$(document).ready(function () {

    var _lastAnim = '';

    $(".leftMenu > div.titre_cat").each(function () {
        var _this = $(this).next();
        $(this).click(function () {
            var _divs = $(".liens_cat");
            _this.show(200, 'linear');
            _divs.not(_this).hide(200, 'linear');
        });
    });
    //$(".leftMenu > div.titre_cat")[0].click();
    //End Anim LeftMenu
    //Begin Event LeftMenu
    $('.liens_cat ul > li > a').click(function () {
        var _name = $(this).attr("action"),
                    _title = $(this).attr("title"),
                     divs = $("div[type]"),
                     div = $("#fr_main");

        $("#title_entity").html(_title);

        divs.not(div).hide(200, 'linear');

        $('.liens_cat > ul > li > a').removeClass('active');
        $(this).addClass('active');

        div.show(200, 'linear');
        $('a.' + _lastAnim + 'panel[action=1]').click();
        _lastAnim = _name;
        $("#RessClic").val($(this).attr("title"));
        //div.slideToggle();
        $("#_IDAppariel").val('0');
        $("#_CAppariel").val('');
        $("#_NAppariel").val('');
        //ressClic = _title;
        //alert($(this).attr("title"));
    });
    //End Event LeftMenu

    $("#displayMap").css("visibility", "hidden");

    jQuery.fn.setAnim = function (obj) {
        var divs = $("div[type]"),
                     div = $("#fr_" + obj);

        divs.not(div).hide(200, 'linear');
        div.show(200, 'linear');
        $('a.' + _lastAnim + 'panel[action=1]').click();
        _lastAnim = obj;
    };
    //Begin Anim LeftMenu
    jQuery.fn.InitDiv = function () {
        $("div[type=Win]").each(function () {
            var _elem = $(this).find("div.right");
            _elem.find("div").html("");
        });
    };

    jQuery.fn.lstInterv = function (IDOT, _type) {
        $("#dv_interventions").html("");

        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getlstInterv", { cond: 'OTID=' + IDOT, type: _type, Op: '' }, function (data) {
            $("#dv_interventions").html(data);
            $('#OTDetail').click();
            $('#dv_aff_interv').css("display", "");
        });
    };

    $.fn.SERVER_HTTP_HOST = function () {
        var url = window.location.href;
        url = url.replace("http://", "");

        var urlExplode = url.split("/");
        var serverName = urlExplode[0];
        var folderName = urlExplode[1].split("#")[0];
        var result = 'http://' + serverName + "/"; //+"/" + folderName;
        return result;
    };

    $('a[action]').click(function () {


        var $target = $($(this).attr('href')),
                    $other = $target.siblings('.active'),
                    animIn = function () {
                        $target.addClass('active').show().css({
                            left: -($target.width())
                        }).animate({
                            left: 0
                        }, 350);
                    };

        if (!$target.hasClass('active') && $other.length > 0) {
            $other.each(function (index, self) {
                _DVELEM = $(this);
                var $this = $(this);
                $this.removeClass('active').animate({
                    left: -$this.width()
                }, 350, animIn);
            });
        } else if (!$target.hasClass('active')) {
            animIn();
        }

    });

    //Begin Ressources
    /* $("a[RessourceID]").click(function () {

       
    //jQuery.fn.InitDiv();
    var _ress = $(this).html();
    $('a.mainpanel[action=1]').click();
    $('#dv_main_step1').html("");

    var _RessourceFamilleID = $(this).attr("FamilleID"),
    _RessourceID = $(this).attr("RessourceID"),
    _RessourceFamille = $(this).attr("action");
    $("#dv_loading_detail").css("display", "");
    $.get($.fn.SERVER_HTTP_HOST() + "/Ressources/GenererDataBy", { RessourceFamille: _RessourceFamille, RessourceFamilleID: _RessourceFamilleID, RessourceID: _RessourceID }, function (data) {
    $("#dv_loading_detail").css("display", "none");
    $('#dv_main_step1').html(data);
    });
        
    });*/

    $("a[action='Planning']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/Planning/planning", function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });
    //End Ressources
    //Begin Plans
    var _MID = 0,
        _MDate = '';
    $("a[action='Plans']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        // $(".secdialog").dialog("close");
        $.get($.fn.SERVER_HTTP_HOST() + "/RDV/RDV", {}, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='Charges']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getSecteurs", { _params: '' }, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    //$("a[action='DetailSect']").click(function () {
    //    $('a.mainpanel[action=1]').click();
    //    $('#dv_main_step1').html("");
    //    $("#dv_loading_detail").css("display", "");
    //    $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getDetailChargeSecteur", { _params: '' }, function (data) {
    //        $("#dv_loading_detail").css("display", "none");
    //        $('#dv_main_step1').html(data);
    //    });
    //});

    $("a[action='Consultation']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/Consultation", { _params: '' }, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='Intervention']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/Interventions", { _params: '' }, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='Confirmation']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html($('#dv_loading').html());
        $.post($.fn.SERVER_HTTP_HOST() + "/OStock/getConfIntv", { _params: '' }, function (data) {
            //alert(data);
            $('#dv_main_step1').html(data);
        });
    });
    //End Plans
    //Begin Pièces & Services
    var _Services = 0;
    $("a[action='Services']").click(function () {
        //jQuery.fn.InitDiv();

        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getServices", function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='Pieces']").click(function () {
        jQuery.fn.InitDiv();

        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getPieces", function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
            //            $('.right').css("height", $('#lstPieces').height() + 300);
            //            $('#_content').css("height", $('#lstPieces').height() + 300 + 20);
        });
    });
    //End Pièces & Services

    //Begin Stock
    var _RessourceID = 0;
    var _GoodsID = 0;

    $("a[action='Stocks']").click(function () {
        $("#_IDGood").val("0");
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getStockPieces", function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='RessourceStocks']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        //$("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getlstRstock", function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='Reservations']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/getReservation", { codeStock: "", beginDate: "", endDate: "", typeRes: "parentP" }, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });

    $("a[action='Historiques']").click(function () {

        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");

        $.post($.fn.SERVER_HTTP_HOST() + "Prevision/getParentRessources", { RessourceFamille: 'prod', lbl: 'lbl_prod|Nom', txt: 'prod', step: '1', mode: 'getGoodList' }, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });

        /*
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/Historiques", { codeStock: "", beginDate: "", endDate: "", title: '' }, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
        */

    });

    //End Stock
    //Begin Importation
    $("a[action='Importer']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/OStock/Import", function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });
    //End Importation

    //Begin manage users
    $.fn.getConnectivity = function () {
        var elem = $(this);
        $.get($.fn.SERVER_HTTP_HOST() + "/Compte/Index", function (data) {
            elem.html(data);
        });
    };

    $.fn.LogIn = function () {
        var username = $("#username").val();
        var password = $("#password").val();

        $.get($.fn.SERVER_HTTP_HOST() + "/Compte/LogIn", { username: username, password: password }, function (data) {
            $('#login').attr('value', 'Chargement...');
            if (data == "1")
                location.reload(true);
            else if (data == "0") {
                $.get($.fn.SERVER_HTTP_HOST() + "/Compte/ChangePw", {}, function (result) {
                    $('#div_login').html(result);

                    alert(result);
                });
            }
            else {
                $.post($.fn.SERVER_HTTP_HOST() + "/Compte/Index", { err: data }, function (data) {
                    if (data) {
                        $('#div_login').html(data);
                    }
                });
            }
            $('#login').attr('value', 'connexion');
        });
    };

    $.fn.PwChanger = function () {
        var password = $("#password").val();
        $.get($.fn.SERVER_HTTP_HOST() + "/Compte/setPw", { password: password }, function (data) {
            //$(_ContentId).html(data);
            if (data == "1")
                location.reload(true);
            else if (data == "0") {
                $.get($.fn.SERVER_HTTP_HOST() + "/Compte/ChangePw", {}, function (result) {
                    $('#div_login').html(result);
                });
            }
            else {
                $.post($.fn.SERVER_HTTP_HOST() + "/Compte/Index", { err: data }, function (data) {
                    if (data) {
                        $('#div_login').html(data);
                    }
                });
            }
        });
    };

    $.fn.LogOut = function () {
        $.get($.fn.SERVER_HTTP_HOST() + "/Compte/Logout", function (data) {
            // $(_ContentId).html(data);
            //$(location).attr('href', "Index");
            if (data)
                location.reload(true);
        });
    };

    $.fn.verifyConnectivity = function () {
        var jqxhr = $.ajax($.fn.SERVER_HTTP_HOST() + "/Compte/verifyConnectivity")
        .done(function (data) {
            if (data == "False") {
                $.fn.setErrorConnectivity();
            } else {
                $("#OmniHeader").css("display", "none");
                $("body").css("background-color", "#0C4B48");
                $("#error").hide();
                $("#invisible").remove();
            }

            $.fn.setConnectivity();
        })
        .fail(function () {
            $("#error").hide();
            $("#invisible").remove();
        });
    };

    $.fn.setErrorConnectivity = function () {
        $.fn.setError("Non connecté, <a href='index' style='color:#fff'>Essayer maintenant</a>");
        $("#error").show();
        $("#invisible").remove();
        $(_ContentId).append("<div id='invisible' style='position:relative;height:400px;z-index:1000'></div>");
    };

    $.fn.setError = function (msg) {
        $("#error").html(msg);
        $("#error").show();
    };

    $.fn.setConnectivity = function () {
        setTimeout(function () {
            $.fn.verifyConnectivity();
        }, 6000);
    };

    $.fn.enterInput = function () {
        $(this).keypress(function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) {
                $.fn.LogIn();
            }
        });
    };

    $("a[action='Users']").click(function () {
        $('a.mainpanel[action=1]').click();
        $('#dv_main_step1').html("");
        $("#dv_loading_detail").css("display", "");
        $.get($.fn.SERVER_HTTP_HOST() + "/Compte/manageUsers", {}, function (data) {
            $("#dv_loading_detail").css("display", "none");
            $('#dv_main_step1').html(data);
        });
    });
});