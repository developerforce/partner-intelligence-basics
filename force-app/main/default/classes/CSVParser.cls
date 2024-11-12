public class CSVParser implements Queueable{
	
    private String LogContent;

    
    public CSVParser(String c) {
        this.LogContent = c;
    }
    
    public void execute(queueableContext qc) {
        List<PackageUsageSummary__c> psList = new List<PackageUsageSummary__c>();
        Boolean ProcessingHeader = true;
        Map<String,Integer> cols = new Map<String,Integer>();
        for (String line: this.LogContent.split('\n')) {
            List<String> fields = line.split(',');
            if (ProcessingHeader) {
                //Read the field names and create a map of field name to column order so that we can lookup the values later.
                for (Integer i = 0; i < fields.size(); i++) {
                    cols.put(fields[i],i);
                }
                ProcessingHeader = false;
                continue;
            }
            
            if (isValidLine(fields)) {
                PackageUsageSummary__c ps = new PackageUsageSummary__c();
                ps.custom_entity__c = getFieldData('custom_entity', fields, cols, '');
                ps.custom_entity_type__c = getFieldData('custom_entity_type', fields, cols, '');
                ps.managed_package_namespace__c = getFieldData('managed_package_namespace', fields, cols, '');
                ps.month__c = getFieldData('month', fields, cols, '');
                ps.num_creates__c = Integer.valueOf(getFieldData('num_creates', fields, cols, '0'));
                ps.num_deletes__c = Integer.valueOf(getFieldData('num_deletes', fields, cols, '0'));
                ps.num_reads__c = Integer.valueOf(getFieldData('num_reads', fields, cols, '0'));
                ps.num_updates__c = Integer.valueOf(getFieldData('num_updates', fields, cols, '0'));
                ps.num_views__c = Integer.valueOf(getFieldData('num_views', fields, cols, '0'));
                ps.organization_id__c = fields[cols.get('organization_id')];
                ps.package_id__c = fields[cols.get('package_id')];
                ps.user_id_token__c = fields[cols.get('user_id_token')];
                ps.user_type__c = fields[cols.get('user_type')];
                //Combined key is a unique id of Summary Log records. Using it as a multi field upsert index to avoid data duplication
                ps.combined_key__c = ps.user_id_token__c + '-' + ps.organization_id__c + '-' + ps.package_id__c + '-' + ps.custom_entity__c + '-' +  ps.month__c;
                psList.add(ps);
            }
        }
        upsert psList combined_key__c;
    }
    
    private boolean isValidLine(List<String> line) {
        //Should probably add some actual validation here
        return true;
    }

    private String getFieldData(String fieldName, List<String> fields, Map<String,Integer> cols, String defaultVal) {
        //Slightly robust way to retrieve
        String retVal = defaultVal;
        Integer colNum = cols.get(fieldName);
        if (colNum  != null && colNum < fields.size()) {
            retVal = fields[colNum];
            if (String.isBlank(retVal)) {
                retVal = defaultVal;
            }
        }
        return retVal;
    }
    
}