<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>



<script type="text/javascript">

    $().ready(function () {

        function ActNBL() {
            $("#addNOBL").click(function () {
                //alert($("#txtSearch").val() + " ,  " + document.getElementById("otid").value);


                $.post(SERVER_HTTP_HOST() + "/OT/addJoinOTNoBL",
                { joinOTNoBL: $("#txtSearch").val(), otid: document.getElementById("otid").value },
                function (htmlResult) {
                    //alert(htmlResult);
                    $("#txtSearch").val("");
                    $("#dvAddNBL").css("visibility", "hidden");
                    getListJoin();
                });
            });
        }

        function getListJoin() {

            $.post(SERVER_HTTP_HOST() + '/OT/addGetJoinOT',
               { otid: document.getElementById("otid").value, joinOtid: 0, op: 'list' },
               function (htmlResult) {
                   //$("#tableSelectedElement").remove();
                   $("#selectedElement").html(htmlResult);
               });
        }


        getListJoin();


        $("#txtSearch").keyup(function () {
            //alert($("#txtSearch").val());
            
            $.post(SERVER_HTTP_HOST() + "/OT/listeTableSearchOT",
                               { value: $("#txtSearch").val() },
                               function (htmlResult) {
                                   // document.getElementById("listResult").innerHTML = htmlResult;


                                   $("#tableResult").remove();
                                   $("#listResult").append(htmlResult);

                                   if ($("#tableResult").length)
                                       $("#dvAddNBL").css("visibility", "hidden");
                                   else {
                                       $("#dvAddNBL").html("<img id='addNOBL' style='margin:8px 0px 0px 5px' src='" + SERVER_HTTP_HOST() + "/Images/add_file16.png' otid=''  nobl='" + $("#txtSearch").val() + "'  />");
                                       $("#dvAddNBL").css("visibility", "visible");
                                       ActNBL();
                                   }
                               }
                        );

        });



    });


 
</script>
  

    <style type="text/css">
    #contentOT{height:470px;width:610px;}
    
    #search{ width:49%;float:left;margin-top:5px;border-radius: 10px 0 0 10px;background-color:#E6E6E6;}
    
    #divSearch{height:35px;background-color:#424242;border-radius: 10px 0 0 10px;}
    
    #listResult{height:410px;}
    
    #elementSelected{ width:49%;float:right;margin-top:5px;border-radius: 0 10px 10px 0;background-color:#E6E6E6;}
    
    #dialog{height:35px;background-color:#424242;border-radius: 0 10px 10px 0;font-size:17px;
        font-family:Verdana;
        color:#E6E6E6;}
    
    #selectedElement{height:410px;}
 
.trover
{
	background-color: #0099CC;
}
.styleBtn{
 /* color: white;
  background-color: #000080;*/
  text-decoration: none;
  font-weight: bold;
  text-align: center;
  width:80px;
  height:30px;
  float:right;
  margin-right:10px;
 margin-top:3px;
}

#titreList
{
        
        font-size:17px;
        font-family:Verdana;
        color:#E6E6E6;
       
        
   }
    
    #txtSearch
    {
        width:255px;
       height:20px;
       margin-left:5px;
       margin-top:5px;
    }
    
    </style>


    <div id="contentOT">
    <% Response.Write("<input type='hidden' value='"+ ViewData["otid"].ToString()+"' id='otidT' >"); %>
    
 

        <div id="search">
        
            <div id="divSearch">
                <input type="text" style="float:left;" id="txtSearch" />
                <span id="dvAddNBL" style="float:left;visibility:hidden"></span>            
            </div>
            
            <div id="listResult">

            </div>
        
        </div>
        <div id="elementSelected">
            
            <div id="dialog">
            <b>Liste des ordres joingnés</b>
            </div>

            <div id="selectedElement">
           
            </div>

        </div>    
    
    </div>