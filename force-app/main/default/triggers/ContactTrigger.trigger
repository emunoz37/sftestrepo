trigger ContactTrigger on Contact (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactTriggerHanlder.afterInsert(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            ContactTriggerHanlder.afterUpdate(Trigger.new, Trigger.old);
        }
    }
}