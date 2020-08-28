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
    <link rel="stylesheet" href="${ctx}/static/css/startProcess.css?v=1">
    <style>
        input{ border: none; outline: none; box-shadow: none;}
        .clearfix::after{
            height: 0;
            display: block;
            visibility: hidden;
            clear:both;
            content: '';
        }
        .searchWrap{
            width: 25%;
            margin: 10px 25px;
        }
        .searchInput{ width: 80%; float: left;}
        .searchInput input{  width: 100%; line-height: 32px; font-size: 14px; color: #666; box-sizing: border-box;
            border-radius: 5px 0 0 5px; border: 1px solid #3296f5; padding: 0 15px;}
        .searchSub{ width: 20%; float: left;}
        .searchSub input{  width: 100%; line-height: 35px; font-size: 14px; color: #fff; box-sizing: border-box;
            border-radius: 0 5px 5px 0; background: #3296f5; text-align: center;}
    </style>
</head>
<body style="background: #F5F7FE;">
<div class="searchWrap clearfix">
    <div class="searchInput">
        <input id="proName" type="text" placeholder="请输入">
    </div>
    <div class="searchSub">
        <input id="searchPro" type="button" value="搜索" style="cursor: pointer;">
    </div>
</div>
      <div id="content">

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
<script>
    $(document).ready(function () {
        var proData=[];
        var userName=parent.Dec.personal.username;
        var userRealName=parent.Dec.personal.displayName.split("(")[0];
        layui.use('layer', function(){
             layer = layui.layer;
            /*得到流程部署信息*/
            var index=layer.load(2,{offset:['200px','50%']});
            $.ajax({
                 type: "POST",
                 dataType: "json",
                data:{userName:userName},
                 url: "${ctx}/processInfo/selectProList",
                success: function (data) {
                    layer.close(index);
                    if(data.msg==='success'){
                        proData=data.result;
                        console.log(proData)
                        $("#content").empty();
                        if(data.result.length>0){
                            for(var i=0;i<data.result.length;i++){
                                $("#content").append("<div class='listing'> <h4 class=\"listing-title\">"+data.result[i].proclassify+"</h4>" +
                                    " <ul id="+i+" class=\"listing-con\"> </ul> </div>");
                                for(var j=0;j<data.result[i].proLists.length;j++){
                                    $("#"+i).append(
                                        "<li name='123'><a href=\"#\" name='tiaozhuan' >"+data.result[i].proLists[j].deName.replace("_","")+
                                        "<input  type='hidden' value="+data.result[i].proLists[j].depid+" >"+
                                        "<input  type='hidden' value="+data.result[i].proLists[j].deName+" >"+
                                        "<input  type='hidden' value="+data.result[i].proLists[j].processDefinitionID+" >" +
                                        "<input  type='hidden' value="+data.result[i].proLists[j].deNameParam+" >" +
                                        "</a><span name='setLevel' class='layui-icon layui-icon-set-fill'></span></li>");
                                }
                            }
                        }else{
                            $("#content").append("<div style='width:200px;height:200px;margin: 200 auto;'>" +
                                "<img src='${ctx}/static/images/noProList.png' width='100%' height='100%'></div>")
                        }
                    }else{
                        window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("获取流程列表错误："+data.result);
                    }

                },
                error: function (e, jqxhr, settings, exception) {
                    layer.close(index);
                    alert('服务器响应失败!!!')
                }
            });
            /*跳转*/
            $(document).on("click","${'[name=\'tiaozhuan\']'}",function(){
                var depid=$(this).parent("li").find("input[type='hidden']").eq(0).val();
                var name=$(this).parent("li").find( "input[type='hidden']").eq(1).val();
                var processDefinitionID=$(this).parent("li").find("input[type='hidden']").eq(2).val();
                var proNameParam=$(this).parent("li").find( "input[type='hidden']").eq(3).val();
                window.parent.FS.tabPane.addItem({title:name,src:"${ctx}/processInfo/authority?depid="+depid+"&proname="+
                encodeURI(name)+"&processDefinitionID="+processDefinitionID+"&userName="+userName+"&proNameParam="+encodeURI(proNameParam)});
            });

            $(document).on("click","${'[name=\'setLevel\']'}",function(){
                var deployid=$(this).parent("li").find("input[type='hidden']").eq(0).val();
                $.post("${ctx}/processInfo/getLevel",{deployid:deployid},function (data) {
                    if(data.msg=='success'){
                        var mydata=data.result;
                        layer.open({
                            title:'设置排序序号',
                            type: 1,
                            area:["350px","200px"],
                            offset:"100px",
                            content: '<div style="text-align: center;margin-top: 20px;">' +
                            '<div style="margin-bottom: 10px;">说明：请输入大于0的整数(整值越小级别越高,可以为空)</div>'+
                            '<input id="levelname" style="height: 30px; border: 1px solid #6666;" placeholder="请填写大于0的整数" oninput="this.value=this.value.replace(/\\D|^0/g,\'\')" /></div>'+
                            '<div style="text-align: center;margin-top: 15px;"><button class="layui-btn" id='+deployid+'  name="quedinglevel">确定</button></div>'
                            , success: function(layero, index){
                                $("#levelname").val(mydata);
                            }
                        });
                    }
                    else if(data.msg=='001'){
                        layer.alert("部署信息为空",{offset:'200px'});
                    }

                    else{
                        window.location.href="${ctx}/static/jsp/error.jsp?message="+encodeURI(data.result);
                    }
                });
            });



            $(document).on("click","${'[name=\'quedinglevel\']'}",function(){
                var mythis=$(this);
                var quedinglevelindex=layer.load(1,{offset:'200px'});
                $.post("${ctx}/processInfo/setLevel",{
                    deployid:mythis.attr("id"),level:$("#levelname").val()
                },function (data) {
                    layer.close(quedinglevelindex);
                    if(data.msg=='success'){
                        layer.closeAll();
                        layer.alert("设置成功,刷新当前页面可生效",{offset:'200px'});
                    }else if(data.msg=='001'){
                        layer.msg("设置失败",{offset:'200px'});
                    }
                    else if(data.msg=='002'){
                        layer.alert("请输入正确的正整数",{offset:'200px'});
                    }
                    else {
                        window.location.href="${ctx}/static/jsp/error.jsp?message="+encodeURI(data.result);
                    }
                });

            });



            $("#searchPro").click(function () {
                var name=$("#proName").val();
                var result=[];
                for(var i=0;i<proData.length;i++){
                    var flag=false;
                    var temp=[];
                    var temp_classify={};
                    for(var j=0;j<proData[i].proLists.length;j++){
                        var deName=proData[i].proLists[j].deName;
                        if(deName.indexOf(name)>-1){
                            flag=true;
                            temp.push(proData[i].proLists[j]);
                        }
                    }
                    if(flag){
                        temp_classify["proclassify"]=proData[i].proclassify;
                        temp_classify["proLists"]=temp;
                        result.push(temp_classify);
                    }
                }
                $("#content").empty();
                if(result.length>0){
                    for(var i1=0;i1<result.length;i1++){
                        $("#content").append("<div class='listing'> <h4 class=\"listing-title\">"+result[i1].proclassify+"</h4>" +
                            " <ul id="+i1+" class=\"listing-con\"> </ul> </div>");
                        for(var j1=0;j1<result[i1].proLists.length;j1++){
                            $("#"+i1).append(
                                "<li name='123'><a href=\"#\" name='tiaozhuan' >"+result[i1].proLists[j1].deName.replace("_","")+
                                "<input  type='hidden' value="+result[i1].proLists[j1].depid+" >"+
                                "<input  type='hidden' value="+result[i1].proLists[j1].deName+" >"+
                                "<input  type='hidden' value="+result[i1].proLists[j1].processDefinitionID+" >" +
                                "<input  type='hidden' value="+result[i1].proLists[j1].deNameParam+" >" +
                                "</a></li>");
                        }
                    }
                }else{
                    $("#content").append("<div style='width:200px;height:200px;margin: 200 auto;'>" +
                        "<img src='${ctx}/static/images/noProList.png' width='100%' height='100%'></div>")
                }
            });

        });

    });

</script>
</html>
