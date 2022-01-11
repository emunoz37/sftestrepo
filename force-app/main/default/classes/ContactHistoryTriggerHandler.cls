public class ContactHistoryTriggerHandler{

    public static void beforeInsert(List<Contact_History__c> triggerNew){
        System.debug('ContactHistoryTriggerHandler beforeInsert-->'+triggerNew[0].Id);
        validateDateOverride(triggerNew);
    }

    public static void afterInsert(List<Contact_History__c> triggerNew){
        System.debug('ContactHistoryTriggerHandler afterInsert-->'+triggerNew[0].Id);
        //updatePreviousEndDate(triggerNew);
    }

    private static void validateDateOverride(List<Contact_History__c> newData){
        List <Contact_History__c> newContactHistoryData = newData;
        String contactId = newContactHistoryData.get(0).Contact__c;
        Date newStartDate = newContactHistoryData.get(0).Begin_Date__c;
        Date newEndDate = newContactHistoryData.get(0).End_Date__c;
        
        List <Contact_History__c> contactHistoryList = [Select Id, Begin_Date__c, End_Date__c FROM Contact_History__c WHERE Contact__c =: contactId];
        
        if( !contactHistoryList.isEmpty() ){
            for( Contact_History__c curContactHistory : contactHistoryList ){
                if( curContactHistory.Begin_Date__c <= newEndDate && curContactHistory.End_Date__c >= newStartDate ){
                    Trigger.new[0].addError('You cannot overlap dates in same Contact');
                    break;
                }
            }
        }
    }

    private static void updatePreviousEndDate(List<Contact_History__c> newData){
        Contact_History__c newContactHistoryData = new Contact_History__c();
        String contactId = newData.get(0).Contact__c;

        List <Contact_History__c> contactHistoryList = [Select Id, Begin_Date__c, End_Date__c FROM Contact_History__c WHERE Contact__c =: contactId ORDER BY CreatedDate Desc];
        newContactHistoryData = contactHistoryList[1];
        newContactHistoryData.End_Date__c = system.today();
        System.debug('ContactHistoryTriggerHandler updatePreviousEndDate-->'+contactId);
        update newContactHistoryData;
    }
}