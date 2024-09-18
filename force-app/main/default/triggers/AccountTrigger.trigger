/**
 * File Name   :    AccountTrigger.trigger
 * Description :    Trigger for Account records
 */
trigger AccountTrigger on Account (before insert, before update, after insert, after update) { 
	ValidationRuleManager.handle('Account');
    TriggerHandlerManager.handle('Account');
}