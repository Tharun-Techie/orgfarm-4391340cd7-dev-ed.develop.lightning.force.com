public with sharing class CatFactController {

    @AuraEnabled(cacheable=false)
    public static String getCatFact() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://catfact.ninja/fact');
        req.setMethod('GET');

        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            
            throw new AuraHandledException('Failed to fetch cat fact');
        }
    }
}