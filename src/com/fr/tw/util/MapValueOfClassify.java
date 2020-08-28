package com.fr.tw.util;

import java.util.*;

public class MapValueOfClassify {
    public static  List<List<Map<String,Object>>> getListArrayByMapValueOfClassify(List<Map<String,Object>> list, String mapVaule, Set<String> sets){
        List<List<Map<String,Object>>> resultList=new ArrayList<>();
        for (String s:sets) {
            List<Map<String,Object>> lm=new ArrayList<>();
            for (Map<String,Object> m:list) {
                if(m.get(mapVaule).toString().equals(s)){
                    lm.add(m);
                }
            }
            resultList.add(lm);
        }//for set
        return resultList;
    }
    public static List<Map<String,Object>> levelAsc(List<Map<String,Object>> list){
        List<Map<String,Object>> levelEmpty=new ArrayList<>();
        List<Map<String,Object>> levelNotEmpty=new ArrayList<>();
      for(Map<String,Object> map : list){
          String level = map.get("level") == null ? "" : map.get("level").toString();
          if("".equals(level)){
              levelEmpty.add(map);
          }else{
              levelNotEmpty.add(map);
          }
      }
        Collections.sort(levelNotEmpty, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                Integer name1 = Integer.valueOf(o1.get("level").toString()) ;
                Integer name2 = Integer.valueOf(o2.get("level").toString()) ;
                return name1.compareTo(name2);
            }
        });

        levelNotEmpty.addAll(levelEmpty);
        return levelNotEmpty;

    }
}
