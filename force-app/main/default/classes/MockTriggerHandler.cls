public class MockTriggerHandler implements TriggerHandlerInterface {
    public void execute(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap) {
        System.debug('Mock TriggerHandlerInterface executed');
    }
}