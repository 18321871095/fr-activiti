package com.fr.tw.util;

import com.fanruan.api.cal.CalculatorKit;
import com.fr.decision.authority.data.User;
import com.fr.decision.webservice.bean.user.UserDetailInfoBean;
import com.fr.decision.webservice.v10.login.LoginService;
import com.fr.decision.webservice.v10.user.UserService;
import com.fr.main.TemplateWorkBook;
import com.fr.main.workbook.WriteWorkBook;
import com.fr.report.write.SubmitHelper;
import com.fr.stable.script.CalculatorProvider;
import com.fr.web.core.ReportSessionIDInfor;
import com.fr.web.core.ReportWebUtils;
import com.fr.web.core.SessionPoolManager;
import org.activiti.bpmn.model.*;
import org.activiti.bpmn.model.Process;
import org.activiti.engine.HistoryService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.delegate.Expression;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.impl.bpmn.parser.handler.UserTaskParseHandler;
import org.activiti.engine.impl.interceptor.CommandContext;
import org.activiti.engine.impl.persistence.entity.ExecutionEntity;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.PvmActivity;
import org.activiti.engine.impl.pvm.PvmTransition;
import org.activiti.engine.impl.pvm.ReadOnlyProcessDefinition;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.impl.pvm.process.TransitionImpl;
import org.activiti.engine.impl.task.TaskDefinition;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.Model;
import org.activiti.engine.runtime.Execution;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.quartz.SimpleTrigger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.Collator;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static oracle.net.aso.C01.*;

public class ProcessUtils {
    public static final Properties p = new Properties();
    public static ExecutorService fixedThreadPool = Executors.newFixedThreadPool(20);



    public static List<ActivityImpl> getProcessActivitis(String processDefinitionID, RepositoryService repositoryService){
        ProcessDefinitionEntity processDefinitionEntity = (ProcessDefinitionEntity)repositoryService.getProcessDefinition(processDefinitionID);
        return processDefinitionEntity.getActivities();
    }
    public static String getUUID(){
        return  UUID.randomUUID().toString().replaceAll("\\-", "");
    }

    //获取整个流程图所有节点对象
    public static Collection<FlowElement> getFlowElements(String processDefinitionID,RepositoryService repositoryService){
        BpmnModel bpmnModel = repositoryService.getBpmnModel(processDefinitionID);
        Process mainProcess = bpmnModel.getMainProcess();
        Collection<FlowElement> flowElements = mainProcess.getFlowElements();
        return flowElements;
    }


    //根据activitiId获取UserTask对象
    public static UserTask getUserTask(String activitiId,String processDefinitionID,RepositoryService repositoryService){
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(processDefinitionID, repositoryService);
        UserTask task=null;
        for(FlowElement e : flowElements){
            if(e.getId().equals(activitiId)){
                task = (UserTask)e;
                break;
            }
        }
        return  task;
    }

    /*得到任务节点扩展属性名*/
    public static String getTaskExectionName(UserTask task,String name){
        Map<String, List<ExtensionElement>> extensionElements = task.getExtensionElements();
        return getExtensionElements(extensionElements,name);
    }
    /*得到边界定时节点扩展属性名*/
    public static String getBoundaryEventExectionName(BoundaryEvent boundaryEvent,String name){
        Map<String, List<ExtensionElement>> extensionElements = boundaryEvent.getExtensionElements();
        return getExtensionElements(extensionElements,name);
    }
    /*得到开始节点属性*/
    public static StartEvent getStartEventObject(String processDefinitionId,RepositoryService repositoryService){
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(processDefinitionId, repositoryService);
        StartEvent start=null;
        for(FlowElement f:flowElements){
            if (f instanceof StartEvent){
                start=(StartEvent)f;
                break;
            }
        }
        return start;
    }

    /*得到开始节点扩展属性名*/
    public static String getStartNodeExectionName(StartEvent start,String name){
        Map<String, List<ExtensionElement>> extensionElements = start.getExtensionElements();
        return getExtensionElements(extensionElements,name);
    }

    /*得到连线节点扩展属性名*/
    public static String getSequenceFlowExectionName(SequenceFlow sequenceFlow,String name){
        Map<String, List<ExtensionElement>> extensionElements = sequenceFlow.getExtensionElements();
        return getExtensionElements(extensionElements,name);
    }

    //获取字符串中的数字
    public static String  getNumInString(String text){
        String regEx="[^0-9]";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(text);
        return m.replaceAll("").trim();
    }
    public static Date getProgressTime(Date date,String duetime){
        Calendar ca = Calendar.getInstance();
        ca.setTime(date);
        if(duetime.contains("s") || duetime.contains("S")){
            ca.add(Calendar.SECOND, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }else if(duetime.contains("m") || duetime.contains("M")){
            ca.add(Calendar.MINUTE, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }else if(duetime.contains("h") || duetime.contains("H")){
            ca.add(Calendar.HOUR, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }else if(duetime.contains("d") || duetime.contains("D")){
            ca.add(Calendar.DATE, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }
        return ca.getTime();
    }
    //获取逾期时间
    public static Date getOverTime(Date date,String duetime,String overdue){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //System.out.println("当前时间："+sdf.format(date));
        Calendar ca = Calendar.getInstance();
        ca.setTime(date);
        if(duetime.contains("s") || duetime.contains("S")){
            ca.add(Calendar.SECOND, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }else if(duetime.contains("m") || duetime.contains("M")){
            ca.add(Calendar.MINUTE, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }else if(duetime.contains("h") || duetime.contains("H")){
            ca.add(Calendar.HOUR, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }else if(duetime.contains("d") || duetime.contains("D")){
            ca.add(Calendar.DATE, Integer.valueOf(ProcessUtils.getNumInString(duetime)));
        }

        // System.out.println("到期时间："+sdf.format(ca.getTime()));
        //逾期时间
        if(duetime.contains("s") || duetime.contains("S")){
            ca.add(Calendar.SECOND, (0-Integer.valueOf(ProcessUtils.getNumInString(overdue))));
        }else if(duetime.contains("m") || duetime.contains("M")){
            ca.add(Calendar.MINUTE, (0-Integer.valueOf(ProcessUtils.getNumInString(overdue))));
        }else if(duetime.contains("h") || duetime.contains("H")){
            ca.add(Calendar.HOUR, (0-Integer.valueOf(ProcessUtils.getNumInString(overdue))));
        }else if(duetime.contains("d") || duetime.contains("D")){
            ca.add(Calendar.DATE, (0-Integer.valueOf(ProcessUtils.getNumInString(overdue))));
        }
        // System.out.println("逾期时间："+sdf.format(ca.getTime()));
        return ca.getTime();
    }
    //得到节点条件值
    public static String getExtensionElements(Map<String, List<ExtensionElement>> extensionElements,String name){
        if(extensionElements.size()>0) {
            List<ExtensionElement> extensionElements1 = (List<ExtensionElement>) extensionElements.get(name);
            if(extensionElements1!=null) {
                return extensionElements1.get(0).getElementText();
            }else {
                return "";
            }
        }else {
            return  "";
        }
    }

    //初始化会签人员
    public static  Map<String,Object> initHuiQian(String processDefinitionID,RepositoryService repositoryService){
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(processDefinitionID, repositoryService);
        List<ActivityImpl> activities = ProcessUtils.getProcessActivitis(processDefinitionID,repositoryService);
        Map<String,Object> map=new HashMap<>();
        for (ActivityImpl activity:activities) {
            String property=activity.getProperty("multiInstance")==null ? "" : activity.getProperty("multiInstance").toString();
            if("parallel".equals(property) || "sequential".equals(property)) {
                List<String> huiqianName=new ArrayList<String>();
                TaskDefinition taskDefinition= (TaskDefinition) activity.getProperty("taskDefinition");
                String activitiID=taskDefinition.getKey();
                FlowElement element = null;
                for (FlowElement f : flowElements) {
                    if (f.getId().equals(activitiID)) {
                        element = f;
                        break;
                    }
                }
                UserTask userTask= (UserTask)element;
                String huiQian_temp = getTaskExectionName(userTask, "huiQian").trim();
                if(huiQian_temp.contains("${")){
                    //把动态需要设置会签的节点保存起来

                }else{
                    String[] huiQians=huiQian_temp.split(",");
                    List<String> huiqian=new ArrayList<>();
                    for (String s:huiQians) {
                        if(!"".equals(s.trim())){
                            huiqian.add(s);
                        }
                    }
                    MultiInstanceLoopCharacteristics loopCharacteristics = userTask.getLoopCharacteristics();
                    for (String str:huiqian) {
                        huiqianName.add(str);
                    }

                /*System.out.println("会签："+huiqianName);*/
                    map.put(loopCharacteristics.getInputDataItem(),huiqianName);
                }

            }
        }
        return  map;
    }

    //根据ActivitiId获取ActivityImpl
    public static ActivityImpl getActivityImplByActivitiId(String activitiId,String processDefinitionID,RepositoryService repositoryService){
        ReadOnlyProcessDefinition processDefinitionEntity = (ReadOnlyProcessDefinition) repositoryService.
                getProcessDefinition(processDefinitionID);
        processDefinitionEntity.getActivities();
        return (ActivityImpl) processDefinitionEntity.findActivity(activitiId);
    }
    //根据PvmTransition获取SequenceFlow从而获取条件
    public static List<SequenceFlow> getSequenceFlowsByPvmTransition(List<PvmTransition> PvmTransitions,String processDefinitionID,RepositoryService repositoryService){
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(processDefinitionID, repositoryService);
        List<SequenceFlow> flowElementList=new ArrayList<>();
        for(FlowElement e : flowElements){
            for(PvmTransition p:PvmTransitions){
                if(p.getId().equals(e.getId())){
                    flowElementList.add((SequenceFlow)e);
                    break;
                }
            }
        }
        return flowElementList;

    }

    //获取申请节点的ActivitiId
    public static String getApplicationActivitiId(String processDefinitionID,RepositoryService repositoryService){
        List<ActivityImpl> processActivitis = ProcessUtils.getProcessActivitis(processDefinitionID, repositoryService);
        String ActivitiId="";
        for(ActivityImpl a:processActivitis){
            if("startEvent".equals(a.getProperty("type"))){
                ActivitiId= a.getOutgoingTransitions().get(0).getDestination().getId();
                break;
            }
        }
        return ActivitiId;
    }
    //获取申请节点的formkey
    public static Map<String,String> getApplicationFormKeyAndName(String processDefinitionID, RepositoryService repositoryService){
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(processDefinitionID, repositoryService);
        Map<String,String> map=new HashMap<>();
        String startId="";
        UserTask task=null;
        for(FlowElement f:flowElements){
            if (f instanceof StartEvent){
                SequenceFlow sequenceFlow = ((StartEvent) f).getOutgoingFlows().get(0);
                startId=sequenceFlow.getTargetRef();
                break;
            }
        }
        for(FlowElement f:flowElements){
            if (startId.equals(f.getId())){
                task=(UserTask)f;
                break;
            }
        }
       /* ActivityImpl activity = getActivityImplByActivitiId(startId, processDefinitionID, repositoryService);
        TaskDefinition taskDefinition = (TaskDefinition) activity.getProperty("taskDefinition");
        String formKey = taskDefinition.getFormKeyExpression().getExpressionText();
        String name = taskDefinition.getNameExpression().getExpressionText();
*/
        map.put("formkey",task.getFormKey());
        map.put("name",task.getName());
        map.put("iswritecomment", ProcessUtils.getTaskExectionName(task, "iswritecomment"));
        map.put("tijiaoName",ProcessUtils.getTaskExectionName(task, "btnName"));
        return map;
    }

    //判断是否为会签节点
    public static boolean isHuiQianNode(String activitiId,String proDefinedId,RepositoryService repositoryService){
        boolean flag=false;
        ActivityImpl activityImpl = getActivityImplByActivitiId(activitiId, proDefinedId, repositoryService);
        String name= (String) activityImpl.getProperty("multiInstance");
        if("parallel".equals(name) || "sequential".equals(name)) {
            flag=true;
        }
        return flag;
    }
    public static boolean isHuiQianNodePallel(String activitiId, String proDefinedId, RepositoryService repositoryService) {
        boolean flag=false;
        ActivityImpl activityImpl = getActivityImplByActivitiId(activitiId, proDefinedId, repositoryService);
        String name= (String) activityImpl.getProperty("multiInstance");
        if("parallel".equals(name) ) {
            flag=true;
        }
        return flag;
    }

    //判断申请节点下个节点是否为并行节点(只适用并行的撤回)
    public static boolean isParallelGatewayByCheHui(String activitiId,String proDefinedId,RepositoryService repositoryService){
        boolean flag=false;
        ActivityImpl activityImpl = getActivityImplByActivitiId(activitiId, proDefinedId, repositoryService);
        List<PvmTransition> incomingTransitions = activityImpl.getIncomingTransitions();
        SequenceFlow sequenceFlow = getSequenceFlowsByPvmTransition(incomingTransitions, proDefinedId, repositoryService).get(0);
        String sourceRef = sequenceFlow.getSourceRef();
        ActivityImpl activityImplByActivitiId = getActivityImplByActivitiId(sourceRef, proDefinedId, repositoryService);
        String name = activityImplByActivitiId.getProperty("type").toString();
        if("parallelGateway".equals(name)){
            flag=true;
        }
        return flag;
    }

    //返回页数Model
    public static List<Model> getModelByYeShu(List<Model> list, int yeshu){
        if(list.size()<=10){
            return list.subList(0,list.size());
        }else{
            if(list.size()/10>=yeshu){
                return list.subList((yeshu-1)*10,(yeshu-1)*10+10);
            }else{
                return list.subList((yeshu-1)*10,(yeshu-1)*10+(list.size()%10));
            }
        }
    }
    //返回页数Deployment
    public static List<Deployment> getDeploymentByYeShu(List<Deployment> list, int yeshu){
        if(list.size()<=10){
            return list.subList(0,list.size());
        }else{
            if(list.size()/10>=yeshu){
                return list.subList((yeshu-1)*10,(yeshu-1)*10+10);
            }else{
                return list.subList((yeshu-1)*10,(yeshu-1)*10+(list.size()%10));
            }
        }
    }

    //返回页数HistoricProcessInstance
    public static List<HistoricProcessInstance> getHistoricProcessInstanceByYeShu(List<HistoricProcessInstance> list, int yeshu){
        if(list.size()<=10){
            return list.subList(0,list.size());
        }else{
            if(list.size()/10>=yeshu){
               return list.subList((yeshu-1)*10,(yeshu-1)*10+10);
            }else{
                return list.subList((yeshu-1)*10,(yeshu-1)*10+(list.size()%10));
            }
        }
    }

    //返回页数Task
    public static List<Task> getTaskByYeShu(List<Task> list, int yeshu){
        if(list.size()<=10){
            return list.subList(0,list.size());
        }else{
            if(list.size()/10>=yeshu){
                return list.subList((yeshu-1)*10,(yeshu-1)*10+10);
            }else{
                return list.subList((yeshu-1)*10,(yeshu-1)*10+(list.size()%10));
            }
        }
    }

    //返回页数List<Map<String, Object>>
    public static List<Map<String, Object>> getCountByYeShu(List<Map<String, Object>> list, int yeshu){
        if(list.size()<=10){
            return list.subList(0,list.size());
        }else{
            if(list.size()/10>=yeshu){
                return list.subList((yeshu-1)*10,(yeshu-1)*10+10);
            }else{
                return list.subList((yeshu-1)*10,(yeshu-1)*10+(list.size()%10));
            }
        }
    }


    //按照时间字符串来排序
    public static void SortByStringTime(List<Map<String, Object>> resultList,String key) {
        Collections.sort(resultList, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                String name1= MapUtils.getString(o1, key);
                String name2=MapUtils.getString(o2, key);
                Collator instance = Collator.getInstance(Locale.CHINA);
                if(instance.compare(name1, name2)<0){
                    return  1;
                }else {
                    return -1;
                }
            }
        });
    }

    //判断是否有权限查看流程
    public static boolean getAuthority(List<IdentityLink> identityLinks, String userName, List<String> deps) throws Exception {
        boolean depAndPost = false;
        boolean myuser = false;
        boolean tuichu=false;
        User user = UserService.getInstance().getUserByUserName(userName);
        for (IdentityLink link : identityLinks) {
            if (StringUtils.isNotBlank(link.getGroupId())) {
                int count=0;
                for(String str:deps){
                    if(str.indexOf(link.getGroupId())==-1){
                        count++;
                    }else{
                        depAndPost=true;
                        tuichu=true;
                        break;
                    }
                }
                if(tuichu){
                    break;
                }
                if(count==deps.size()){
                    depAndPost=false;
                }
            }
            if (StringUtils.isNotBlank(link.getUserId())) {
                if (link.getUserId().equals(userName+"("+user.getRealName()+")")) {
                    myuser = true;
                    break;
                }
            }
        }
        return  depAndPost || myuser ;
    }
    //获取userName的部门+职位
    public static List<String> getDepByUserName( List<Map<String, String>> departmentPosts) throws Exception {
        List<String> deps=new ArrayList<>();
        for (int i=0;i<departmentPosts.size();i++) {
            String depAndpost="";
            if(departmentPosts.get(i).get("departments").split(",").length==0){
                depAndpost+=departmentPosts.get(i).get("departments");
            }else{
                String[] split = departmentPosts.get(i).get("departments").split(",");
                for(int j=0;j<split.length;j++){
                    depAndpost+=split[j]+"-";
                }
            }
            deps.add(depAndpost.substring(0,depAndpost.length()-1));
        }
        return  deps;
    }


    //获取userName的部门+职位
    public static List<String> getDepsAndPostByUserName(String userName) throws Exception {
        User user = UserService.getInstance().getUserByUserName(userName);
        UserDetailInfoBean depAndPostInfo = UserService.getInstance().getDepAndPostInfo(user);
        List<Map<String, String>> departmentPosts = depAndPostInfo.getDepartmentPosts()==null?new ArrayList<Map<String, String>>()
                :depAndPostInfo.getDepartmentPosts();
        List<String> deps=new ArrayList<>();
        //[{"jobTitle":"demo","departments":"人力资源,子部门"},{"jobTitle":"sale","departments":"人力资源,子部门,子部门1"}]
        //每一个部门一个map
        for (int i=0;i<departmentPosts.size();i++) {
            String depAndpost="";
            if(departmentPosts.get(i).get("departments").split(",").length==0){
                depAndpost+=departmentPosts.get(i).get("departments");
            }else{
                String[] split = departmentPosts.get(i).get("departments").split(",");
                for(int j=0;j<split.length;j++){
                    depAndpost+=split[j]+"-";
                }
            }
            deps.add(depAndpost+departmentPosts.get(i).get("jobTitle"));
        }
        return  deps;
    }

    public static void judeDirExists(String path) {
        File file = new File(path);
        if (!file.exists()) {
            //boolean mkdir() 创建此抽象路径名指定的目录（文件夹）    注意：如果父路径不存在，则不会创建文件夹
            //boolean mkdirs() ：如果父路径不存在，会自动先创建路径所需的文件夹，即会先创建父路径内容再创建文件夹
            file.mkdirs();
        }
    }

    public static String getFileHashPath(String saveFilename) {
        int hashcode = saveFilename.hashCode();
        int dir1 = hashcode&0xf;  //0--15
        int dir2 = (hashcode&0xf0)>>4;  //0-15
       // return   dir1 + "\\" + dir2 ;
        return   dir1  +File.separator+ dir2 ;

    }
    public static String  uploadAttachment(HttpServletRequest request,MultipartFile file) throws Exception {
        String filePath="";
        String attachmentid="";
        String propertiesPath =request.getSession().getServletContext().getRealPath("/")+"WEB-INF"+File.separator+"classes"+File.separator+"db.properties";
        FileInputStream inputStream = new FileInputStream(propertiesPath);
        try{
            p.load(inputStream);
            String attachment = p.getProperty("attachment");
            String fileHashPath=ProcessUtils.getFileHashPath(file.getOriginalFilename());
            /* windows：
             System.out.println(request.getSession().getServletContext().getRealPath("/"));
            E:\activiti\webroot-xiugai3-17\out\artifacts\webroot_war_exploded\
              System.out.println(System.getProperty("os.name"));
            Windows 10
              System.out.println(filePath+fileHashPath);
            E:\attachment\4\8
            Linux：
            /home/jh/project/apache-tomcat-8.5.20/webapps/webroot/
            Linux
            /home/jh/attachment1/2/6
            * */
            String system = System.getProperty("os.name");
            if(attachment==null){
                if(system.toLowerCase().startsWith("win")){
                    filePath=request.getSession().getServletContext().getRealPath("/").
                            split(":")[0]+":"+File.separator+"attachment"+File.separator;
                }else{
                    filePath=File.separator+"attachment"+File.separator;
                }
                attachmentid=fileHashPath+File.separator+file.getOriginalFilename();
            }else{
                filePath=attachment+File.separator;
                attachmentid=filePath+fileHashPath+File.separator+file.getOriginalFilename();
            }
            ProcessUtils.judeDirExists(filePath+fileHashPath);
            file.transferTo(new File(filePath+fileHashPath+
                    File.separator+file.getOriginalFilename()));
           // System.out.println(filePath+fileHashPath);
            return  attachmentid;
        }
        catch (Exception e){
            throw new Exception("附件上传出错："+e.getMessage());
        }
        finally {
            inputStream.close();
        }

    }
    public static  Map<String,String>  getAttachmentPath(HttpServletRequest request) throws Exception {
        Map<String,String> map=new HashMap<>();
        String path =request.getSession().getServletContext().getRealPath("/")+"WEB-INF"+File.separator+"classes"+File.separator+"db.properties";
        //System.out.println(path);
        FileInputStream inputStream = new FileInputStream(path);
        String s="";
        String system = System.getProperty("os.name");
        if(system.toLowerCase().startsWith("win")) {
             s = request.getSession().getServletContext().getRealPath("/").split(":")[0] +
                    ":" + File.separator + "attachment" + File.separator;
        }else{
            s=File.separator+"attachment"+File.separator;
        }
        try {
            //从输入流中读取属性列表（键和元素对）
            p.load(inputStream);
            String attachment = p.getProperty("attachment");
            if(attachment==null){
                map.put("type","0");
                map.put("defaultPath",s);
                map.put("customPath","");
                return map;
            }else{
                map.put("type","1");
                map.put("defaultPath",s);
                map.put("customPath", p.getProperty("attachment"));
                return map;
            }
        } catch (IOException e) {
            map.put("type","2");
            map.put("message",e.getMessage());
            return map;
        }finally {
               inputStream.close();
        }
    }

    public static String  confirmAttachmentPath(HttpServletRequest request,String setPath) throws Exception {
        String path =request.getSession().getServletContext().getRealPath("/")+"WEB-INF"+File.separator+"classes"+File.separator+"db.properties";
        FileOutputStream outputStream=null;
        try {
            outputStream=new FileOutputStream(path);
            if("".equals(setPath)){
                //删除
                p.remove("attachment");
            }else{
                //修改或新增
                p.setProperty("attachment",setPath);
            }
            p.store(outputStream,"");
            return "1";
        } catch (IOException e) {
            return e.getMessage();
        }finally {
           if(outputStream!=null){
               outputStream.close();
           }
        }
    }

    //判断是否为管理员
    public static boolean isAdmin(String userName) throws Exception {
        UserService instance = UserService.getInstance();
        return   instance.isAdmin(instance.getUserByUserName(userName).getId());
    }

    /*public static void diguiGetLastElement( List<Map<String,Object>>  list,ActivityImpl activity){
        List<PvmTransition> incomingTransitions = activity.getIncomingTransitions();
        for(PvmTransition p:incomingTransitions){
            Map<String,Object> map=new HashMap<>();
            TransitionImpl t = (TransitionImpl) p;
            ActivityImpl last = t.getSource();
            if("userTask".equals(last.getProperty("type"))){
                map.put("id",last.getId());
                map.put("name",last.getProperty("name"));
                list.add(map);
            }
            if(!"startEvent".equals(last.getProperty("type"))){
                diguiGetLastElement(list,last);
            }else{
                break;
            }
        }
    }*/

    //判断流程自动流转与第二次默认通过
    public  static Map<String,Object> autopass(TaskService taskService, String processInstanceId, RepositoryService repositoryService,
      RuntimeService runtimeService,org.springframework.jdbc.core.JdbcTemplate jdbcTemplate,
     HistoryService historyService) throws Exception {
        Map<String,Object> resultMap=new HashMap<>();
        List<Task> list = taskService.createTaskQuery().processInstanceId(processInstanceId).list();
        for(Task t:list){
            UserTask userTask = getUserTask(t.getTaskDefinitionKey(), t.getProcessDefinitionId(), repositoryService);
            String autopass=ProcessUtils.getTaskExectionName(userTask, "autobypass");
            String seccondautobypass=ProcessUtils.getTaskExectionName(userTask, "seccondautobypass");
            if ("true".equals(autopass)){
                String taskid=t.getId();
                String Assignee=t.getAssignee()==null?"":t.getAssignee();
                String taskName=t.getName();
                Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
                if(task!=null && !"".equals(Assignee)){
                    taskService.complete(t.getId());
                    ProcessInstance proInstance = runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
                    if(proInstance==null){
                        jdbcTemplate.update("update act_hi_varinst set TEXT_='6' where PROC_INST_ID_=? and NAME_='process_state'",
                                new Object[]{processInstanceId});
                    }else {
                        runtimeService.setVariable(proInstance.getId(), "process_state", "1");
                    }
                    String realName="";
                    User user = UserService.getInstance().getUserByUserName(Assignee);
                    if(user!=null){
                        realName=user.getRealName();
                    }
                    //这里有可能会有问题，帆软平台把该用户删除了
                    jdbcTemplate.update("insert into proopreateinfo(id,proInstanceId,taskid,opreateName,opreateRealName,opreateTime,opreateType,nodeName,mycomment,attachment) VALUES(?,?,?,?,?,?,?,?,?,?)",
                            new Object[]{ ProcessUtils.getUUID(),processInstanceId,taskid,Assignee,realName,new Date(),7,taskName,"",""});
                    resultMap.put("state","autopass");
                    resultMap.put("data",list);

                   /* ProcessUtils.fixedThreadPool.execute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                sendMessage.getSendMessageUser(taskService,processInstanceId,jdbcTemplate,proname,para,"1",list,task.getProcessDefinitionId(),repositoryService,"autopass");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });*/

                }

            }
            if("true".equals(seccondautobypass)){
              /*  String aa=t.getAssignee();
                List<Map<String, Object>> list1 = jdbcTemplate.queryForList("select * from proopreateinfo where proInstanceId=? and opreateName=? and opreateType='7'",
                        new Object[]{t.getProcessInstanceId(), t.getAssignee()});*/
                List<HistoricTaskInstance> list2 = historyService.createHistoricTaskInstanceQuery().processInstanceId(t.getProcessInstanceId()).
                        taskDefinitionKey(t.getTaskDefinitionKey()).list();
                if(list2.size()>1){
                    String taskid=t.getId();
                    String Assignee=t.getAssignee()==null?"":t.getAssignee();
                    String taskName=t.getName();
                    Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
                    if(task!=null && !"".equals(Assignee)){
                        taskService.complete(t.getId());
                        ProcessInstance proInstance = runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
                        if(proInstance==null){
                            jdbcTemplate.update("update act_hi_varinst set TEXT_='6' where PROC_INST_ID_=? and NAME_='process_state'",
                                    new Object[]{processInstanceId});
                        }else {
                            runtimeService.setVariable(proInstance.getId(), "process_state", "1");
                        }
                        String realName="";
                        User user = UserService.getInstance().getUserByUserName(Assignee);
                        if(user!=null){
                            realName=user.getRealName();
                        }
                        //这里有可能会有问题，帆软平台把该用户删除了
                        jdbcTemplate.update("insert into proopreateinfo(id,proInstanceId,taskid,opreateName,opreateRealName,opreateTime,opreateType,nodeName,mycomment,attachment) VALUES(?,?,?,?,?,?,?,?,?,?)",
                                new Object[]{ ProcessUtils.getUUID(),processInstanceId,taskid,Assignee,realName,new Date(),7,taskName,"",""});
                        resultMap.put("state","seccondautobypass");
                        resultMap.put("data",list);
                    }

                }
            }
        }
        return  resultMap;
    }


    //得到不同的退回状态
    public static String  getBackState(ActivityImpl currentActivity,ActivityImpl destinationActivity,Task task,
                                    HistoryService historyService,RuntimeService runtimeService){
        HistoricActivityInstance historicTask = historyService.createHistoricActivityInstanceQuery().processInstanceId(task.getProcessInstanceId()).
                activityId(destinationActivity.getId()).orderByHistoricActivityInstanceStartTime().desc().list().get(0);
        String currentType=currentActivity.getProperty("multiInstance")==null ? "" : currentActivity.getProperty("multiInstance").toString();
        String destinationType=destinationActivity.getProperty("multiInstance")==null ? "" : destinationActivity.getProperty("multiInstance").toString();
        //并行节点之外的单节点退回到单节点 0
        if(historicTask.getProcessInstanceId().equals(historicTask.getExecutionId()) && task.getExecutionId().equals(task.getProcessInstanceId())){
            System.out.println("并行节点之外的单节点退回到单节点");
            return "0";
        }
        else if(!"parallel".equals(currentType) && !"parallel".equals(destinationType) &&
                !task.getExecutionId().equals(task.getProcessInstanceId()) && !historicTask.getProcessInstanceId().equals(historicTask.getExecutionId()) &&
                task.getExecutionId().equals(historicTask.getExecutionId())){
            //这里有个小问题，如果并行中有并行这个个条件不成立
            System.out.println("并行节点之中的单节点退回到单节点");
            return "1";
        }
        else if( !task.getExecutionId().equals(task.getProcessInstanceId()) && !historicTask.getProcessInstanceId().equals(historicTask.getExecutionId())
                && !"parallel".equals(currentType) && "parallel".equals(destinationType) && !ProcessUtils.ishuiqian_Bingxing(currentActivity,destinationActivity)){
            System.out.println("并行中同根线上单节点退回签");
            return "2";
        }
        else if(!task.getExecutionId().equals(task.getProcessInstanceId()) && !historicTask.getProcessInstanceId().equals(historicTask.getExecutionId())
                && "parallel".equals(currentType) && !"parallel".equals(destinationType)){
            System.out.println("并行中回签退回单节点");
            return "3";
        }
        else if("parallel".equals(currentType) && !"parallel".equals(destinationType) &&
                        ProcessUtils.is_current_huiqian_Bingxing(task.getExecutionId(),runtimeService) &&
                        historicTask.getExecutionId().equals(historicTask.getProcessInstanceId())){
            System.out.println("并行中回签退回并行之外的单节点");
            return "4";
        }
        else if(false){
            System.out.println("并行中回签退回并行之外的会签节点 ");
            return "5";
        }
        else if(task.getExecutionId().equals(task.getProcessInstanceId()) && !"parallel".equals(currentType)
                 && "parallel".equals(destinationType)){
            System.out.println("并行之外的单节点退回到会签 ");
            return "6";
        }
        else if("parallel".equals(currentType) && !ProcessUtils.is_current_huiqian_Bingxing(task.getExecutionId(),runtimeService)
                && historicTask.getExecutionId().equals(historicTask.getProcessInstanceId()) && !"parallel".equals(destinationType)){
            System.out.println("并行之外的会签退回到会单节点");
            return "7";
        }
        else if(!"parallel".equals(currentType) && !"parallel".equals(destinationType) && !task.getExecutionId().equals(task.getProcessInstanceId())
                && historicTask.getExecutionId().equals(historicTask.getProcessInstanceId())){
            System.out.println("并行之中的单节点退出并行之外的单节点");
            return "8";
        }
        else{
            System.out.println("不支持该类型的的退回");
            return "000";
        }


    }

    //判断当前会签节点在并行之中还是在并行之外
    public  static Boolean is_current_huiqian_Bingxing(String currentActivityExecutionId,RuntimeService runtimeService){
        ExecutionEntity execution = (ExecutionEntity)runtimeService.createExecutionQuery().executionId(currentActivityExecutionId).singleResult();
        String parentId = execution.getParentId();
        Execution execution1 = runtimeService.createExecutionQuery().executionId(parentId).singleResult();
        String parentId1 = execution1.getParentId();
        Execution execution11 = runtimeService.createExecutionQuery().executionId(parentId1).singleResult();
        String businessKey = ((ExecutionEntity) execution11).getBusinessKey();
        if(businessKey==null || "".equals(businessKey)){
            //System.out.println("并行节点会签");
            return true;
        }else{
           // System.out.println("单节点会签");
            return false;
        }
    }

    //判断目标会签节点在并行之中还是在并行之外
    public  static Boolean ishuiqian_Bingxing(ActivityImpl currentActivity, ActivityImpl destinationActivity){
        List<String> list =new ArrayList<>();
        huiqianIsBingxing(currentActivity,destinationActivity,list);
        if(list.contains("parallelGateway")){
            //会签节点在并行之外
            return true;
        }else {
            //会签节点在并行之中
            return false;
        }

    }

    //判断目标会签节点在并行之中还是在并行之外
    public static void huiqianIsBingxing(ActivityImpl currentActivity,ActivityImpl destinationActivity,List<String> list){
        List<PvmTransition> incomingTransitions = currentActivity.getIncomingTransitions();
        //parallelGateway
        for(PvmTransition p:incomingTransitions){
            TransitionImpl t = (TransitionImpl) p;
            ActivityImpl last = t.getSource();
            if(!destinationActivity.getId().equals(last.getId())){
                list.add(last.getProperty("type").toString());
                huiqianIsBingxing(last,destinationActivity,list);
            }else{
                break;
            }
        }
    }

    public static boolean isFaBu(String  depid,RepositoryService repositoryService){
        Model model = repositoryService.createModelQuery().deploymentId(depid).singleResult();
        String state=model.getCategory();
        if(!"update".equals(state)){
            return  true;
        }else{
            return  false;
        }
    }
  /*  public static String getParamRegEx(String text){
        *//*String regEx="[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";*//*
        String regEx="[{}$]";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(text);
        return m.replaceAll("").trim();
    }*/
    //获取当前节点办理人是否是变量，是否设置了下个办理人和递归获取所有条件分支条件
    public static List<Map<String,Object>> getElementCondition(String taskid, String processDefinitionID, RepositoryService repositoryService, TaskService taskService){
        List<Map<String,Object>> condition=new ArrayList<>();
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(processDefinitionID, repositoryService);
        String activitiId="";
        if("".equals(taskid) || taskid==null){
            activitiId=ProcessUtils.getApplicationActivitiId(processDefinitionID,repositoryService);
        }else{
            activitiId=taskService.createTaskQuery().taskId(taskid).singleResult().getTaskDefinitionKey();
        }
        for(FlowElement e : flowElements){
            if(e.getId().equals(activitiId)){
                UserTask task=(UserTask)e;
                //获取办理人变量
                if("".equals(taskid) || taskid==null){
                    Map<String,Object> mapAssignee=new HashMap<>();
                    String assignee = task.getAssignee();
                    mapAssignee.put("tioajianParam",assignee.substring(assignee.indexOf("{") + 1, assignee.indexOf("}")));
                  /*  mapAssignee.put("tioajianParam",getParamRegEx(assignee));*/
                    mapAssignee.put("tioajianValue","");
                    mapAssignee.put("mytype","Assgin");
                    condition.add(mapAssignee);
                }
                //获取是否设置了下个根据模板设置下个任务节点办理人
                String setNextAssgin=getTaskExectionName(task,"issetassgin");
                if(!"".equals(setNextAssgin)){
                    Map<String,Object> map=new HashMap<>();
                    map.put("tioajianParam",setNextAssgin);
                    map.put("tioajianValue","");
                    map.put("mytype","setNextAssgin");
                    condition.add(map);
                }
                //获取申请节点下一步是否有条件,申请节点只可能有一条出方向的线

                addCondtions(task.getOutgoingFlows().get(0).getTargetRef(), processDefinitionID, repositoryService,condition);
                break;
            }
        }//获取条件

        return  condition;
    }
    //递归获取条件网关的条件，因为有可能两个条件网关连续使用
    public static void   addCondtions(String targetRef,String processDefinitionID,
                                      RepositoryService repositoryService,List<Map<String,Object>> condition){
        // System.out.println("我进来了");
        ActivityImpl activity = getActivityImplByActivitiId(targetRef, processDefinitionID, repositoryService);
        String nextType = activity.getProperty("type").toString();
        //如果是条件网关则获取条件，不是不获取
        if ("exclusiveGateway".equals(nextType) || "inclusiveGateway".equals(nextType)) {
            List<PvmTransition> PvmTransitions = activity.getOutgoingTransitions();
            if(PvmTransitions.size()>1){
                List<SequenceFlow> sequenceFlowsByPvmTransition = getSequenceFlowsByPvmTransition(PvmTransitions, processDefinitionID, repositoryService);
                for(SequenceFlow sp:sequenceFlowsByPvmTransition){
                    Map<String,Object> map=new HashMap<>();
                    String expressions = sp.getConditionExpression();
                    if(expressions!=null && !"".equals(expressions)){
                        String sequenceFlowCondition = expressions.substring(expressions.indexOf("{") + 1, expressions.indexOf("}")).trim().split("==")[0];
                        //String sequenceFlowCondition = getParamRegEx(expressions).split("==")[0];
                        map.put("tioajianParam",sequenceFlowCondition);
                        map.put("frfunction",getSequenceFlowExectionName(sp,"frfunction"));
                        map.put("mytype","sequenceFlow");
                        condition.add(map);
                        addCondtions(sp.getTargetRef(),processDefinitionID,repositoryService,condition);
                    }
                }
            }
        }
    }
    //获取条件
    public static  void getCondition(String processDefinitionID,String taskid,RepositoryService repositoryService,
                                     TaskService taskService,String seesionid,HttpServletRequest request, Map<String, Object> map,
                                     Map<String, Object> resultMap,String username) throws Exception {
        String prodeid="";String activitiId="";
        List<Map<String, Object>> condition=new ArrayList<>();
        //condition获取条件参数 获取条件参数
        //[{mytype=Assgin, tioajianParam=asd, tioajianValue=},
        // {mytype=sequenceFlow, tioajianParam=act_16b588aef8a840e1b8352b4e68b521dc, frfunction=if(B7>=2,true,false)},
        // {mytype=sequenceFlow, tioajianParam=act_bdf2c04e4b834508b61f9387f57e9614, frfunction=if(B7<2,true,false)},
        // {mytype=setNextAssgin, tioajianParam=B7}]]
        if("".equals(taskid)&&!"".equals(processDefinitionID)){
            prodeid=processDefinitionID;
            condition = ProcessUtils.getElementCondition("",processDefinitionID, repositoryService,taskService);
            activitiId = ProcessUtils.getApplicationActivitiId(prodeid, repositoryService);
        }else if(!"".equals(taskid)&&"".equals(processDefinitionID)){
            Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
            prodeid=task.getProcessDefinitionId();
            condition = ProcessUtils.getElementCondition(taskid,task.getProcessDefinitionId(), repositoryService,taskService);
            activitiId=task.getTaskDefinitionKey();
        }
        CalculatorProvider calculator = CalculatorKit.createCalculator(seesionid, null);
        //System.out.println("seesionid:"+seesionid);
        //FineToolsProcessor tools = FineServerKit.getToolsProcessorInstance();
       // System.out.println(condition);

        for(Map<String, Object> conditions:condition){
            String type=conditions.get("mytype").toString();
            if("setNextAssgin".equals(type)){
               /* List<Map<String,Object>>  list=new ArrayList<>();*/
                Map<String,Object> mp=new HashMap<>();

                ActivityImpl activity = ProcessUtils.getActivityImplByActivitiId(activitiId,prodeid, repositoryService);
                //递归获取下个任务节点的办理人变量
                ProcessUtils.getNextUserTaskElement(mp,activity,prodeid,repositoryService);
                //mp是下个节点信息
                if("assgin".equals(mp.get("type").toString())){
                    //单个人
                    //Object tioajianParam = calculator.evalValue(conditions.get("tioajianParam").toString());
                    String nextAssign  = (String)calculator.evalValue(conditions.get("tioajianParam").toString());
                    // String nextAssign = (String)tools.evalFormula(conditions.get("tioajianParam").toString(), seesionid, request, null);
                    if(!"".equals(mp.get("assgin").toString())){
                        map.put(mp.get("assgin").toString(), nextAssign);
                        resultMap.put(mp.get("assgin").toString(), nextAssign);
                    }else{
                        map.put(conditions.get("tioajianParam").toString(), nextAssign);
                        resultMap.put(conditions.get("tioajianParam").toString(), nextAssign);
                    }
                    //以下代码之前是没有的
                    //单个人
                   // String s = conditions.get("tioajianParam").toString();
                  //  map.put(getParamRegEx(s), nextAssign);
                   // resultMap.put(getParamRegEx(s), nextAssign);

                   // System.out.println("是任务节点========>"+m.replaceAll("").trim()+","+nextAssign);
                }else if("huiqian".equals(mp.get("type").toString())){
                    //会签
                    //String nextAssignHuiQian =  (String)tools.evalFormula(conditions.get("tioajianParam").toString(), seesionid, request, null);
                 /*  if("".equals(mp.get("huiqian").toString())){*/
                       String nextAssignHuiQian =  (String)calculator.evalValue(conditions.get("tioajianParam").toString());
                       String[] value = nextAssignHuiQian.split(",");
                       List<String> huiqians=new ArrayList<>();
                       for(int ii=0;ii<value.length;ii++){
                          huiqians.add(value[ii]);
                       }
                       String s = mp.get("huiqian").toString();
                       map.put(s,huiqians);
                       resultMap.put(mp.get("huiqian").toString(),huiqians);
                      // System.out.println(map);
                  // }
                    /*for(Map<String,Object> mapList:list){
                        map.put(mapList.get("huiqian").toString(),huiqians);
                        resultMap.put(mapList.get("huiqian").toString(),huiqians);
                    }*/
                }else{
                    //以下代码之前是没有的，这里的作用就是设置下个办理人时，下个节点不是任务节点，还是把变量的值设置进去
                    String nextAssign  = (String)calculator.evalValue(conditions.get("tioajianParam").toString());
                    //单个人
                    //String s = conditions.get("tioajianParam").toString();
                    map.put(conditions.get("tioajianParam").toString(), nextAssign);
                   // System.out.println("不是任务节点========>"+m.replaceAll("").trim()+","+nextAssign);
                    resultMap.put(conditions.get("tioajianParam").toString(), nextAssign);
                }
            }
            else if("sequenceFlow".equals(type)){
                //条件
               // boolean fr = (boolean)tools.evalFormula(conditions.get("frfunction").toString(), seesionid, request, null);
                boolean fr = (boolean)calculator.eval(conditions.get("frfunction").toString());
                map.put(conditions.get("tioajianParam").toString(),fr);

                resultMap.put(conditions.get("tioajianParam").toString(),fr);
            }else{
                //申请节点办理人变量赋值
                map.put(conditions.get("tioajianParam").toString(),username);
                resultMap.put(conditions.get("tioajianParam").toString(),username);
            }
        }

    }

    //递归得到当前结点下个任务节点
    public static void getNextUserTaskElement(Map<String,Object> map,ActivityImpl activity,String processDefinitionID,RepositoryService repositoryService ){
        Collection<FlowElement> flowElements = getFlowElements(processDefinitionID, repositoryService);
        List<PvmTransition> outgoingTransitions = activity.getOutgoingTransitions();
        for(PvmTransition p:outgoingTransitions){
            //  Map<String,Object> map=new HashMap<>();
            TransitionImpl t = (TransitionImpl) p;
            ActivityImpl next = t.getDestination();
            if("userTask".equals(next.getProperty("type"))){
                String property=next.getProperty("multiInstance")==null ? "" : next.getProperty("multiInstance").toString();
                if("parallel".equals(property) || "sequential".equals(property)) {
                    map.put("id", next.getId());
                    map.put("name", next.getProperty("name"));
                    FlowElement element = null;
                    for (FlowElement f : flowElements) {
                        if (f.getId().equals(next.getId())) {
                            element = f;
                            break;
                        }
                    }
                    UserTask userTask= (UserTask)element;
                    String huiQian = getTaskExectionName(userTask, "huiQian").trim();
                    MultiInstanceLoopCharacteristics loopCharacteristics = userTask.getLoopCharacteristics();
                    //这里如果A节点的直接下个节点B会签节点，添加会签那里设不设置都可以
                    map.put("huiqian",loopCharacteristics.getInputDataItem());
                    map.put("type", "huiqian");
                    //  list.add(map);
                }else{
                    TaskDefinition task= (TaskDefinition)next.getProperty("taskDefinition");
                    Set<Expression> candidateUserIdExpressions = task.getCandidateUserIdExpressions();
                    String expressionText = "";
                    if(task.getAssigneeExpression()!=null){
                        //办理人那里设置了变量
                        expressionText = task.getAssigneeExpression().getExpressionText();
                    }else{
                        //抢占式那里设置了变量
                        if(candidateUserIdExpressions.size()>0){
                            for(Expression e : candidateUserIdExpressions){
                                expressionText=e.getExpressionText();
                                break;
                            }
                        }
                    }
                    String assgin="";
                    if(expressionText.indexOf("{")>0){
                        assgin  = expressionText.substring(expressionText.indexOf("{") + 1, expressionText.indexOf("}"));
                    }
                    map.put("id", next.getId());
                    map.put("name", next.getProperty("name"));
                    map.put("assgin", assgin);
                    map.put("type", "assgin");
                }
            }else{
                map.put("type", "none");
                //递归
                // getNextUserTaskElement(list,next,processDefinitionID,repositoryService);
            }

        }
    }


    //获取当前流程的办理人、节点名称、表单模板
    public static Map<String,String>  getCurrentAssignee(TaskService taskService,String proInstanceId){
        Map<String,String> map=new HashMap<>();
        try {
            String assignee = "";
            String node="";
            UserService instance = UserService.getInstance();
            List<Task> list = taskService.createTaskQuery().processInstanceId(proInstanceId).list();
            for (Task t : list) {
                node+=t.getName()+",";
                if (t.getAssignee() != null) {
                    User user = instance.getUserByUserName(t.getAssignee().trim());
                    if(user!=null){
                        assignee += user.getRealName()+ ",";
                    }
                } else {
                    List<IdentityLink> identityLinksForTask = taskService.getIdentityLinksForTask(t.getId());
                    for (IdentityLink d : identityLinksForTask) {
                        User user1 = instance.getUserByUserName(d.getUserId());
                        if(user1!=null){
                            assignee += user1.getRealName()+ ",";
                        }
                    }
                }
            }
           // System.out.println(assignee);
            map.put("assignee",assignee.length() == 0 ? "" : assignee.substring(0, assignee.length() - 1));
            map.put("node",node.length() == 0 ? "" : node.substring(0, node.length() - 1));
           //System.out.println(map);
            return map;
        }catch (Exception e){
            map.put("assignee","");
            map.put("node","");
            return map;
        }
    }

    //后台提交模板数据
    public static String submitCpt(String sessionID){
        String result="";
        try {
            if(!"".equals(sessionID) && sessionID!=null){
                ReportSessionIDInfor sessionIDInfor3 = SessionPoolManager.getSessionIDInfor(sessionID, ReportSessionIDInfor.class);
                if (sessionIDInfor3 != null) {
                    TemplateWorkBook templateBook = sessionIDInfor3.getWorkBookDefine();
                    Map<String, Object> map = ReportWebUtils.dealWithReportParameters(sessionIDInfor3.getWorkBookDefine(), sessionIDInfor3.getParameterMap4Execute());
                    SubmitHelper.submit((WriteWorkBook) sessionIDInfor3.getWorkBook2Show(), templateBook, map);
                    return  "success";
                } else {
                   return "sessionIDInfo对象为null";
                }
            }else{
                return "sessionID为空";
            }
        }
        catch (Exception e){
            return e.getMessage()+"";
        }
    }

    //发送短信
    public static void sendMessage(TaskService taskService, String processInstanceId, JdbcTemplate jdbcTemplate,String proname,Map<String,String> para,String state,
                                   List<Task> lists,String processDefinitionID,RepositoryService repositoryService,String type){
        ProcessUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    sendMessage.getSendMessageUser(taskService,processInstanceId,jdbcTemplate,proname,para,state,lists,
                            processDefinitionID,repositoryService,type);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }







































    //根据activitId获取FlowElement
    public static FlowElement getFlowElementByActivitId(String prodefinedid,String activitId,RepositoryService repositoryService){
        Collection<FlowElement> flowElements = ProcessUtils.getFlowElements(prodefinedid,repositoryService);
        FlowElement element= null;
        for (FlowElement flowElement : flowElements) {
            if (flowElement.getId().equals(activitId)) {

                break;
            }
        }
        return  element;
    }




    public static String getUserNameAndUserRealNameByFR(HttpServletRequest request){
        return LoginService.getInstance().getCurrentUserNameFromRequest(request);
    }
    public static String getUserNameByFR(HttpServletRequest request){
        String a=getUserNameAndUserRealNameByFR(request);
        return getUserNameAndUserRealNameByFR(request).split("\\(")[1].replaceAll("\\)","");
    }

    public static String getUserRealNameByFR(HttpServletRequest request){
        return getUserNameAndUserRealNameByFR(request).split("\\(")[0];

    }









  public static List<Map<String,Object>> getLastBackNode(String processDefinitionId, RepositoryService repositoryService, String activitiId,
                              HistoryService historyService,String proInstanceId){
      ReadOnlyProcessDefinition processDefinitionEntity=(ReadOnlyProcessDefinition)repositoryService.
              getProcessDefinition(processDefinitionId);
      BpmnModel bpmnModel = repositoryService.getBpmnModel(processDefinitionId);
      Process mainProcess = bpmnModel.getMainProcess();
      Collection<FlowElement> flowElements = mainProcess.getFlowElements();

      ActivityImpl selfActivity = null;
      for (FlowElement flowElement : flowElements) {
          if (flowElement.getId().equals(activitiId)) {
              selfActivity = (ActivityImpl)processDefinitionEntity.findActivity(flowElement.getId());
          }
      }

      List<PvmTransition> ingoingFlows = selfActivity.getIncomingTransitions();


      Set<Map<String,Object>> result=new HashSet<Map<String, Object>>();

      getLastNode(ingoingFlows, result, processDefinitionEntity);

      List<HistoricTaskInstance> list = historyService.createHistoricTaskInstanceQuery().processInstanceId(proInstanceId).finished().orderByHistoricTaskInstanceStartTime().asc().list();

      List<Map<String,Object>> list1=new ArrayList<Map<String, Object>>();
      List<Map<String,Object>> list2=new ArrayList<Map<String, Object>>();
      List<Map<String,Object>> list_result=new ArrayList<Map<String, Object>>();
      for(int i=0;i<list.size();i++){
          Map<String,Object> map=new HashMap<String,Object>();
          map.put("activitiID",list.get(i).getTaskDefinitionKey());
          map.put("activitiName",list.get(i).getName());
          list1.add(map);
      }
      for (int i = 0; i < list1.size(); i++) {
          if (!list2.contains(list1.get(i))) {
              list2.add(list1.get(i));

          }
      }

      for(int i=0;i<list2.size();i++){
          String activitiID=list2.get(i).get("activitiID").toString();
          for(Map<String,Object> map : result){
              if(map.get("activitiID").toString().equals(activitiID)){
                  list_result.add(list2.get(i));
              }
          }
      }

      return list_result;
  }

    public static Set<Map<String,Object>> getLastNode( List<PvmTransition> ingoingFlows,  Set<Map<String,Object>> result,ReadOnlyProcessDefinition processDefinitionEntity){
        for(PvmTransition flow : ingoingFlows){

            String activitiid=flow.getSource().getId();

            ActivityImpl activity = (ActivityImpl)processDefinitionEntity.findActivity(activitiid);
            if("startEvent".equals(activity.getProperty("type"))){
                return result;
            }else {
                if("userTask".equals(activity.getProperty("type"))){
                    Map<String,Object> map=new HashMap<String, Object>();
                    map.put("activitiID", activity.getId());
                    map.put("activitiName", activity.getProperty("name"));
                    result.add(map);
                }
                getLastNode(activity.getIncomingTransitions(),result,processDefinitionEntity);
                // return result;
            }

        }
        return result;
    }

    public static  String  getProName(String str){
       return  str.substring(0, str.indexOf("$")==-1?str.length(): str.indexOf("$") ).trim();
    }
    public static String  getProNameParam(String str){

        return  str.substring(str.indexOf("{")==-1?0:str.indexOf("{") + 1, str.indexOf("}")==-1?0:str.indexOf("}")).trim();
    }

    /**
     * 判断文件格式
     * @param file
     * @return
     */
    public static boolean checkFileFormat(MultipartFile file) {
        if (file == null) {
            return false;
        }
        try {
            String type = ProcessUtils.getFileType(file.getInputStream());
            if(FileType.TXT.getValue().equals(type)){//TXT,DOCX
                return true;
            }
            if(FileType.XLS_DOC.getValue().equals(type)){//PPT,DOC,XLS
                return true;
            }
            if(FileType.XLSX_DOCX.getValue().equals(type)){//XLSX
                return true;
            }
            if(FileType.PDF.getValue().equals(type)){//PDF
                return true;
            }
            if(FileType.PNG.getValue().equals(type)){//PNG
                return true;
            }
            if(FileType.JPEG.getValue().equals(type)){//JPG
                return true;
            }
        }catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return false;
    }
    public static String getFileType(InputStream is) throws Exception{
        FileType fileType = ProcessUtils.getType(is);
        if(fileType!=null){
            return fileType.getValue();
        }
        return null;
    }


    /**
     * 获取文件类型类
     * @param // filePath 文件路径
     * @return 文件类型
     */
    public static FileType getType(InputStream is) throws IOException {
        String fileHead = ProcessUtils.getFileContent(is);
        if (fileHead == null || fileHead.length() == 0) {
            return null;
        }
        fileHead = fileHead.toUpperCase();
        FileType[] fileTypes = FileType.values();
        for (FileType type : fileTypes) {
            if (fileHead.startsWith(type.getValue())) {
                return type;
            }
        }
        return null;
    }
    public static String getFileContent(InputStream is) throws IOException {
        byte[] b = new byte[28];
        InputStream inputStream = null;
        try {
            is.read(b, 0, 28);
        } catch (IOException e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    throw e;
                }
            }
        }
        return ProcessUtils.bytesToHexString(b);
    }
    public static String bytesToHexString(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder();
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }




}
