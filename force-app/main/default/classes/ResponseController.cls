public with sharing class ResponseController {
    
    @AuraEnabled(cacheable=true)
    public static List<Response__c> getResponsesByQuestion(String questionId) {
        return [SELECT Id, Configuration__c FROM Response__c WHERE Question__c = :questionId];
    }
    
    @AuraEnabled
    public static Id createResponse(String responseData) {
        Map<String, Object> responseDataMap = (Map<String, Object>) JSON.deserializeUntyped(responseData);
        String questionId = (String) responseDataMap.get('QuestionId');
        
        // Create Response__c record
        Response__c newResponse = new Response__c();
        newResponse.Configuration__c = (String) responseDataMap.get('Configuration');
        newResponse.Question__c = questionId;
        insert newResponse;
        
        return newResponse.Id;
    }
    
    @AuraEnabled
    public static Response__c getResponseById(String responseId) {
        return [SELECT Id, Configuration__c FROM Response__c WHERE Id = :responseId];
    }
    
    @AuraEnabled
    public static void updateResponse(String responseData) {
        Map<String, Object> responseDataMap = (Map<String, Object>) JSON.deserializeUntyped(responseData);
        Response__c existingResponse = new Response__c(Id = (String) responseDataMap.get('Id'));
        existingResponse.Configuration__c = (String) responseDataMap.get('Configuration');
        update existingResponse;
    }
    
    @AuraEnabled
    public static void deleteResponse(String responseId) {
        Response__c responseToDelete = new Response__c(Id = responseId);
        delete responseToDelete;
    }
    
}