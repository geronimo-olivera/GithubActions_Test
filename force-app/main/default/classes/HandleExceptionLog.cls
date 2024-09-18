/**
 * File Name   :	HandleExceptionLog.cls
 * Description :	Class for publishing exception logs.
 **/
public class HandleExceptionLog {
    /**
     * Method to check whether the current context is asynchronous, returning a Boolean value. It evaluates if the code is executing within a batch job, future method, queueable job, or scheduled job.
     * @param className the name of the apex class.
     * @param methodName the name of the apex method.
     * @param errorMessage the error message.
     * @param strackTrace the strackTrace.
     */
    public static void publish(String className, String methodName, String errorMessage, String strackTrace) {
        insert new Exception_Log__c(Class_Name__c = className, Method_Name__c = methodName, Error_Message__c = errorMessage, Stack_Trace__c = strackTrace);
    }
}