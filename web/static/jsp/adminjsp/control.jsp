<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<%
    String register=response.getHeader("register");
    String time=response.getHeader("time");
%>
<html>
<head>
    <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
    <link rel="stylesheet" href="${ctx}/static/css/control.css?v=1">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/myPagination.css"/>
    <style type="text/css">
        .laydate_table {
            display: none;
        }
        #laydate_hms{
            display: none !important;
        }
        .ganyu{
            width: 95%;
            height: 85%;
            margin: 0 auto;
            overflow-y: auto;
        }
        .ganyubtn{
            float: right;
            margin: 10px;
            width: 65px;
            height: 30px;
            background: #1E9FFF;
            border: 1px solid #1E9FFF;
            color: #fff;
            cursor: pointer;
        }
    </style>
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
<body style="background-color:#fff ">



<div style="padding: 10px 10px;" >
    <div  class="layui-form" style="width: 150px;display: inline-block;">
        <input   type="text" id="proname"  placeholder="流程名称" class="layui-input">
    </div>
    <div  class="layui-form" style="width: 150px;display: inline-block;">
        <input   type="text" id="proInstanceId"  placeholder="流程编号" class="layui-input">
    </div>
    <div  class="layui-form" style="width: 150px;display: inline-block;">
        <input   type="text" id="people"  placeholder="发起人" class="layui-input">
    </div>
    <div  class="layui-form" style="width: 150px;display: inline-block;">
        <input   type="text" id="dep"  placeholder="请输入部门" class="layui-input">
    </div>
    <%--<div  class="layui-form" style="width: 200px;display: inline-block;">
        <select  id="dep">
            <option value="">请输入部门</option>
        </select>
    </div>--%>
    <div  class="layui-form" style="width: 200px;display: inline-block;">
        <input  type="text" id="time"  placeholder="发起时间" class="layui-input">
    </div>
    <div  class="layui-form" style="width: 150px;display: inline-block;">
        <select  id="status">
            <option value="">请选择完成状态</option>
            <option value="1">完成</option>
            <option value="0">未完成</option>
        </select>
    </div>

    <div class="layui-form" style="width: 65px;display: inline-block;">
        <button class="layui-btn" onclick="selControl()" >查询</button>
    </div>
    <table border="0" class="tab-table" cellspacing="0" cellpadding="0">
        <tr>
            <th >流程名称</th>
            <th >流程编号</th>
            <th >发起人</th>
            <th >发起部门</th>
            <th >发起时间</th>
            <th >节点名称</th>
            <th >当前办理人</th>
            <th >结束时间</th>
            <th >状态</th>
            <th >操作</th>
        </tr>
        <tbody id="controlTbody">
            <%--<tr>
                <td>申请流程</td>
                <td>孙红</td>
                <td>开发部</td>
                <td>2012-12-12 12:12:12</td>
                <td>2012-12-12 12:12:12</td>
                <td>结束</td>
                <td>
                    <button name="controlDetail" style="color: #FFB800;" class="mybtn">详情</button> &nbsp;|&nbsp;
                    <button name="controlDelete" style="color: #FF5722;" class="mybtn">删除</button>
                </td>
            </tr>--%>
        </tbody>
    </table>
    <div  id="page_control" class="pagination" style="float: right;margin-top: 20px;"></div>
    <div id="noDateDivControl"></div>

</div>

<div style="width: 120px;height: 50px;border: 1px solid #00a0e9;display: <%=register.equals("false")?"block":"none" %>;
        position: fixed;right: 10px;bottom: 10px;background: #00a0e9;color: #fff;font-size: 15px;text-align: center;">
    <div onclick="this.parentNode.style.display='none'" style="width: 20px;height: 20px; line-height: 20px; background: #999; box-sizing: border-box;border-radius: 50%; text-align: center;
position: absolute; left: -10px; top: -10px; color: #fff;">
        <a href="#" style="color: #fff; display: inline-block;">×</a>
    </div>
    试用阶段，剩余<%=time %>天！
</div>

</body>
<script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>
<script src="${ctx}/static/layui/layui.js"></script>
<script src="${ctx}/static/js/myPagination.js"></script>
<script>
    var control_layer;
    var userName=parent.Dec.personal.username;
    var userRealName=parent.Dec.personal.displayName.split("(")[0];
    $(document).ready(function () {
        layui.use(['layer','form','laydate'], function() {
            control_layer = layui.layer;
            control_form = layui.form;
            control_laydate = layui.laydate;
            control_laydate.render({
                elem: '#time' //指定元素
                ,type: 'month'
            });
            initControl(1,true);

            $(document).on("click","${'[name=\'controlDetail\']'}",function(){
                var proname=$(this).parents("tr").find("td").eq(0).text();
                var requestid=$(this).parents("tr").find("input[type='hidden']").eq(0).val();
                var reportName=$(this).parents("tr").find("input[type='hidden']").eq(1).val();
                var processDefinitionID=$(this).parents("tr").find("input[type='hidden']").eq(2).val();
                var processInstanceId=$(this).parents("tr").find("input[type='hidden']").eq(3).val();
               // console.log(proname+","+requestid+","+reportName+","+processDefinitionID+","+processInstanceId)
                window.parent.FS.tabPane.addItem({title:proname,src:"${ctx}/static/jsp/frontEnd/hisProcessDetail.jsp?businessKey="+
                requestid+"&reportName="+encodeURI(reportName)+"&proInsID="+processInstanceId+"&proDefinitionId="+processDefinitionID});
            });

            $(document).on("click","${'[name=\'controlDelete\']'}",function(){
                var mythis=$(this);
                var processInstanceId=$(this).parents("tr").find("input[type='hidden']").eq(3).val();
                control_layer.confirm('是否删除？', {
                    btn: ['确定', '取消'] //可以无限个按钮
                    ,offset:'200px'
                }, function(index, layero){
                    var index1=control_layer.load(2,{offset:'200px'});
                    $.post("${ctx}/processInfo/deleteSelfProcessByAdmin",{
                        proInstanceId:processInstanceId,
                        userName:userName,
                        userRealName:userRealName
                    },function (data) {console.log(JSON.stringify(data))
                        control_layer.closeAll();
                        if(data.msg==='success'){
                            mythis.parents("tr").find("td").eq(4).text(getCurrentTime());
                            mythis.parents("tr").find("td").eq(5).text("已删除");
                            mythis.remove();
                        }else if(data.msg==='1'){
                            control_layer.msg(data.result,{offset:'200px'});
                        }
                        else {
                            window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("管理员流程删除错误："+data.result);
                        }
                    })
                },function(index){

                });
            });

            //干预
            var ganyu;var selectnode="";var proInid="";
            $(document).on("click","${'[name=\'controlGanYu\']'}",function(){
                var index=control_layer.load(2,{offset:'200px'});
                var processInstanceId=$(this).parents("tr").find("input[type='hidden']").eq(3).val();
                proInid=processInstanceId;
                $.ajax({
                    type: "POST",
                    data:{proInstanceId:processInstanceId},
                    dataType: "json",
                    url: "${ctx}/processInfo/getInterPoseNodeInfoTest",
                    success: function (data) {
                        control_layer.close(index);
                        selectnode="";
                        if(data.msg==='success'){
                            var html="";
                            for(var i=0;i<data.result.length;i++){
                                html+="<div style='margin-left: 10px;'>" +
                                    "<input type=\"radio\" lay-filter='nodefilter' name=\"node\" value="+data.result[i].id+" title="+data.result[i].name+">" +
                                    "</div>";
                            }
                            ganyu = control_layer.open({
                                type: 1,
                                content: '<div id="ganyudiv" class="ganyu layui-form"></div><div><button class="ganyubtn" name="ganyu_queding">确定</button></div>',
                                title:'请选择节点',
                                area:['500px','400px'],
                                offset:'20px',
                                success: function(layero, index){
                                    $("#ganyudiv").empty().append(html);
                                    control_form.render(); //更新全部
                                }
                            });
                        }
                        else if(data.msg==='001'){
                            control_layer.alert("流程定义id为空",{offset:'20px;'})
                        }else if(data.msg==='002'){
                            control_layer.alert("当前流程编号的流程没有正在运行的任务",{offset:'20px;'})
                        }
                        else{
                            window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("获取节点信息出错："+data.result);
                        }
                    },
                    error: function (e, jqxhr, settings, exception) {
                        control_layer.close(index);
                        alert('服务器响应失败!!!')
                    }
                });

            });
            control_form.on('radio(nodefilter)', function(data){
                selectnode=data.value;
            });
            $(document).on("click","${'[name=\'ganyu_queding\']'}",function(){
                if(selectnode==''){
                    control_layer.msg("请选择要节点",{offset:'200px;'})
                }else{
                    var index11=control_layer.load(2,{offset:'200px'});
                    $.ajax({
                        type: "POST",
                        data:{targetActivitiID:selectnode,proInid:proInid},
                        dataType: "json",
                        url: "${ctx}/processInfo/interPose",
                        success: function (data) {
                            control_layer.close(index11);
                            if(data.msg==='success'){
                                control_layer.close(ganyu);
                                control_layer.alert("干预成功,获取流程最新状态请刷新当前页面",{offset:'20px;',icon:'1'})
                            }
                            else  if(data.msg==='fail'){
                                window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("干预出错："+data.result);
                            }
                            else{
                                control_layer.alert(data.result,{offset:'20px;'})
                            }
                        },
                        error: function (e, jqxhr, settings, exception) {
                            control_layer.close(index11);
                            alert('服务器响应失败!!!')
                        }
                    });
                }
            });

            //展开名字
            $(document).on("click","${'[name=\'zhankai_assginee\']'}",function(){
                var assignee = $(this).parents("tr").find("input[type='hidden']").eq(5).val();
                alert(assignee)
            });
            //展开节点
            $(document).on("click","${'[name=\'zhankai_node\']'}",function(){
                var node = $(this).parents("tr").find("input[type='hidden']").eq(4).val();
                alert(node)
            });
            //展开部门
            $(document).on("click","${'[name=\'zhankai_dep\']'}",function(){
                var node = $(this).parents("tr").find("input[type='hidden']").eq(6).val();
                alert(node)
            });


            //初始化部门
          /*  $.ajax({
                type:"get",//http://localhost:8080/webroot/decision/v10/departments/old-platform-department-31
                //{"data":[{"id":"1491023f-8744-4c08-96f2-b3c5c4099567","pId":"old-platform-department-31","text":"人力资源子部门","pText":"","isParent":false,"open":false,"privilegeDetailBeanList":null}]}
                url:"${ctx}/decision/v10/departments/decision-dep-root",
                dataType:'json',
                headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
                success:function (data) {
                    $("#dep").empty();
                    $("#dep").append(" <option value=\"\">请选择部门</option>");
                    for(var i=0;i<data.data.length;i++) {
                        $("#dep").append(" <option value="+data.data[i].text+">"+data.data[i].text+"</option>");
                        /!*var temp="";
                        if(!data.data[i].isParent){
                            temp="<div onclick='getPosition(this)' id="+data.data[i].id+" class=\"myli\" style='display: inline-block;margin-left: 15px;'>"+data.data[i].text+"</div>";
                        }else {
                            temp="<div name='add'  style='border: 1px solid #000;cursor: pointer;display: inline-block;width: 10px;height: 10px;background-image: url(\"${ctx}/static/images/add.png\");background-size: cover'></div>"
                                +"<div onclick='getPosition(this)' id="+data.data[i].id+" class=\"myli\" style='margin-left: 5px;display: inline-block'>"+data.data[i].text+"</div>";
                        }
                        $("#department").append("<li >"+temp+"</li>");*!/
                    }
                    control_form.render(); //更新全部
                },
                error:function (xhr,text) {
                    alert(text);
                }
            });*/

        });


    });

    function initControl(num,flag) {
        var index=control_layer.load(2,{offset:'200px'});
        $.ajax({
            type: "POST",
            data:{num:num,userName:userName},
            dataType: "json",
            url: "${ctx}/processInfo/getcontrol",
            success: function (data) {
                control_layer.close(index);
                if(data.msg==='success'){
                    if(flag){
                        new myPagination({
                            id: 'page_control',
                            curPage: 1, //初始页码
                            pageTotal: data.yeshu, //总页数
                            pageAmount: 10,  //每页多少条
                            dataTotal: data.total, //总共多少条数据
                            pageSize: 5, //可选,分页个数
                            showPageTotalFlag: true, //是否显示数据统计
                            getPage: function (page) {
                                //获取当前页数
                                initControl(page,false);
                            }
                        });
                    }
                    link_control(data.result);

                }
                else{
                    window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("管理员获取流程列表错误："+data.result);
                }
            },
            error: function (e, jqxhr, settings, exception) {
                control_layer.close(index);
                alert('服务器响应失败!!!')
            }
        });
    }

    function selControl() {
        var proname=$("#proname").val();
        var proInstanceId=$("#proInstanceId").val();
        var name=$("#people").val();
        var depName=$("#dep").val();
        var time=$("#time").val();
        var year=time.split("-")[0];
        var month=parseInt(time.split("-")[1]);
        var status=$("#status").val();
       // alert(name+","+depName+","+time.split("-")[0]+","+parseInt(time.split("-")[1]));
        initSelControl(1,true,proname,proInstanceId,name,depName,time,status);
    }

    function initSelControl(num,flag,proname,proInstanceId,name,depName,time,status) {
        var index=control_layer.load(2,{offset:'200px'});
        $.ajax({
            type: "POST",
            data:{num:num,proname:proname,proInstanceId:proInstanceId,userName:userName,name:name,depName:depName,time:time,status:status},
            dataType: "json",
            url: "${ctx}/processInfo/getcontrol1",
            success: function (data) {
                control_layer.close(index);
                if(data.msg==='success'){
                    if(flag){
                        new myPagination({
                            id: 'page_control',
                            curPage: 1, //初始页码
                            pageTotal: data.yeshu, //总页数
                            pageAmount: 10,  //每页多少条
                            dataTotal: data.total, //总共多少条数据
                            pageSize: 5, //可选,分页个数
                            showPageTotalFlag: true, //是否显示数据统计
                            getPage: function (page) {
                                //获取当前页数
                                initSelControl(page,false,proname,proInstanceId,name,depName,time,status);
                            }
                        });
                    }
                    link_control(data.result);

                }
                else{
                    window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("管理员获取流程列表错误："+data.result);
                }
            },
            error: function (e, jqxhr, settings, exception) {
                control_layer.close(index);
                alert('服务器响应失败!!!')
            }
        });
    }
    
    function link_control(datas) {
        $("#controlTbody").empty();
        $("#noDateDivControl").empty();
        if(datas.length==0){
            $("#noDateDivControl").append("<div style=\"width: 250px;height: 200px;margin: 20px 42%;\">\n" +
                "<img src=\"${ctx}/static/images/noDate.jpg\" width=\"100%\" height=\"100%\">\n" +
                "</div>");
            $("#page_control").hide();
        }else{
            $("#page_control").show();
            for(var i=0;i<datas.length;i++){
             //   console.log("assgine:"+datas[i].currentAssignee)
                $("#controlTbody").append("<tr>" +
                    "<td>"+datas[i].proname+"</td>"+
                    "<td>"+datas[i].processInstanceId+"</td>"+
                    "<td>"+datas[i].startRealName+"</td>"+
                    "<td>"+showDep(datas[i].dep)+"</td>"+
                    "<td>"+datas[i].startTime+"</td>"+
                    "<td>"+showNode(datas[i].nodeName)+"</td>"+
                    "<td>"+showAssignee(datas[i].currentAssignee)+"</td>"+
                    "<td>"+datas[i].endTime+"</td>"+
                    "<td>"+getState(datas[i].status)+"</td>"+
                    "<td>" +getBtnByState(datas[i].status)+"</td>"+
                    "<input type='hidden' value="+datas[i].requestid+" />"+
                    "<input type='hidden' value="+datas[i].reportName+" />"+
                    "<input type='hidden' value="+datas[i].processDefinitionID+" />"+
                    "<input type='hidden' value="+datas[i].processInstanceId+" />"+
                    "<input type='hidden' value="+datas[i].nodeName+" />"+
                    "<input type='hidden' value="+datas[i].currentAssignee+" />"+
                    "<input type='hidden' value="+datas[i].dep+" />"+
                    "<tr>");
            }
        }

    }

    function getState(state) {
        if(state=='0' || state=='1' || state=='2' || state=='5'){
            return "进行中";
        }else if(state=='3' || state=='8'){
            return "已退回";
        }else if(state=='4'){
            return "已撤回";
        }else if(state=='7'){
            return "已删除";
        }else if(state=='6' || state=='9'){
            return "已完成";
        }else{
            return "";
        }
    }

    function getBtnByState(state) {
        var html= "<button name=\"controlDetail\" style=\"color: #FFB800;\" class=\"mybtn\">详情</button>";
        if(state=='6' || state=='7' || state=='9' ){
            return html;
        }else{
            return html+" &nbsp;&nbsp;<button name=\"controlDelete\" style=\"color: #FF5722;\" class=\"mybtn\">删除</button>"+
                "&nbsp;&nbsp;<button name=\"controlGanYu\" style=\"color: #00a0e9;\" class=\"mybtn\">干预</button>";;
        }
    }

    function getCurrentTime() {
        var mydate=new Date();
        return mydate.getFullYear()+"-"+(mydate.getMonth()+1)+"-"+mydate.getDay()+" "+mydate.getHours()+":"+mydate.getMinutes()+":"+mydate.getSeconds();

    }

    //简化办理人显示
    function showAssignee(assignee) {
        if(assignee==''){
            return "";
        }else{
            var arr = assignee.split(",");
            if(arr.length>3){
                return arr[0]+","+arr[1]+","+arr[2]+"..."+"<span style='cursor: pointer;color: blue;' name='zhankai_assginee'>展开</span>"
            }else{
                return assignee;
            }
        }
    }
    //简化节点名称显示
    function showNode(node) {
        if(node==''){
            return "";
        }else{
            var arr = node.split(",");
            if(arr.length>1){
                return arr[0]+"..."+"<span style='cursor: pointer;color: blue;' name='zhankai_node'>展开</span>"
            }else{
                return node;
            }
        }
    }

    //简化部门
    function showDep(dep) {
        if(dep==''){
            return "";
        }else{
            var arr = dep.split(",");
            if(arr.length>1){
                return arr[0]+"..."+"<span style='cursor: pointer;color: blue;' name='zhankai_dep'>展开</span>"
            }else{
                return dep;
            }
        }
    }

</script>
</html>
