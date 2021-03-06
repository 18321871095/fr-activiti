<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" scope="session" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
    <script src="${ctx}/static/js/jquery-2.1.1.min.js"></script>
    <script src="${ctx}/static/layui/layui.js"></script>
    <style>
        a{
            cursor: pointer;
            position: relative;
            top: -4px;
            left:0.5em;
            -webkit-transition: all .3s ease-in 0s;
                transition: all .3s ease-in 0s;
        }
      a:hover{
          color: #3296f5;
          -webkit-transition: all .3s ease-in 0s;
              transition: all .3s ease-in 0s;
      }
        .mydiv{
            background: url(${ctx}/static/images/shanchu.png);
            background-size: cover;
            display: inline-block;
            width: 16px;
            height: 16px;
            cursor: pointer;
            float:right;
        }
        #myul li{
        line-height:30px;
        }
    </style>
</head>
<body style="box-sizing:border-box;padding:15px;">
<div style="border: 1px solid #e2e2e2;width: 30%;float: left;height: 98%;padding:15px;box-sizing:border-box;">
    <ul id="myul" style="line-height: 30px;">

    </ul>
</div>
<div style="/*border: 1px solid #000;*/width: 68%;float: right;height: 98%">
    <div style="">
        部门或岗位
    </div>
    <div id="depAndpost" style="border: 1px solid #e2e2e2;height: 100px;margin: 10px 0;word-wrap:break-word;    padding: 10px;
                                                                                                                box-sizing: border-box;
overflow-y: auto">

    </div>
    <br/>
    <div style="">
        人员
    </div>
    <div id="user" style="border: 1px solid #e2e2e2;height: 100px;margin: 10px 0;word-wrap:break-word;    padding: 10px;
                                                                                                          box-sizing: border-box;overflow-y: auto;">

    </div>
    <div style="margin-top: 100px;">
        <button id="queding" style="margin-left: 435px;cursor: pointer;display: inline-block;height: 30px;
   line-height: 30px;background-color: #3296f5;color: #fff;white-space: nowrap;text-align: center;font-size:14px;
   border: none;border-radius: 2px;cursor: pointer;" class="layui-btn">确定</button>
    </div>
</div>



</body>
<script>
    $(function () {
        var procdefid="${param.procdefid}";
        layui.use('layer', function() {
           var layer=layui.layer;

            $.post("${ctx}/processInfo/getReserveAuthority",{},function (data) {
                if(data.msg=='success'){
                    for(var i=0;i<data.result.length;i++){
                        $("#myul").append("<li><input name='showDeatailsAuthority' style='width: 18px;height: 18px' type='radio'/>" +
                            "<a>"+data.result[i].name+
                            "<input type='hidden' value="+"\""+data.result[i].groupid+"\""+" />"+
                            "<input type='hidden' value="+"\""+data.result[i].userid+"\""+" />"+
                            "<input type='hidden' value="+"\""+data.result[i].procdefid+"\""+" />"+
                            "</a>&nbsp;&nbsp;<div name='shanchubaocunquanxian' class='mydiv'></div></li>");
                    }i
                }else{
                    window.location.href="${ctx}/static/jsp/error.jsp?message="+encodeURI(data.result);
                }
            });


            $(document).on("click","${'[name=\'showDeatailsAuthority\']'}",function(){
                $("#depAndpost").text($(this).parents("li").find("input[type='hidden']").eq(0).val());
                $("#user").text($(this).parents("li").find("input[type='hidden']").eq(1).val());
            });

            $("#queding").click(function () {
                var count=0;var result={};
                $("#myul").find("input[type='radio']").each(function () {
                    if($(this).is(":checked")){
                        // procdefid=$(this).parents("li").find("input[type='hidden']").eq(2).val();
                        result["dep"]=$(this).parents("li").find("input[type='hidden']").eq(0).val();
                        result["people"]=$(this).parents("li").find("input[type='hidden']").eq(1).val();
                    }else {
                        count++;
                    }
                });
                if(count==$("#myul").find("input[type='radio']").length){
                    layer.alert('请选择一个权限导入',{offset:'200px'})
                }else {
                    var index=layer.load(2);
                    $.post("${ctx}/processInfo/daoruAuthority",{
                        prodefinedid:"${param.procdefid}",arr:JSON.stringify(result)
                    },function (data) {
                        layer.close(index);
                        if(data.msg='success'){
                            parent.deploylayer.close(parent.daoruquanxianIndex);
                            parent.deploylayer.msg('导入成功',{offset:'200px'});
                        }else{
                            window.location.href="${ctx}/static/jsp/error.jsp?message="+encodeURI(data.result);
                        }
                    });
                }


            });


            $(document).on("click","${'[name=\'shanchubaocunquanxian\']'}",function(){
                var mythis=$(this);
                layer.confirm('是否删除该保存的流程权限?', {icon: 3, title:'提示'}, function(index){
                    var index1=layer.load(2);
                    $.post("${ctx}/processInfo/shanchubaocunquanxian",{procdefid:
                        mythis.parents("li").find("input[type='hidden']").eq(2).val()},function (data) {
                        layer.close(index1);
                        if(data.result=='1'){
                            layer.msg("删除成功");
                            mythis.parents("li").remove();
                            layer.close(index);
                        }else{
                            layer.msg('删除失败')
                        }
                        layer.close(index);
                    });

                });
            });

        });




    })
</script>
</html>
