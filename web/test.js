//cpt模板的seesionid
var seesionid="cpt模板的seesionid";
//上传文件（这里是流程页面中附件上传的文件），不用就设置为null
var fileObj = document.getElementById("file").files[0]; // js 获取文件对象
var form = new FormData();
form.append("commentinfo","审批意见");
form.append("proname","流程名称");
form.append("userName","用户名");
form.append("userRealName","用户真实姓名");
//是新建提交还是保存提交，这里设置成空就行了
form.append("state","");
//业务编号，流程是通过UUID生成的32位
form.append("requestid","业务编号");
//cpt模板路径，比如demo/analytics/financial/EVA经济附加值模型.cpt
form.append("reportName","cpt模板");
//流程定义id
form.append("processDefinitionID","流程定义id");
//任务编号，这里设置成空就行
form.append("taskid","");
//上面得到的cpt模板的seesionid
form.append("seesionid","cpt模板的seesionid");
//判断上传的文件是否为空，不为空添加到FormData中
if(typeof (fileObj)!="undefined"){
    form.append("file", fileObj);
}
//ajax请求
$.ajax({
    type: "POST",
    data:form,
    dataType: "json",
    processData:false,
    contentType: false,
    url: "/processInfo/guanlianproyuyewu",//接口地址
    success: function (data) {
        if(data.msg==='success'){
            //流程提交正常，然后cpt模板提交数据入库，我这里模板是嵌套在iframe中，不在iframe中，写法不同
            document.getElementById('reportFrame').contentWindow.contentPane.writeReport();
        }else if(data.msg==='001'){
            alert("分支条件都不成立，流程无法继续进行")
        }
        else{
            //流程提交出错
            window.location.href="${ctx}/static/jsp/message.jsp?message="+encodeURI("提交流程错误："+data.result);
        }
    },
    error: function (e, jqxhr, settings, exception) {
        alert('服务器响应失败!!!')
    }
});