public class CountNumberOfEmployeesTriggerHandler implements TriggerHandlerInterface {
    public static void execute(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap) {
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                onAfterInsert(oldRecords, newRecords, oldMap, newMap);                
            }
            
            if (Trigger.isUpdate) {
                onAfterUpdate(oldRecords, newRecords, oldMap, newMap);
            }
            
            if (Trigger.isDelete) {
                onAfterDelete(oldRecords, oldMap);
            }
        }
    }
    
    private static void onAfterInsert(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap){
        countNumberOfEmployesOnRelatedAccount((List<Contact>) newRecords, null);
    }
    
    private static void onAfterUpdate(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap){
        countNumberOfEmployesOnRelatedAccount((List<Contact>) newRecords, (Map<Id, Contact>) oldMap);
    }
    
    private static void onAfterDelete(sObject[] oldRecords, Map<Id, sObject> oldMap){
        countNumberOfEmployesOnRelatedAccount((List<Contact>) oldRecords, null);
    }
    
    private static void countNumberOfEmployesOnRelatedAccount(List<Contact> contacts, Map<Id, Contact> oldMap) {
        
        Set<Id> oldAccountIds = new Set<Id>();
        Set<Id> newAccountIds = new Set<Id>();
        
        for (Contact contact : contacts) {
            newAccountIds.add(contact.AccountId);
            if (oldMap != null && oldMap.containsKey(contact.Id)) {
                Contact oldContact = oldMap.get(contact.Id);
                if (contact.AccountId != oldContact.AccountId) {
                    oldAccountIds.add(oldContact.AccountId);
                }
            }
        }
        
        List<Account> accountsToUpdate = [SELECT Id, Name, NumberOfEmployees, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: newAccountIds OR Id IN: oldAccountIds];
        for (Account account : accountsToUpdate) {
            Integer numberOfEmployees = account.Contacts.size();
            if (account.NumberOfEmployees != numberOfEmployees) {
                account.NumberOfEmployees = numberOfEmployees;
            }
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }  
    }
}