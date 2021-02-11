trigger AppAnalyticsQueryRequestTrigger on AppAnalyticsQueryRequest (before insert, before update) {    
/*
This Trigger will loop through updated AppAnalytics Query Request records.

If the request is a PackageUsageSummary and if RequestState has changed to "Complete" then we can download the CSV

*/  
    for (AppAnalyticsQueryRequest aaqr: Trigger.new) {
        
        if (Trigger.isUpdate && Trigger.isBefore && ((aaqr.DataType == 'CustomObjectUsageSummary' || aaqr.DataType == 'PackageUsageSummary') && aaqr.RequestState == 'Complete' && aaqr.RequestState != Trigger.oldMap.get(aaqr.id).RequestState ) 
                || Test.isRunningTest()) {
			
            if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()) {
                System.debug('Enqueueing log Download');
                if (!Test.isRunningTest()) {
                    System.enqueueJob(new LogDownloader(aaqr.DownloadUrl, aaqr.DownloadExpirationTime, aaqr.DownloadSize));
                }
            }
            else {
                system.debug('Not Enqueing Download -- Limit Exceeded');
            }
        }
        else {
            system.debug('Not Enqueing Download');
        }
    }
}