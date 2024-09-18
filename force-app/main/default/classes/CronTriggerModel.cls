public with sharing class CronTriggerModel {
    @AuraEnabled
    public String id;

    @AuraEnabled
    public String jobName;

    @AuraEnabled
    public String submittedByURL;

    @AuraEnabled
    public String submittedBy;

    @AuraEnabled
    public DateTime dateSubmitted;

    @AuraEnabled
    public DateTime started;

    @AuraEnabled
    public DateTime nextRun;

    @AuraEnabled
    public String apexClassName; //PARA CREAR EL NUEVO JOB

    @AuraEnabled
    public String apexClassType; //PARA CREAR EL NUEVO JOB

    @AuraEnabled
    public Integer batchSize; //PARA EL TAMANIO DE RECORDS A PROCESAR

    @AuraEnabled
    public String cronExp; //PARA CREAR EL NUEVO JOB

    public CronTriggerModel(CronTrigger job) {
        this.id = job.Id;
        this.jobName = job.CronJobDetail.Name;
        this.submittedByURL = '/' + job.CreatedById;
        this.submittedBy = job.CreatedBy.Name;
        this.dateSubmitted = job.CreatedDate;
        this.started = job.StartTime;
        this.nextRun = job.NextFireTime;
    }

    public static List<CronTriggerModel> getScheduledBatches() {
        List<CronTriggerModel> CronTriggerModel = new List<CronTriggerModel>();
        List<CronTrigger> scheduledJobs = [
            SELECT Id, CreatedById, CreatedBy.Name, CreatedDate, CronJobDetail.Name, NextFireTime, StartTime
            FROM CronTrigger
            WHERE CronJobDetail.JobType = '7'
            ORDER BY CronJobDetail.Name ASC
        ];
        if (!scheduledJobs.isEmpty()) {
            for (CronTrigger job : scheduledJobs) {
                CronTriggerModel.add(new CronTriggerModel(job));
            }
        }

        return CronTriggerModel;
    }

    public static List<CronTrigger> getScheduledJobsByJobId(String jobId) {
        return [SELECT Id FROM CronTrigger WHERE Id = :jobId LIMIT 1];
    }

    public static void abortScheduledJob(List<CronTrigger> scheduledJobsToAbort) {
        if (!scheduledJobsToAbort.isEmpty()) {
            System.abortJob(scheduledJobsToAbort[0].Id);
        }
    }
}