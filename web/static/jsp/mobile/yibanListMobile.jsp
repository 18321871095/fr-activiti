<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<%
    String register=response.getHeader("register");
    String time=response.getHeader("time");
%>
<script>
    var register="<%=register %>";
    if(register=='false'){
       alert("插件试用阶段，还剩余<%=time %>天")
    }
</script>
<html>
<head>
    <title>已办</title>
    <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <link rel="stylesheet" href="${ctx}/static/css/mui.min.css">
    <link rel="stylesheet" href="${ctx}/static/css/muikuozhan.css">
    <link rel="stylesheet" href="${ctx}/static/css/index_mobile.css">
    <style>
        html,
        body {
            background-color: #efeff4;
        }

        .mui-bar~.mui-content .mui-fullscreen {
            top: 44px;
            height: auto;
        }

        .mui-pull-top-tips {
            position: absolute;
            top: -20px;
            left: 50%;
            margin-left: -25px;
            width: 40px;
            height: 40px;
            border-radius: 100%;
            z-index: 1;
        }

        .mui-bar~.mui-pull-top-tips {
            top: 24px;
        }

        .mui-pull-top-wrapper {
            width: 42px;
            height: 42px;
            display: block;
            text-align: center;
            background-color: #efeff4;
            border: 1px solid #ddd;
            border-radius: 25px;
            background-clip: padding-box;
            box-shadow: 0 4px 10px #bbb;
            overflow: hidden;
        }

        .mui-pull-top-tips.mui-transitioning {
            -webkit-transition-duration: 200ms;
            transition-duration: 200ms;
        }

        .mui-pull-top-tips .mui-pull-loading {
            /*-webkit-backface-visibility: hidden;
            -webkit-transition-duration: 400ms;
            transition-duration: 400ms;*/
            margin: 0;
        }

        .mui-pull-top-wrapper .mui-icon,
        .mui-pull-top-wrapper .mui-spinner {
            margin-top: 7px;
        }

        .mui-pull-top-wrapper .mui-icon.mui-reverse {
            /*-webkit-transform: rotate(180deg) translateZ(0);*/
        }

        .mui-pull-bottom-tips {
            text-align: center;
            background-color: #efeff4;
            font-size: 15px;
            line-height: 40px;
            color: #777;
        }

        .mui-pull-top-canvas {
            overflow: hidden;
            background-color: #fafafa;
            border-radius: 40px;
            box-shadow: 0 4px 10px #bbb;
            width: 40px;
            height: 40px;
            margin: 0 auto;
        }

        .mui-pull-top-canvas canvas {
            width: 40px;
        }

        .mui-slider-indicator.mui-segmented-control {
            background-color: #efeff4;
        }
        .mui-fullscreen .mui-segmented-control~.mui-slider-group{
            position: absolute;
            top: 94px;
        }
        .workflow-state{
            float: right;
            width: 20%;
            margin-top: 14px;
        }
        .mui-table {
            display: table;
            width: 80%;
            table-layout: fixed;
            float: left;
        }
    </style>
</head>
<body>


<div class="mui-content">
    <div id="slider" class="mui-slider mui-fullscreen">
        <div id="sliderSegmentedControl" class="mui-scroll-wrapper  mui-segmented-control ">
            <div class="mui-scroll" style="width: 100%;">
                <a  id="daiban" class="mui-control-item mui-active" <%--href="#item1mobile"--%> style="width: 50%;">
                    已申请(<span id="count1">0</span>)
                </a>
                <a id="yibaocun" class="mui-control-item" <%--href="#item2mobile"--%>  style="width: 50%;">
                    已办理(<span id="count2">0</span>)
                </a>

            </div>
        </div>
        <div id="search_yichengqing" style="width: 100%;height: 45px;background: #fff;">
            <input type="text" id="yishenqing_proname" placeholder="流程名称" style="width: 35%;height: 30px;margin-top: 5px;margin-left: 5px;" />
            <input type="text" id="yishenqing_proinstanceid" placeholder="流程编号"style="width: 35%;height: 30px;margin-top: 5px;" />
            <button id="yishengqingBtn" style="margin-top: 5px;height: 30px;background: #4cd964;padding: 0px 12px;color: #fff;">搜索</button>
        </div>
        <div id="search_yichuli" style="width: 100%;height: 45px;background: #fff;display: none;">
            <input type="text" id="yichuli_proname" placeholder="流程名称" style="width: 35%;height: 30px;margin-top: 5px;margin-left: 5px;" />
            <input type="text" id="yichuli_proinstanceid" placeholder="流程编号"style="width: 35%;height: 30px;margin-top: 5px;" />
            <button id="yichuliBtn" style="margin-top: 5px;height: 30px;background: #4cd964;padding: 0px 12px;color: #fff;">搜索</button>
        </div>
        <div class="mui-slider-group toDo" style="top: 85px;">
            <div id="item1mobile" class="mui-slider-item mui-control-content mui-active">
                <div id="scroll1" class="mui-scroll-wrapper">
                    <div  class="mui-scroll" id="daibanrefresh">
                        <ul id="daibanul"  class="mui-table-view">

                        </ul>
                    </div>
                </div>
            </div>
            <div id="item2mobile" class="mui-slider-item mui-control-content">
                <div class="mui-scroll-wrapper">
                    <div class="mui-scroll" id="yibaocunrefresh">
                        <ul id="yibaocunul"  class="mui-table-view">

                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>
<script src="${ctx}/static/js/mui.js"></script>
<script src="${ctx}/static/js/muikuozhan.js"></script>
<script src="${ctx}/static/js/mui.pullToRefresh.js"></script>
<script src="${ctx}/static/js/mui.pullToRefresh.material.js"></script>
<script type="text/javascript" src="/webroot/decision/view/report?op=emb&resource=finereport.js"></script>
<script>

    (function($) {
        //阻尼系数
        var deceleration = mui.os.ios ? 0.003 : 0.0009;
        $('.mui-scroll-wrapper').scroll({
            bounce: false,
            indicators: true, //是否显示滚动条
            deceleration: deceleration
        });
        $.ready(function() {
            var yishenqingCount=1;
            var yishenqing_self;
            var yishenqing_search=false;
            var yishenqing_proname="";
            var yishenqing_proinstanceid="";
            var yishenqing_empty=false;
            var yishenqing_load=false;

            var yichuliCount=1;
            var yichuliFlag=true;
            var yichuli_self;
            var yichuli_search=false;
            var yichuli_proname="";
            var yichuli_proinstanceid="";
            var yichuli_empty=false;
            var yichuli_load=false;



            var slider = mui("#slider").slider();
            slider.stopped = true; //关闭滑动切换

            inityishengqing();


            $("#slider").on("tap","#daiban",function () {
                jQuery("#item1mobile").show();
                jQuery("#item2mobile").hide();
                jQuery("#search_yichengqing").show();
                jQuery("#search_yichuli").hide();
            });
            $("#slider").on("tap","#yibaocun",function () {
                jQuery("#item1mobile").hide()
                jQuery("#item2mobile").show()
                jQuery("#search_yichengqing").hide();
                jQuery("#search_yichuli").show();
                if(yichuliFlag){
                    inityichuli();
                }
            });

            //已申请搜索
            $("#slider").on("tap","#yishengqingBtn",function (){
                yishenqing_proname =jQuery("#yishenqing_proname").val();
                yishenqing_proinstanceid=jQuery("#yishenqing_proinstanceid").val();
                yishenqing_search=true;
                yishenqing_empty=true;
                yishenqingCount=1;
                if(yishenqing_load){
                    yishenqing_self.refresh(true);
                }

                getYiShenQiList(yishenqingCount,yishenqing_self,"2",yishenqing_proname,yishenqing_proinstanceid);
            });
            //已申请查看办理人
            mui("#daibanul").on("tap","[name='zhankai_yishenqing']",function (e){
                e.stopPropagation();
               alert(this.dataset.assignee)
            });

            //已处理搜索
            $("#slider").on("tap","#yichuliBtn",function (){
                yichuli_proname =jQuery("#yichuli_proname").val();
                yichuli_proinstanceid=jQuery("#yichuli_proinstanceid").val();
                yichuli_search=true;
                yichuli_empty=true;
                yichuliCount=1;
                if(yichuli_load){
                    yichuli_self.refresh(true);
                }
                getYiChuLiList(yichuliCount,yichuli_self,"2",yichuli_proname,yichuli_proinstanceid);
            });
            //已处理查看办理人
            mui("#yibaocunul").on("tap","[name='zhankai_yichuli']",function (e){
                e.stopPropagation();
                alert(this.dataset.assignee)
            });

            //跳转详情页面
            $(".mui-scroll").on("tap",".mui-table-view-cell",function(){
                var reportName=this.dataset.reportname;
                var proinsid=this.dataset.proinsid;
                var requestid=this.dataset.businesskey;
                var proDefineId = this.dataset.prodefinitionid;
                var activityid = this.dataset.activityid;
                var src = "${ctx}/static/jsp/mobile/requestDetailMobile.jsp?requestid="+requestid+"&reportName="+
                    encodeURI(reportName)+"&proDefineID="+proDefineId+"&proinsid="+proinsid+"&activityid="+activityid;
               window.location.href=src;
            })

            //初始化已申请
            function inityishengqing() {
                $("#daibanrefresh").pullToRefresh({
                    up: {//上拉下载
                        auto:true,
                        callback: function() {
                            yishenqing_self = this;
                            var type=yishenqing_search ? "2" : "1";
                            getYiShenQiList(yishenqingCount,yishenqing_self,type,yishenqing_proname,yishenqing_proinstanceid);
                        }
                    }
                });
            }

            //初始化已处理
            function inityichuli() {
                $("#yibaocunrefresh").pullToRefresh({
                    up: {//上拉下载
                        auto:true,
                        callback: function() {
                            yichuli_self = this;
                            var type=yichuli_search ? "2" : "1";
                            getYiChuLiList (yichuliCount,yichuli_self,type,yichuli_proname,yichuli_proinstanceid);
                        }
                    }
                });
            }

           //获取已申请列表
            function getYiShenQiList(page,self,type,proname,proinstanceid){
                $.showLoading("","div");
                $.ajax("${ctx}/mobile/selectHisPro",{
                    type: "POST",
                    data:{num:page,proName:proname,proInstanceid:proinstanceid,type:type},
                    dataType: "json",
                    success: function (data) {
                        $.hideLoading();
                        if(data.msg==='success'){
                            jQuery("#count1").text(data.total);
                            var html = '';
                            var datas = data.result;
                            if(yishenqing_empty){
                                jQuery("#daibanul").empty();
                                yishenqing_empty=false;
                            }
                            for(var i=0;i<datas.length;i++){
                                html += "  <li   data-businessKey='"+datas[i].businessKey+"'  data-reportname='"+datas[i].reportName+"'  data-activityid='"+datas[i].activityid+"'  data-proinsid='"+datas[i].proInsID+"'  data-proname='"+datas[i].proname+"' data-prodefinitionid='"+datas[i].proDefinitionId+"'       class=\"mui-table-view-cell\">\n" +
                                    "                <div class=\"mui-table\">\n" +
                                    "                    <h4 class=\"mui-ellipsis\">"+datas[i].proname+"</h4>\n" +
                                    "                    <div class=\"mui-clearfix toDoBox\">\n" +
                                    "                        <div class=\"mui-table-cell mui-pull-left\">\n" +
                                    "                            <h5>["+datas[i].userRealName+"]</h5>\n" +
                                    "                        </div>\n" +
                                    "                        <div class=\"mui-table-cell mui-pull-left \">\n" +
                                    "                            <span class=\"mui-h5\">提交于"+datas[i].proStartTime+"</span>\n" +
                                    "                        </div><br/>" +
                                    "                        <div style='margin-left: -42px;' class=\"mui-table-cell mui-pull-left \">\n" +
                                    "                            <span class=\"mui-h5\">流程编号"+datas[i].proInsID+"</span>\n" +
                                    "                        </div><br/>" +
                                    "                        <div style='margin-left: -4px;' class=\"mui-table-cell mui-pull-left \">\n" +
                                    "                            <span class=\"mui-h5\">当前办理人&nbsp;"+showAssignee_shenqing(datas[i].currentAssignee)+"</span>\n" +
                                    "                        </div><br/>" +
                                    "                    </div>\n" +
                                    "                </div>\n" +
                                    "<div class=\"workflow-state\">"+
                                    "<span class=\"state-span\">"+datas[i].proCompleteState+"</span>"+
                                        "</div>"+
                                    "            </li>";
                            }
                            jQuery("#daibanul").append(html);
                            self.endPullUpToRefresh(yishenqingCount>=data.yeshu);
                            yishenqingCount++;
                            yishenqing_load=yishenqingCount>=data.yeshu;
                        }else {
                            $.toast("获取已申请列表错误："+data.result);
                        }
                    },
                    error: function () {
                        $.hideLoading();
                        $.toast('服务器响应失败!!!')
                    }

                });
            }

            //获取已处理任务列表
            function getYiChuLiList(page,self,type,proname,proinstanceid) {
                $.showLoading("","div");
                $.ajax("${ctx}/mobile/selectHisProYiChuLi",{
                    type: "POST",
                    data:{num:page,proName:proname,proInstanceid:proinstanceid,type:type},
                    dataType: "json",
                    success: function (data) {
                        $.hideLoading();
                        if(data.msg==='success'){
                            var baocunhtml = '';
                            var datas = data.result;
                            jQuery("#count2").text(data.total);
                            if(yichuli_empty){
                                jQuery("#yibaocunul").empty();
                                yichuli_empty=false;
                            }
                            for(var i=0;i<datas.length;i++){
                                baocunhtml += "  <li  data-businessKey='"+datas[i].businessKey+"'  data-reportname='"+datas[i].proFormKey+"'  data-activityid='"+datas[i].activityid+"'  data-proinsid='"+datas[i].proInstanceId+"'  data-proname='"+datas[i].proname+"' data-prodefinitionid='"+datas[i].proDefineID+"'        class=\"mui-table-view-cell\">\n" +
                                    "                <div class=\"mui-table\">\n" +
                                    "                    <h4 class=\"mui-ellipsis\">"+datas[i].proname+"</h4>\n" +
                                    "                    <div class=\"mui-clearfix toDoBox\">\n" +
                                    "                        <div class=\"mui-table-cell mui-pull-left\">\n" +
                                    "                            <h5>["+datas[i].startPeople+"]</h5>\n" +
                                    "                        </div>\n" +
                                    "                        <div class=\"mui-table-cell mui-pull-left \">\n" +
                                    "                            <span class=\"mui-h5\">提交于"+datas[i].proStartTime+"</span>\n" +
                                    "                        </div><br/>" +
                                    "                        <div style='margin-left: -55px;' class=\"mui-table-cell mui-pull-left \">\n" +
                                    "                            <span class=\"mui-h5\">流程编号"+datas[i].proInstanceId+"</span>\n" +
                                    "                        </div><br/>" +
                                    "                        <div style='margin-left: -4px;' class=\"mui-table-cell mui-pull-left \">\n" +
                                    "                            <span class=\"mui-h5\">当前办理人&nbsp;"+showAssignee_yichuli(datas[i].currentAssignee)+"</span>\n" +
                                    "                            <input style='display: none;' value="+datas[i].currentAssignee+" >" +
                                    "                        </div>" +
                                    "                    </div>\n" +
                                    "                </div>\n"+
                                     "<div class=\"workflow-state\">"+
                                        "<span class=\"state-span\">"+getState(datas[i].proStatus)+"</span>"+
                                      "</div>"+
                                     " </li>";
                            }
                            jQuery("#yibaocunul").append(baocunhtml);
                            yichuliFlag=false;
                            self.endPullUpToRefresh(yichuliCount>=data.yeshu);
                            yichuliCount++;
                            yichuli_load=yichuliCount>=data.yeshu;
                        }else {
                           $.toast("获取已处理列表错误："+data.result);
                        }
                    },
                    error: function () {
                        $.hideLoading();
                        $.toast('服务器响应失败!!!')
                    }

                });
            }

            function getState(state) {
                // 0：申请人提交可撤回状态  1：通过 2：查看 3：被退回（不包括申请节点） 4：撤回 5：转办 6:完成 7：删除 8：被退回到申请节点
                if(state=='1' || state=='0'){
                    return "进行中";
                }else if(state=='2'){
                    return "已被查看";
                }
                else if(state=='3' || state=='8'){
                    return "被退回";
                }
                else if(state=='4'){
                    return "已撤回";
                }
                else if(state=='5'){
                    return "已转办";
                }
                else if(state=='6' || state=='9'){
                    return "已完成";
                }else if(state=='7'){
                    return "已删除";
                }else {
                    return "其他";
                }
            }


            //简化办理人显示
            function showAssignee_shenqing(assignee) {
                if(assignee==''){
                    return "";
                }else{
                    var arr = assignee.split(",");
                    if(arr.length>3){
                        return arr[0]+","+arr[1]+","+arr[2]+"..."+
                            "<span data-assignee="+assignee+" style='cursor: pointer;color: blue;' name='zhankai_yishenqing'>展开</span>"
                    }else{
                        return assignee;
                    }
                }
            }

            function showAssignee_yichuli(assignee) {
                if(assignee==''){
                    return "";
                }else{
                    var arr = assignee.split(",");
                    if(arr.length>3){
                        return arr[0]+","+arr[1]+","+arr[2]+"..."+
                            "<span data-assignee="+assignee+" style='cursor: pointer;color: blue;' name='zhankai_yichuli'>展开</span>"
                    }else{
                        return assignee;
                    }
                }
            }

        });
    })(mui);

</script>
</body>
</html>
