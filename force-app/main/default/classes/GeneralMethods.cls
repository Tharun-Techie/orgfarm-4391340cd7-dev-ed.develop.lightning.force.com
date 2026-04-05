public class GeneralMethods {

    public static String getStoryLink(String itemId) {
        return Global_Constants.HN_API + '/v0/item/' + itemId + '.json?print=pretty';
    }

    public static void insertRecord(String itemId) {
        ResponseWrapper story = (ResponseWrapper)JSON.deserialize(getResponse(itemId), ResponseWrapper.class);
        Database.insert(objectMaper(story),false);
    }

    public static String getResponse(String itemId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(GeneralMethods.getStoryLink(itemId));
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return sanityJSON(response.getBody());
        } else {
            throw new AuraHandledException('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }

    }

    public static String getBestStories() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(Global_Constants.HN_API_BestStories);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
 
        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            throw new AuraHandledException('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }

    }

    public static List < String > getBestStoriesList() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(Global_Constants.HN_API_BestStories);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return getListString(response.getBody());
        } else {
            throw new AuraHandledException('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }

    }

    public static String getTopStories() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(Global_Constants.HN_API_TopStories);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            throw new AuraHandledException('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }

    }

    public static List < String > getTopStoriesList() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(Global_Constants.HN_API_TopStories);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return getListString(response.getBody());
        } else {
            throw new AuraHandledException('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }

    }

    private static List < Integer > getListInteger(String response) {
        // Convert string to a List of Integers
        return (List < Integer > ) JSON.deserialize(response, List < Integer > .class);
    }

    private static List<String> getListString(String response) {
    // Convert string to a List of String
    return (List<String>) JSON.deserialize(response, List<String>.class);
    }

    private static String sanityJSON(String res){
            if(String.isBlank(res)){
                throw new AuraHandledException('Response is Null or Empty'); 
            }
                // Using quotes + colon ensures we only replace JSON keys
                 return res.replaceAll('(?i)"by"\\s*:', '"postedBy":')
                          .replaceAll('(?i)"id"\\s*:', '"ItemId":')
                          .replaceAll('(?i)"time"\\s*:', '"UnixTime":')
                          .replaceAll('(?i)"type"\\s*:', '"Itemtype":');
    }
	
    Public static HN_DataObject__c objectMaper(ResponseWrapper story){
            HN_DataObject__c obj = new HN_DataObject__c();
            obj.Username__c = story.postedBy;
           
        
            obj.Descendants__c = story.descendants != null ? Integer.valueOf(story.descendants) : 0;
            obj.ItemId__c = story.ItemId != null ? Long.valueOf(story.ItemId) : null;
            
            
            obj.Kids__c = story.kids != null ? String.join(story.kids, ',') : null;
            
            obj.Score__c = story.score != null ? Integer.valueOf(story.score) : 0;
            obj.Time__c =  story.UnixTime != null ? Long.valueOf(story.UnixTime) : null;
            obj.Text__c = story.title;
            obj.Url__c = story.url;
            
            return obj;
    }
    


}