/**
 * File Name   :    ContactTrigger.trigger
 * Description :    Trigger for Contact records
 */
trigger ContactTrigger on Contact (before insert, before update, after insert, after update, after delete) {
	TriggerHandlerManager.handle('Contact');
}