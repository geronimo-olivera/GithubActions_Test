global class NewTestScheduleClass implements Schedulable {
    
    private Type className;
    
    global NewTestScheduleClass(Type actionClass){
        this.className = actionClass;
        
    }

    global void execute(SchedulableContext SC) {
       System.enqueueJob(className);
   }
}