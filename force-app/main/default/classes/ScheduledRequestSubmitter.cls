global with sharing class ScheduledRequestSubmitter Implements Schedulable {
    global void execute(SchedulableContext ctx) {

        List<AppAnalyticsQueryRequest> aaqrList = new List<AppAnalyticsQueryRequest>();

        //Start Date = Midnight on the first day of the previous month
        Date s = Date.today().addMonths(-1).toStartOfMonth();
        DateTime startTime = DateTime.newInstanceGMT(s.year(), s.month(), s.day(), 0,0,0);

        //End Date = 1 minute before midnight
        
        Date e = Date.today().toStartOfMonth().addDays(-1);
        DateTime endTime = DateTime.newInstanceGMT(e.year(), e.month(), e.day(), 23,59,59);
        

        //For each Package in the LMO, Create an AppAnalyticsQueryRequest record
        for (sfLma__Package__c p: [select sfLma__Package_ID__c from sfLma__Package__c]) {
            AppAnalyticsQueryRequest aaqr = new AppAnalyticsQueryRequest();
            aaqr.DataType = 'PackageUsageSummary';
            aaqr.StartTime = startTime;
            aaqr.EndTime = endTime;
            aaqr.PackageIds = p.sfLma__Package_ID__c;
            aaqrList.add(aaqr);
        }

        //Submit the Requests
        insert aaqrList;

     }   
}
