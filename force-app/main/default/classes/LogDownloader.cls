public class LogDownloader implements Queueable,Database.AllowsCallouts{
/*
Class is asynchronous/queable to take advantage of the longer processing times and larger heap sizes necessary to download the summary log file
*/
    //private AppAnalyticsQueryRequest aaqr;
    private String DownloadURL;
    private Datetime DownloadExpiration;
    private Long DownloadSize;


    public LogDownloader(String DownloadURL, Datetime DownloadExpiration, Long DownloadSize) {
        this.DownloadURL = DownloadURL;
        this.DownloadExpiration = DownloadExpiration;
        this.DownloadSize = DownloadSize;
    }
    
    public void execute(queueableContext qc) {
        //Don't download if the file size is greater than available heap or if the URL has expired. 
        if (this.DownloadSize < (Limits.getLimitHeapSize() - Limits.getHeapSize()) && this.DownloadExpiration > DateTime.now()) {
            Http h = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('GET');
            httpReq.setEndpoint(this.DownloadUrl);
            httpResponse res = h.send(httpReq);
            if (res.getStatusCode() == 200) {
                System.debug('File Downloaded. Parsing CSV');
                //Parse the downloaded log file if we're not doing a test
                if (!Test.isRunningTest() && (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs())) {
                    System.enqueueJob(new CSVParser(res.getBody()));    
                }

            }
            else {
                system.debug('Download Failed. Code: ' + res.getStatusCode() + ' Message: ' + res.getStatusCode());
            }
        }
        else {
            system.debug('Request too large or expired');
        }
    }
    
    
}