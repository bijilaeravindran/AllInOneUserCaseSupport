({
	doInit : function(component, event, helper) {
		console.log('Inside Case doInit');
		helper.fetchcase(component);
	},

	changeCaseObject : function(component, event, heler){
    console.log('Picklist Values-->'+event.getSource().get("v.value"));
		var action = component.get("c.fetchCaseDetail");
				action.setParams({
									"stats": event.getSource().get("v.value")
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

	closeCase : function(component, event, helper){
		var close = component.getEvent('hideCaseModal');
          close.fire();
	},

	//Load spinner
showSpinner : function (component) {
		 component.set("v.spinnerLoad","true");
 },

 //Hide spinner
 hideSpinner : function (component) {
		 component.set("v.spinnerLoad","false");
 },

})
