@isTest
public inherited sharing class ScheduledRequestSubmitterTest {
    @isTest
    static void testSchedule() {
        sfLma__Package__c p = new sfLma__Package__c();

        p.sfLma__Package_ID__c = '033xx00SIMsmall';

        insert p;

        system.assertEquals(1,[select count() from sfLma__Package__c]);

        system.assertEquals(0, [select count() from AppAnalyticsQueryRequest]);

        Test.startTest();
        system.schedule('TestRequestSubmitter', '0 0 0 3 9 ? 2035', new ScheduledRequestSubmitter());
        Test.stopTest();
        system.assertEquals(1, [select count() from AppAnalyticsQueryRequest]);
    }
}
