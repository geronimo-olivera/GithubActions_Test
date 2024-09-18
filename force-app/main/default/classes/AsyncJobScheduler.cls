global class AsyncJobScheduler implements Schedulable {
    private Type actionClass;
    private String apexClassType;
    private Integer batchSize;

    public AsyncJobScheduler(Type actionClass, String apexClassType, Integer batchSize) {
        this.actionClass = actionClass;
        this.apexClassType = apexClassType;
        this.batchSize = batchSize;
    }

    global void execute(SchedulableContext SC) {
        if (apexClassType.equals('batchable')) {
            Database.Batchable<sObject> batchInstance = (Database.Batchable<sObject>) actionClass.newInstance();
            Database.executeBatch(batchInstance, batchSize);
        } else if (apexClassType.equals('queueable')) {
            System.enqueueJob(actionClass);
        }
    }
}