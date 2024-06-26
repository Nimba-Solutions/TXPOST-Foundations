public with sharing class FormController {
    
    @AuraEnabled(cacheable=true)
    public static List<Form__c> getForms() {
        return [SELECT Id, Title__c, Status__c FROM Form__c ORDER BY CreatedDate DESC];
    }
    
    @AuraEnabled
    public static Id createForm(String formData) {
        try {
            Map<String, Object> formDataMap = (Map<String, Object>) JSON.deserializeUntyped(formData);
            Form__c newForm = new Form__c();
            newForm.Title__c = (String) formDataMap.get('Title');
            newForm.Status__c = 'Draft'; // Setting a default status
            insert newForm;
            return newForm.Id;
        } catch (Exception ex) {
            // Log the exception for debugging
            System.debug('Exception occurred while creating form: ' + ex.getMessage());
            throw ex;
        }
    }
    
    @AuraEnabled
    public static Form__c getFormById(String formId) {
        return [SELECT Id, Title__c, Status__c FROM Form__c WHERE Id = :formId];
    }
    
    @AuraEnabled
    public static void updateForm(String formData) {
        try {
            Map<String, Object> formDataMap = (Map<String, Object>) JSON.deserializeUntyped(formData);
            Form__c existingForm = new Form__c(Id = (String) formDataMap.get('Id'));
            existingForm.Title__c = (String) formDataMap.get('Title');
            existingForm.Status__c = (String) formDataMap.get('Status');
            update existingForm;
        } catch (Exception ex) {
            // Log the exception for debugging
            System.debug('Exception occurred while updating form: ' + ex.getMessage());
            throw ex;
        }
    }
    
    @AuraEnabled
    public static void deleteForm(String formId) {
        Form__c formToDelete = new Form__c(Id = formId);
        delete formToDelete;
    }
    
}