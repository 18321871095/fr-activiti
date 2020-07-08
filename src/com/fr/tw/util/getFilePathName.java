package com.fr.tw.util;

import javax.servlet.http.HttpServletRequest;
import java.io.File;

public class getFilePathName {
    public static String  getFileName(HttpServletRequest request){
        String path="";
        String realPath = request.getSession().getServletContext().getRealPath("/WEB-INF/plugins/");
        File file=new File(realPath);
        String[] list = file.list();
            for(String s:list){
                if(s.indexOf("com.fr.plugin.workflow.engine")!=-1){
                    path=realPath+File.separator+s+File.separator+"workflow-engine.lic";
                }
            }
            File ff=new File(path);
       // System.out.println(ff.exists());
        //System.out.println("lic路径："+path);
        return path;
    }
}
