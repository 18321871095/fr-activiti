package com.fr.tw.test;




import com.fr.decision.authority.data.User;
import com.fr.decision.webservice.v10.user.UserService;

import com.fr.tw.util.ProcessUtils;
import org.activiti.bpmn.model.MultiInstanceLoopCharacteristics;
import org.activiti.bpmn.model.UserTask;
import org.activiti.engine.HistoryService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.TaskService;
import org.activiti.engine.delegate.Expression;
import org.activiti.engine.history.HistoricVariableInstance;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.impl.task.TaskDefinition;
import org.activiti.engine.impl.util.json.JSONObject;
import org.activiti.engine.task.TaskQuery;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.math.BigInteger;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class test {
    public static void main(String[] args) throws Exception {

      /*  ApplicationContext ap = new ClassPathXmlApplicationContext(new String[]{"spring-activiti.xml"});
            RepositoryService repositoryService = (RepositoryService) ap.getBean("repositoryService");
            TaskService taskService = (TaskService) ap.getBean("taskService");
        HistoryService historyService=(HistoryService)ap.getBean("historyService");
        List<HistoricVariableInstance> hisVarList = historyService.createHistoricVariableInstanceQuery().
                processInstanceId("120001").list();
        for(HistoricVariableInstance h:hisVarList){
            if("asdas".equals(h.getVariableName())){
                System.out.println(h.getValue());
            }
        }*/
/*
      String str="请将流程图${B5}";
        String trim = str.substring(str.indexOf("{") == -1 ? 0 : str.indexOf("{") + 1, str.indexOf("}") == -1 ? 0 : str.indexOf("}")).trim();
        System.out.println(trim);
*/
        System.out.println("张三,李四，王五".contains("张三,李四"));

        //System.out.println(ProcessUtils.getParamRegEx(assignee));
       /* List<ActivityImpl> processActivitis = ProcessUtils.getProcessActivitis("process:14:117504", repositoryService);
        for(ActivityImpl activity:processActivitis){
            if("userTask".equals(activity.getProperty("type"))){
                TaskDefinition taskDefinition = (TaskDefinition) activity.getProperty("taskDefinition");
                //System.out.println(activity.getProperty("multiInstance"));
                //System.out.println(activity.getProperty("type"));
                Object name = activity.getProperty("name");
                String s = taskDefinition.getAssigneeExpression() == null ? "" : taskDefinition.getAssigneeExpression().getExpressionText();

                UserTask userTask = ProcessUtils.getUserTask("sid-DF9A4FB9-4BDD-4C12-A695-62083B503F17", "process:14:117504", repositoryService);
                String[] huiQians=ProcessUtils.getTaskExectionName(userTask,"huiQian").trim().split(",");
                List<String> huiqian=new ArrayList<>();
                for (String ss:huiQians) {
                    if(!"".equals(ss.trim())){
                        huiqian.add(ss);
                    }
                }
                Set<Expression> candidateUserIdExpressions = taskDefinition.getCandidateUserIdExpressions();
                Expression ee=null;
               for(Expression e: candidateUserIdExpressions){
                   ee=e;
               }
                String s1 = ee == null ? "" : ee.getExpressionText();
                System.out.print(name+","+s+","+ taskDefinition.getCandidateUserIdExpressions()+","+huiqian+","+activity.getId()+","+taskDefinition.getKey());

                System.out.println();

            }
            //开始节点 ${asdas},[]  单任务：Billy,[] 抢占式:'',[sunlin, Tom, Billy] 动态单任务：${aaa},[]   动态抢占式:'',[${B7}]
            //会签：${list},[],[Billy,  sunlin,  Tom, eoco,  Anna,  demo] 动态会签 ${list},[],[${B1}]

          //  System.out.println(taskDefinition.getAssigneeExpression().getExpressionText());
        }*/
        /*try{
            DingTalkMessageBody message=new DingTalkMessageBody();
            message.setTitle("我是测试哦");
            message.setLink("https://www.baidu.com/?tn=02003390_2_hao_pg");
            message.setContent("我是内容");

            DingTalkAgent dingTalkAgent = new DingTalkAgent();
            dingTalkAgent.setAgentId("701731015");
            dingTalkAgent.setAppKey("dingie9en3pn2kfrdbfm");
            dingTalkAgent.setSecret("xE3OLm2vhkiLHAL2P-SAUfyrkwlokrhEdQP6yKWBTogPnY5yJ9Vn4YjXPNj3lM-1");
            dingTalkAgent.setCorpId("ding8266fd37f54f82c335c2f4657eb6378f");

            List<String> list=new ArrayList<>();
            list.add("jianghan");

            DingTalkMessage dingTalkMessage = DingTalkMessage.create(message, dingTalkAgent);
            dingTalkMessage.sendToDecUser(list,dingTalkAgent);

        }
        catch (Exception e){
            e.printStackTrace();
        }*/
    }


}
