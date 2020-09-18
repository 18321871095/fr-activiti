<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>办理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <link rel="stylesheet" href="${ctx}/static/css/mui.min.css">
    <link rel="stylesheet" href="${ctx}/static/css/muikuozhan.css">
    <link rel="stylesheet" href="${ctx}/static/css/index.css">
    <link rel="stylesheet" href="${ctx}/static/css/back.css">
</head>
<%
    String Authorization="";
    Cookie[] c=request.getCookies();
    for(Cookie cookie:c){
        if("fine_auth_token".equals(cookie.getName())){
            Authorization=cookie.getValue();
        }
    }
%>
<body>
<div class="mui-content">
    <div style="padding: 10px 10px;">
        <div id="segmentedControl" class="mui-segmented-control">
            <a id="banliInfo" class="mui-control-item mui-active" >表单信息</a>
            <a id="banliPic"  class="mui-control-item" >流程图</a>
        </div>
    </div>
    <div id="item1">
        <div id="BanLiTaskForm" class="toDoDetails">
            流程信息
        </div>
        <div id="tijiaoCommentBanLiTask" class="toDoDetailsBtnBoxTextareaBox">

        </div>
        <div id="BanLiTaskYiJian" class="toDoDetails2">
            <h3 class="newFlowTitle"><span class="newFlowTitleSpan"></span><span class="newFlowTitleTit">流转意见</span></h3>

            <%--<div style="height: 250px;overflow-y: auto;">
            <ul class="toDoDetails2List">
                <li>
                    <span>节点：技术总监</span><span>操作类型：提交</span><span>发起人：王斗斗</span><span>时间：2019-09-12</span>
                </li>
                <li>
                    <span>节点：技术总监</span><span>操作类型：提交</span><span>发起人：王斗斗</span><span>时间：2019-09-12</span>
                </li>
                <li>
                    <span>节点：技术总监</span><span>操作类型：提交</span><span>发起人：王斗斗</span><span>时间：2019-09-12</span>
                </li>
                <li>
                    <span>节点：技术总监</span><span>操作类型：提交</span><span>发起人：王斗斗</span><span>时间：2019-09-12</span>
                </li>
                <li>
                    <span>节点：技术总监</span><span>操作类型：提交</span><span>发起人：王斗斗</span><span>时间：2019-09-12</span>
                </li>
                <li>
                    <span>节点：技术总监</span><span>操作类型：提交</span><span>发起人：王斗斗</span><span>时间：2019-09-12</span>
                </li>
            </ul>
            </div>--%>
        </div>
        <div class="toDoDetailsBtnBox" style="z-index: 997">
            <div id="BanLiTaskBtn" class="toDoDetailsBtn">
              <%--  <button class="">提交</button>
                <button class="">保存</button>
                <button class="">删除</button>
                <button class="">保存</button>
                <button class="">提交</button>--%>
            </div>
        </div>
    </div>
    <div id="item2">
        <div id="propicBanLiTask">

        </div>
    </div>
</div>
<%--退回--%>
<div id="bottomPopover" class="mui-popover mui-popover-bottom" style="font-size: 14px;">
    <div class="mui-popover-arrow"></div>
    <ul class="mui-table-view">
        <p class="mui-popup-title">流程退回</p>
        <div class="mui-content-padded">
            <h5 class="thjdleft">节点</h5>
            <select id="selectBackNode" class="mui-btn thjdright">

            </select>
        </div>

    </ul>

   <div id="selectpeople" class="divhqr mui-scroll-wrapper" style="padding-bottom: 80px; overflow-y: auto;display: none;height: 72%;">
        <div id="selectpeople1" class="mui-scroll">

        </div>
    </div>

    <div class="lctubtn" >
        <button class="mui-btn" name="" id="cancle" value="">取消</button>
        <button class="mui-btn mui-btn-blue" name="" id="ok" value="">确定</button>

    </div>
    <!-- </div>

</div> -->



</div>
<%--转办--%>
<div id="bottomPopover_zhuanban" class="mui-popover mui-popover-bottom" style="font-size: 14px;">
    <div class="mui-popover-arrow"></div>

        <p class="mui-popup-title">流程转办</p>
        <div id="search" style="width: 100%;height: 45px;background: #fff;padding-left: 10px;">
            <input type="text" id="name" placeholder="姓名" style="width: 35%;height: 30px;margin-top: 5px;margin-left: 5px;" />
            <input type="text" id="dep" placeholder="部门" style="width: 35%;height: 30px;margin-top: 5px;margin-left: 5px;" />
            <button id="searcher" style="margin-top: 5px;height: 30px;background: #4cd964;padding: 0px 12px;color: #fff;">搜索</button>
        </div>
    <div id="zhuanban_people" class="divhqr mui-scroll-wrapper" style="padding-bottom: 80px; overflow-y: auto;height: 72%">
        <div id="zhuanban_people1" class="mui-scroll">
           <%-- <c:forEach  begin="0" end="20">

            </c:forEach>--%>
        </div>
    </div>

    <div class="lctubtn" >
        <button class="mui-btn" name="" id="cancle_zhuanban" value="">取消</button>
        <button class="mui-btn mui-btn-blue" name="" id="ok_zhuanban" value="">确定</button>
    </div>
    <!-- </div>

</div> -->



</div>
<%--会签--%>
<div id="bottomPopover_huiqian" class="mui-popover mui-popover-bottom" style="font-size: 14px;">
    <div class="mui-popover-arrow"></div>

    <p class="mui-popup-title">加签</p>
    <div id="search_huiqian" style="width: 100%;height: 45px;background: #fff;padding-left: 10px;">
        <input type="text" id="name_huiqian" placeholder="姓名" style="width: 35%;height: 30px;margin-top: 5px;margin-left: 5px;" />
        <input type="text" id="dep_huiqian" placeholder="部门" style="width: 35%;height: 30px;margin-top: 5px;margin-left: 5px;" />
        <button id="searcher_huiqian" style="margin-top: 5px;height: 30px;background: #4cd964;padding: 0px 12px;color: #fff;">搜索</button>
    </div>
    <div id="huiqian_people" class="divhqr mui-scroll-wrapper" style="padding-bottom: 80px; overflow-y: auto;height: 72%">
        <div id="huiqian_people1" class="mui-scroll">
           <%-- <div class="mui-input-row mui-checkbox mui-left">
                <label>张三1</label>
                <input  name="1" type="checkbox"  value="张三1" >
            </div>
            <div class="mui-input-row mui-checkbox mui-left">
                <label>张三2</label>
                <input  name="1" type="checkbox"  value="张三2" >
            </div>
            <div class="mui-input-row mui-checkbox mui-left">
                <label>张三3</label>
                <input  name="1" type="checkbox"  value="张三3" >
            </div>--%>

        </div>
    </div>

    <div class="lctubtn" >
        <button class="mui-btn" name="" id="cancle_huiqian" value="">取消</button>
        <button class="mui-btn mui-btn-blue" name="" id="ok_huiqian" value="">确定</button>
    </div>
    <!-- </div>

</div> -->



</div>
</body>
<script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>
<script src="${ctx}/static/js/mui.js"></script>
<script src="${ctx}/static/js/muikuozhan.js"></script>
<script src="${ctx}/static/js/selfAdaption.js"></script>
<script>

</script>
<script>
    $(function () {
        //滚动
        mui(".mui-scroll-wrapper").scroll();
        var peoples_zhuanban=[];
        var peoples_huiqian=[];
        var taskid="${param.taskid}";
        var proname=decodeURI("${param.proname}");
        var proDefinedId="${param.proDefinedId}";
        var proInstanceId="${param.proInstanceId}";
        var propicInit=false;
        var iswritecomment="";
        var reportName="";
        var propicInit_banli=false;
        $("#banliInfo").click(function () {
            $("#item1").show();
            $("#item2").hide();

        });
        $("#banliPic").click(function () {
            $("#item1").hide();
            $("#item2").show();
            if(!propicInit_banli){
                propicInit_banli=true;
                baliTaskinintProPic(proDefinedId,proInstanceId);
            }
        });
        mui.showLoading("获取任务信息","div");
        $.ajax({
            type: "POST",
            dataType: "json",
            data:{taskid:taskid},
            url: "${ctx}/mobile/userTaskForm",
            success: function (data) {
                mui.hideLoading();
                if(data.msg==='success'){
                    iswritecomment=data.result.iswritecomment;
                    reportName=data.result.moban;
                    if(reportName.indexOf("op=write")<0 && reportName.indexOf("op=view")<0){
                        reportName+="&op=write";
                    }
                    var src= "${ctx}/decision/view/report?viewlet="+encodeURI(reportName)+"&op=write&__cutpage__=v"+"&requestid="
                        +data.result.yeuwuid+"&processInstanceId="+data.result.processInstanceId;
                    $("#BanLiTaskForm").empty().append("<iframe frameborder=\"0\" id=\"banlireportFrame\" src="+src+" width = 100% ></iframe>");
                    //报表自适应高度
                    selfAdaption("banlireportFrame");
                    $("#tijiaoCommentBanLiTask").append("<textarea id=\"banlicomment\" rows=\"5\" placeholder=\"请输入意见\" class=\"toDoDetailsBtnBoxTextarea\"></textarea>");
        /*            $("#shangcuhanFuJianBanLiTask").append("<h1 onclick='selFileBanliTask()' style='cursor: pointer;' class='appendix-title'>上传附件</h1>")
                        .append("<input id='showFileName' style='background: transparent;border: none '/><input onchange='showFileBanliTask()' type='file' id='file' style='display: none' />");
*/
                    //添加意见
                    var showProYiJian="${ctx}/static/jsp/mobile/commentMobile.jsp?proInstanceId="+data.result.processInstanceId+
                        "&proDefinitionId="+data.result.proDefinitionId+"&activityid="+data.result.activityid;
                    $("#BanLiTaskYiJian").append("<iframe  frameborder=\"0\"  src="+showProYiJian+" width = 100%  " +
                        " height = 250px></iframe>");
                    //添加按钮
                    $("#BanLiTaskBtn").empty().append(getBtn(data.result.tijiao,data.result.istuihui,data.result.tuihui,
                        data.result.addHuiQianRen,data.result.zhuanban));
                }else if(data.msg==='2'){
                    $("body").empty().append("该任务已经办理了");
                }
                else{
                    window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("获取表单信息错误："+data.result);
                }
            },
            error: function (e, jqxhr, settings, exception) {
                mui.hideLoading();
                alert('服务器响应失败!!!')
            }
        });

        /*完成任务*/
        $(document).on("click","${'#banliTaskTiJiao'}",function(){
            if(getiswritecommentBanLiTask(iswritecomment)){
                var banliTaskFlag=true;
                if(banliTaskFlag){
                    if(reportName.indexOf("op=write")>-1){
                        document.getElementById('banlireportFrame').contentWindow.contentPane._doVerify(
                            function () {
                                banliTaskTiJiaoMobile(taskid,proname,mui,true);
                            },function () {
                                document.getElementById('banlireportFrame').contentWindow.contentPane.verifyReport();
                                mui.alert("模板数据校验不通过请检查");
                            });
                    }else{
                        banliTaskTiJiaoMobile(taskid,proname,mui,false);
                    }
                }
            }else{
                mui.alert("请填写意见！！！");
            }


        });

        /*保存任务*/
        $(document).on("click","${'[name=\'baocunTask\']'}",function(){
            if(reportName.indexOf("op=write")>-1){
                document.getElementById('banlireportFrame').contentWindow.contentPane._doVerify(function () {
                    bancunTaskMobile(taskid,mui,true);
                },function () {
                    document.getElementById('banlireportFrame').contentWindow.contentPane.verifyReport();
                    mui.alert("模板数据校验不通过请检查");
                });
            }else{
                bancunTaskMobile(taskid,mui,false);
            }




            /* document.getElementById('banlireportFrame').contentWindow.contentPane.verifyAndWriteReport(true,undefined,function(){

             },function () {});*/
        });

        /*退回*/
        $(document).on("click","${'[name=\'backTask\']'}",function(){
           if($("#banlicomment").val()==''){
               mui.alert("请先在意见框中输入退回意见")
           }else{
               mui.showLoading("","div");
               $.post("${ctx}/processInfo/getbackTaskNodeInfoTest",{taskid:"${param.taskid}"},function (data) {
                   mui.hideLoading();
                   if(data.msg==='success'){
                       mui("#bottomPopover").popover('toggle', document.getElementById("div"));
                       $("#selectpeople").hide();
                       $("#selectpeople1").empty();
                       $("#bottomPopover").css("height","167px")
                       $("#selectBackNode").empty().append("<option value='' name='0'>请选择退回节点</option>");
                       for(var i=0;i<data.result.length;i++){
                           //name 1 会签  0 非会签
                           $("#selectBackNode").append(
                               "<option name="+data.result[i].state+" id="+data.result[i].id+" value="+data.result[i].id+" >"
                               +data.result[i].name+"</option>\n" );
                       }
                   }else{
                       mui.alert("获取退回节点信息出错")
                   }
               });
           }
        })

        /*获取会签办理人*/
        $(document).on("change","${'#selectBackNode'}",function(){
            var name=$("#selectBackNode :checked").attr("name");
            var value=$("#selectBackNode :checked").val();
            if(name=='1'){
                $("#bottomPopover").css("height","435px");
                $("#selectpeople").show().find("input[type='checkbox']").prop("checked",false);
                $.post("${ctx}/processInfo/getbackTaskNodeInfoPeople",{ProcessInstanceId:"${param.proInstanceId}",
                    activityid:value},function (data) {
                    if(data.msg=='success'){
                        $("#selectpeople1").empty().append("<div style='color: red;'>退回到会签节点可以选择退回到具体哪些人，不选择则退回到整个节点</div>");
                        for(var i=0;i<data.result.length;i++){
                            $("#selectpeople1").append("<div class=\"mui-input-row mui-checkbox mui-left\">\n" +
                                "           <label>"+showRealName(data.result[i].user)+"</label>\n" +
                                "           <input  name="+data.result[i].userid+" type=\"checkbox\"  value="+data.result[i].userid+">\n" +
                                "       </div>");
                        }
                    }else{
                        mui.toast("获取会签节点办理人错误")
                    }
                });
            }else{
                $("#bottomPopover").css("height","167px");
                $("#selectpeople").hide().find("input[type='checkbox']").prop("checked",false);;
            }
           // console.log(name)
           // console.log(value)
        });

        /*取消退回*/
        $(document).on("click","${'#cancle'}",function(){
            mui("#bottomPopover").popover('toggle', document.getElementById("div"));
        })
        /*确定退回*/
        $(document).on("click","${'#ok'}",function(){
            var selectNode=$("#selectBackNode").val();
            var taskid="${param.taskid}";
            var banlicomment=$("#banlicomment").val();
            //var reportName=reportName;
            var assign=getAssigns();
            if(selectNode==''){
                mui.toast("请选择要退回到的节点")
            }else{
                mui.showLoading("退回中","div");
                $.post("${ctx}/processInfo/backTaskNode",{
                targetActivitiID:selectNode,
                taskid:taskid,
                commentinfo:banlicomment,
                assign:assign,
                reportName:reportName
            },function(data){
                 mui.hideLoading();
                 mui("#bottomPopover").popover('toggle', document.getElementById("div"));
                if(data.msg==='success') {
                    mui.alert('退回成功',function(){
                        window.history.go(-1);
                    });
                }else if(data.msg==='fail'){
                    mui.alert("服务器出错，错误信息"+data.result)
                }else{
                    mui.alert("退回失败，原因："+data.result)
                }
            });
            }

        })

        /*会签*/
        $(document).on("click","${'[name=\'addHuiQians\']'}",function(){
              mui.showLoading("","div");
             $.ajax({
                type:"post",
                url:"${ctx}/processDiagram/getzuzhiJson",
                dataType:'json',
                headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
                success:function (data) {
                    mui.hideLoading();
                    mui("#bottomPopover_huiqian").popover('toggle', document.getElementById("div"));
                    $("#name_huiqian").val("");
                    $("#dep_huiqian").val("");
                    if(data.code==0){
                        peoples_huiqian=data.data;
                        $("#huiqian_people1").empty();
                        for(var i=0;i<data.data.length;i++){
                            $("#huiqian_people1").append(
                                "<div class=\"mui-input-row mui-checkbox mui-left\">\n" +
                                "<label>"+data.data[i].realName+"&nbsp;&nbsp;部门："+data.data[i].depPostNames+"</label>\n" +
                                "<input  name="+data.data[i].username+" type=\"checkbox\"  value="+data.data[i].username+" >\n" +
                                "</div>");
                        }
                    }else{
                        mui.alert("获取人员出错，信息为："+data.msg)
                    }
                },
                error:function (xhr,text) {
                    mui.hideLoading();
                    alert(text);
                }
            });
        })

        /*会签搜索*/
        $(document).on("click","${'#searcher_huiqian'}",function(){
            var name=$.trim($("#name_huiqian").val());
            var dep=$.trim($("#dep_huiqian").val());
            var result=search_huiqian(name,dep,peoples_huiqian);
            $("#huiqian_people1").empty();
            for(var i=0;i<result.length;i++){
                $("#huiqian_people1").append(
                    "<div class=\"mui-input-row mui-checkbox mui-left\">\n" +
                    "<label>"+result[i].realName+"&nbsp;&nbsp;部门："+result[i].depPostNames+"</label>\n" +
                    "<input  name="+result[i].username+" type=\"checkbox\"  value="+result[i].username+" >\n" +
                    "</div>");
            }
        });

        /*确定加签*/
        $(document).on("click","${'#ok_huiqian'}",function(){
            var name=getHuiQianAssigns();
            if(typeof(name)=='undefined'){
                mui.toast("请选择需要加签人员");
            }else{
                mui.showLoading("加签中","div");
                mui("#bottomPopover_huiqian").popover('toggle', document.getElementById("div"));
                $.post("${ctx}/processInfo/addHuiQianAssgin",{
                    huiqians:name,
                    taskid:taskid,
                },function (data) {
                    mui.hideLoading();
                    if(data.result==='success'){
                        mui.alert('加签成功');
                    }else if(data.result==='001'){
                        mui.alert("加签名单中不能有自己")
                    }
                    else {
                        mui.alert("添加会签人错误"+data.msg)
                    }
                });
            }

        })

        /*取消会签*/
        $(document).on("click","${'#cancle_huiqian'}",function(){
            mui("#bottomPopover_huiqian").popover('toggle', document.getElementById("div"));
        })

        /*转办*/
        $(document).on("click","${'[name=\'zhuanbanTask\']'}",function(){
            if($("#banlicomment").val()==''){
                mui.alert("请先在意见框中输入转办意见")
            }else{
                mui.showLoading("","div");
                $.ajax({
                    type:"post",
                    url:"${ctx}/processDiagram/getzuzhiJson",
                    dataType:'json',
                    headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
                    success:function (data) {
                        mui.hideLoading();
                        mui("#bottomPopover_zhuanban").popover('toggle', document.getElementById("div"));
                        $("#name").val("");
                        $("#dep").val("");
                        if(data.code==0){
                            peoples_zhuanban=data.data;
                            $("#zhuanban_people1").empty();
                            for(var i=0;i<data.data.length;i++){
                                $("#zhuanban_people1").append(
                                    "<div class=\"mui-input-row mui-radio mui-left\">\n" +
                                    "<label>"+data.data[i].realName+"&nbsp;&nbsp;部门："+data.data[i].depPostNames+"</label>\n" +
                                    "<input  name=\"zhuanban_people\" type=\"radio\"  value="+data.data[i].username+" >\n" +
                                    "</div>");
                            }
                        }else{
                            mui.alert("获取人员出错，信息为："+data.msg)
                        }
                    },
                    error:function (xhr,text) {
                        mui.hideLoading();
                        alert(text);
                    }
                });
            }
        })

        /*转办搜索*/
        $(document).on("click","${'#searcher'}",function(){
            var name=$.trim($("#name").val());
            var dep=$.trim($("#dep").val());
            var result=search_zhuanban(name,dep,peoples_zhuanban);
            $("#zhuanban_people1").empty();
            for(var i=0;i<result.length;i++){
                $("#zhuanban_people1").append(
                    "<div class=\"mui-input-row mui-radio mui-left\">\n" +
                    "<label>"+result[i].realName+"&nbsp;&nbsp;部门："+result[i].depPostNames+"</label>\n" +
                    "<input  name=\"zhuanban_people\" type=\"radio\"  value="+result[i].username+" >\n" +
                    "</div>");
            }
        });

        /*确定转办*/
        $(document).on("click","${'#ok_zhuanban'}",function(){
            var name=$("[name='zhuanban_people']:checked").val();
            if(typeof(name)=='undefined'){
                mui.toast("请选择转办人员");
            }else{
                mui.showLoading("转办中","div");
                $.post("${ctx}/processInfo/zhuanbanTask",{
                    taskid:taskid,
                    zhuanbanName:name,
                    info:$("#banlicomment").val(),
                    reportName:reportName
                },function (data) {
                    mui.hideLoading();
                    mui("#bottomPopover_zhuanban").popover('toggle', document.getElementById("div"));
                    if(data.result==='success'){
                        mui.alert('转办成功',function(){
                            window.history.go(-1);
                        });
                    }else if(data.result==='001'){
                        mui.alert("转办不能选择自己")
                    }
                    else {
                        mui.alert("转办错误："+data.msg)
                    }
                });
            }

        })

        /*取消转办*/
        $(document).on("click","${'#cancle_zhuanban'}",function(){
            mui("#bottomPopover_zhuanban").popover('toggle', document.getElementById("div"));
        })

    });

    function banliTaskTiJiaoMobile(taskid,proname,mui,cpt_insert) {
        mui.showLoading("提交中","div");
        var seesionid=document.getElementById('banlireportFrame').contentWindow.contentPane.currentSessionID;
        var form = new FormData();
        form.append("taskid",taskid);
        form.append("proname",proname);
        form.append("seesionid",seesionid);
        form.append("cpt",cpt_insert);
        form.append("commentinfo",$("#banlicomment").val());
        $.ajax({
            type: "POST",
            data:form,
            dataType: "json",
            processData:false,
            contentType: false,
            url: "${ctx}/mobile/completeTask",
            success: function (data) {
                mui.hideLoading();
                if(data.msg==='success'){
                   /* if(cpt_insert){
                        document.getElementById('banlireportFrame').contentWindow.contentPane.writeReport();
                    }*/
                    mui.alert('提交成功',function(){
                        window.history.go(-1);
                    });
                }else if(data.msg==='001'){
                    mui.alert("分支条件都不成立，流程无法继续进行");
                }else if(data.msg==='002'){
                    mui.alert("该任务已经不存在(可能流程设置了总时间),请刷新待办任务列表");
                }
                else{
                    window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("提交流程错误："+data.result);
                }
            },
            error: function (e, jqxhr, settings, exception) {
                mui.hideLoading();
                alert('服务器响应失败!!!')
            }
        });
    }

    function bancunTaskMobile(taskid,mui,cpt_insert) {
        mui.showLoading("保存中","div");
        var seesionid=document.getElementById('banlireportFrame').contentWindow.contentPane.currentSessionID;
        $.ajax({
            type: "POST",
            dataType: "json",
            data:{taskid:taskid,seesionid:seesionid,cpt:cpt_insert},
            url: "${ctx}/mobile/banliBaoCun",
            success: function (data) {
                mui.hideLoading();
                if(data.msg==='success'){
                   /* if(cpt_insert){
                        document.getElementById('banlireportFrame').contentWindow.contentPane.writeReport();
                    }*/
                    mui.alert('保存成功');
                }else if(data.msg==='001'){
                    mui.alert('任务不存在');
                }else{
                    window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("保存失败："+data.result);
                }

            },
            error: function (e, jqxhr, settings, exception) {
                mui.hideLoading();
                alert('服务器响应失败!!!')
            }
        });
    }

    //获取按钮
    function  getBtn(tijiao,istuihui,tuihui,huiqian,zhuanban) {
        var tijiaoHtml,baocunHtml,tuihuiHtml,tianjiahuiqianHtml,zhuanbanHtml;
        tijiaoHtml="<button id=\"banliTaskTiJiao\" name=\"submitFormInfoBanLiTask\" class=\"\">"+tijiao+"</button>";
        baocunHtml=" <button name=\"baocunTask\" class=\"\">保存</button>";
        if(istuihui=='true'){
            var temp=tuihui=='' ? '退回' : tuihui;
            tuihuiHtml="<button  name=\"backTask\" class=\"\">"+temp+"</button>";
        }else{
            tuihuiHtml="";
        }
        if(huiqian!=''){
            tianjiahuiqianHtml="<button name=\"addHuiQians\" name=\"baocunTask\" class=\"\">"+huiqian+"</button>";
        }else{
            tianjiahuiqianHtml="";
        }
        if(zhuanban!=''){
            zhuanbanHtml="<button  name=\"zhuanbanTask\" class=\"\">转办</button>";
        }else{
            zhuanbanHtml="";
        }
        return tijiaoHtml+baocunHtml+tuihuiHtml+tianjiahuiqianHtml+zhuanbanHtml;

    }

    //第一次渲染流程图
    function baliTaskinintProPic(proDefinitionId,proInsID) {
        $("#propicBanLiTask").empty();
        var showProPic="${ctx}/diagram-viewer/index.html?processDefinitionId="+proDefinitionId+"&processInstanceId="+proInsID;
        $("#propicBanLiTask").append("<iframe id='BanLiTaskgLiuChengtu' frameborder=\"0\"  src="+showProPic+" width = 100%  height = 80%></iframe>");
        var liuchengtu=setInterval(function () {
            var num= $("#BanLiTaskgLiuChengtu").contents().find("svg").find('text').length;
            if(num>0){
                $("#BanLiTaskgLiuChengtu").contents().find("svg").find('text').each(function () {
                    if($(this).attr("fill")=='#000000'){
                        var old= $(this).attr('y');
                        $(this).attr('y',parseInt(old)-20.5);
                    }
                });
                clearInterval(liuchengtu);
            }
        },1000);
    }

    function getiswritecommentBanLiTask(iswritecomment) {
        if("true"==iswritecomment){
            if($("#banlicomment").val()==''){
                return false;
            }else
            {
                return true;
            }
        }else{
            return true;
        }
    }

    function getAssigns(obj) {
        var data="";
        $("#selectpeople").find("input[type='checkbox']").each(function () {
            if($(this).is(":checked")){
                data+=$(this).val()+",";
            }
        });
        return data.length==0?"":data.substring(0,data.length-1);
    }

    function showRealName(name) {
        if(name==''){
            return "";
        }else{
            return name.substring(name.indexOf("(")+1,name.indexOf(")"))
        }
    }

    function search_zhuanban(name,dep,peoples_zhuanban) {
        var result=peoples_zhuanban;
        var result1=[];
        if(name=='' && dep==''){
            return peoples_zhuanban;
        }else{
            if(name!=''){
                for(var i=0;i<result.length;i++){
                    var realname=result[i].realName;
                    if(realname.indexOf(name)>-1){
                        result1.push(result[i]);
                    }
                }
                result=result1;
                result1=[];
            }
            if(dep!=''){
                for(var j=0;j<result.length;j++){
                    var realdep=result[j].depPostNames;
                    if(realdep.indexOf(dep)>-1){
                        result1.push(result[j]);
                    }
                }
                result=result1;
                result1=[];
            }

        }
        return result;
    }

    function search_huiqian(name,dep,peoples_huiqian) {
        var result=peoples_huiqian;
        var result1=[];
        if(name=='' && dep==''){
            return peoples_huiqian;
        }else{
            if(name!=''){
                for(var i=0;i<result.length;i++){
                    var realname=result[i].realName;
                    if(realname.indexOf(name)>-1){
                        result1.push(result[i]);
                    }
                }
                result=result1;
                result1=[];
            }
            if(dep!=''){
                for(var j=0;j<result.length;j++){
                    var realdep=result[j].depPostNames;
                    if(realdep.indexOf(dep)>-1){
                        result1.push(result[j]);
                    }
                }
                result=result1;
                result1=[];
            }

        }
        return result;
    }

    function getHuiQianAssigns(obj) {
        var data="";
        $("#huiqian_people1").find("input[type='checkbox']").each(function () {
            if($(this).is(":checked")){
                data+=$(this).val()+",";
            }
        });
        return data.length==0?"":data.substring(0,data.length-1);
    }

</script>
</html>
