public class UpdateTitleTriggerHandler implements TriggerHandlerInterface {

     public static void execute(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                onBeforeInsert(oldRecords, newRecords, oldMap, newMap);
            }
            
            if (Trigger.isUpdate) {
                onBeforeUpdate(oldRecords, newRecords, oldMap, newMap);
            }           
        }
    }
    
    private static void onBeforeInsert(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap){
    	UpdateLenguageTriggerHandler(newRecords);
    }
    
    private static void onBeforeUpdate(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap){
    	UpdateLenguageTriggerHandler(newRecords);
    }
        
    private static void UpdateLenguageTriggerHandler(List<Contact> contacts) {
		
        for(Contact contact : contacts){
            contact.Title = 'Salesforce Developer';
        }	        
    }

}