public with sharing class ScheduledJobsService {
    public static List<CronTriggerModel> getScheduledBatches() {
        return CronTriggerModel.getScheduledBatches();
    }

    public static List<ApexClassModel> getApexClasses() {
        return ApexClassModel.getApexClasses();
    }

    public static void deleteScheduledJob(String jobId) {
        if (String.isNotBlank(jobId)) {
            List<CronTrigger> scheduledJobsToAbort = CronTriggerModel.getScheduledJobsByJobId(jobId);
            CronTriggerModel.abortScheduledJob(scheduledJobsToAbort);
        }
    }

    public static void scheduleNewJob(String jobToCreate) {
        CronTriggerModel parsedJobToCreate = (CronTriggerModel) JSON.deserialize(jobToCreate, CronTriggerModel.class);
        if (parsedJobToCreate != null) {
            String apexClassName = parsedJobToCreate.apexClassName;
            String apexClassType = parsedJobToCreate.apexClassType;
            if (String.isNotBlank(apexClassName) && String.isNotBlank(apexClassType)) {
                Type actionClass = Type.forName(apexClassName);
                if (actionClass != null) {
                    String cronExp = parsedJobToCreate.cronExp;
                    if (String.isNotBlank(cronExp)) {
                        String jobName = parsedJobToCreate.jobName;
                        if (apexClassType.equals('scheduleable')) {
                            Schedulable scheduleableClass = (Schedulable) actionClass.newInstance();
                            System.schedule(jobName, cronExp, scheduleableClass);
                        } else {
                            Integer batchSize = parsedJobToCreate.batchSize;
                            AsyncJobScheduler asyncJobScheduler = new AsyncJobScheduler(
                                actionClass,
                                apexClassType,
                                batchSize
                            );
                            System.schedule(jobName, cronExp, asyncJobScheduler);
                        }
                    }
                }
            }
        }
    }
}