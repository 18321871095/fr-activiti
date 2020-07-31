<%@ page import="org.activiti.engine.RepositoryService" %>
<%@ page import="com.fr.tw.util.SpringContextUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
<head>
    <style>
         html,body{
                     font-family: "Microsoft YaHei";
                     }
                      .myli{
                          cursor: pointer;
                          font-size:14px;
                          color:#333;
                          -webkit-transition: all .3s ease-in 0s;
                              transition: all .3s ease-in 0s;
                      }
                      .myli:hover{
                          color: #3296f5;
                          -webkit-transition: all .3s ease-in 0s;
                              transition: all .3s ease-in 0s;
                      }
                .people_span{
                    cursor: pointer;
                    height: 30px;
                        line-height: 30px;
                        padding-left: 10px;
                        padding-right: 10px;
                        text-align: center;
                        white-space: nowrap;
                        overflow: hidden;
                        position: relative;
                        float: left;
                        margin-top: 8px;
                        margin-right: 10px;
                        margin-bottom: 8px;
                    background-color: rgba(54,133,242,.1);
                   -webkit-transition: all .3s ease-in 0s;
                       transition: all .3s ease-in 0s;
                }
                .people_span:hover{
               -webkit-transition: all .3s ease-in 0s;
                   transition: all .3s ease-in 0s;
                    background-color: #3685f2;
                       border-radius: 2px;
                        color: #fff;
                    height: 30px;
                        line-height: 30px;
                        padding-left: 10px;
                        padding-right: 10px;
                        text-align: center;
                        white-space: nowrap;
                        overflow: hidden;
                        position: relative;
                        float: left;
                        margin-top: 8px;
                        margin-right: 10px;
                        margin-bottom: 8px;

                }
 .layui-form-item .layui-inline {
                    margin-bottom: 0;
                    margin-right: 10px;
                }
                .layui-form-item{ margin-bottom:5px;}
        .layui-input, .layui-select, .layui-textarea {
            height: 30px;
            line-height: 1.3;
            line-height: 38px \9;
            border-width: 1px;
            border-style: solid;
            background-color: #fff;
            border-radius: 2px;
        }
        .layui-btn {
            display: inline-block;
            height: 30px;
            line-height: 30px;
            padding: 0 18px;
            background-color: #3296f5;
            color: #fff;
            white-space: nowrap;
            text-align: center;
            font-size: 14px;
            border: none;
            border-radius: 2px;
            cursor: pointer;
        }

    </style>

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
<body style="padding: 0 20px;margin:0px;box-sizing:border-box;">
<div style="width: 45%;height: 50%;float: left;border: 1px solid #e6e6e6;box-sizing:border-box;">


 <div class="layui-form-item" style="margin-top:5px;">
          <div class="layui-inline">
            <label class="layui-form-label" style="width:auto;padding:0 15px;line-height:30px;">角色：</label>
            <div class="layui-input-inline" style=" width: 170px;">
              <input id="RoleName" type="text" placeholder="模糊查询角色名称" class="layui-input">
            </div>
              <div class="layui-input-inline" style=" width: 60px;">
                <button class="layui-btn" lay-submit="" lay-filter="demo1" onclick="selRole11()">搜索</button>
              </div>
              </div>
            </div>


    <%--<span style="font-size: 15px">角色：</span>
    <input id="RoleName" type="text" placeholder="模糊查询角色名称" /><button onclick="selRole11()">搜索</button>--%>
    <hr style="margin: 5px 0px">
    <div style="width: 100%;height: 83%;overflow-y:auto;">
        <ul id="Role" style="line-height: 37px;padding: 0px 10px;font-size: 18px">
        </ul>
    </div>




</div>


<div style="width: 55%;height: 50%;float: left;border: 1px solid #e6e6e6;box-sizing:border-box;">

<div class="layui-form-item" style="margin-top:5px;">
              <div class="layui-inline">
                <span class="layui-form-label" style="width:auto;padding:0 15px;line-height:30px;">人员：</span>
                  </div>
                </div>

    <%--<span style="font-size: 15px">人员：</span>--%>
    <hr style="margin: 5px 0px">
    <div style="width: 100%;height: 83%;overflow-y:auto;">
        <ul id="user" style="line-height: 37px;padding: 0px 10px;font-size: 14px">
        </ul>
    </div>
</div>
<%--===================================================================================================--%>
<%--
<div style="float: left;width: 86%" >
    <span>所选角色</span>
    <div id="depOrPos" style="border: 1px solid #e6e6e6;width: 100%;height: 150px;margin-left: 110px;
    word-wrap:break-word;overflow-y: auto"></div>
</div>
--%>

<div style="float: left;width: 100%">
<div class="layui-row" style="margin-top:15px;">
        <div class="layui-col-xs2">
          <div class="">所选人员</div>
        </div>
        <div class="layui-col-xs10">
          <div id="people" style="border: 1px solid #e6e6e6;width: 100%;height: 150px;padding:0 5px;box-sizing:border-box;word-wrap:break-word;
         overflow-y: auto;">

             </div>
        </div>
      </div>
</div>
<%--<div style="float: left;width: 86%">
    <span>所选人员</span>
    <div id="people" style="border: 1px solid #e6e6e6;width: 100%;height: 150px;margin-left: 110px;word-wrap:break-word;
overflow-y: auto;">

    </div>

</div>--%>




<div style="float: right;margin-top: 35px;margin-right: 50px;">
    <button class="layui-btn" id="reserve1" style="margin-top: 30px">保存</button>
    <br/> <br/>
</div>


<script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>
<script src="${ctx}/static/layui/layui.js"></script>
</body>
<script>
    var arr=[];var peolpearr=[];var dep="";var layer;var currentobj;
    var tempdep;var RoleNameAll;
    $(function () {

       layui.use(['form','layer'], function() {
                var form = layui.form,
                   layer=layui.layer;

               });

        //获取角色
        $.ajax({
            type:"get",
            url:"${ctx}/decision/v10/roles?page=1&count=100000",
            dataType:'json',
            headers:{"Authorization":"Bearer "+"<%=Authorization %>"},
            success:function (data) {
                var mydata=data.data.items;
                RoleNameAll=mydata;
                $("#Role").empty();
                for(var i=0;i<mydata.length;i++) {
                    var temp="";
                    temp="<div onclick='getRoleUser(this)' id="+mydata[i].id+" class=\"myli\" " +
                        "style='margin-left: 5px;display: inline-block'>"+mydata[i].text+"</div>";
                    $("#Role").append("<li >"+temp+"</li>");
                }
            },
            error:function (xhr,text) {
                alert(text);
            }
        });

        //获取权限
        $.ajax({
            type:"POST",
            url:"${ctx}/processInfo/getProAuthoritys",
            data:{prodefinedid:"${param.prodefinedid}"},
            success:function (data) {
                if(data.msg=='success'){
                    /* $("#depOrPos").text(data.result.dep);
                     $("#people").text(data.result.people);*/
                    if(data.result.dep!=''){
                        var d=data.result.dep.split(",");
                        for(var i=0;i<d.length;i++){
                            arr.push(d[i]);
                            $("#depOrPos").append("<span name='deleteDepAndPost' class=\"people_span\">"+d[i]+"</span>");
                        }
                    }
                    if(data.result.people!=''){
                        var p=data.result.people.split(",");
                        for(var i=0;i<p.length;i++){
                            peolpearr.push(p[i]);
                            $("#people").append("<span name='deletePeople' class=\"people_span\">"+p[i]+"</span>");
                        }
                    }
                }else {
                    window.location.href="${ctx}/static/jsp/error.jsp?message="+encodeURI("获取权限错误："+data.result);
                }
            },
            error:function (xhr,text) {
                alert('服务器响应失败!!!')
            }
        });

        //删除角色人员
        $(document).on("click","${'[name=\'deletePeople\']'}",function(){
            var val=$(this).text();
            //console.log("befor:"+JSON.stringify(peolpearr));
            for(var i=0;i<peolpearr.length;i++){
                if(val===peolpearr[i]){
                    peolpearr.splice(peolpearr.indexOf(val),1);
                }
            }
            $(this).remove();
        });

        $("#reserve1").click(function () {
            var peoples=$("#people").text();
            if(peoples==''){
                layer.msg("没有选择人",{offset:'300px'});
            }else {
                var index_set = layer.load(2,{offset:'300px'});
                var result={};
                result["dep"]="";
                result["people"]=getpeopleValue1();
                //console.log("人员："+getpeopleValue()+",岗位："+getDepAndPost())
                //设置权限
                $.ajax({
                    type:"POST",
                    url:"${ctx}/processInfo/setProAuthoritys",
                    data:{prodefinedid:"${param.prodefinedid}",arr:JSON.stringify(result)},
                    success:function (data) {
                        layer.close(index_set);
                        if(data.result=='success'){
                            parent.deploylayer.close(parent.index_a)
                           // parent.deploylayer.msg("权限设置成功",{offset:'300px'});
                            parent.deploylayer.alert("权限设置成功,如果权限发生了更改，请再一次保存权限与最新设置的权限保持一致",{offset:'200px'});
                        }else {
                            layer.alert("设置权限错误："+data.msg,{offset:'200px'});
                           // window.location.href="${ctx}/static/jsp/error.jsp?message="+encodeURI("设置权限错误："+data.msg);
                        }
                    },
                    error:function (xhr,text) {
                        layer.close(index_set);
                        alert('服务器响应失败!!!')
                    }
                });
            }
        });

    });


    function getRoleUser(obj) {
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
                $("#user").empty().append("<input type='checkbox' onchange='selAll(this)' />全选");
                for(var i=0;i<mydata.length;i++) {

                    $("#user").append("<li  class=\"myli\">"
                        +"<div  onclick='addValuePeople(this)' style='width:20px;height:20px;display: inline-block;position:relative;top:-1px;cursor: pointer'>"+
                        "<img src='${ctx}/static/images/addpic.png' width='100%' height='100%' /></div>&nbsp;&nbsp;&nbsp;"
                        +"<span>"+mydata[i].username+"</span>"+
                        "<span>"+mydata[i].realName+"</span></li>");

                }

            },
            error:function (xhr,text) {
                alert(text);
            }
        });
    }

    function addValuePeople(obj) {
        var mythis=$(obj);
        var val=mythis.parent("li").find("span").eq(0).text()+"("+mythis.parent("li").find("span").eq(1).text()+")";
        var flag=false;
        for(var i=0;i<peolpearr.length;i++){
            if(peolpearr[i]==val){
                flag=true;
                break;
            }
        }
        if(!flag){
            peolpearr.push(val);
            $("#people").append("<span name='deletePeople' class=\"people_span\">"+val+"</span>");
        }else{
            layer.msg("已经添加了",{offset:'300px'});
        }
    }

    function selAll(obj) {
        var mythis=$(obj);
     if(mythis.is(":checked")){
         mythis.parent("ul").find("li").each(function () {
                 var val=$(this).find("span").eq(0).text()+"("+$(this).find("span").eq(1).text()+")";
                 var flag=false;
                 for(var i=0;i<peolpearr.length;i++){
                     if(peolpearr[i]==val){
                         flag=true;
                         break;
                     }
                 }
                 if(!flag){
                     peolpearr.push(val);
                     $("#people").append("<span name='deletePeople' class=\"people_span\">"+val+"</span>");
                 }else{
                 }
         });
     }else{
         //console.log("1:"+JSON.stringify(peolpearr))
         var val1="";
         mythis.parent("ul").find("li").each(function () {
             val1=$(this).find("span").eq(0).text()+"("+$(this).find("span").eq(1).text()+")";
             for(var i=0;i<peolpearr.length;i++){
                 if(peolpearr[i]==val1){
                    peolpearr.splice(i,1);
                 }
             }
         });
        // console.log("2:"+JSON.stringify(peolpearr))
         $("#people").empty();
         for(var i=0;i<peolpearr.length;i++){
             $("#people").append("<span name='deletePeople' class=\"people_span\">"+peolpearr[i]+"</span>");
         }
     }
    }

    function selRole11() {
        var name=$("#RoleName").val();
        $("#Role").empty();
        for(var i=0;i<RoleNameAll.length;i++) {
           if((RoleNameAll[i].text).indexOf(name)>-1){
               var temp="";
               temp="<div onclick='getRoleUser(this)' id="+RoleNameAll[i].id+" class=\"myli\" " +
                   "style='margin-left: 5px;display: inline-block'>"+RoleNameAll[i].text+"</div>";
               $("#Role").append("<li >"+temp+"</li>");
           }
        }
    }

    function getpeopleValue1() {
        var value="";
        $("#people").find("span").each(function () {
            value+=$(this).text()+",";
        });
        return value.substring(0,value.length-1);
    }

</script>
</html>
