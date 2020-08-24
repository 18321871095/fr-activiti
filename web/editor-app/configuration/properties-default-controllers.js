/*
 * Activiti Modeler component part of the Activiti project
 * Copyright 2005-2014 Alfresco Software, Ltd. All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

/*
 * String controller
 */

var KisBpmStringPropertyCtrl = [ '$scope', function ($scope) {

	$scope.shapeId = $scope.selectedShape.id;
	$scope.valueFlushed = false;
    /** Handler called when input field is blurred */
    $scope.inputBlurred = function() {
    	$scope.valueFlushed = true;
    	if ($scope.property.value) {
    		$scope.property.value = $scope.property.value.replace(/(<([^>]+)>)/ig,"");
    	}
        $scope.updatePropertyInModel($scope.property);
    };

    $scope.enterPressed = function(keyEvent) {
    	if (keyEvent && keyEvent.which === 13) {
    		keyEvent.preventDefault();
	        $scope.inputBlurred(); // we want to do the same as if the user would blur the input field
    	}
    };
    
    $scope.$on('$destroy', function controllerDestroyed() {
    	if(!$scope.valueFlushed) {
    		if ($scope.property.value) {
        		$scope.property.value = $scope.property.value.replace(/(<([^>]+)>)/ig,"");
        	}
    		$scope.updatePropertyInModel($scope.property, $scope.shapeId);
    	}
    });

}];

/*
 * Boolean controller
 */

var KisBpmBooleanPropertyCtrl = ['$scope', function ($scope) {

    $scope.changeValue = function() {
        if ($scope.property.key === 'oryx-defaultflow' && $scope.property.value) {
            var selectedShape = $scope.selectedShape;
            if (selectedShape) {
                var incomingNodes = selectedShape.getIncomingShapes();
                if (incomingNodes && incomingNodes.length > 0) {
                    // get first node, since there can be only one for a sequence flow
                    var rootNode = incomingNodes[0];
                    var flows = rootNode.getOutgoingShapes();
                    if (flows && flows.length > 1) {
                        // in case there are more flows, check if another flow is already defined as default
                        for (var i = 0; i < flows.length; i++) {
                            if (flows[i].resourceId != selectedShape.resourceId) {
                                var defaultFlowProp = flows[i].properties['oryx-defaultflow'];
                                if (defaultFlowProp) {
                                    flows[i].setProperty('oryx-defaultflow', false, true);
                                }
                            }
                        }
                    }
                }
            }
        }
        $scope.updatePropertyInModel($scope.property);
    };

}];

/*
 * Text controller
 */

var KisBpmHuiQianCtrl = [ '$scope', '$modal', function($scope, $modal) {

    var opts = {
        template:  'editor-app/configuration/properties/huiqian-popup.html?version=' + Date.now(),
        scope: $scope
    };

    // Open the dialog
    //console.log($scope.property)
    $modal(opts);
}];

var KisBpmHuiQianPropertyPopupCtrl = ['$scope','$rootScope', function($scope,$rootScope) {
/*    console.log($scope.selectedItem.properties);
    console.log($scope.selectedShape.properties);
    console.log($rootScope.modelData.model.childShapes);*/
    var data = $rootScope.modelData.model.childShapes;
    var id = $scope.selectedShape.resourceId;
    var temp_huiqin;
    console.log(id)
    console.log(data)
    console.log($scope.selectedShape.properties);
  /*  console.log($scope.selectedItem.properties);*/

   if(data!=undefined){
       for(var i=0;i<data.length;i++){
           if(id==data[i].resourceId){
               temp_huiqin=data[i];
               break;
           }
       }
   }else{
     /*  temp_huiqin={};
       temp_huiqin["properties"]={};*/
   }

    if($scope.property.value=='j**h'){
        $scope.property.value='';
        $scope.huiqianRadioType="0";
        $scope.huiqianTemp="";
    }
   if(data!=undefined&&temp_huiqin!=undefined){
       if(temp_huiqin.properties.huiqianType==undefined || temp_huiqin.properties.huiqianType==''|| temp_huiqin.properties.huiqianType=='0'){
           $scope.huiqianRadioType="0";
           $scope.huiqianTemp="";
       }
       if(temp_huiqin.properties.huiqianType=='1'){
           $scope.huiqianRadioType="1";
           $scope.huiqianTemp=temp_huiqin.properties.huiqianTemp;
       }
   }else{
      if($scope.selectedShape.properties["oryx-huiqianType"]==undefined ||$scope.selectedShape.properties["oryx-huiqianType"]=='0' ){
          $scope.huiqianRadioType ='0';
          $scope.huiqianTemp='';
      }
      if($scope.selectedShape.properties["oryx-huiqianType"]=='1'){
          $scope.huiqianRadioType ='1';
          $scope.huiqianTemp =  $scope.selectedShape.properties["oryx-huiqianTemp"];
      }
   }
    $scope.save = function() {
       var flag=true;
        if($scope.huiqianRadioType=="0"){
            console.log("会签用户名")
                if(data!=undefined&&temp_huiqin!=undefined){
                    temp_huiqin.properties["huiqianType"]='0';
                    temp_huiqin.properties["huiqianTemp"]='';
                }
                else{
                    $scope.property["huiqianType"]='0';
                    $scope.property["huiqianTemp"]='';
                }
        }else{
            console.log("会签角色")
            if(( document.getElementById("huiqian").value).indexOf("${")>-1){
                flag=false;
                alert("目前不支持角色类型的会签人以${}形式动态设置添加");
            }else{
                if(data!=undefined&&temp_huiqin!=undefined){
                    temp_huiqin.properties["huiqianType"]='1';
                    temp_huiqin.properties["huiqianTemp"]=document.getElementById("huiqianTemp").value;
                }
                else{
                    $scope.property["huiqianType"]='1';
                    $scope.property["huiqianTemp"]=document.getElementById("huiqianTemp").value;
                }
            }
        }
        if(flag){
            $scope.property.value = document.getElementById("huiqian").value;
            //新增参数
            $scope.updatePropertyInModel($scope.property);
            $scope.close();
        }
    };
    $scope.close = function() {
        $scope.property.mode = 'read';
        $scope.$hide();
    };
}];

var KisBpmFrFunctionCtrl = [ '$scope', '$modal', function($scope, $modal) {

    var opts = {
        template:  'editor-app/configuration/properties/frfunction-popup.html?version=' + Date.now(),
        scope: $scope
    };

    // Open the dialog
    $modal(opts);
}];
var KisBpmFrFunctionPropertyPopupCtrl = ['$scope', '$http', function($scope,$http) {
    $scope.save = function() {
       // var valuetemp=document.getElementById("frfunction").value.replace(/\s|\xA0/g,"");
        var valuetemp=document.getElementById("frfunction").value.replace(/(^\s*)|(\s*$)/g, "");
        //console.log(valuetemp)
        var value="";
        if(valuetemp.indexOf("=")===0){
            value=valuetemp.replace(/=/,"");
        }else{
            value=valuetemp;
        }
        $scope.property.value = value;
        $scope.updatePropertyInModel($scope.property);
        $scope.close();
    };
    $scope.close = function() {
        $scope.property.mode = 'read';
        $scope.$hide();
    };
    $scope.jiaoyan = function() {
        var frValue=document.getElementById("frfunction").value;
      //  var authorization="333";
        //var curWwwPath=window.document.location.href;
        if(frValue==''){
            alert("请输入条件");
        }else{
          //  var mydata={"valid":true,"textType":"formula","text":""+frValue,"color":"#999999","fontSize":20};
           // var mycookie=document.cookie.split(";");
            /*for(var i=0;i<mycookie.length;i++){

                var myValue=mycookie[i].split("=");
                if(myValue[0].replace(/\s*!/g,"")=="fine_auth_token"){
                    authorization=myValue[1];
                }
            }*/
            //console.log(authorization);
           // console.log(curWwwPath.split("modeler.html")[0])
            /*$http({
                method:'post',
                //url:curWwwPath.split("modeler.html")[0]+'decision/v10/security/watermark/preview',
                url:'processInfo/jiaoyan',
               // headers:{"Authorization":"Bearer "+authorization,"Content-Type":"application/json;charset=utf-8"},
                //headers:{"Content-Type":"application/x-www-form-urlencoded;charset=utf-8"},
              //  data:JSON.stringify(mydata),
                data:{mytext:frValue.replace(/\s*!/g,"").replace(/=/g,"")}
            }).success(function(req){
               //console.log(JSON.stringify(req))
               /!* if(typeof(req.errorCode)=='undefined'){
                    alert('公式合法')
                }else{
                    alert('公式错误')

                }*!/
               if(req=='1'){
                   alert('公式合法')
               }else{
                   alert('公式错误')
               }
            });*/


            var myvaluetemp= frValue.replace(/\s|\xA0/g,"");
            var myvalue="";
            if(myvaluetemp.indexOf("=")===0){
                myvalue=myvaluetemp.replace(/=/,"");
            }else{
                myvalue=myvaluetemp;
            }
            //要通过post传递的参数
            var data = {
                    mytext: myvalue
                },
//post请求的地址
                url = "processInfo/jiaoyan",
//将参数传递的方式改成form
                postCfg = {
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    transformRequest: function (data) {
                        var str = [];
                        for (var p in data) {
                            str.push(encodeURIComponent(p) + "=" + encodeURIComponent(data[p]));
                        }
                        return str.join("&");
                    }
                };
//发送post请求，获取数据
            $http.post(url, data, postCfg)
                .success(function (response) {
                    if(response=='1'){
                        alert('公式合法')
                    }else{
                        alert('公式错误')
                    }
                });


        }
    };
}];

var KisBpmFrFunctionSetAssginCtrl = [ '$scope', '$modal', function($scope, $modal) {

    var opts = {
        template:  'editor-app/configuration/properties/frfunctionsetassgin-popup.html?version=' + Date.now(),
        scope: $scope
    };

    // Open the dialog
    $modal(opts);
}];

var KisBpmFrFunctionSetAssginPropertyPopupCtrl = ['$scope', '$http', function($scope,$http) {
    $scope.save = function() {
        var valuetemp=document.getElementById("frfunctionsetassgin").value.replace(/(^\s*)|(\s*$)/g, "");
        var value="";
        if(valuetemp.indexOf("=")===0){
            value=valuetemp.replace(/=/,"");
        }else{
            value=valuetemp;
        }
        $scope.property.value = value;
        $scope.updatePropertyInModel($scope.property);
        $scope.close();
    };
    $scope.close = function() {
        $scope.property.mode = 'read';
        $scope.$hide();
    };
    $scope.jiaoyansetassgin = function() {
        var frValue=document.getElementById("frfunctionsetassgin").value;
        if(frValue==''){
            alert("请输入公式");
        }else{
            var myvaluetemp= frValue.replace(/\s|\xA0/g,"");
            var myvalue="";
            if(myvaluetemp.indexOf("=")===0){
                myvalue=myvaluetemp.replace(/=/,"");
            }else{
                myvalue=myvaluetemp;
            }
            //要通过post传递的参数
            var data = {
                    mytext: myvalue
                },
//post请求的地址
                url = "processInfo/jiaoyan",
//将参数传递的方式改成form
                postCfg = {
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    transformRequest: function (data) {
                        var str = [];
                        for (var p in data) {
                            str.push(encodeURIComponent(p) + "=" + encodeURIComponent(data[p]));
                        }
                        return str.join("&");
                    }
                };
//发送post请求，获取数据
            $http.post(url, data, postCfg)
                .success(function (response) {
                    if(response=='1'){
                        alert('公式合法')
                    }else{
                        alert('公式错误')
                    }
                });


        }
    };
}];

var KisBpmTextPropertyCtrl = [ '$scope', '$modal', function($scope, $modal) {

    var opts = {
        template:  'editor-app/configuration/properties/text-popup.html?version=' + Date.now(),
        scope: $scope
    };

    // Open the dialog
    $modal(opts);
}];

var KisBpmTextPropertyPopupCtrl = ['$scope','$rootScope', function($scope,$rootScope) {
   // console.log($rootScope)
    //当前节点实时数据，在没有保存整个流程图之前
    //console.log($scope.selectedShape.properties)
    //var this_data=$scope.selectedShape.properties;
    var data = $rootScope.modelData.model.childShapes;
    var id = $scope.selectedShape.resourceId;
    var temp_cpt;
    if(data!=undefined){
        for(var i=0;i<data.length;i++){
            if(id==data[i].resourceId){
                temp_cpt=data[i];
                break;
            }
        }
    }

    if(temp_cpt.properties["cptType"]=='0'){
        $scope.cptType='0';
    }else{
        $scope.cptType='1';
    }

    $scope.save = function() {

       if(temp_cpt!=undefined){
           temp_cpt.properties["cptType"]=$scope.cptType;
       }

        $scope.property.value= document.getElementById("selLayout").value;
        $scope.updatePropertyInModel($scope.property);

        $scope.close();
    };
    $scope.close = function() {
        $scope.property.mode = 'read';
        $scope.$hide();
    };

    $scope.yulan = function(){
        //console.log(window.document.location.href.split("/modeler")[0])
      // var type="write";
        if($scope.cptType=='1'){
            type="write";
        }else if($scope.cptType=='0'){
            type="view";
        }
       window.open(window.document.location.href.split("/modeler")[0]+"/decision/view/report?viewlet="+document.getElementById("selLayout").value
           +"&op="+type,"_blank");
    };



}];

