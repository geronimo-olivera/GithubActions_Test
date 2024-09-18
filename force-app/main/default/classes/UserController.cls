public with sharing class UserController {
    public static List<UserModel.UserWrapper> getActiveUsers() {
        try {
            return UserService.getActiveUsers();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<UserModel.UserWrapper> getUsersWithPermissionSetAssigned(Id permissionSetId) {
        try {
            return UserService.getUsersWithPermissionSetAssigned(permissionSetId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}