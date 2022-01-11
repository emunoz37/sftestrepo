trigger ContactHistoryTrigger on Contact_History__c (before insert, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContactHistoryTriggerHandler.beforeInsert(Trigger.new);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactHistoryTriggerHandler.afterInsert(Trigger.new);
        }
    }
}