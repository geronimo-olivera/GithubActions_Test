public class BatchCalculateOpenCases implements Database.Batchable<SObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, (SELECT Id FROM Cases) FROM Account');
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account account : scope) {
            
            Integer openCaseCount = account.Cases.size();
            System.debug('openCaseCount: ' + openCaseCount);
            
            //acc.Open_Cases_Count__c = openCaseCount;
            //accountsToUpdate.add(acc);
        }
        
        // Update accounts with the new open case counts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext BC) {}
}