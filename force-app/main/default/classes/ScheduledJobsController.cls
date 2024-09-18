public with sharing class ScheduledJobsController {
    /**
     * Method to get all Scheduled Jobs.
     */
    @AuraEnabled
    public static List<CronTriggerModel> getScheduledBatches() {
        try {
            return ScheduledJobsService.getScheduledBatches();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * Method to get batchable, queueable and scheduleable apex classes.
     * @return all batchable, queueable and scheduleable apex classes.
     */
    @AuraEnabled(cacheable=true)
    public static List<ApexClassModel> getApexClasses() {
        try {
            return ScheduledJobsService.getApexClasses();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * Method to delete a job that is already scheduled.
     * @param jobId the id of the job to delete.
     */
    @AuraEnabled
    public static void deleteScheduledJob(String jobId) {
        try {
            ScheduledJobsService.deleteScheduledJob(jobId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * Method to schedule a new scheduled job.
     * @param jobToCreate JSON information of the job to create.
     */
    @AuraEnabled
    public static void scheduleNewJob(String jobToCreate) {
        try {
            ScheduledJobsService.scheduleNewJob(jobToCreate);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}