public with sharing class PermissionSetController {
    @AuraEnabled(cacheable=true)
    public static List<PermissionSetModel.PermissionSetWrapper> gePermissionSets() {
        try {
            return PermissionSetService.gePermissionSets();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}