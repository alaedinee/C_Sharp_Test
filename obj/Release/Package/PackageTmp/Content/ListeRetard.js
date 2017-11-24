
    function chargerSelect(val) {
        // $(this).attr("nobl");
        // alert('ok');
        document.getElementById('NoBL').value = val;
        document.getElementById('submitBtn').form.submit();
    }
    $().ready(function () {



        $('#listeretard').dataTable();

        $("a").click(function () {


            if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewCom") {

                $.post(
                    "../OT/PopUpMAJViewMAJ",
                    { mode: "", otid: $(this).attr("otid") },
                    function (htmlResult) {
                        $("#PopUpMAJ").remove();
                        $("#container").append(htmlResult);
                        $("#PopUpMAJ").dialog();

                    }
               );

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkNewRemarque") {

                $.post(
                    "../OT/RemarqueOT",
                    { otid: $(this).attr("otid"), path: '../' },
                    function (htmlResult) {
                        $("#RemarqueOT").remove();
                        $("#container").append(htmlResult);
                        $("#RemarqueOT").dialog({ width: 400 });


                    }
               );

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkJoinOT") {

                $.post(SERVER_HTTP_HOST() + '/OT/addGetJoinOT',
               { otid: $(this).attr("otid"), joinOtid: 0, op: 'listOT' },
               function (htmlResult) {


                   htmlResult = '<div id="divJointOT">' + htmlResult + '</div>';

                   $("#divJointOT").remove();
                   $("#container").append(htmlResult);
                   $("#divJointOT").dialog();


                   //                   $("#tableSelectedElement").remove();
                   //                   $("#divJoinElementOT").html(htmlResult);  lnkJoinDOC


               });

            }
            else if ($(this).attr("otid") != null && $(this).attr("id") == "lnkJoinDOC") {

                $.post(SERVER_HTTP_HOST() + '/OT/getUploadFileOTID',
               { otid: $(this).attr("otid") },
               function (htmlResult) {

                   htmlResult = '<div id="divJointDOC">' + htmlResult + '</div>';

                   $("#divJointDOC").remove();
                   $("#container").append(htmlResult);
                   $("#divJointDOC").dialog();


               });

            }


        });


    });