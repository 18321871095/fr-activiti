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
 * Assignment
 */
var KisBpmAssignmentCtrl = [ '$scope', '$modal', function($scope, $modal) {

    // Config for the modal window
    var opts = {
        template:  'editor-app/configuration/properties/assignment-popup.html?version=' + Date.now(),
        scope: $scope
    };

    // Open the dialog
    $modal(opts);
}];

var KisBpmAssignmentPopupCtrl = [ '$scope', function($scope) {
    // Put json representing assignment on scope
    //{candidateUsers: Array(1), assignee: ""}
   // console.log($scope.property.value.assignment )
    if ($scope.property.value !== undefined && $scope.property.value !== null
        && $scope.property.value.assignment !== undefined
        && $scope.property.value.assignment !== null) 
    {

       //console.log($scope.property.value.assignment.assignee)
        var assginValue=$scope.property.value.assignment.assignee;

        if(assginValue=='${list}' || assginValue.indexOf("${Assgin_")>-1){
            $scope.property.value.assignment.assignee="";
            $scope.assignment = $scope.property.value.assignment;
        }else{
            $scope.assignment = $scope.property.value.assignment;

        }
        //新增初始化办理人的类别
        if($scope.property.value.assignment.assigneType==undefined){
            $scope.property.value.assignment.assigneType="0";
            $scope.assignment.assigneType="0";
        }
        if($scope.property.value.assignment.assigneTemp==undefined){
            $scope.property.value.assignment.assigneTemp="";
            $scope.assignment.assigneTemp="";
        }
        //新增初始化抢占式的类别
        if($scope.property.value.assignment.preemptiveType==undefined){
            $scope.property.value.assignment.preemptiveType="0";
            $scope.assignment.preemptiveType="0";
        }
        if($scope.property.value.assignment.preemptiveTemp==undefined){
            $scope.property.value.assignment.preemptiveTemp="";
            $scope.assignment.preemptiveTemp="";
        }
        //新增判断办理人的类别
        if($scope.property.value.assignment.assigneType==undefined || $scope.property.value.assignment.assigneType=='0'){
            $scope.assigneRadioType=0;
        }else if($scope.property.value.assignment.assigneType=='1'){
            $scope.assigneRadioType=1;
        }
        //新增抢占式办理人类别
        if($scope.property.value.assignment.preemptiveType==undefined || $scope.property.value.assignment.preemptiveType=='0'){
            $scope.preemptiveRadioType=0;
        }else if($scope.property.value.assignment.preemptiveType=='1'){
            $scope.preemptiveRadioType=1;
        }

       /* $scope.property.value有值时assignment也有值$scope.assignment也有值，结构为{assignee:'Lily',candidateUsers:[{value:''}]}，
       $scope.assignment结构一样*/
        console.log("$scope.property.value不为空设置办理人")
       // console.log($scope.property)
       // console.log($scope.assignment)
    } else {
        /* $scope.property.value没有值时，结构为$scope.property.value=""，$scope.assignment={}*/
        $scope.assignment = {};
        $scope.assigneRadioType=0;
        console.log("$scope.property.value为空设置办理人")
       // console.log($scope.property)
       // console.log($scope.assignment)
    }
    console.log("$scope:")
    //console.log($scope)




    if ($scope.assignment.candidateUsers == undefined || $scope.assignment.candidateUsers.length == 0)
    {  //console.log('candidateUsers没有值')
        $scope.assignment.candidateUsers = [{value: ''}];
    }

    $scope.save = function() {//猜测 $scope.assignment是子页面值， $scope.property.value.assignment是保存后显示的值
        var assign=document.getElementById("assigneeField").value.replace(/\s|\xA0/g,"");
        var assigneTemp=document.getElementById("assigneTemp").value.replace(/\s|\xA0/g,"");
        var users=document.getElementById("userField").value.replace(/\s|\xA0/g,"");
        var preemptiveTemp=document.getElementById("preemptiveTemp").value.replace(/\s|\xA0/g,"");
        var flag=true;
        if(assign!=''||users!=''){
            $scope.property.value = {};
            //自定义
            $scope.assignment.assignee=assign;
            $scope.assignment.candidateUsers[0].value=users;
            //这句代码顺序不能变
            $scope.property.value.assignment= $scope.assignment;
            if(assign!=''){
                //自定义的assignment的变量
                $scope.property.value.assignment.assigneType=$scope.assigneRadioType;
                $scope.assignment.assigneType=$scope.assigneRadioType;
                //清空抢占式类型
                $scope.property.value.assignment.preemptiveTemp="";
                $scope.assignment.preemptiveTemp="";
                $scope.property.value.assignment.preemptiveType="0";
                $scope.assignment.preemptiveType="0";
                if($scope.assigneRadioType=='0'){
                    $scope.property.value.assignment.assigneTemp="";
                    $scope.assignment.assigneTemp="";
                }else {
                    if(assign.indexOf("${")>-1){
                        flag=false;
                        alert("目前不支持角色类型的办理人以${}形式动态设置添加");
                    }else{
                        $scope.property.value.assignment.assigneTemp=assigneTemp;
                        $scope.assignment.assigneTemp=assigneTemp;
                    }

                }
            }else{
                //自定义的抢占式办理人类型的变量
                $scope.property.value.assignment.preemptiveType=$scope.preemptiveRadioType;
                $scope.assignment.preemptiveType=$scope.preemptiveRadioType;
                //清空办理人类型
                $scope.property.value.assignment.assigneTemp="";
                $scope.assignment.assigneTemp="";
                $scope.property.value.assignment.assigneType="0";
                $scope.assignment.assigneType="0";
                if($scope.preemptiveRadioType=='0'){
                    $scope.property.value.assignment.preemptiveTemp="";
                    $scope.assignment.preemptiveTemp="";
                }else{
                    if(users.indexOf("${")>-1){
                        flag=false;
                        alert("目前不支持角色类型的抢占式以${}形式动态设置添加");
                    }else{
                        $scope.property.value.assignment.preemptiveTemp=preemptiveTemp;
                        $scope.assignment.preemptiveTemp=preemptiveTemp;
                    }
                }
            }
            //end
           // console.log($scope.property)
            //console.log($scope.assignment)
        }
        else{
            $scope.property.value = "";
            $scope.assignment.assigneType="0";
            $scope.assignment.assigneTemp="";
            $scope.assignment.assignee="";
            //抢占式
            $scope.assignment.preemptiveType="0";
            $scope.assignment.hushiahu="";
            $scope.assignment.candidateUsers[0].value="";
           // console.log($scope.property)
           // console.log($scope.assignment)
        }
	    if(flag){
            $scope.updatePropertyInModel($scope.property);
            $scope.close();
            console.log("保存后：")
            console.log($scope.property)
            console.log($scope.assignment)
        }

    };
    //自定义
    $scope.showAssign = function() {
		document.getElementById("AssignDiv").style.display="block";
        document.getElementById("GroupDiv").style.display="none";
        document.getElementById("userField").value="";

    };
    $scope.showGroup = function() {
        document.getElementById("AssignDiv").style.display="none";
        document.getElementById("GroupDiv").style.display="block";
        document.getElementById("assigneeField").value="";

    };
    $scope.showGroupValue=function () {
        document.getElementById("userField").value="";
    }
    //end
    // Close button handler
    $scope.close = function() {
    	//handleAssignmentInput($scope);
    	$scope.property.mode = 'read';
    	$scope.$hide();
    };
    
    var handleAssignmentInput = function($scope) {
    	if ($scope.assignment.candidateUsers)
    	{
	    	var emptyUsers = true;
	    	var toRemoveIndexes = [];
	        for (var i = 0; i < $scope.assignment.candidateUsers.length; i++)
	        {
	        	if ($scope.assignment.candidateUsers[i].value != '')
	        	{
	        		emptyUsers = false;
	        	}
	        	else
	        	{
	        		toRemoveIndexes[toRemoveIndexes.length] = i;
	        	}
	        }
	        
	        for (var i = 0; i < toRemoveIndexes.length; i++)
	        {
	        	$scope.assignment.candidateUsers.splice(toRemoveIndexes[i], 1);
	        }
	        
	        if (emptyUsers)
	        {
	        	$scope.assignment.candidateUsers = undefined;
	        }
    	}
        
    	/*if ($scope.assignment.candidateGroups)
    	{
	        var emptyGroups = true;
	        var toRemoveIndexes = [];
	        for (var i = 0; i < $scope.assignment.candidateGroups.length; i++)
	        {
	        	if ($scope.assignment.candidateGroups[i].value != '')
	        	{
	        		emptyGroups = false;
	        	}
	        	else
	        	{
	        		toRemoveIndexes[toRemoveIndexes.length] = i;
	        	}
	        }
	        
	        for (var i = 0; i < toRemoveIndexes.length; i++)
	        {
	        	$scope.assignment.candidateGroups.splice(toRemoveIndexes[i], 1);
	        }
	        
	        if (emptyGroups)
	        {
	        	$scope.assignment.candidateGroups = undefined;
	        }
    	}*/
    };
}];