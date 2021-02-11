@isTest
public inherited sharing class CSVParserTest {
    @isTest 
    static void testCSVParse() {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('PackageSummaryTest');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/csv');

        Test.setMock(HttpCalloutMock.class, mock);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://mock');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        

        Test.startTest();
        System.enqueueJob(new CSVParser(res.getBody()));
        Test.stopTest();

        System.assertEquals(2, [select Count() from PackageUsageSummary__c]);

    }
}
