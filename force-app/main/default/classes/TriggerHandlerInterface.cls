/**
 * File Name   :	TriggerHandlerInterface.cls
 * Description :	An interface defining the contract for trigger handler classes, facilitating the implementation of custom logic for Salesforce triggers.
 **/
public interface TriggerHandlerInterface {
    /**
     * Designed to execute custom logic within trigger handler classes, enabling the processing of old and new records along with their corresponding maps in Salesforce triggers.
     * @param oldRecords Array of old records.
     * @param newRecords Array of new records.
     * @param oldMap Map of old records, indexed by ID.
     * @param newMap Map of new records, indexed by ID.
     */
    void execute(sObject[] oldRecords, sObject[] newRecords, Map<Id, sObject> oldMap, Map<Id, sObject> newMap);
}