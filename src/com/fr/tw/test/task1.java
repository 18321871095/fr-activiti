package com.fr.tw.test;

import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.activiti.engine.history.HistoricProcessInstanceQuery;

import java.io.FileInputStream;
import java.util.Properties;

public class task1 implements Runnable {

    @Override
    public void run() {
        Properties p = new Properties();
        // String path =request.getSession().getServletContext().getRealPath("/")+"WEB-INF"+File.separator+"classes"+File.separator+"db.properties";
        //System.out.println(path);
        FileInputStream inputStream = null;
        try {
            System.out.println(Thread.currentThread().getName()+"启动");
            inputStream = new FileInputStream(
                    "E:\\activiti\\webroot-xiugai3-17\\out\\artifacts\\webroot_war_exploded\\WEB-INF\\classes\\db.properties");
            p.load(inputStream);
            String attachment = p.getProperty("attachment");
            System.out.println(attachment);
            Thread.sleep(10000);
            System.out.println(Thread.currentThread().getName()+"结束");
            inputStream.close();
            System.out.println(Thread.currentThread().getName()+"流关闭");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
