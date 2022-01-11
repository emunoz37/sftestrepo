public class ContactTriggerHanlder{
    public static void afterInsert(List<Contact> triggerNew){
        System.debug('ContactTriggerHanlder afterInsert-->'+triggerNew[0].Id);
        createContactHistory(triggerNew, null);
    }

    public static void afterUpdate(List<Contact> triggerNew, List<Contact> TriggerOld){
        System.debug('ContactTriggerHanlder afterUpdate-->'+triggerNew[0].Id);
        System.debug('ContactTriggerHanlder afterUpdate TriggerOld.AccountId-->'+TriggerOld[0].AccountId);
        System.debug('ContactTriggerHanlder afterUpdate TriggerNew.AccountId-->'+triggerNew[0].AccountId);
        System.debug('ContactTriggerHanlder afterUpdate Count list-->'+triggerNew.size());
        createContactHistory(triggerNew, TriggerOld);
    }
    
    private static void createContactHistory(List<Contact> newData, List<Contact> oldData){
        Contact newContactData = newData[0];
        Contact_History__c newContactHistoryData = new Contact_History__c();

        if (newContactData.DoNotCall == true) {
            System.debug('ContactTriggerHanlder DoNotCall == true--> Suspended');
            newContactHistoryData.Contact__c = newContactData.Id;
            newContactHistoryData.Begin_Date__c = system.today();
            newContactHistoryData.End_Date__c = null;
            newContactHistoryData.Status__c = 'Suspended';
        }else{
            if (oldData == null) {
                if(newContactData.AccountId == null){
                    System.debug('ContactTriggerHanlder Insert DoNotCall == false-->AccountId == null-->Prospect');
                    newContactHistoryData.Contact__c = newContactData.Id;
                    newContactHistoryData.Begin_Date__c = system.today();
                    newContactHistoryData.End_Date__c = null;
                    newContactHistoryData.Status__c = 'Prospect';
                } else if(newContactData.AccountId != null){
                    System.debug('ContactTriggerHanlder Insert DoNotCall == false-->AccountId not null-->Active');
                    newContactHistoryData.Contact__c = newContactData.Id;
                    newContactHistoryData.Begin_Date__c = system.today();
                    newContactHistoryData.End_Date__c = null;
                    newContactHistoryData.Status__c = 'Active';
                }
            }else{
                Contact oldContactData = newData[0]; 

                if(oldContactData.AccountId == null){
                    System.debug('ContactTriggerHanlder update DoNotCall == false-->AccountId == null-->Prospect');
                    newContactHistoryData.Contact__c = oldContactData.Id;
                    newContactHistoryData.Begin_Date__c = system.today();
                    newContactHistoryData.End_Date__c = null;
                    newContactHistoryData.Status__c = 'Prospect';
                } else if(oldContactData.AccountId != null){
                    System.debug('ContactTriggerHanlder update DoNotCall == false-->AccountId not null-->Active');
                    newContactHistoryData.Contact__c = oldContactData.Id;
                    newContactHistoryData.Begin_Date__c = system.today();
                    newContactHistoryData.End_Date__c = null;
                    newContactHistoryData.Status__c = 'Active';
                } 
            }
        }
        insert newContactHistoryData;
    }
}