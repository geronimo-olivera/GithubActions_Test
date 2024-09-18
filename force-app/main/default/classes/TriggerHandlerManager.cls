/**
 * File Name   :	TriggerHandlerManager.cls
 * Description :	Manager for selecting and executing the appropriate trigger handlers.
 **/
public class TriggerHandlerManager {
    /**
     * Method responsible for handling trigger execution logic.
     * @param objectName the api name of the SObject.
     */
    public static void handle(String objectName) {
        try {
            if (String.IsNotBlank(objectName)) {
                List<Trigger_Handler__mdt> triggerHandlers = Test.isRunningTest() ? getMockDataTriggerHandler() : getTriggerHandlersByObjectName(objectName);
                
                if (!triggerHandlers.isEmpty()) {
                    for (Trigger_Handler__mdt handler : triggerHandlers) {
                        Type classType = Type.forName(handler.Class_Name__c);
                        if (classType != null) {
                            TriggerHandlerInterface handlerInterface = (TriggerHandlerInterface) classType.newInstance();
                            
                            if (handlerInterface != null) {
                                handlerInterface.execute(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                            }
                        }
                    }
                }
            }
            
        } catch (Exception ex) {
            System.debug('Error Message: ' + ex.getMessage()+ ' \n' + 'StackTrace: ' + ex.getStackTraceString());
        }
    }

    /**
     * Method to retrieve a list of trigger handler metadata records based on the specified object name, ensuring only active handlers are selected and ordered by their defined order.
     * @param objectName the api name of the SObject.
     * @return a List with the Trigger Handlers of the object.
     */
    private static List<Trigger_Handler__mdt> getTriggerHandlersByObjectName(String objectName) {
        return [SELECT Class_Name__c FROM Trigger_Handler__mdt WHERE Is_Active__c = TRUE AND Object__c = :objectName ORDER BY Order__c ASC];
    }

    /**
     * Method to retrieve a mock list of trigger handler metadata records for testing purposes.
     * @return a List with the Trigger Handlers records for testing purposes.
     */
    private static List<Trigger_Handler__mdt> getMockDataTriggerHandler() {
        Trigger_Handler__mdt mockMetadata = new Trigger_Handler__mdt(MasterLabel = 'Test Handler', Class_Name__c = 'MockTriggerHandler', Is_Active__c = true, Object__c = 'Account', Order__c = 1);
        return new List<Trigger_Handler__mdt>{ mockMetadata };
    }
}