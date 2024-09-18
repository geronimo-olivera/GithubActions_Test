public with sharing class UserService {
    public static List<UserModel.UserWrapper> getActiveUsers() {
        return UserModel.getActiveUsers();
    }

    public static List<UserModel.UserWrapper> getUsersWithPermissionSetAssigned(Id permissionSetId) {
        return UserModel.getUsersWithPermissionSetAssigned(permissionSetId);
    }
}