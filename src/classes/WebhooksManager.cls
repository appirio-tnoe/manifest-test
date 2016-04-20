@RestResource(urlMapping='/payload/*')
global with sharing class WebhooksManager {
    @HttpGet
    global static String doGet() {
        String name = RestContext.request.params.get('name');
        return 'Hello ' + name;
    }
    
	@HttpPost
    global static List<Manifest_Item__c> createManifestItem() {
        RestRequest req = RestContext.request;
        List<Manifest_Item__c> mItems = new List<Manifest_Item__c>();
        
        Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

        List<Object> commits = (List<Object>)root.get('commits');
        for (Object c : commits) {
            Map<String, Object> cMap = (Map<String, Object>) c;

            String message = (String) cMap.get('message');
            String relatedTo = message.substringBefore(':');
            String notes = message.substringAfter(':');

            List<Object> add = (List<Object>) cMap.get('added');
            List<Object> rem = (List<Object>) cMap.get('removed');
            List<Object> mod = (List<Object>) cMap.get('modified');

            Map<String, String> miMap = new Map<String, String>();
            for (Object filepath : add) {
                miMap.put('action', 'Add');
                miMap.put('filepath', (String) filepath);
                miMap.put('notes', notes);
                miMap.put('relatedTo', relatedTo);
                mItems.add(WebhooksManagerHelper.createManifestItem(miMap));
            }
            for (Object filepath : rem) {
                miMap.put('action', 'Delete');
                miMap.put('filepath', (String) filepath);
                miMap.put('notes', notes);
                miMap.put('relatedTo', relatedTo);
                mItems.add(WebhooksManagerHelper.createManifestItem(miMap));
            }
            for (Object filepath : mod) {
                miMap.put('action', 'Update');
                miMap.put('filepath', (String) filepath);
                miMap.put('notes', notes);
                miMap.put('relatedTo', relatedTo);
                mItems.add(WebhooksManagerHelper.createManifestItem(miMap));
            }
        }
        
        insert mItems;
        return mItems;
    }
}