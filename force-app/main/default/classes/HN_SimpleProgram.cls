public with sharing class HN_SimpleProgram {
    public HN_SimpleProgram() {
    }

    @AuraEnabled(cacheable=false)
    public static String getSimpleResponse() {
        Http http = new Http();

        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://hacker-news.firebaseio.com/v0/item/47440233.json?print=pretty');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            throw new AuraHandledException('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }

    @AuraEnabled(cacheable=false)
    public static String responseChecker(String itemId){
       
        Http h = new Http();
        HttpRequest r = new HttpRequest();
        try{

        r.setEndpoint('callout:HN_API/v0/' + itemId + '.json?print=pretty');
        r.setMethod('GET');
        HttpResponse resp = h.send(r);
         return resp.getBody();
        }

        catch(Exception e){

        }
       return null;
    }



}