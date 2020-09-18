package com.fr.tw.test;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fr.base.Formula;
import com.fr.base.ScriptFormula;
import com.fr.decision.authority.data.User;
import com.fr.decision.system.bean.message.MessageUrlType;
import com.fr.decision.webservice.bean.user.UserDetailInfoBean;
import com.fr.decision.webservice.v10.login.LoginService;
import com.fr.decision.webservice.v10.message.MessageService;
import com.fr.decision.webservice.v10.user.UserService;
import com.fr.json.JSONObject;
import com.fr.script.Calculator;
import com.fr.stable.StringUtils;
import com.fr.stable.UtilEvalError;
import com.fr.swift.query.info.bean.element.CalculatedFieldBean;
import com.fr.third.v2.org.apache.poi.ss.formula.FormulaParseException;
import com.fr.tw.custom.BpmnJsonConverterProperties;
import com.fr.tw.custom.CustomSequenceFlowJsonConverter;
import com.fr.tw.custom.CustomUserTaskJsonConverter;
import com.fr.tw.rsa.Base64Utils;
import com.fr.tw.rsa.LicenseGenerator;
import com.fr.tw.rsa.RSAUtils;
import com.fr.tw.util.*;
import com.fr.third.springframework.context.config.*;
import com.fr.view.StringAnalysisGroup;
import org.activiti.bpmn.converter.BpmnXMLConverter;
import org.activiti.bpmn.model.*;
import org.activiti.editor.language.json.converter.BpmnJsonConverter;
import org.activiti.engine.*;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.impl.cfg.IdGenerator;
import org.activiti.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.activiti.engine.impl.context.Context;
import org.activiti.engine.impl.interceptor.CommandContext;
import org.activiti.engine.impl.jobexecutor.TimerStartEventJobHandler;
import org.activiti.engine.impl.persistence.entity.*;
import org.activiti.engine.impl.pvm.PvmActivity;
import org.activiti.engine.impl.pvm.PvmTransition;
import org.activiti.engine.impl.pvm.ReadOnlyProcessDefinition;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.impl.pvm.process.TransitionImpl;
import org.activiti.engine.impl.task.TaskDefinition;
import org.activiti.engine.repository.Model;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.Task;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;
import com.fr.general.FArray;
import java.io.File;
import java.io.FileInputStream;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.fr.third.springframework.web.servlet.config.MvcNamespaceHandler;
import  org.springframework.beans.factory.xml.NamespaceHandler;

import javax.swing.filechooser.FileSystemView;

public class mytest {

    public static void main(String[] args) throws Exception {
        try{
           // ApplicationContext ap = new ClassPathXmlApplicationContext(new String[]{"spring-activiti.xml"});
            //ApplicationContext ap = new ClassPathXmlApplicationContext(new String[]{"spring-activiti.xml", "spring-mvc.xml"});
          /*  RepositoryService repositoryService = (RepositoryService) ap.getBean("repositoryService");
            RuntimeService runtimeService = (RuntimeService) ap.getBean("runtimeService");
            TaskService taskService = (TaskService) ap.getBean("taskService");
            HistoryService historyService = (HistoryService) ap.getBean("historyService");
            IdentityService identityService = (IdentityService) ap.getBean("identityService");
            ManagementService managerService = (ManagementService) ap.getBean("managementService");
            FormService formService = (FormService) ap.getBean("formService");
            JdbcTemplate jdbcTemplate = (JdbcTemplate) ap.getBean("jdbcTemplate");

            runtimeService.setVariable("50126","process_state","77");
            runtimeService.deleteProcessInstance("50126","adminganyu");*/
           try{
               Map<String,Object> resultMap=new HashMap<>();
               System.out.println(resultMap.get("123")==null);
           }catch (Exception e){
               System.out.println( e.getMessage());
           }

        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    public void wenjian(File f,List<Map<String,String>> list){
        Map<String,String> map=new HashMap<>();
        map.put("id",f.getAbsolutePath());
        map.put("pId",f.getParent());
        map.put("text",f.getName());
        map.put("path",f.getAbsolutePath());
        list.add(map);
        File[] files = f.listFiles();
        for(File ff :files){
            if(ff.isDirectory()&&!ff.isHidden()){
                wenjian(ff,list);
            }
        }
    }


    public static void aa(){
        if(true){
            if(true){
                System.out.println("1");
                if(true){
                    return ;
                }
                System.out.println("222");
            }
        }
        System.out.println("2");
    }



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

    //得到节点条件值
    public static String getExtensionElements(Map<String, List<ExtensionElement>> extensionElements, String name){
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
    /*得到任务节点扩展属性名*/
    public static String getTaskExectionName(UserTask task,String name){
        Map<String, List<ExtensionElement>> extensionElements = task.getExtensionElements();
        return getExtensionElements(extensionElements,name);
    }
}
