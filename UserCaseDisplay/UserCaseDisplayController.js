({
	// Opens the Users' Case details in a modal pop up window
	openMyCases : function(component, event, helper) {
		var openCase = component.find('userCase');
		$A.util.removeClass(openCase, "slds-hide");
	},

	hideCaseDetail : function(component, event, helper){
		var closeCase = component.find('userCase');
		$A.util.addClass(closeCase, "slds-hide");
	},
})