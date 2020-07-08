package com.fr.tw.process;


import com.fr.decision.authority.data.User;
import com.fr.decision.webservice.v10.login.LoginService;
import com.fr.decision.webservice.v10.user.UserService;
import com.fr.tw.util.*;
import org.activiti.bpmn.model.UserTask;
import org.activiti.engine.*;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.history.HistoricVariableInstance;
import org.activiti.engine.impl.identity.Authentication;
import org.activiti.engine.impl.persistence.entity.TaskEntity;
import org.activiti.engine.impl.persistence.entity.VariableInstance;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.Model;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import sun.rmi.runtime.Log;

import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Mr.huang on 2019/9/29.
 */
@Controller
@RequestMapping("/mobile")
public class MobileController {
    @Autowired
    private RepositoryService repositoryService;
    @Autowired
    private TaskService taskService;
    @Autowired
    private RuntimeService runtimeService;
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private HistoryService historyService;
    @Autowired
    private ManagementService managerService;

    /**
     * 移动端新建流程列表
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/selectProList")
    @ResponseBody
    public JSONResult selectProList(HttpServletRequest request) throws Exception {
        String currentUserNameFromRequestCookie = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
        JSONResult jr=new JSONResult();
        try {
            List<Map<String,Object>> dataList=new ArrayList<Map<String, Object>>();
            Set<String> set=new HashSet<>();
            List<Map<String,Object>> dataList1=new ArrayList<Map<String, Object>>();
            List<String> deps = ProcessUtils.getDepsAndPostByUserName(currentUserNameFromRequestCookie);
            List<Deployment> delist=repositoryService.createDeploymentQuery().list();
            for (Deployment deployment:delist) {
                ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().deploymentId(deployment.getId()).singleResult();
                Model model = repositoryService.createModelQuery().deploymentId(deployment.getId()).singleResult();
                List<IdentityLink> identityLinks= repositoryService.getIdentityLinksForProcessDefinition(processDefinition.getId());
                if(ProcessUtils.getAuthority(identityLinks,currentUserNameFromRequestCookie,deps) || ProcessUtils.isAdmin(currentUserNameFromRequestCookie) || deployment.getTenantId().equals(currentUserNameFromRequestCookie)){
                    if(processDefinition.getDescription()==null && model!=null){
                        Map<String,Object> maps=new HashMap<String,Object>();
                        maps.put("depid",deployment.getId());
                        maps.put("deName",ProcessUtils.getProName(deployment.getName()));
                        maps.put("deNameParam",ProcessUtils.getProNameParam(deployment.getName()));
                        maps.put("processDefinitionID",processDefinition.getId());
                        List<Map<String, Object>> list1 = jdbcTemplate.queryForList("" +
                                "SELECT * FROM CLASSIFY WHERE ID=?", new Object[]{deployment.getCategory()});
                        String classfifyName="";
                        if(list1.size()!=0){
                            classfifyName=list1.get(0).get("classifyname").toString();
                        }
                        maps.put("proclassify",classfifyName);
                        maps.put("version",processDefinition.getVersion());
                        dataList.add(maps);
                    }
                }
            }
            for (Map<String, Object> map:dataList) {
                set.add(map.get("proclassify").toString());
            }
            List<List<Map<String,Object>>> proclassifys = MapValueOfClassify.getListArrayByMapValueOfClassify(dataList, "proclassify", set);
            for (List<Map<String,Object>> objectList:proclassifys) {
                Map<String,Object> m=new HashMap<>();
                m.put("proclassify",objectList.get(0).get("proclassify").toString());
                m.put("proLists",objectList);
                dataList1.add(m);
            }

            jr.setMsg("success");
            jr.setResult(dataList1);
        } catch (Exception e) {
            jr.setMsg("fail");
            jr.setResult(e.getMessage());
        }
        return jr;
    }

    /**
     * 点击申请流程时候判断
     * @param processDefinitionID
     * @param depid
     * @param proname
     * @param proNameParam
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/authority")
    public String authority(String processDefinitionID,String depid,String proname,String proNameParam,HttpServletRequest request) throws Exception {
         String currentUserNameFromRequestCookie = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
        try {
            List<IdentityLink> identityLinks = repositoryService.getIdentityLinksForProcessDefinition(processDefinitionID);
            ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionId(processDefinitionID).singleResult();
            if (identityLinks.size() > 0) {
                if (ProcessUtils.isAdmin(currentUserNameFromRequestCookie) || currentUserNameFromRequestCookie.equals(processDefinition.getTenantId())) {
                    //判断流程是否解除发布了
                    if (ProcessUtils.isFaBu(depid, repositoryService)) {
                        request.setAttribute("depid", depid);
                        request.setAttribute("proname", proname);
                        request.setAttribute("processDefinitionID", processDefinitionID);
                        request.setAttribute("proNameParam", proNameParam);
                        return "/static/jsp/mobile/applicationMobile.jsp";
                    } else {
                        return "/static/jsp/message.jsp?message="+
                                URLEncoder.encode("该流程处于解除发布状态，无法新建", "utf-8");
                    }

                } else {
                    List<String> deps = ProcessUtils.getDepsAndPostByUserName(currentUserNameFromRequestCookie);
                    if (ProcessUtils.getAuthority(identityLinks, currentUserNameFromRequestCookie, deps) || currentUserNameFromRequestCookie.equals(processDefinition.getTenantId())) {
                        if (ProcessUtils.isFaBu(depid, repositoryService)) {
                            request.setAttribute("depid", depid);
                            request.setAttribute("proname", proname);
                            request.setAttribute("processDefinitionID", processDefinitionID);
                            request.setAttribute("proNameParam", proNameParam);
                            return "/static/jsp/mobile/applicationMobile.jsp";
                        } else {
                            return "/static/jsp/message.jsp?message="+
                                    URLEncoder.encode("该流程处于解除发布状态，无法新建", "utf-8");
                        }

                    } else {
                        return "/static/jsp/message.jsp?message=" +  URLEncoder.encode("您没有权限启动该流程", "utf-8");

                    }

                }

            } else {
                if (ProcessUtils.isAdmin(currentUserNameFromRequestCookie) || currentUserNameFromRequestCookie.equals(processDefinition.getTenantId())) {
                    if (ProcessUtils.isFaBu(depid, repositoryService)) {
                        request.setAttribute("depid", depid);
                        request.setAttribute("proname", proname);
                        request.setAttribute("processDefinitionID", processDefinitionID);
                        request.setAttribute("proNameParam", proNameParam);
                        return "/static/jsp/mobile/applicationMobile.jsp";
                    } else {
                        return "/static/jsp/message.jsp?message="+
                                URLEncoder.encode("该流程处于解除发布状态，无法新建", "utf-8");
                    }

                } else {
                    return "/static/jsp/message.jsp?message=" +  URLEncoder.encode("您没有权限启动该流程", "utf-8");
                }

            }
        }catch (Exception e){
            if(e instanceof ActivitiObjectNotFoundException){
                return "/static/jsp/message.jsp?message=" + URLEncoder.encode("该流程已更新请刷新新建页面", "utf-8");
            }else{
                return "/static/jsp/message.jsp?message=" +  URLEncoder.encode(e.getMessage(), "utf-8");
            }
        }

    }

    /**
     *获取初始化流程formkey
     */
    @RequestMapping("/applicationForm")
    @ResponseBody
    public JSONResult applicationForm(String processDefinitionID) throws Exception {
        Map<String,String> map=new HashMap<String, String>();
        JSONResult jr=new JSONResult();
        try{
            //这个id是用来存模板上业务数据用的唯一标识id
            String id =ProcessUtils.getUUID();
            Map<String, String> mapFormKeyAndName = ProcessUtils.getApplicationFormKeyAndName(processDefinitionID, repositoryService);
            //session.setAttribute("reportName",reportName);//process:3:7530
            map.put("reportName",mapFormKeyAndName.get("formkey").toString());
            map.put("requestid",id);
            map.put("taskName",mapFormKeyAndName.get("name").toString());
            map.put("iswritecomment",mapFormKeyAndName.get("iswritecomment").toString());
            map.put("tijiaoName",mapFormKeyAndName.get("tijiaoName").toString());
            jr.setMsg("success");
            jr.setResult(map);
        }
        catch (Exception e){
            jr.setResult(e.getMessage());
            jr.setMsg("fail");
        }
        return jr;
    }


    /**
     *关联业务与流程时，启动流程
     */
    @RequestMapping("/guanlianproyuyewu")
    @ResponseBody
    @Transactional
    public JSONResult guanlianproyuyewu(@RequestParam(value="file",required=false)
                                                MultipartFile file, String state, HttpServletRequest request){

        String processDefinitionID=request.getParameter("processDefinitionID");
        String commentinfo=request.getParameter("commentinfo");
        String proname=request.getParameter("proname");
        String requestid= request.getParameter("requestid");
        String reportName= request.getParameter("reportName");
        String taskid= request.getParameter("taskid");
        String seesionid= request.getParameter("seesionid");
        String attachmentid="";
        String startTime="";
        String type="";
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> map=new HashMap<>();
        Map<String, Object> resultMap=new HashMap<>();
        JSONResult jr=new JSONResult();
        try {
            ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionId(processDefinitionID).singleResult();
            String username= LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            String userRealName=UserService.getInstance().getUserByUserName(username).getRealName();
            //初始化会签节点操作者信息
            map = ProcessUtils.initHuiQian(processDefinitionID,repositoryService);
            //添加流程判断条件
            ProcessUtils.getCondition(processDefinitionID,taskid,repositoryService,taskService,seesionid,request,map,resultMap,username);
            //0：申请人提交可撤回状态  1：通过 2：查看 3：被退回（不包括申请节点） 4：撤回 5：转办 6:完成 7：删除 8：被退回到申请节点
            map.put("process_state","0");
            //添加模板,这个一定要放在变量中
            map.put("process_formKey",reportName);
            //添加流程发起人
            map.put("process_userRealName",userRealName);
            //启动流程
            Authentication.setAuthenticatedUserId(username);
            ProcessInstance processInstance = runtimeService.startProcessInstanceById(processDefinition.getId(),requestid,map);
            startTime=sdf.format(new Date());
            runtimeService.setProcessInstanceName(processInstance.getId(),proname);
            //启动后默认通过第一个任务节点（申请节点）
            Task task = taskService.createTaskQuery().processInstanceId(processInstance.getId()).singleResult();
            TaskEntity taskEntity = (TaskEntity) task;
            String temp_taskid=task.getId();
            String temp_applicationNodeName=task.getName();
            ActivityImpl activityImpl = ProcessUtils.getActivityImplByActivitiId(task.getTaskDefinitionKey(), task.getProcessDefinitionId(), repositoryService);
            type=activityImpl.getProperty("multiInstance")==null ? "" : activityImpl.getProperty("multiInstance").toString();
            taskService.complete(task.getId());
            //上传附件
            if(file!=null){
                attachmentid=ProcessUtils.uploadAttachment(request,file);
            }
            if("1".equals(state)){//
                if("".equals(attachmentid)){
                    attachmentid=jdbcTemplate.queryForObject("SELECT ATTACHMENT FROM PROOPREATEINFO WHERE REQUESTID=?",new Object[]{requestid},String.class);
                }
                jdbcTemplate.update("DELETE FROM PROOPREATEINFO WHERE REQUESTID=?",new Object[]{requestid});
            }
            //保存操作信息
            jdbcTemplate.update("INSERT INTO PROOPREATEINFO(ID,PROINSTANCEID,TASKID,OPREATENAME,OPREATEREALNAME,OPREATETIME,OPREATETYPE,NODENAME,MYCOMMENT,ATTACHMENT,REPORTNAME,PRONAME) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
                    new Object[]{ProcessUtils.getUUID(),processInstance.getId(),temp_taskid,username,userRealName,new Date(),1,temp_applicationNodeName, PreventXSS.delHTMLTag(commentinfo),attachmentid,taskEntity.getFormKey(),proname});

            ProcessInstance pro = runtimeService.createProcessInstanceQuery().processInstanceId(processInstance.getId()).singleResult();
            if(pro!=null){
                //自动流传与第二次默认通过
                Object proDueTime = runtimeService.getVariable(pro.getId(), "proDueTime");
                if(!"parallel".equals(type) && !"sequential".equals(type)){
                    ProcessUtils.autopass(taskService,processInstance.getId(),repositoryService,
                            runtimeService,jdbcTemplate,username,historyService);
                }
                //发送消息
                Map<String,String> para=new HashMap<>();
                para.put("startPeople",userRealName);
                para.put("startTime",startTime);

                para.put("proDueTime",proDueTime==null?"":proDueTime.toString());
                para.put("shenheTime",startTime);
                sendMessage.getSendMessageUser(taskService,processInstance.getId(),jdbcTemplate,proname,para,"1",null);
            }else{
                jdbcTemplate.update("UPDATE ACT_HI_VARINST SET TEXT_='6' WHERE PROC_INST_ID_=? AND NAME_='process_state'",
                        new Object[]{processInstance.getId()});
            }
            jr.setMsg("success");
            jr.setResult(resultMap);
        }catch (Exception e){
            if((e.getMessage()+"").indexOf("No outgoing sequence flow of the exclusive gateway")>-1
                    && (e.getMessage()+"").indexOf("could be selected for continuing the process")>-1){
                jr.setResult("");
                jr.setMsg("001");
            }else{
                e.printStackTrace();
                jr.setResult(e.getMessage());
                jr.setMsg("fail");
            }
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return jr;
    }
    /**
     * 申请人保存未提交的流程
     */
    @RequestMapping(value = "/reserveProInfo")
    @ResponseBody
    @Transactional
    public JSONResult reserveProInfo(String requestid,String commentinfo,String taskName,
                                     @RequestParam(value="file",required=false) MultipartFile file,
                                     String reportName,String proname,String processDefinitionID
            ,String deployid,HttpServletRequest request) {
        JSONResult jr=new JSONResult();
        String attachmentid="";int update=0;
        try {
            String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            String userRealName = UserService.getInstance().getUserByUserName(userName).getRealName();
            Integer integer = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM PROOPREATEINFO WHERE REQUESTID=?", new Object[]{requestid}, Integer.class);
            if(integer==1){
                //更新
                if(file!=null){
                    attachmentid=ProcessUtils.uploadAttachment(request,file);
                    update = jdbcTemplate.update("UPDATE PROOPREATEINFO SET OPREATETIME=?,MYCOMMENT=?,ATTACHMENT=? WHERE REQUESTID=?",
                            new Object[]{new Date(),commentinfo,attachmentid,requestid});
                }else {
                    update = jdbcTemplate.update("UPDATE PROOPREATEINFO SET OPREATETIME=?,MYCOMMENT=? WHERE REQUESTID=?",
                            new Object[]{new Date(),commentinfo,requestid});
                }
                if(update>0) {
                    jr.setMsg("success");
                }
                else {
                    jr.setMsg("fail");
                    jr.setResult("保存失败");
                }
            }else if(integer==0){
                //保存操作者操作信息
                if(file!=null){
                    attachmentid=ProcessUtils.uploadAttachment(request,file);
                }
                String sql="INSERT INTO PROOPREATEINFO(ID,OPREATENAME,OPREATEREALNAME,OPREATETIME,OPREATETYPE,NODENAME,MYCOMMENT,ATTACHMENT,REQUESTID,REPORTNAME,DEPLOYID,PRONAME) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
                update=jdbcTemplate.update(sql,new Object[]{ProcessUtils.getUUID(),userName,userRealName,new Date(),2,taskName,commentinfo,
                        attachmentid,requestid,reportName,deployid,proname});
                if(update>0) {
                    jr.setMsg("success");
                }
                else {
                    jr.setMsg("fail");
                    jr.setResult("保存失败");
                }
            }
            else {
                jr.setMsg("fail");
                jr.setResult("保存失败:预期一条记录，实际查出多条记录");
            }
        } catch (Exception e) {
            jr.setMsg("0");
            jr.setResult(e.getMessage());
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return jr;
    }


    /*
    *查询自己的任务
     */
    @RequestMapping("/selectTask")
    @ResponseBody
    public JSONResult selectTask(String num,HttpServletRequest request,String proName,String proInstanceId,String type)
    {
        JSONResult jr=new JSONResult();
        Integer yeshu=Integer.valueOf(num);
        int total=0;
        try {
            String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            List<Map<String, Object>> result = new ArrayList<>();
            //组任务办理人为null
            List<Task> zuList = taskService.createTaskQuery().taskCandidateUser(userName).orderByTaskCreateTime().desc().list();
            //有办理人的任务
            List<Task> assignList = taskService.createTaskQuery().taskAssignee(userName).orderByTaskCreateTime().desc().list();
            assignList.addAll(zuList);
            //排序
            sortListByTime.taskLists(assignList);
            List<Task> list=null;
            if("1".equals(type)){
                list =ProcessUtils.getTaskByYeShu(assignList,yeshu);
                total=assignList.size();
            }
            else{
                list=assignList;
            }
            List<Map<String, Object>> listmaps = new ArrayList<Map<String, Object>>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (Task t : list) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("taskId", t.getId());
                map.put("taskName", t.getName());
                HistoricProcessInstance hps = historyService.createHistoricProcessInstanceQuery().
                        processInstanceId(t.getProcessInstanceId()).singleResult();
                map.put("proStartTime", sdf.format(hps.getStartTime()));
                map.put("proname", hps.getName());
                map.put("userName", hps.getStartUserId());
                //process_userRealName
                map.put("userRealName",runtimeService.getVariableInstance(t.getProcessInstanceId(),
                        "process_userRealName").getValue());
                map.put("proDefinedId", t.getProcessDefinitionId());
                map.put("proInstanceId", t.getProcessInstanceId());
                listmaps.add(map);
            }
            List<Map<String, Object>> result1 = new ArrayList<>();
            if("2".equals(type)){
                if((proName!=null&&!"".equals(proName))||(proInstanceId!=null&&!"".equals(proInstanceId))){
                    if(proName!=null&&!"".equals(proName)){
                        for(int k=0;k<listmaps.size();k++) {
                            String s = listmaps.get(k).get("proname").toString();
                            if (s.contains(proName)) {
                                if(!result1.contains(listmaps.get(k))){
                                    result1.add(listmaps.get(k));
                                }
                            }
                        }
                        listmaps=result1;
                        result1 = new ArrayList<>();
                    }
                    if(proInstanceId!=null&&!"".equals(proInstanceId)){
                        for(int k3=0;k3<listmaps.size();k3++) {
                            String s1 = listmaps.get(k3).get("proInstanceId").toString();
                            if (s1.contains(proInstanceId)) {
                                if(!result1.contains(listmaps.get(k3))){
                                    result1.add(listmaps.get(k3));
                                }
                            }
                        }
                        listmaps=result1;
                        result1 = new ArrayList<>();
                    }
                }
                result=ProcessUtils.getCountByYeShu(listmaps,yeshu);
                total=listmaps.size();
            }
            else{
                result=listmaps;
            }

            jr.setResult(result);
            jr.setTotal(total);
            if(total<=10){
                jr.setYeshu(1);
            }else{
                jr.setYeshu(total%10==0 ? total/10 : total/10+1);
            }
            jr.setMsg("success");

        }
        catch (Exception e){
            jr.setResult(e.getMessage());
            jr.setMsg("fail");
        }
        return jr;
    }


    /**
     *查看历史流程已处理的
     */
    @RequestMapping("/selectHisProYiChuLi")
    @ResponseBody
    public JSONResult selectHisProYiChuLi(String num,HttpServletRequest request,String proName,String proInstanceid,String type)
    {
        JSONResult jr=new JSONResult();
        Integer yeshu=Integer.valueOf(num);
        String message="";
        String process_formKey="";
        String currentAssignee="";
        try {
            boolean flag=true;
            int total=0;
            List<Map<String, Object>> resultList=null;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
            List<Map<String, Object>> list=null;
            String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            List<Map<String, Object>> list_temp = jdbcTemplate.queryForList("SELECT  proInstanceId,taskid,reportName  " +
                            "FROM proopreateinfo WHERE opreateName=? AND opreateType  IN('3','5','7','10') ORDER BY opreateTime DESC",
                    new Object[]{userName});
            List<String> list1 = new ArrayList<>();
            List<Map<String, Object>> mapList=new ArrayList<>();
            for(int i=0;i<list_temp.size();i++){
                String proInstanceId=list_temp.get(i).get("proInstanceId")==null?"":list_temp.get(i).get("proInstanceId").toString();
                if(!list1.contains(proInstanceId)){
                    list1.add(proInstanceId);
                    mapList.add(list_temp.get(i));
                }
            }
            List<Map<String, Object>> list11=new ArrayList<>();
            for(int i=0;i<mapList.size();i++){
                HistoricProcessInstance hisProInstance = historyService.createHistoricProcessInstanceQuery().
                        processInstanceId(mapList.get(i).get("proInstanceId").toString()).singleResult();
                if(hisProInstance!=null){
                    list11.add(mapList.get(i));
                }
            }
            if("1".equals(type)){
                list = ProcessUtils.getCountByYeShu(list11, yeshu);
                total=list11.size();
            }else{
                list=list11;
            }

            List<Map<String, Object>> result=new ArrayList<>();
            //  System.out.println(list);
            for (int i=0;i<list.size();i++) {
                Map<String, Object> map = new HashMap<>();
                HistoricProcessInstance hisProInstance = historyService.createHistoricProcessInstanceQuery().
                        processInstanceId(list.get(i).get("proInstanceId").toString()).singleResult();
                if(hisProInstance!=null){
                    if(hisProInstance.getEndTime()==null){
                        Map<String, VariableInstance> mapVariable = runtimeService.getVariableInstances(list.get(i).get("proInstanceId").toString());
                        String process_state=mapVariable.get("process_state").getTextValue();
                        process_formKey=mapVariable.get("process_formKey").getTextValue();
                        String process_userRealName=mapVariable.get("process_userRealName").getTextValue();
                        Map<String, String> currentMap = ProcessUtils.getCurrentAssignee(taskService, hisProInstance.getId());
                        currentAssignee=currentMap.get("assignee")==null ? "" : currentMap.get("assignee").toString();
                        map.put("startPeople",process_userRealName);
                        map.put("proEndTime", "");
                        map.put("proStatus",process_state);

                    }else{
                        currentAssignee="";
                        if(hisProInstance.getDeleteReason()==null){
                            map.put("proStatus","6");
                        }else {
                            //已删除流程
                            //已删除流程
                            if("expired".equals(hisProInstance.getDeleteReason().trim())){
                                map.put("proStatus","9");
                            }else{
                                map.put("proStatus","7");
                            }
                        }
                        List<HistoricVariableInstance> hisVarList = historyService.createHistoricVariableInstanceQuery().
                                processInstanceId(list.get(i).get("proInstanceId").toString()).list();
                        for(HistoricVariableInstance h:hisVarList){
                            if("process_userRealName".equals(h.getVariableName())){
                                map.put("startPeople",h.getValue().toString());
                            }else if("process_formKey".equals(h.getVariableName())){
                                process_formKey=h.getValue().toString();
                            }
                        }
                        map.put("proEndTime", sdf.format(hisProInstance.getEndTime()));

                    }
                    String reportName= list.get(i).get("reportName") == null ? "" : list.get(i).get("reportName").toString();
                    if("".equals(reportName)){
                        List<HistoricTaskInstance> list2 = historyService.createHistoricTaskInstanceQuery().processInstanceId(list.get(i).get("proInstanceId").toString()).
                                taskAssignee(userName).orderByHistoricTaskInstanceStartTime().desc().list();
                        if(list2.size()==0){
                            //flag=false;
                            String taskid=list.get(i).get("taskid")==null?"":list.get(i).get("taskid").toString();
                            List<HistoricTaskInstance> list3 = historyService.createHistoricTaskInstanceQuery().taskId(taskid).list();
                            if(list3.size()>0){
                                map.put("proFormKey",list3.get(0).getFormKey());
                            }else{
                                map.put("proFormKey",process_formKey);
                            }
                            //break;
                        }else{
                            String formKey = list2.get(0).getFormKey();
                            if(formKey==null || "".equals(formKey)){
                                String taskDefinitionKey = list2.get(0).getTaskDefinitionKey();
                                UserTask activityImpl = ProcessUtils.getUserTask(taskDefinitionKey, list2.get(0).getProcessDefinitionId(), repositoryService);
                                map.put("proFormKey",activityImpl.getFormKey());
                            }else{
                                map.put("proFormKey",formKey);
                            }
                        }
                    }else{
                        map.put("proFormKey",reportName);
                    }

                    map.put("businessKey", hisProInstance.getBusinessKey());
                    map.put("proname", hisProInstance.getName());
                    map.put("proStartTime", sdf.format(hisProInstance.getStartTime()));
                    map.put("proDefineID", hisProInstance.getProcessDefinitionId());
                    map.put("proInstanceId", hisProInstance.getId());
                    map.put("currentAssignee", currentAssignee);
                    String s = list.get(i).get("taskid").toString();
                    String taskDefinitionKey="";
                    List<Map<String, Object>> list2 = jdbcTemplate.queryForList("SELECT * FROM ACT_HI_ACTINST WHERE TASK_ID_=?",
                            new Object[]{s});
                    if(list2.size()>0){
                        taskDefinitionKey=list2.get(0).get("ACT_ID_").toString();
                    }
                    else{
                        taskDefinitionKey="";
                    }
                    map.put("activityid", taskDefinitionKey);
                    result.add(map);
                }
            }
            List<Map<String, Object>> result1 = new ArrayList<>();
            if("2".equals(type)){
                if((proName!=null&&!"".equals(proName))||(proInstanceid!=null&&!"".equals(proInstanceid))){
                    if(proName!=null&&!"".equals(proName)){
                        for(int k=0;k<result.size();k++) {
                            String s = result.get(k).get("proname").toString();
                            if (s.contains(proName)) {
                                if(!result1.contains(result.get(k))){
                                    result1.add(result.get(k));
                                }
                            }
                        }
                        result=result1;
                        result1 = new ArrayList<>();
                    }
                    if(proInstanceid!=null&&!"".equals(proInstanceid)){
                        for(int k3=0;k3<result.size();k3++) {
                            String s1 = result.get(k3).get("proInstanceId").toString();
                            if (s1.contains(proInstanceid)) {
                                if(!result1.contains(result.get(k3))){
                                    result1.add(result.get(k3));
                                }
                            }
                        }
                        result=result1;
                        result1 = new ArrayList<>();
                    }
                }
                resultList =ProcessUtils.getCountByYeShu(result,yeshu);
                total=result.size();
            }else{
                resultList=result;
            }

            ProcessUtils.SortByStringTime(resultList,"proStartTime");
            if(flag){
                jr.setResult(resultList);
                jr.setMsg("success");
            }else{
                jr.setResult("流程实例"+message+","+"用户名"+userName+",查询出错");
                jr.setMsg("fail");
            }

            jr.setTotal(total);
            if(total<=10){
                jr.setYeshu(1);
            }else{
                jr.setYeshu(total%10==0 ? total/10 : total/10+1);
            }
            return jr;
        }catch ( Exception e){
            jr.setResult(e.getMessage());
            jr.setMsg("fail");
            return jr;
        }
    }

    /**
     *查看已申请
     */
    @RequestMapping("/selectHisPro")
    @ResponseBody
    public JSONResult selectHisPro(String num,HttpServletRequest request,String proName,String proInstanceid,String type)
    {
        JSONResult jr=new JSONResult();
        List<Map<String, Object>> HisList=new ArrayList<Map<String, Object>>();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        Integer yeshu=Integer.valueOf(num);
        int total=0;
        try {
            List<HistoricProcessInstance> list=null;
            List<Map<String, Object>> result_yishenqing=null;
            String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            String userRealName =UserService.getInstance().getUserByUserName(userName).getRealName();
            List<HistoricProcessInstance> resultList = historyService.createHistoricProcessInstanceQuery()
                    .startedBy(userName).orderByProcessInstanceStartTime().desc().list();
            if("1".equals(type)){
                list = ProcessUtils.getHistoricProcessInstanceByYeShu(resultList,yeshu);
                total=resultList.size();
            }else{
                list=resultList;
            }
            //申请节点的activityid
            for (int i = 0; i < list.size(); i++) {
                String endTime="";
                String completeState="";
                String process_state="";
                String process_formKey="";
                String currentAssignee="";
                Map<String, Object> HisMap = new HashMap<String, Object>();
                if (list.get(i).getEndTime() == null) {
                    endTime = "";
                    completeState = "进行中";
                    Map<String, VariableInstance> map = runtimeService.getVariableInstances(list.get(i).getId());
                    process_state=map.get("process_state").getTextValue();
                    process_formKey=map.get("process_formKey").getTextValue();
                    Map<String, String> currentMap = ProcessUtils.getCurrentAssignee(taskService, list.get(i).getId());
                    currentAssignee=currentMap.get("assignee")==null ? "" : currentMap.get("assignee").toString();
                } else {
                    currentAssignee="";
                    endTime = sdf.format(list.get(i).getEndTime());
                    if(list.get(i).getDeleteReason()==null){
                        completeState = "完成";
                        process_state="6";

                    }else {
                        //已删除流程
                        if("expired".equals(list.get(i).getDeleteReason().trim())){
                            completeState="完成";
                            process_state="9";
                        }else{
                            completeState="已删除";
                            process_state="7";
                        }

                    }
                    List<HistoricVariableInstance> hisVarList = historyService.createHistoricVariableInstanceQuery().
                            processInstanceId(list.get(i).getId()).list();
                    for(HistoricVariableInstance h:hisVarList){
                        if("process_formKey".equals(h.getVariableName())){
                            process_formKey=h.getValue().toString();
                        }
                    }

                }
                HisMap.put("businessKey", list.get(i).getBusinessKey());
                HisMap.put("reportName",  process_formKey);
                HisMap.put("proInsID", list.get(i).getId());
                HisMap.put("proDefinitionId", list.get(i).getProcessDefinitionId());
                HisMap.put("proStartTime", sdf.format(list.get(i).getStartTime()));
                HisMap.put("proEndTime", endTime);
                HisMap.put("proCompleteState", completeState);
                HisMap.put("prostate", process_state);
                HisMap.put("proname", list.get(i).getName());
                HisMap.put("userRealName",userRealName);
                HisMap.put("currentAssignee",currentAssignee);
                String applicationId=ProcessUtils.getApplicationActivitiId(list.get(i).getProcessDefinitionId(),
                        repositoryService);
                HisMap.put("activityid", applicationId);

                HisList.add(HisMap);
            }

            List<Map<String, Object>> result1 = new ArrayList<>();
            if("2".equals(type)){
                if((proName!=null&&!"".equals(proName))||(proInstanceid!=null&&!"".equals(proInstanceid))){
                    if(proName!=null&&!"".equals(proName)){
                        for(int k=0;k<HisList.size();k++) {
                            String s = HisList.get(k).get("proname").toString();
                            if (s.contains(proName)) {
                                if(!result1.contains(HisList.get(k))){
                                    result1.add(HisList.get(k));
                                }
                            }
                        }
                        HisList=result1;
                        result1 = new ArrayList<>();
                    }
                    if(proInstanceid!=null&&!"".equals(proInstanceid)){
                        for(int k3=0;k3<HisList.size();k3++) {
                            String s1 = HisList.get(k3).get("proInsID").toString();
                            if (s1.contains(proInstanceid)) {
                                if(!result1.contains(HisList.get(k3))){
                                    result1.add(HisList.get(k3));
                                }
                            }
                        }
                        HisList=result1;
                        result1 = new ArrayList<>();
                    }
                }
                result_yishenqing=ProcessUtils.getCountByYeShu(HisList,yeshu);
                total=HisList.size();
            }
            else{
                result_yishenqing=HisList;
            }

            jr.setMsg("success");
            jr.setResult(result_yishenqing);
            jr.setTotal(total);
            if(total<=10){
                jr.setYeshu(1);
            }else{
                jr.setYeshu(total%10==0 ? total/10 : total/10+1);
            }
            return jr;
        }
        catch (Exception e){
            jr.setResult(e.getMessage());
            jr.setMsg("fail");
            return jr;
        }
    }


    /**
     *根据任务id查布局
     */
    @RequestMapping("/userTaskForm")
    @ResponseBody
    public JSONResult userTaskForm(String taskid) {
        JSONResult jr=new JSONResult();
        String zhuanban="";
        String btnname="";
        String tuihui="";
        String istuihui="";
        String addHuiQianRen="";
        String issetaddhuiqian="";
        String iswritecomment="";
        Map<String,Object> map=new HashMap<>();
        try {
            Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
            if(task!=null){
                ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().
                        processInstanceId(task.getProcessInstanceId()).singleResult();
                // 0：申请人提交可撤回状态  1：通过 2：查看 3：被退回（不包括申请节点） 4：撤回 5：转办 6:完成 7：删除 8：被退回到申请节点
                String applicationActivitiId = ProcessUtils.getApplicationActivitiId(task.getProcessDefinitionId(), repositoryService);
                if(!applicationActivitiId.equals(task.getTaskDefinitionKey())){
                    runtimeService.setVariable(task.getProcessInstanceId(),"process_state","2");
                }
                UserTask userTask = ProcessUtils.getUserTask(task.getTaskDefinitionKey(), task.getProcessDefinitionId(), repositoryService);

                String btnName = ProcessUtils.getTaskExectionName(userTask, "btnName");
                btnname="".equals(btnName) ? "通过" : btnName;

                //true false
                zhuanban = ProcessUtils.getTaskExectionName(userTask, "zhuanban");
                istuihui = ProcessUtils.getTaskExectionName(userTask, "istuihui");
                issetaddhuiqian = ProcessUtils.getTaskExectionName(userTask, "issetaddhuiqian");
                iswritecomment = ProcessUtils.getTaskExectionName(userTask, "iswritecomment");
                //判断是否为会签节点
                if(ProcessUtils.isHuiQianNodePallel(task.getTaskDefinitionKey(),task.getProcessDefinitionId(),repositoryService)) {
                    addHuiQianRen="true".equals(issetaddhuiqian) ? "加签" : "";
                }
                if("true".equals(istuihui)){
                    String tuiHui = ProcessUtils.getTaskExectionName(userTask, "tuihui");
                    tuihui="".equals(tuiHui) ? "退回" : tuiHui;
                }
                if(!ProcessUtils.isHuiQianNodePallel(task.getTaskDefinitionKey(),task.getProcessDefinitionId(),repositoryService)
                        && task.getAssignee()!=null){
                    if("true".equals(zhuanban)){
                        zhuanban="转办";
                    }
                }
                map.put("moban",userTask.getFormKey());
                map.put("yeuwuid",processInstance.getBusinessKey());
                map.put("zhuanban",zhuanban);
                map.put("tijiao",btnname);
                map.put("tuihui",tuihui);
                map.put("istuihui",istuihui);
                map.put("addHuiQianRen",addHuiQianRen);
                map.put("proDefinitionId",task.getProcessDefinitionId());
                map.put("processInstanceId",task.getProcessInstanceId());
                map.put("iswritecomment",iswritecomment);
                map.put("activityid",task.getTaskDefinitionKey());
                jr.setResult(map);
                jr.setMsg("success");
            }else{
                jr.setResult(map);
                jr.setMsg("2");
            }
        }catch (Exception e){
            jr.setResult(e.getMessage());
            jr.setMsg("fail");
        }
        return jr;
    }

    /**
     *完成任务
     */
    @RequestMapping("/completeTask")
    @ResponseBody
    @Transactional
    public JSONResult completeTask(String taskid,String commentinfo,HttpServletRequest request,String seesionid,
                                   @RequestParam(value="file",required=false) MultipartFile file,String proname) {
        JSONResult jr=new JSONResult();
        Map<String,Object> map=new HashMap<>();
        Map<String,Object> resultMap=new HashMap<>();
        String attachmentid = "";
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        String type="";
        try {
            String userName=LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            String userRealName=UserService.getInstance().getUserByUserName(userName).getRealName();
            Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
            if(task!=null){
                TaskEntity taskEntity = (TaskEntity) task;
                ProcessUtils.getCondition("",taskid,repositoryService,taskService,
                        seesionid,request,map,resultMap,userName);
                String proInstanceId=task.getProcessInstanceId();
                //上传附件
                if(file!=null){
                    attachmentid=ProcessUtils.uploadAttachment(request,file);
                }
                ActivityImpl activityImpl = ProcessUtils.getActivityImplByActivitiId(task.getTaskDefinitionKey(), task.getProcessDefinitionId(), repositoryService);
                type=activityImpl.getProperty("multiInstance")==null ? "" : activityImpl.getProperty("multiInstance").toString();
                taskService.complete(taskid,map);
                //保存操作信息
                // 1：申请人提交 2：保存 3：驳回 4：撤回 5：转办 6：删除 7:通过
                jdbcTemplate.update("INSERT INTO PROOPREATEINFO(ID,PROINSTANCEID,TASKID,OPREATENAME,OPREATEREALNAME,OPREATETIME,OPREATETYPE,NODENAME,MYCOMMENT,ATTACHMENT,REPORTNAME) VALUES(?,?,?,?,?,?,?,?,?,?,?)",
                        new Object[]{ ProcessUtils.getUUID(),proInstanceId,taskid,userName,userRealName,new Date(),7,task.getName(),PreventXSS.delHTMLTag(commentinfo),attachmentid,taskEntity.getFormKey()});

                ProcessInstance proInstance = runtimeService.createProcessInstanceQuery().processInstanceId(proInstanceId).singleResult();
                if(proInstance==null){
                    jdbcTemplate.update("UPDATE ACT_HI_VARINST SET TEXT_='6' WHERE PROC_INST_ID_=? AND NAME_='process_state'",
                            new Object[]{proInstanceId});
                }else {
                    runtimeService.setVariable(proInstance.getId(),"process_state","1");
                    Object proDueTime = runtimeService.getVariable(proInstance.getId(), "proDueTime");
                    //自动流传与第二次默认通过
                    if(!"parallel".equals(type) && !"sequential".equals(type)){
                        ProcessUtils.autopass(taskService,proInstance.getId(),repositoryService,
                                runtimeService,jdbcTemplate,userName,historyService);
                    }
                    //推送消息
                    Map<String,String> para=new HashMap<>();
                    HistoricProcessInstance proInstanceHis = historyService.createHistoricProcessInstanceQuery().
                            processInstanceId(proInstance.getId()).singleResult();
                    User userByUserName = UserService.getInstance().getUserByUserName(proInstanceHis.getStartUserId());
                    String realName="";
                    if(userByUserName!=null){
                        realName=userByUserName.getRealName();
                    }else{
                        List<HistoricVariableInstance> hisVarList = historyService.createHistoricVariableInstanceQuery().
                                processInstanceId(proInstance.getId()).list();
                        for(HistoricVariableInstance h:hisVarList){
                            if("process_userRealName".equals(h.getVariableName())){
                                realName=h.getValue().toString();
                            }
                        }
                    }

                    para.put("startPeople",realName);
                    para.put("startTime",sdf.format(proInstanceHis.getStartTime()));

                    para.put("proDueTime",proDueTime==null?"":proDueTime.toString());
                    para.put("shenheTime",sdf.format(new Date()));
                    sendMessage.getSendMessageUser(taskService,proInstanceId,jdbcTemplate,proname,para,"1",null);
                }

                jr.setResult(resultMap);
                jr.setMsg("success");
            }else{
                jr.setResult("");
                jr.setMsg("002");
            }
        }
        catch (Exception e){
            if((e.getMessage()+"").indexOf("No outgoing sequence flow of the exclusive gateway")>-1
                    && (e.getMessage()+"").indexOf("could be selected for continuing the process")>-1){
                jr.setResult("");
                jr.setMsg("001");
            }else{
                jr.setResult(e.getMessage());
                jr.setMsg("fail");
            }

            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return jr;
    }

    //办理人保存
    @RequestMapping(value = "/banliBaoCun")
    @ResponseBody
    public JSONResult banliBaoCun(String taskid,HttpServletRequest request){
        JSONResult jr=new JSONResult();
        Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
        try {
            String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            String userRealName = UserService.getInstance().getUserByUserName(userName).getRealName();
            if(task!=null){
                jdbcTemplate.update("INSERT INTO PROOPREATEINFO(ID,PROINSTANCEID,TASKID,OPREATENAME,OPREATEREALNAME,OPREATETIME,OPREATETYPE,NODENAME,MYCOMMENT) " +
                        " VALUES(?,?,?,?,?,?,?,?,?)", new Object[]{ProcessUtils.getUUID(), task.getProcessInstanceId(),taskid, userName, userRealName, new Date(),8,task.getName(),""});
                jr.setMsg("success");
                jr.setResult("");
            }
            else{
                jr.setMsg("001");
                jr.setResult("");
            }

            return  jr;
        }
        catch ( Exception e){
            jr.setMsg("fail");
            jr.setResult(e.getMessage());
            return  jr;
        }
    }


    /*
    * 测试
    * */
    @RequestMapping("/test")
    @ResponseBody
    public  JSONResult test(HttpServletRequest request){
        String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
        List<HistoricProcessInstance> resultList =
                historyService.createHistoricProcessInstanceQuery().processInstanceNameLike("%%")
                .notDeleted().unfinished()
                .startedBy(userName).orderByProcessInstanceStartTime().desc().list();
        JSONResult jr=new JSONResult();
        jr.setResult(resultList);
        return jr;
    }





    //删除保存
    @RequestMapping("/removeBaoCun")
    @ResponseBody
    public JSONResult removeBaoCun(String id){
        JSONResult jr=new JSONResult();
        int update = jdbcTemplate.update("UPDATE PROOPREATEINFO SET OPREATETYPE='9' WHERE REQUESTID=?", new Object[]{id});
        if(update>0){
            jr.setResult("success");
        }else {
            jr.setResult("fail");
        }
        return  jr;
    }

    /*开始节点的流程撤回*/
    @RequestMapping(value = "/chehui")
    @ResponseBody
    @Transactional
    public JSONResult chehui(String processDefinitionID,String proInstanceId,HttpServletRequest request){

        JSONResult jr=new JSONResult();
        try {
            String userName = LoginService.getInstance().getCurrentUserNameFromRequestCookie(request);
            String userRealName = UserService.getInstance().getUserByUserName(userName).getRealName();
            if(proInstanceId==null || "".equals(proInstanceId) || "".equals(processDefinitionID) || processDefinitionID==null){
                jr.setResult("0");
                jr.setMsg("流程实例ID或流程定义ID为空");
            }else{
                List<Task> list = taskService.createTaskQuery().processInstanceId(proInstanceId).list();
                Task task = list.get(0);

                String applicationActivitiId = ProcessUtils.getApplicationActivitiId(processDefinitionID, repositoryService);

                ActivityImpl destinationActivity = ProcessUtils.getActivityImplByActivitiId(applicationActivitiId,task.getProcessDefinitionId(),repositoryService);

                ActivityImpl currentActivity = ProcessUtils.getActivityImplByActivitiId(task.getTaskDefinitionKey(),task.getProcessDefinitionId(),repositoryService);

                if (ProcessUtils.isHuiQianNode(task.getTaskDefinitionKey(),processDefinitionID,repositoryService)) {
                    //申请下一个结点为会签节点
                    managerService.executeCommand(new ShareniuMultiInstanceJumpCmd(task.getExecutionId(), task.getProcessInstanceId(),
                            destinationActivity, null, currentActivity));
                } else if (ProcessUtils.isParallelGatewayByCheHui( task.getTaskDefinitionKey(),task.getProcessDefinitionId(),repositoryService)) {
                    //申请下一个结点为并行节点
                    managerService.executeCommand(new ShareniuParallelJumpCmd(task.getExecutionId(), task.getProcessInstanceId(),
                            destinationActivity, null, currentActivity));
                } else {
                    managerService.executeCommand(new ShareniuCommonJumpTaskCmd(task.getExecutionId(), task.getProcessInstanceId(),
                            destinationActivity, null, currentActivity));
                }
                //标记流程为撤回
                runtimeService.setVariable(task.getProcessInstanceId(),"process_state","4");
                //保存操作信息
                jdbcTemplate.update("INSERT INTO PROOPREATEINFO(ID,PROINSTANCEID,TASKID,OPREATENAME,OPREATEREALNAME,OPREATETIME,OPREATETYPE,NODENAME,MYCOMMENT,ATTACHMENT) VALUES(?,?,?,?,?,?,?,?,?,?)",
                        new Object[]{ ProcessUtils.getUUID(),proInstanceId,task.getId(),userName,userRealName,new Date(),4,task.getName(),"",""});
                jr.setMsg("success");
                jr.setResult("success");
            }
        }
        catch (Exception e){
            jr.setResult("fail");
            jr.setMsg(e.getMessage());
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return jr;
    }

    /*开始节点的流程删除*/
    @RequestMapping(value = "/deleteSelfProcess")
    @ResponseBody
    @Transactional
    public JSONResult deleteSelfProcess(String proInstanceId,String userName,String userRealName){
        JSONResult jr=new JSONResult();
        try {
            String taskid="";  String taskName="";
            List<Task> task = taskService.createTaskQuery().processInstanceId(proInstanceId).list();
            if(task.size()>0){
                taskid=task.get(0).getId();
                taskName=task.get(0).getName();
            }
            // 0：申请人提交可撤回状态  1：通过 2：查看 3：被退回（不包括申请节点） 4：撤回 5：转办 6:完成 7：删除 8：被退回到申请节点
            runtimeService.setVariable(proInstanceId,"process_state","7");
            runtimeService.deleteProcessInstance(proInstanceId,"selfDelete");
            //保存操作信息
            // 1：申请人提交 2：申请人保存 3：驳回 4：撤回 5：转办 6：删除流程 7:办理人通过 8：办理人保存
            jdbcTemplate.update("INSERT INTO PROOPREATEINFO(ID,PROINSTANCEID,TASKID,OPREATENAME,OPREATEREALNAME,OPREATETIME,OPREATETYPE,NODENAME,MYCOMMENT,ATTACHMENT) VALUES(?,?,?,?,?,?,?,?,?,?)",
                    new Object[]{ ProcessUtils.getUUID(),proInstanceId,taskid,userName,userRealName,new Date(),6,taskName,"",""});
            jr.setMsg("success");
            jr.setResult("success");
        }
        catch (Exception e){
            jr.setResult("fail");
            jr.setMsg(e.getMessage());
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return jr;
    }

}
