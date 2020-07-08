<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
    <link rel="stylesheet" href="${ctx}/static/css/proDeployInfo.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/myPagination.css"/>
    <link rel="stylesheet" href="${ctx}/static/css/ySelect.css"/>
    <style>

        .wrap{ width: 600px; margin: 20px auto;}
        .myspan{
            cursor: pointer;
        }
        .myspantitle{
            margin-left: 10px;
            cursor: pointer;
        }
        .myspantitle:hover{
            color: red;
        }
        .spannull{
            cursor: pointer;
            width: 9px;
            display: inline-block;
        }
    </style>
</head>
<body style="background-color:#fff ">
<button id="btn">跳转</button>
<div class="wrap">
    <ul id="root" style="line-height: 35px;margin-left: 0px;">
       <%--    <li>
               <span class="myspan">-</span><span class="myspantitle">111</span>
               <ul style="line-height: 35px;margin-left: 20px">
                   <li>
                       <span class="myspan">+</span><span class="myspantitle">222</span>
                       <ul style="line-height: 35px;margin-left: 20px">
                           <li>
                               <span class="myspan">+</span><span class="myspantitle">333</span>
                               <ul style="line-height: 35px;margin-left: 20px">
                                   <li>
                                       <span class="myspan">+</span><span class="myspantitle">444</span>
                                   </li>
                               </ul>
                           </li>
                       </ul>
                   </li>
                   <li><span class="myspan">+</span><span class="myspantitle">一级菜单子菜单2</span> </li>
                   <li><span class="spannull"></span><span class="myspantitle">一级菜单子文件</span> </li>
                   <li><span class="myspan">+</span><span class="myspantitle">一级菜单子菜单3</span> </li>
               </ul>
           </li>
        <li><span class="myspan">+</span><span class="myspantitle">一级菜单2</span></li>
        <li><span class="myspan">+</span><span class="myspantitle">一级菜单3</span></li>--%>
    </ul>
</div>
</body>
<script src="${ctx}/static/layui/layui.js"></script>
<script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>

<script>
    $(function () {
        $("#btn").click(function () {
            window.parent.FS.tabPane.addItem({title:"会签流程图",src:"${ctx}/processInfo/authority?depid="+"375101"+"&proname="+
            encodeURI("会签流程图")+"&processDefinitionID="+"process:4:37513"+"&userName="+"admin"+"&proNameParam="+encodeURI("")});
/*            window.location.href="http://localhost:8080/webroot/processInfo/" +
                "authority?depid=37510&proname=encodeURI(会签流程图)&processDefinitionID=process:4:37513&userName=admin";*/
        });
       /* getFiles("",$("#root"));
        $(document).on("click","${'.myspan'}",function(){
            if($(this).attr("name")=='add'){
                var path=$(this).next("span").attr("id");
                getFiles(path,$(this).next("span"),20,$(this));
            }else{
                $(this).next("span").next("ul").remove();
                $(this).attr("name","add");
                $(this).text("+");
            }
        });
        $(document).on("click","${'.myspantitle'}",function(){
            console.log($(this).attr("id"))
        });*/


    })

    function getFiles(path,objappend,marginLeft,currentobj) {
        $.post("/webroot/t",{path:path},function (data) {
            if(path==''){
                objappend.empty();
                for(var i=0;i<data.result.length;i++){
                    var className=data.result[i].type=='0' ? "spannull" : "myspan";
                    objappend.append("<li>" +
                        "<span class="+className+" name='add'>+</span>" +
                        "<span id="+data.result[i].path+" class=\"myspantitle\">"+data.result[i].name+"</span>" +
                        "</li>");
                }
            }
           else{
                objappend.after("<ul style=\"line-height: 35px;margin-left:"+marginLeft+"px\"></ul>");
                for(var i=0;i<data.result.length;i++){
                   if(data.result[i].type=='0'){
                       objappend.next("ul").append("<li>" +
                           "<span class='spannull'></span>" +
                           "<span id="+data.result[i].path+" class=\"myspantitle\">"+data.result[i].name+"</span>" +
                           "</li>");
                   }else{
                       objappend.next("ul").append("<li>" +
                           "<span class='myspan' name='add'>+</span>" +
                           "<span id="+data.result[i].path+" class=\"myspantitle\">"+data.result[i].name+"</span>" +
                           "</li>");
                   }
                }
                currentobj.attr("name","jian");
                currentobj.text("-");
            }
        })
    }
</script>
</html>
