({
	fetchcase : function(component) {
		var action = component.get("c.getPicklistValues");
		action.setParams({
              "obj": component.get("v.objInfo"),
							"fld": "Status"
        });
		action.setCallback(this, function(response) {
			console.log('picklist Values-->'+response.getReturnValue());
			component.set("v.caseType",response.getReturnValue());
			console.log('response.getReturnValue()[0]===='+response.getReturnValue()[0]);
			this.fetchRecords(component,  response.getReturnValue()[0] );
		});
		$A.enqueueAction(action);
	},

	fetchRecords : function(component, defaultCase){
		console.log('default CaseType--'+defaultCase);
		var action = component.get("c.fetchCaseDetail");
		action.setParams({
							"stats": defaultCase
				});
			 action.setCallback(this, function(response){
			 var state = response.getState();
				 if(state == 'SUCCESS'){
					 var caseDetail = response.getReturnValue();
					 console.log('fetch detailRepsonse-->'+JSON.stringify(caseDetail, null, 4));
					 component.set("v.allCases",caseDetail);
				 }else{
					 console.log('Error fetching values');
				 }
			 });
			$A.enqueueAction(action);

	},
})