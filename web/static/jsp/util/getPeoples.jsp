<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <style>
    html,body{
    font-family: 'Microsoft YaHei';
    }
        .myli{
            cursor: pointer;
            font-family: 'Microsoft YaHei';
            line-height: 25px;
                text-align: left;
                white-space: nowrap;
                position: relative;
                margin: 0px 13px;
                padding-left: 1.5em;
                font-size: 14px;
                color: #666666;
                cursor: pointer;
                -webkit-transition: all .3s ease-in 0s;
                transition: all .3s ease-in 0s;
                display:block;
        }
        .myli:hover, .myli:focus{
             background-color: rgba(54, 133, 242, .06);
                color: #3685f2;
                -webkit-transition: all .3s ease-in 0s;
                transition: all .3s ease-in 0s;
                font-family: 'Microsoft YaHei';
        }
        .bmList .myli{
          color:#666;
          /*padding-left:0!important;*/
          font-family: 'Microsoft YaHei';
        }
         .bmList .myli:hover, .bmList .myli:focus{
                  color:#3685f2!important;
                 /* background:none!important;*/
                  font-family: 'Microsoft YaHei';
             background: url("${ctx}/static/images/tree_vertical_line_3.png") repeat-y;
             background-position: -10px center;

                }
        .clearfix::after {
            height: 0;
            display: block;
            visibility: hidden;
            clear: both;
            content: '';
        }
        .hdWrap{
            width: 100%;
            border-bottom: 1px solid #f5f5f5;
            cursor: pointer;
            padding: 5px 10px;
            font-family: 'Microsoft YaHei';
            box-sizing:border-box;
        }
        .hdWrap a{ font-size: 14px; color: #333; padding: 5px 10px; margin: 10px; font-family: 'Microsoft YaHei';}
        .hdWrap a.active{
            color: #3296f5;
            border-bottom: 2px solid #3296f5;font-family: 'Microsoft YaHei';
        }
        .headText{
            font-size: 14px;
            color: #333;
            border-left: 4px solid #3296f5;
            padding-left: 0.5em;
            margin: 5px 10px;
            box-sizing: border-box;font-family: 'Microsoft YaHei';
        }
        .bmWrap::-webkit-scrollbar{
          width:5px;
          height:5px;
          /**/
        }
        .bmWrap::-webkit-scrollbar-track{
          background: rgb(239, 239, 239);
          border-radius:10px;
        }
        .bmWrap::-webkit-scrollbar-thumb{
          background: #bfbfbf;
          border-radius:10px;
        }
        .bmWrap::-webkit-scrollbar-thumb:hover{
          background: rgba(0,0,0,0.3);
        }
        .bmWrap::-webkit-scrollbar-corner{
          background: #179a16;
        }
    /* .x-icon{
      width: 25px; height: 25px;
      !*background: url(images/tree_vertical_line_1.png) repeat-y;*!
     float: left;
      background: url("images/tree_vertical_line_3.png") repeat-y;
  }*/
    .bmWrap1::before {
        background: url("${ctx}/static/images/tree_vertical_line_1.png") repeat-y;
        content: '';
        position: absolute;
        top: 0;
        left: 0px;
        width: 20px;
        height: 100%;
    }
    .bmWrap .myli{
        /*position: absolute;
        left: 10px;*/
        /*float: left;*/
        padding-left: 30px;
        color: #333;
        font-size: 14px;
        margin-left: 0;
        background: url("${ctx}/static/images/tree_vertical_line_3.png") repeat-y;
        background-position: -10px center;
    }
    .bmWrap .myli:hover{
        /*background: none!important;*/
    }
    .base-line-conn-background {


    }
    .addClass{
        border: 1px solid #000;
        cursor: pointer;
        display: inline-block;
        width: 10px;
        height: 10px;
        background-image: url("${ctx}/static/images/add.png");
        background-size: cover;
        position: relative;
        left: 12px;
        box-sizing: border-box;
        z-index: 99999;
    }
    </style>
<%--    <link rel="stylesheet" href="${ctx}/static/css/xzblr.css"--%>
    <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
    <script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>
    <%
        String Authorization="";
        Cookie[] c=request.getCookies();
        for(Cookie cookie:c){
            if("fine_auth_token".equals(cookie.getName())){
                Authorization=cookie.getValue();
            }
        }
    %>
</head>

<body style="padding: 0px;margin: 0px">

<%--<div style="display: inline-block" id="my" onclick="aa()" class="add"></div>
<div style="display: inline-block" id="my1" onclick="aa()" class="jian"></div>--%>
<div>
<c:if test="${param.state=='1'||param.state=='2'||param.state=='3'}">
    <div class="hdWrap" >
        <a id="dep_a" class="active" onclick="showDiv(1,this)">部门-人员</a>
        <a id="role_a" onclick="showDiv(0,this)">角色-人员</a>
    </div>
       <%-- <div class="hd clearfix">
            <a href="#" class="active">部门-人员</a>
            <a href="#">角色-人员</a>
        </div>--%>
    <%--<select id="mySelect" onchange="showDiv()" style="width: 100px;margin: 5px;">
        <option value="1">部门-人员</option>
        <option value="0">角色-人员</option>
    </select>--%>
</c:if>
</div>

<div id="depDiv" class="clearfix" style="border:1px solid #f5f5f5;box-sizing:border-box;">
    <div class="bmList" style="width: 38%;height: 90%;float: left;box-sizing:border-box;">
       <div class="headText">
            部门
        </div>
        <div class="layui-form" action="">
            <div class="layui-form-item" style="margin-bottom: 0;">
                <div class="layui-input-block" style="margin:0px 10px;">
                    <div style="width: 80%; float: left;">
                        <input type="text" id="selDepName" style="border-radius: 5px 0 0 5px;height: 30px;line-height: 30px;"
                               lay-verify="title" autocomplete="off" placeholder="搜索部门" class="layui-input">

                    </div>
                    <div style="width: 20%; float: left;">
                        <button class="layui-btn" onclick="selDep(this)"
                                style="width: 100%; background: #3296f5;border-radius: 0 5px 5px 0;height: 30px;line-height: 30px;">
                            <i class="layui-icon layui-icon-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
      <%--  <span style="font-size: 15px">部门：</span>
        <input id="selDepName" type="text" placeholder="搜索部门" /><button onclick="selDep(this)">搜索</button>
        <hr style="margin: 2px 0px">--%>
        <div class="bmWrap1 bmWrap" style="height: 75%;overflow-y: auto;position: relative;">
            <ul id="department" style="line-height: 25px;padding: 0px 10px;font-size: 15px;">
            </ul>
        </div>

    </div>
    <div class="bmWrap" style="width: 27%;height: 90%;float: left;overflow-y:auto;border-left:1px solid #f5f5f5;box-sizing:border-box;">
        <div class="headText">
            职位
        </div>
      <%--  <span style="font-size: 15px">职位：</span>
        <hr style="margin: 5px 0px">--%>
        <div class="bmWrap" style="height: 85%;overflow-y: auto;">
            <ul id="position" style="line-height: 25px;padding: 0px 10px;font-size: 15px">
            </ul>
        </div>
    </div>
    <div style="width: 34%;height: 90%;float: left;border-left:1px solid #f5f5f5;box-sizing:border-box;">
        <div class="headText">
            人员
        </div>
        <%--<span style="font-size: 15px">人员：</span><hr style="margin: 5px 0px">--%>
        <div class="bmWrap" style="height: 85%;overflow-y: auto;">
            <ul id="user"  class="clearfix" style="line-height: 25px;padding: 0px 15px;font-size: 15px;list-style: none;">
            </ul>
        </div>
    </div>
</div>

<div id="roleDiv" class="clearfix" style="display: none;border:1px solid #f5f5f5;box-sizing:border-box;">
    <div class="bmList" style="float: left;box-sizing:border-box;">
        <div class="headText">
            角色
        </div>
           <%-- <span style="font-size: 15px">角色：</span>--%>
        <div class="layui-form" action="" style="width: 100%;">
            <div class="layui-form-item" style="margin-bottom: 0;">
                <div class="layui-input-block" style="margin:0px 10px;">
                    <div style="width: 80%; float: left;">
                        <input type="text" id="role_name1" style="border-radius: 5px 0 0 5px;height: 30px;line-height: 30px;"
                               lay-verify="title" autocomplete="off" placeholder="搜索角色" class="layui-input">

                    </div>
                    <div style="width: 20%; float: left;">
                        <button class="layui-btn" onclick="selRole1(this)"
                                style="width: 100%; background: #3296f5;border-radius: 0 5px 5px 0;height: 30px;line-height: 30px;">
                            <i class="layui-icon layui-icon-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
         <%--   <input id="role_name1" type="text" placeholder="搜索角色" /><button onclick="selRole1(this)">搜索</button>--%>
          <%--  <hr style="margin: 2px 0px">--%>
        <div class="bmWrap1 bmWrap" style="width: 38%;height: 65%;float: left;overflow-y:auto;width: 100%;position: relative;">
            <ul id="role" style="line-height: 25px;padding: 0px 10px;font-size: 15px">
            </ul>
        </div>
    </div>
    <div style="float: left;width: 68%;border-left:1px solid #f5f5f5;box-sizing:border-box;">
        <div class="headText">
            人员
        </div>
       <%-- <span style="font-size: 15px">人员：</span><hr style="margin: 5px 0px">--%>
        <div class="bmWrap" style="width: 38%;height: 80%;float: left;overflow-y:auto;width: 100%">
            <ul id="role_user" style="line-height: 25px;padding: 0px 15px;font-size: 15px;list-style: none;">
            </ul>
        </div>
    </div>
</div>

<div id="roleDiv1" style="display: none;">
    <div style="width: 99%;height: 90%;float: left;overflow-y:auto;">
        <span style="font-size: 15px">角色：</span>
        <input id="role_name" type="text" placeholder="搜索角色" /><button onclick="selRole(this)">搜索</button>
        <hr style="margin: 5px 0px">
        <ul id="role1" style="line-height: 40px;padding: 0px 10px;font-size: 15px">
        </ul>
    </div>
</div>

</body>
<script>

    var state="${param.state}";
    var roleData,dep;
    var huiqianUser=[];
    var groups=[];
    var groupRoles=[];
    var groupRolesByHuiQian=[];
    var huiqianUserByRole=[];
    if(state=='2'){
        var temp_huiqian=parent.document.getElementById("huiqian").value.split(",");
        for(var i=0;i<temp_huiqian.length;i++){
            if(temp_huiqian[i]!=''){
                huiqianUser.push(temp_huiqian[i]);
            }
        }
    }else if(state=='3'){
        var temp_groups=parent.document.getElementById("userField").value.split(",");
        for(var i=0;i<temp_groups.length;i++){
            if(temp_groups[i]!=''){
                groups.push(temp_groups[i]);
            }
        }
    }else if(state=='5'){
        var temp_groupsInRole=parent.document.getElementById("preemptiveTemp").value;
        if(temp_groupsInRole==undefined || temp_groupsInRole==''){
            groupRoles =[];
        }else{
            groupRoles = JSON.parse(temp_groupsInRole);
        }
    }else if(state=='6'){
        var temp_groupsInRoleByHuiQian=parent.document.getElementById("huiqianTemp").value;
        if(temp_groupsInRoleByHuiQian==undefined || temp_groupsInRoleByHuiQian==''){
            groupRolesByHuiQian =[];
        }else{
            groupRolesByHuiQian = JSON.parse(temp_groupsInRoleByHuiQian);
        }
    }


    $(function () {
        if(state=='1'||state=='2'||state=='3'){
            getDeps();
            getRoles();
        }else if(state=='4'){
            getRoles();
            showRoleDiv();
        }else if(state=='5'||state=='6'){
            getRoles();
            showRoleDiv();
        }

        $(document).on("click","${'[name=\'add\']'}",function(){
            $(this).css("background-image","url('${ctx}/static/images/jian.png')").attr("name","jian");
            var mythis=$(this);
            $.ajax({
                type:"get",
                url:"${ctx}/decision/v10/departments/"+$(this).next("div").attr("id"),
                dataType:'json',
                headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
                success:function (data) {
                    for(var i=0;i<data.data.length;i++) {
                        var temp="";
                        if(!data.data[i].isParent){
                            temp="<div onclick='getPosition(this)' id="+data.data[i].id+" class=\"myli\" style='display: inline-block;margin-left: 15px;'>"+data.data[i].text+"</div>";
                        }else {
                            temp="<div name='add'  class='addClass'></div>"
                                +"<div onclick='getPosition(this)' id="+data.data[i].id+" class=\"myli\" style='display: inline-block;margin-left: 5px'>"+data.data[i].text+"</div>";
                        }
                        mythis.next().after("<ul style='list-style: none;margin-left: 15px;'><li>"+temp+"</li></ul>");
                       // $("#department").append("<li >"+temp+"</li>");
                    }
                },
                error:function (xhr,text) {
                    alert(text);
                }
            });

        });


        $(document).on("click","${'[name=\'jian\']'}",function(){
            $(this).css("background-image","url('${ctx}/static/images/add.png')").attr("name","add")
                .next().nextAll().remove();
        });

    });

    function getDeps() {
        $.ajax({
            type:"get",//http://localhost:8080/webroot/decision/v10/departments/old-platform-department-31
            //{"data":[{"id":"1491023f-8744-4c08-96f2-b3c5c4099567","pId":"old-platform-department-31","text":"人力资源子部门","pText":"","isParent":false,"open":false,"privilegeDetailBeanList":null}]}
            url:"${ctx}/decision/v10/departments/decision-dep-root",
            dataType:'json',
            headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
            success:function (data) {
                dep=data;
                $("#department").empty();
                for(var i=0;i<data.data.length;i++) {
                    var temp="";
                    if(!data.data[i].isParent){
                        temp="<div onclick='getPosition(this)' id="+data.data[i].id+" class=\"myli\" style='display: inline-block;margin-left: 15px;'>"+data.data[i].text+"</div>";
                    }else {
                        temp="<div name='add' class='addClass' ></div>"
                            +"<div onclick='getPosition(this)' id="+data.data[i].id+" class=\"myli\" style='margin-left: 5px;display: inline-block'>"+data.data[i].text+"</div>";
                    }
                    $("#department").append("<li class=\"clearfix\"> <div class=\"x-icon\"></div>"+temp+"</li>");
                }
            },
            error:function (xhr,text) {
                alert(text);
            }
        });
    }

    function getRoles() {
        $.ajax({
            type:"get",
            url:"${ctx}/decision/v10/roles?page=1&count=100000",
            dataType:'json',
            headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
            success:function (data) {
                var mydata=data.data.items;
                roleData=mydata;
                $("#role").empty();
                for(var i=0;i<mydata.length;i++) {
                    var temp="";
                   if(state==5){
                       if(checkRolesById(groupRoles,mydata[i].id)){
                           $("#role").append("<div style='position: relative;left: 10px;' name="+mydata[i].id+" id="+mydata[i].text+"><input checked onclick='addQianZhanShiByRole(this)' " +
                               "type='checkbox' name="+mydata[i].id+" value="+mydata[i].text+" />" + mydata[i].text+"&nbsp;&nbsp;&nbsp;</div>");
                       }else{
                           $("#role").append("<div style='position: relative;left: 10px;' name="+mydata[i].id+" id="+mydata[i].text+"><input onclick='addQianZhanShiByRole(this)' " +
                               "type='checkbox' name="+mydata[i].id+" value="+mydata[i].text+" />" + mydata[i].text+"&nbsp;&nbsp;&nbsp;</div>");
                       }
                   }else if(state==6)
                   {
                       if(checkRolesById(groupRolesByHuiQian,mydata[i].id)){
                           $("#role").append("<div style='position: relative;left: 10px;' name="+mydata[i].id+" id="+mydata[i].text+"><input checked onclick='addHuiQianByRole(this)' " +
                               "type='checkbox' name="+mydata[i].id+" value="+mydata[i].text+" />" + mydata[i].text+"&nbsp;&nbsp;&nbsp;</div>");
                       }else{
                           $("#role").append("<div style='position: relative;left: 10px;' name="+mydata[i].id+" id="+mydata[i].text+"><input onclick='addHuiQianByRole(this)' " +
                               "type='checkbox' name="+mydata[i].id+" value="+mydata[i].text+" />" + mydata[i].text+"&nbsp;&nbsp;&nbsp;</div>");
                       }

                   }
                   else{
                       temp="<div onclick='getRole_user(this)' id="+mydata[i].id+" class=\"myli\" " +
                           "style='margin-left: 5px;display: inline-block'>"+mydata[i].text+"</div>";
                       $("#role").append("<li >"+temp+"</li>");
                   }
                }
                $("#role1").empty();
                $("#role1").append("<input onchange='selAllHuiQianByRole(this)' value=\"\"  type='checkbox' />全选<br/>");
                for(var i=0;i<mydata.length;i++) {
                    $("#role1").append("<input onclick='addHuiQianByRole(this)' type='checkbox' value="+mydata[i].text+" />" + mydata[i].text+"&nbsp;&nbsp;&nbsp;");
                }
            },
            error:function (xhr,text) {
                alert(text);
            }
        });
    }

    function getPosition(obj) {
        parentid=obj.id;
        $.ajax({
            type:"get",
            url:"${ctx}/decision/v10/"+obj.id+"/posts",
            dataType:'json',
            headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
            success:function (data) {
                $("#position").empty();
                $("#user").empty();
                for(var i=0;i<data.data.length;i++) {
                    $("#position").append("<li onclick="+"getUser(this,"+"\""+obj.id+"\""+")" +" id="+data.data[i].id+" class=\"myli\">"
                        +data.data[i].text+"</li>");
                }
            },
            error:function (xhr,text) {
                alert(text);
            }
        });
    }

    function getUser(obj,departmentid) {
        var data =  {"page" :"1","count":"100000"};
        $.ajax({
            type:"POST",
            url:"${ctx}/decision/v10/"+departmentid+"/"+obj.id+"/users",
            dataType:'json',
            data:JSON.stringify(data),
            headers:{"Authorization":"Bearer "+"<%=Authorization %>"
                ,"Content-Type":"application/json", "Accept": "application/json"},
            success:function (data) {
                $("#user").empty();
               if(state==1){
                   for(var i=0;i<data.data.items.length;i++) {
                       $("#user").append("<li onclick='addAssagin(this)' id="+data.data.items[i].username+" class=\"myli\">"
                           +data.data.items[i].username+"   "+data.data.items[i].realName+"</li>");
                   }
               }else if(state==2){
                   var value = parent.document.getElementById("huiqian").value;
                   //会签
                   $("#user").append("<li><input onchange='selAllHuiQian(this,0)' type='checkbox' />全选</li>");

                   for(var i=0;i<data.data.items.length;i++) {
                       if(value.indexOf(data.data.items[i].username)>-1){
                           $("#user").append("<li id="+data.data.items[i].username+" class=\"myli\">"
                               +"<input onchange='addHuiQian(this)' type='checkbox' value="+data.data.items[i].username+" checked />"+data.data.items[i].username+"   "
                               +data.data.items[i].realName+"</li>");
                       }else{
                           $("#user").append("<li id="+data.data.items[i].username+" class=\"myli\">"
                               +"<input onchange='addHuiQian(this)' type='checkbox' value="+data.data.items[i].username+" />"+data.data.items[i].username+"   "
                               +data.data.items[i].realName+"</li>");
                       }

                   }
               }else if(state==3){
                   var value = parent.document.getElementById("userField").value;
                   //组成员
                   $("#user").append("<li><input onchange='selAllGroup(this,0)' type='checkbox' />全选</li>");

                       for(var i=0;i<data.data.items.length;i++) {
                           if(value.indexOf(data.data.items[i].username)>-1) {
                               $("#user").append("<li id=" + data.data.items[i].username + " class=\"myli\">"
                                   + "<input onchange='addGroup(this)' type='checkbox' value="+data.data.items[i].username+" checked />" + data.data.items[i].username + "   " + data.data.items[i].realName + "</li>");
                           }
                           else{
                               $("#user").append("<li id="+data.data.items[i].username+" class=\"myli\">"
                                   +"<input onchange='addGroup(this)' value="+data.data.items[i].username+" type='checkbox'  />"+data.data.items[i].username+"   "+data.data.items[i].realName+"</li>");
                           }
                       }


               }
            },
            error:function (xhr,text) {
                alert(text);
            }
        });
    }

    function addAssagin(obj) {
            parent.document.getElementById("assigneeField").value = obj.id;
    }

    function addGroup(obj) {
        var group=parent.document.getElementById("userField");
        if(obj.checked)
        {
            var myvalue="";
            if(groups.indexOf(obj.parentNode.id)==-1){
                groups.push(obj.parentNode.id);
            }
            for(var i=0;i<groups.length;i++){
                myvalue+=groups[i]+",";
            }
            group.value=myvalue.substr(0, myvalue.length - 1);
        }
        else {
            var myvalue="";
            if(groups.indexOf(obj.parentNode.id)>-1){
                groups.splice(groups.indexOf(obj.parentNode.id),1);
            }
            for(var i=0;i<groups.length;i++){
                myvalue+=groups[i]+",";
            }
            group.value=myvalue.substr(0, myvalue.length - 1);

        }
    }

    function selAllGroup(obj,id) {
        var mythis=$(obj);
        var group=parent.document.getElementById("userField");
        var myvalue="";
        if(mythis.is(":checked")){
            var temp="";
            $("#"+(id==0?"user":"role_user")).find("input[type='checkbox']").each(function () {
                if(typeof ($(this).parent("li").attr("id"))!='undefined'){
                    if(groups.indexOf($(this).parent("li").attr("id"))==-1){
                        groups.push($(this).parent("li").attr("id"));
                    }
                    $(this).prop("checked",true);
                }
            });
            for(var i=0;i<groups.length;i++){
                myvalue+=groups[i]+",";
            }
            group.value=myvalue.substr(0, myvalue.length - 1);
        }else{
            $("#"+(id==0?"user":"role_user")).find("input[type='checkbox']").each(function () {
                $(this).prop("checked",false);
                if(groups.indexOf($(this).val())>-1){
                    groups.splice(groups.indexOf($(this).val()),1);
                }
                /*for(var j=0;j<huiqianUser.length;j++){
                    if($(this).val()==huiqianUser[j]){
                        huiqianUser.splice(j,1);
                    }
                }*/
            });
            for(var ii=0;ii<groups.length;ii++){
                myvalue+=groups[ii]+",";
            }

            group.value=myvalue.substr(0, myvalue.length - 1);
        }

    }

    function aa() {
        $("#my").removeClass("add::after ")
    }

    function showDiv(name,obj) {
       // var name=$("#mySelect").val();
        if(name=='1'){
            $("#dep_a").addClass("active");
            $("#role_a").removeClass("active");
            $("#depDiv").show();
            $("#roleDiv").hide();
            $("#roleDiv1").hide();
            if(state==2){
                huiqianUser=[];  groups=[];
                parent.document.getElementById("huiqian").value="";
                $("#user").find("input[type='checkbox']").prop("checked",false);
                $("#role_user").find("input[type='checkbox']").prop("checked",false);
            }else if(state==3){
                huiqianUser=[];  groups=[];
                parent.document.getElementById("userField").value="";
                $("#user").find("input[type='checkbox']").prop("checked",false);
                $("#role_user").find("input[type='checkbox']").prop("checked",false);
            }
        }else if(name=='0'){
            $("#dep_a").removeClass("active");
            $("#role_a").addClass("active");
            showRoleDiv();
        }else{
            $("#roleDiv").hide();
            $("#depDiv").hide();
            $("#roleDiv1").show();

        }
    }

    function getRole_user(obj) {
        var data =  {"page" :"1","count":"100000"};
        $.ajax({
            type:"post",
            url:"${ctx}/decision/v10/"+obj.id+"/users",
            dataType:'json',
            contentType: "application/json",
            data:JSON.stringify(data),
            headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
            success:function (data) {
                var mydata=data.data.items;
                $("#role_user").empty();
                console.log(state)
                    if(state==1){
                    if(mydata.length>0){
                        for(var i=0;i<mydata.length;i++) {
                            $("#role_user").append("<li onclick='addAssagin(this)' id="+mydata[i].username+" class=\"myli\">"
                                +mydata[i].username+"   "+mydata[i].realName+"</li>");
                        }
                    }

                        else{
                                $("#role_user").append("<div style='width:250px;height:250px;margin: 0 auto;'>" +
                                    "<img src='${ctx}/static/images/nouser.jpg' width='100%' height='100%'  /></div>");
                            }

                    }
                    else if(state==2){
                        var value = parent.document.getElementById("huiqian").value;
                        //会签
                       if(mydata.length>0){
                           $("#role_user").append("<li><input onchange='selAllHuiQian(this,1)' type='checkbox' />全选</li>");
                           for(var i=0;i<mydata.length;i++) {
                               if(value.indexOf(mydata[i].username)>-1){
                                   $("#role_user").append("<li id="+mydata[i].username+" class=\"myli\">"
                                       +"<input onchange='addHuiQian(this)' value="+mydata[i].username+" type='checkbox' checked />"+mydata[i].username+"   "
                                       +mydata[i].realName+"</li>");
                               }else{
                                   $("#role_user").append("<li id="+mydata[i].username+" class=\"myli\">"
                                       +"<input onchange='addHuiQian(this)' value="+mydata[i].username+" type='checkbox' />"+mydata[i].username+"   "
                                       +mydata[i].realName+"</li>");
                               }

                           }
                       }else{
                           $("#role_user").append("<div style='width:250px;height:250px;margin: 0 auto;'>" +
                               "<img src='${ctx}/static/images/nouser.jpg' width='100%' height='100%'  /></div>");
                       }
                    }
                    else if(state==3){
                        var value = parent.document.getElementById("userField").value;
                        //组成员
                        if(mydata.length>0){
                            $("#role_user").append("<li><input onchange='selAllGroup(this,1)' type='checkbox' />全选</li>");

                            for(var i=0;i<mydata.length;i++) {
                                if(value.indexOf(mydata[i].username)>-1) {
                                    $("#role_user").append("<li id=" + mydata[i].username + " class=\"myli\">"
                                        + "<input onchange='addGroup(this)' value="+mydata[i].username+" type='checkbox' checked  />" + mydata[i].username + "   "
                                        + mydata[i].realName + "</li>");
                                }
                                else{
                                    $("#role_user").append("<li id="+mydata[i].username+" class=\"myli\">"
                                        +"<input onchange='addGroup(this)' value="+mydata[i].username+" type='checkbox'  />"+mydata[i].username+"   "
                                        +mydata[i].realName+"</li>");
                                }
                            }
                        }else{
                            $("#role_user").append("<div style='width:250px;height:250px;margin: 0 auto;'>" +
                                "<img src='${ctx}/static/images/nouser.jpg' width='100%' height='100%'  /></div>");
                        }



                    }

                    else if(state==4){
                        if(mydata.length==0){
                            $("#role_user").append("<div style='width:250px;height:250px;margin: 0 auto;'>" +
                                "<img src='${ctx}/static/images/nouser.jpg' width='100%' height='100%'  /></div>");
                        }else{
                            console.log("角色用户："+mydata[0].username)
                            parent.document.getElementById("assigneeField").value = obj.innerHTML;
                            parent.document.getElementById("assigneTemp").value = mydata[0].username;
                            //parent.document.getElementById("assigneTemp1").value = mydata[0].username;
                            for(var i=0;i<mydata.length;i++) {
                                $("#role_user").append("<li  id="+mydata[i].username+" class=\"myli\">"
                                    +mydata[i].username+"   "+mydata[i].realName+"</li>");
                            }
                        }

                    }

                  /*  else if(state==5){
                        if(mydata.length==0){
                            alert("该角色没有用户")
                        }else{
                            var username="";
                            for(var ii=0;ii<mydata.length;ii++){
                                username+=mydata[ii].username+",";
                            }
                            console.log("角色用户："+username.length==0?"":username.substring(0,username.length-1));
                            parent.document.getElementById("userField").value = obj.innerHTML;
                            parent.document.getElementById("preemptiveTemp").value = username.length==0?"":username.substring(0,username.length-1);
                        }
                    }*/

            },
            error:function (xhr,text) {
                alert(text);
            }
        });
    }

    function addHuiQian(obj) {
        var huiqian=parent.document.getElementById("huiqian");
        if(obj.checked)
        {
            var myvalue="";
            if(huiqianUser.indexOf(obj.parentNode.id)==-1){
                huiqianUser.push(obj.parentNode.id);
            }
            for(var i=0;i<huiqianUser.length;i++){
                myvalue+=huiqianUser[i]+",";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);
        }
        else {
            var myvalue="";
            if(huiqianUser.indexOf(obj.parentNode.id)>-1){
                huiqianUser.splice(huiqianUser.indexOf(obj.parentNode.id),1);
            }
            for(var i=0;i<huiqianUser.length;i++){
                myvalue+=huiqianUser[i]+",";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);

        }

    }

    function selAllHuiQian(obj,id) {
        var mythis=$(obj);
        var huiqian=parent.document.getElementById("huiqian");
        var myvalue="";
        if(mythis.is(":checked")){
            var temp="";
            $("#"+(id==0?"user":"role_user")).find("input[type='checkbox']").each(function () {
                if(typeof ($(this).parent("li").attr("id"))!='undefined'){
                    if(huiqianUser.indexOf($(this).parent("li").attr("id"))==-1){
                        huiqianUser.push($(this).parent("li").attr("id"));
                    }
                    $(this).prop("checked",true);
                }
            });
            for(var i=0;i<huiqianUser.length;i++){
                myvalue+=huiqianUser[i]+",";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);
        }else{
            $("#"+(id==0?"user":"role_user")).find("input[type='checkbox']").each(function () {
                $(this).prop("checked",false);
                if(huiqianUser.indexOf($(this).val())>-1){
                    huiqianUser.splice(huiqianUser.indexOf($(this).val()),1);
                }
                /*for(var j=0;j<huiqianUser.length;j++){
                    if($(this).val()==huiqianUser[j]){
                        huiqianUser.splice(j,1);
                    }
                }*/
            });
            for(var ii=0;ii<huiqianUser.length;ii++){
                myvalue+=huiqianUser[ii]+",";
            }

            huiqian.value=myvalue.substr(0, myvalue.length - 1);
        }

    }

    function addHuiQianByRole(obj) {
        var huiqian=parent.document.getElementById("huiqian");
        if(obj.checked)
        {
            var myvalue="";
            if(huiqianUserByRole.indexOf(obj.value)==-1){
                huiqianUserByRole.push(obj.value);
            }
            for(var i=0;i<huiqianUserByRole.length;i++){
                myvalue+=huiqianUserByRole[i]+"/";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);
        }
        else {
            var myvalue="";
            if(huiqianUserByRole.indexOf(obj.value)>-1){
                huiqianUserByRole.splice(huiqianUserByRole.indexOf(obj.value),1);
            }
            for(var i=0;i<huiqianUserByRole.length;i++){
                myvalue+=huiqianUserByRole[i]+"/";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);

        }

    }

    function selAllHuiQianByRole(obj) {
        var mythis=$(obj);
        var huiqian=parent.document.getElementById("huiqian");
        var myvalue="";
        if(mythis.is(":checked")) {
            $("#role1").find("input[type='checkbox']").each(function () {
                if($(this).val()!=''){
                    if(huiqianUserByRole.indexOf($(this).val())==-1){
                        huiqianUserByRole.push($(this).val());
                    }
                    $(this).prop("checked",true);
                }
            });
            for(var i=0;i<huiqianUserByRole.length;i++){
                myvalue+=huiqianUserByRole[i]+"/";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);
        }
        else{
            $("#role1").find("input[type='checkbox']").each(function () {
                $(this).prop("checked",false);
                if(huiqianUserByRole.indexOf($(this).val())>-1){
                    huiqianUserByRole.splice(huiqianUserByRole.indexOf($(this).val()),1);
                }
            });
            for(var ii=0;ii<huiqianUserByRole.length;ii++){
                myvalue+=huiqianUserByRole[ii]+",";
            }
            huiqian.value=myvalue.substr(0, myvalue.length - 1);
        }
    }

    function addQianZhanShiByRole(obj) {
        var group=parent.document.getElementById("userField");
        var roleid=obj.name;
        //console.log(roleid)
        var data =  {"page" :"1","count":"100000"};
        if(obj.checked)
        {
            $.ajax({
                type:"post",
                url:"${ctx}/decision/v10/"+roleid+"/users",
                dataType:'json',
                contentType: "application/json",
                data:JSON.stringify(data),
                headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
                success:function (data) {
                    var mydata = data.data.items;
                    if(mydata.length>0){
                        var temp={};
                        temp["id"]=obj.name;
                        temp["name"]=obj.value;
                        temp["user"]=getRolesInAssgine(mydata);
                        updateRoles(groupRoles,temp,1,group);
                        for(var i=0;i<mydata.length;i++) {
                            $("#role_user").empty().append("<li id="+mydata[i].username+" class=\"myli\">"
                                +mydata[i].username+"   "+mydata[i].realName+"</li>");
                        }
                    }else{
                        $("#role_user").empty().append("<div style='width:250px;height:250px;margin: 0 auto;'>" +
                            "<img src='${ctx}/static/images/nouser.jpg' width='100%' height='100%'  /></div>");
                        obj.checked=false;
                    }
                },
                error:function (xhr,text) {
                    alert(text);
                }
            });
        }
        else {
            var temp={};
            temp["id"]=obj.name;
            updateRoles(groupRoles,temp,2,group);
        }
    }

    function addHuiQianByRole(obj) {
        var group=parent.document.getElementById("huiqian");
        var roleid=obj.name;
        //console.log(roleid)
        var data =  {"page" :"1","count":"100000"};
        if(obj.checked)
        {
            $.ajax({
                type:"post",
                url:"${ctx}/decision/v10/"+roleid+"/users",
                dataType:'json',
                contentType: "application/json",
                data:JSON.stringify(data),
                headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
                success:function (data) {
                    var mydata = data.data.items;
                    if(mydata.length>0){
                        var temp={};
                        temp["id"]=obj.name;
                        temp["name"]=obj.value;
                        temp["user"]=getRolesInAssgine(mydata);
                        updateRolesByHuiQian(groupRolesByHuiQian,temp,1,group);
                        for(var i=0;i<mydata.length;i++) {
                            $("#role_user").empty().append("<li id="+mydata[i].username+" class=\"myli\">"
                                +mydata[i].username+"   "+mydata[i].realName+"</li>");
                        }
                    }else{
                        $("#role_user").empty().append("<div style='width:250px;height:250px;margin: 0 auto;'>" +
                            "<img src='${ctx}/static/images/nouser.jpg' width='100%' height='100%'  /></div>");
                        obj.checked=false;
                    }
                },
                error:function (xhr,text) {
                    alert(text);
                }
            });
        }
        else {
            var temp={};
            temp["id"]=obj.name;
            updateRolesByHuiQian(groupRolesByHuiQian,temp,2,group);
        }
    }

    function checkRolesById(groupRoles,id) {
        var flag=false;
        for(var i=0;i<groupRoles.length;i++){
            if(groupRoles[i].id==id){
                flag=true;
                break;
            }
        }
        return flag;
    }

    function updateRoles(groupRoles,temp,state,group) {
        if(state==1){
            var flag=false;
            for(var i=0;i<groupRoles.length;i++){
                if( groupRoles[i].id == temp["id"]){
                    groupRoles[i].name=temp["name"];
                    groupRoles[i].user=temp["user"];
                    flag=true;
                    break;
                }
            }
            if(flag){

            }else{
                //没有新增
                groupRoles.push(temp);
            }
        }else{
            for(var j=0;j<groupRoles.length;j++){
                if(groupRoles[j].id == temp["id"]){
                    groupRoles.splice(j,1);
                }
            }
        }
        //console.log(groupRoles)
        if(groupRoles.length==0){
            group.value="";
        }else{
            var myvalue=[];
            for(var m=0;m<groupRoles.length;m++){
                myvalue.push(groupRoles[m].name)
            }
            group.value=myvalue.join(",");
            parent.document.getElementById("preemptiveTemp").value=JSON.stringify(groupRoles);
        }

    }

    function updateRolesByHuiQian(groupRolesByHuiQian,temp,state,group) {
        if(state==1){
            var flag=false;
            for(var i=0;i<groupRolesByHuiQian.length;i++){
                if( groupRolesByHuiQian[i].id == temp["id"]){
                    groupRolesByHuiQian[i].name=temp["name"];
                    groupRolesByHuiQian[i].user=temp["user"];
                    flag=true;
                    break;
                }
            }
            if(flag){

            }else{
                //没有新增
                groupRolesByHuiQian.push(temp);
            }
        }else{
            for(var j=0;j<groupRolesByHuiQian.length;j++){
                if(groupRolesByHuiQian[j].id == temp["id"]){
                    groupRolesByHuiQian.splice(j,1);
                }
            }
        }
        //console.log(groupRoles)
        if(groupRolesByHuiQian.length==0){
            group.value="";
        }else{
            var myvalue=[];
            for(var m=0;m<groupRolesByHuiQian.length;m++){
                myvalue.push(groupRolesByHuiQian[m].name)
            }
            group.value=myvalue.join(",");
            parent.document.getElementById("huiqianTemp").value=JSON.stringify(groupRolesByHuiQian);
        }

    }

    function contactArr(result_arr,arr) {
        for(var i=0;i<arr.length;i++){
            if(result_arr.indexOf(arr[i])==-1){
                result_arr.push(arr[i])
            }
        }
    }

    function getRolesInAssgine(data) {
        var value=[];
        if(data.length==0){
            return value;
        }else{
            for(var i=0;i<data.length;i++){
                value.push(data[i].username);
            }
            return value;
        }

    }

    function selRole(obj) {
        var huiqian=parent.document.getElementById("huiqian").value;
        var name=$("#role_name").val();
        $("#role1").empty();
        $("#role1").append("<input onchange='selAllHuiQianByRole(this)'  type='checkbox' />全选<br/>");
        for(var i=0;i<roleData.length;i++) {
            var aa=roleData[i].text;
           if(aa.indexOf(name)>-1){
               if(huiqian.indexOf(roleData[i].text)>-1){
                   $("#role1").append("<input onclick='addHuiQianByRole(this)' type='checkbox' value="+roleData[i].text+" checked  />" +
                       roleData[i].text+"&nbsp;&nbsp;&nbsp;");
               }else{
                   $("#role1").append("<input onclick='addHuiQianByRole(this)' type='checkbox' value="+roleData[i].text+"  />" +
                       roleData[i].text+"&nbsp;&nbsp;&nbsp;");
               }
           }
        }
    }

    function selRole1(obj) {
        var name=$("#role_name1").val();
        $("#role").empty();
        for(var i=0;i<roleData.length;i++) {
            var aa=roleData[i].text;
            if(aa.indexOf(name)>-1){
                console.log(state)
                //1  3  4
               if(state=='1' || state=='2' ||  state=='3' || state=='4'){
                   var temp="";
                   temp="<div onclick='getRole_user(this)' id="+roleData[i].id+" class=\"myli\" " +
                       "style='margin-left: 5px;display: inline-block'>"+roleData[i].text+"</div>";
                   $("#role").append("<li >"+temp+"</li>");
               }else if(state=='5'){
                   $("#role").append("<div style='position: relative;left: 10px;' name="+roleData[i].id+" id="+roleData[i].text+">" +
                   "<input  onclick='addQianZhanShiByRole(this)' " +
                   "type='checkbox' name="+roleData[i].id+" value="+roleData[i].text+" />" + roleData[i].text+"&nbsp;&nbsp;&nbsp;</div>");
               }else if( state=='6'){
                   $("#role").append("<div style='position: relative;left: 10px;' name="+roleData[i].id+" id="+roleData[i].text+"><input onclick='addHuiQianByRole(this)' " +
                       "type='checkbox' name="+roleData[i].id+" value="+roleData[i].text+" />" + roleData[i].text+"&nbsp;&nbsp;&nbsp;</div>");
               }


            }
        }
    }

    function selDep(obj) {
        var name=$("#selDepName").val();
        $("#department").empty();
        console.log(dep)
        for(var i=0;i<dep.data.length;i++) {
            var aa=dep.data[i].text;
            if(aa.indexOf(name)>-1){
                var temp="";
                if(!dep.data[i].isParent){
                    temp="<div onclick='getPosition(this)' id="+dep.data[i].id+" class=\"myli\" style='display: inline-block;margin-left: 15px;'>"+dep.data[i].text+"</div>";
                }else {
                    temp="<div name='add'  class='addClass'  ></div>"
                        +"<div onclick='getPosition(this)' id="+dep.data[i].id+" class=\"myli\" style='margin-left: 5px;display: inline-block'>"+dep.data[i].text+"</div>";
                }
                $("#department").append("<li class=\"clearfix\"> <div class=\"x-icon\"></div>"+temp+"</li>");
            }
        }

    }

    function  showRoleDiv() {
        $("#roleDiv").show();
        $("#depDiv").hide();
        $("#roleDiv1").hide();
        if(state==2){
            huiqianUser=[];  groups=[];
            parent.document.getElementById("huiqian").value="";
            $("#user").find("input[type='checkbox']").prop("checked",false);
            $("#role_user").find("input[type='checkbox']").prop("checked",false);
        }else if(state==3){
            huiqianUser=[];  groups=[];
            parent.document.getElementById("userField").value="";
            $("#user").find("input[type='checkbox']").prop("checked",false);
            $("#role_user").find("input[type='checkbox']").prop("checked",false);
        }
    }

</script>
</html>
