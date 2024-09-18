@isTest
public class TriggerHandlerManagerTest {
    
    @isTest
    static void testHandleWithValidObjectName() {
    
        Test.startTest();
        
        TriggerHandlerManager.handle('Account');
        
        Test.stopTest();
    }
}