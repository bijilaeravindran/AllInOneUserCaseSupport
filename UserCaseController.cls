public without sharing class UserCaseController {

    // Wrapper Class to hold feedDetails and Case Details
    public class CaseWrapper{
      @AuraEnabled
      public FeedComment feedDetails {get; set;}
      @AuraEnabled
      public Case caseDetails {get; set;}
      @AuraEnabled
      public String createdDt {get; set;}

      public CaseWrapper(FeedComment feedDetails, Case caseDetails, String createdDt){
        this.feedDetails = feedDetails;
        this.caseDetails = caseDetails;
        this.createdDt = createdDt;
      }
    }

     @AuraEnabled
     public static List<CaseWrapper> fetchCaseDetail(String stats){
       System.debug('Status-->'+stats);
        List<Case>  caseValues = [SELECT Id, ParentRecord_Id__c, Status,CaseFeedId__c, CreatedById, Priority, Record_Name__c, Description, CreatedDate, Record_Type__c, Link_to_Record__c
                                  FROM Case
                                  where CreatedById =: UserInfo.getUserId() AND Status =: stats];

       System.debug('Case Values==>'+caseValues);
       List<Id> parentIdList = new List<Id>();
       List<Id> caseFeedIdList = new List<Id>();
       for(Case cs : caseValues){
         if(cs.ParentRecord_Id__c != null){
           parentIdList.add(cs.ParentRecord_Id__c);
           caseFeedIdList.add(cs.CaseFeedId__c);
         }
       }
       System.debug('parentIdList==>'+parentIdList+'  '+'caseFeedIdList=='+caseFeedIdList);

       Map<Id, FeedComment> feedsMap = new Map<Id, FeedComment>();
       Map<Id, FeedComment> feedsIdMap = new Map<Id, FeedComment>();

       List<FeedComment> fs = new List<FeedComment>([SELECT Id, FeedItemId, ParentId, CommentBody, CreatedDate, RelatedRecordId
                                                     FROM FeedComment
                                                     where ParentId
                                                     IN :parentIdList Order By CreatedDate]);
       Map<String, FeedComment> fsMap = new Map<String, FeedComment>();

      for(FeedComment f : fs){
        fsMap.put(f.FeedItemId, f);
      }

       for(FeedComment fc : fsMap.Values()) {
         fc.CommentBody = fc.CommentBody.replaceAll('<[/a-zAZ0-9]*>','');
         feedsMap.put(fc.ParentId, fc);
         feedsIdMap.put(fc.FeedItemId, fc);
       }
       System.debug('feedsIdMap-->'+feedsIdMap);
       List<CaseWrapper> cases = new List<CaseWrapper>();
       for(Case cs : caseValues){
         System.debug('Case value from FeedMap'+feedsIdMap.get(cs.CaseFeedId__c));
          cs.Description = cs.Description.replaceAll('<[/a-zAZ0-9]*>','');
          cs.Description = cs.Description.replace('@THOR Capgemini​', '');
          String csDate = cs.CreatedDate.formatGMT('dd-MM-yyyy');

         if(feedsMap.containsKey(cs.ParentRecord_Id__c) && feedsIdMap.containsKey(cs.CaseFeedId__c)){
           cases.add(new CaseWrapper( feedsIdMap.get(cs.CaseFeedId__c), cs, csDate ) );
         }else{
           cases.add(new CaseWrapper( null, cs, csDate  ) );
         }
       }
       System.debug('cases==>'+cases);
       return cases;
     }

      @AuraEnabled
     public static List <String> getPicklistValues(SObject obj, String fld){
      list<String> options = new list<String>();
      Schema.sObjectType objType = obj.getSObjectType();
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
      list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : values){
         options.add(a.getValue());
      }
      return options;
     }

  }