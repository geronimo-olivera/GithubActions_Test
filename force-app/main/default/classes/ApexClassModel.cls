public with sharing class ApexClassModel {
    @AuraEnabled
    public String className;

    @AuraEnabled
    public String classType;

    public ApexClassModel(String className, String classType) {
        this.className = className;
        this.classType = classType;
    }

    public static List<ApexClassModel> getApexClasses() {
        List<ApexClassModel> apexClassesToReturn = new List<ApexClassModel>();
        List<ApexClass> apexClasses = [
            SELECT Body, Name
            FROM ApexClass
            WHERE Status = 'Active' AND Name != :ApexClassModel.class.getName()
        ];

        for (ApexClass apexClass : apexClasses) {
            Boolean isQueueable = apexClass.Body.contains('implements Queueable') && apexClass.Body.contains('execute');
            Boolean isBatchable =
                apexClass.Body.contains('implements Database.Batchable') &&
                apexClass.Body.contains('start') &&
                apexClass.Body.contains('execute') &&
                apexClass.Body.contains('finish');
            Boolean isSchedulable =
                apexClass.Body.contains('implements Schedulable') && apexClass.Body.contains('execute');

            if (isQueueable) {
                apexClassesToReturn.add(new ApexClassModel(apexClass.Name, 'queueable'));
            } else if (isBatchable) {
                apexClassesToReturn.add(new ApexClassModel(apexClass.Name, 'batchable'));
            } else if (isSchedulable) {
                apexClassesToReturn.add(new ApexClassModel(apexClass.Name, 'scheduleable'));
            }
        }

        return apexClassesToReturn;
    }
}