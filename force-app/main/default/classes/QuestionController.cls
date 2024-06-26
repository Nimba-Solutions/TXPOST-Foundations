public with sharing class QuestionController {
    
    @AuraEnabled(cacheable=true)
    public static List<Question__c> getQuestionsByForm(String formId) {
        List<FormQuestion__c> formQuestions = [SELECT Question__r.Id FROM FormQuestion__c WHERE Form__c = :formId];
        
        Set<Id> questionIds = new Set<Id>();
        for (FormQuestion__c fq : formQuestions) {
            questionIds.add(fq.Question__r.Id);
        }
        
        return [SELECT Id, Title__c, Description__c FROM Question__c WHERE Id IN :questionIds];
    }
    
    @AuraEnabled
    public static Id createQuestion(String questionData) {
        Map<String, Object> questionDataMap = (Map<String, Object>) JSON.deserializeUntyped(questionData);
        String formId = (String) questionDataMap.get('FormId');
        
        // Create Question__c record
        Question__c newQuestion = new Question__c();
        newQuestion.Title__c = (String) questionDataMap.get('Title');
        newQuestion.Description__c = (String) questionDataMap.get('Description');
        insert newQuestion;
        
        // Create FormQuestion__c junction record
        FormQuestion__c formQuestion = new FormQuestion__c();
        formQuestion.Form__c = formId;
        formQuestion.Question__c = newQuestion.Id;
        insert formQuestion;
        
        return newQuestion.Id;
    }
    
    @AuraEnabled
    public static Question__c getQuestionById(String questionId) {
        return [SELECT Id, Title__c, Description__c FROM Question__c WHERE Id = :questionId];
    }
    
    @AuraEnabled
    public static void updateQuestion(String questionData) {
        Map<String, Object> questionDataMap = (Map<String, Object>) JSON.deserializeUntyped(questionData);
        Question__c existingQuestion = new Question__c(Id = (String) questionDataMap.get('Id'));
        existingQuestion.Title__c = (String) questionDataMap.get('Title');
        existingQuestion.Description__c = (String) questionDataMap.get('Description');
        update existingQuestion;
    }
    
    @AuraEnabled
    public static void deleteQuestion(String questionId) {
        Question__c questionToDelete = new Question__c(Id = questionId);
        delete questionToDelete;
    }
    
}