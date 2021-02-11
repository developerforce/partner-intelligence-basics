@isTest
public inherited sharing class AppAnalyticsQueryRequestTriggerTest {
    @isTest 
    static void testAAQRTrigger() {
        AppAnalyticsQueryRequest aaqr = new AppAnalyticsQueryRequest();
        Date s = Date.today().addMonths(-1).toStartOfMonth();
        DateTime startDate = DateTime.newInstanceGMT(s.year(), s.month(), s.day(), 0,0,0);
        Date e = Date.today().toStartOfMonth().addDays(-1);
        DateTime endDate = DateTime.newInstanceGMT(e.year(), e.month(), e.day(), 23,59,59);
        aaqr.DataType = 'PackageUsageSummary';
        aaqr.StartTime = startDate;
        aaqr.EndTime = endDate;
        aaqr.PackageIds = '033xx00SIMsmall';
        insert aaqr;

        AppAnalyticsQueryRequest a = [select id, RequestState from AppAnalyticsQueryRequest where ID = :aaqr.id];
        
        
    }
}
