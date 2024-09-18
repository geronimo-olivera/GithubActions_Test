public with sharing class UserModel {
    public class UserWrapper {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String username;

        @AuraEnabled
        public String email;

        @AuraEnabled
        public String profileName;

        @AuraEnabled
        public Boolean isActive;

        public UserWrapper(User user) {
            email = user.Email;
            id = user.Id;
            isActive = user.IsActive;
            name = user.Name;
            profileName = user.Profile.Name;
            username = user.Username;
        }
    }

    public static List<UserWrapper> getActiveUsers() {
        List<UserWrapper> users = new List<UserWrapper>();
        for (User user : [
            SELECT Id, Name, Profile.Name, Username, Email
            FROM User
            WHERE IsActive = TRUE
        ]) {
            users.add(new UserWrapper(user));
        }
        return users;
    }

    public static List<UserWrapper> getUsersWithPermissionSetAssigned(Id permissionSetId) {
        List<UserWrapper> users = new List<UserWrapper>();
        for (User user : [
            SELECT Id, Email, IsActive, Name, Profile.Name, Username
            FROM User
            WHERE Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSetId)
        ]) {
            users.add(new UserWrapper(user));
        }
        return users;
    }
}