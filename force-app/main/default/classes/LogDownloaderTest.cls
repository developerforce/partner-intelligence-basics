@isTest
public inherited sharing class LogDownloaderTest {
    @isTest 
    static void testDatafileDownload() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PackageSummaryTest');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/csv');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        System.enqueueJob(new LogDownloader('https://mock', DateTime.now().addMinutes(60), 456));
        Test.stopTest();
    }
}
