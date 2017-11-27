<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Main.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

        <link href="../../Content/style.css" rel="stylesheet" type="text/css" media="screen" />
        <script type="text/javascript" src="../../Scripts/script.js" charset="UTF-8"></script>


    <link href="../../Content/DataTables/media/css/demo_table.css" rel="stylesheet" type="text/css" media="screen" />
    <link rel="stylesheet" href="../../Content/css/jquery-ui.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="../../Content/css/jquery-ui-timepicker-addon.css" media="screen" />
    <script type="text/javascript" src="../../Content/js/jquery.dataTables.js" charset="UTF-8"></script>

    <script type="text/javascript" src="../../Content/js/jquery-ui.js" charset="UTF-8"></script>
    <script src="../../Content/js/jquery.ui.datepicker-fr.js" type="text/javascript"></script>  
    <script type="text/javascript" src="../../Content/js/jquery-ui-timepicker-addon.js" charset="UTF-8"></script>



                        <div id="_content" style="width: 100% ; border:0" >
                            <div id="contenu">
                                <div id="texte_article_p" style="width: 95%; height: 5px">

                                    <%--<% Response.Write(ViewBag._RessourceContents); %>--%>
                                    <!-- Begin main -->
                                    <div id="fr_main">
                                        <div class="right" style="height:1000px">
                                            <div class="mainpanel panel" id="dv_main_step1" style='display:block'>
                                            sssssss</div>
                                            <div class="mainpanel panel" id="dv_main_step2">
                                            </div>
                                            <div class="mainpanel panel" id="dv_main_step3">
                                            </div>
                                            <div class="mainpanel panel" id="dv_main_step4">
                                            </div>
                                            <div class="mainpanel panel" id="dv_main_step5">
                                            </div>
                                            <div class="mainpanel panel" id="dv_main_step6">
                                            </div>
                                        </div>
                                        <br clear="both" />
                                        <!-- Begin Links Steps -->
                                        <a href="#dv_main_step1" class="mainpanel panel" action='1'>Step1</a>
                                        <a href="#dv_main_step2" class="mainpanel panel" action='2'>Step2</a>
                                        <a href="#dv_main_step3" class="mainpanel panel" action='3'>Step3</a>
                                        <a href="#dv_main_step4" class="mainpanel panel" action='4'>Step4</a>
                                        <a href="#dv_main_step5" class="mainpanel panel" action='5'>Step5</a>
                                        <a href="#dv_main_step6" class="mainpanel panel" action='6'>Step6</a>
                                        <!-- End Links Steps -->
                                    </div>
                                    <!-- End main -->
                                </div>
                                <div class="clr"></div>
                            </div>
                        </div>
                        <br clear="both" />

                <a action="Emplacement" ></a>

    <script>
        $(document).ready(function () {
            $("a[action='1']").click();
            $("a[action='Emplacement']").click();
        });
    </script>
</asp:Content>