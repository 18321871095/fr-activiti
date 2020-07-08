package com.fr.tw.process;

import com.fr.decision.authority.data.User;
import com.fr.decision.webservice.v10.user.UserService;
import com.fr.tw.util.JSONResult;
import com.fr.tw.util.ProcessUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.swing.filechooser.FileSystemView;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class test {
    @RequestMapping("/ding")
    @ResponseBody
    public String ding(){
        try{
            UserService instance = UserService.getInstance();

            User lily = instance.getUserByUserName("Lily");
           /* DingTalkMessageBody message=new DingTalkMessageBody();
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
            dingTalkMessage.sendToDecUser(list,dingTalkAgent);*/
            System.out.println(lily.toString());
            return lily.toString();
        }
        catch (Exception e){
            e.printStackTrace();
            return  e.getMessage()+"";
        }
    }
   /* @RequestMapping("/t")
    @ResponseBody
    public JSONResult t(HttpServletRequest request, String path) throws Exception {
        JSONResult jr=new JSONResult();
        List<Map<String,String>> list=new ArrayList<>();
        String message="";
        try {
            if ("".equals(path) || path == null) {
                File[] roots = File.listRoots();
               // FileSystemView sys = FileSystemView.getFileSystemView();
                for (int i = 0; i < roots.length; i++) {
                  *//*  if (!sys.getSystemTypeDescription(roots[i]).equals("本地磁盘")) {
                        continue;
                    }*//*
                    Map<String, String> map = new HashMap<>();
                    map.put("name", roots[i].getAbsolutePath());
                    map.put("path", roots[i].getAbsolutePath());
                    map.put("type", isHaveSonDirectory(roots[i]));
                    list.add(map);
                }
            } else {
                File f = new File(path);
                File[] files = f.listFiles();
                if(files!=null){
                    for (File ff : files) {
                        if (ff.isDirectory() && !ff.isHidden()) {
                            message=ff.getAbsolutePath();
                            Map<String, String> map1 = new HashMap<>();
                            map1.put("name", ff.getName());
                            map1.put("path", ff.getAbsolutePath());
                            map1.put("type", isHaveSonDirectory(ff));
                            list.add(map1);
                        }
                    }
                }
            }
            jr.setMsg("success");
            jr.setResult(list);
            return jr;
        }
        catch (Exception e){
            jr.setMsg("fail");
            jr.setResult(message+","+e.getMessage());
            return jr;
        }
    }

    public String isHaveSonDirectory(File file){
        //0：没有子文件夹 1：有子文件夹
        String flag="0";
        File[] files = file.listFiles();
        if(files==null){
            flag="0";
        }else{
            for(File f: files){
                if(f.isDirectory()){
                    flag="1";
                    break;
                }
            }
        }
        return flag;
    }*/




    public void wenjian(File f,List<Map<String,String>> list){
        System.out.println(f.getAbsolutePath());
        Map<String,String> map=new HashMap<>();
        map.put("id",f.getAbsolutePath());
        map.put("pId",f.getParent());
        if("".equals(f.getName())){
            map.put("text",f.getPath());
        }else{
            map.put("text",f.getName());
        }
        map.put("path",f.getAbsolutePath());
        list.add(map);
        File[] files = f.listFiles();
        for(File ff :files){
            if(ff.isDirectory()&&!ff.isHidden()){
                wenjian(ff,list);
            }
        }
    }
}
