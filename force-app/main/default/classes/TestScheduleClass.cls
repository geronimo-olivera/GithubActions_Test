global class TestScheduleClass implements Schedulable {
   global void execute(SchedulableContext SC) {
       System.enqueueJob(new TestQueueableClass());
   }
}