package com.fr.tw.test;

import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricProcessInstanceQuery;
import org.activiti.engine.impl.persistence.entity.ExecutionEntity;
import org.activiti.engine.runtime.ProcessInstance;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Properties;

public class task implements Runnable {
    public static void main(String[] args) throws Exception {
        Properties p = new Properties();
        FileOutputStream   outputStream=new FileOutputStream("E:\\activiti\\webroot-xiugai3-17\\out\\artifacts\\webroot_war_exploded\\WEB-INF\\classes\\db.properties");
        p.remove("attachment11");
        p.store(outputStream,"");
        outputStream.close();
        System.out.println("success");
    }


    @Override
    public void run() {
        Properties p = new Properties();
        // String path =request.getSession().getServletContext().getRealPath("/")+"WEB-INF"+File.separator+"classes"+File.separator+"db.properties";
        //System.out.println(path);

        FileOutputStream outputStream=null;
        try {

            /*System.out.println(Thread.currentThread().getName()+"启动");
            inputStream = new FileInputStream(
                    "E:\\activiti\\webroot-xiugai3-17\\out\\artifacts\\webroot_war_exploded\\WEB-INF\\classes\\db.properties");
            p.load(inputStream);
            String attachment = p.getProperty("attachment");
            System.out.println(attachment);
            Thread.sleep(5000);
            System.out.println(Thread.currentThread().getName()+"结束");
            inputStream.close();
            System.out.println(Thread.currentThread().getName()+"流关闭");*/
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}
