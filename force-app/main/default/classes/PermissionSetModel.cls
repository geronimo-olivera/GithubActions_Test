public with sharing class PermissionSetModel {
    public class PermissionSetWrapper {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String description;

        @AuraEnabled
        public String licenseName;

        @AuraEnabled
        public Boolean isCustom;

        public PermissionSetWrapper(PermissionSet permissionSet) {
            id = permissionSet.Id;
            name = permissionSet.Label;
            description = permissionSet.Description;
            licenseName = permissionSet.License.Name;
            isCustom = permissionSet.IsCustom;
        }
    }

    public static List<PermissionSetWrapper> gePermissionSets() {
        List<PermissionSetWrapper> permissionSets = new List<PermissionSetWrapper>();
        for (PermissionSet permissionSet : [
            SELECT Description, Id, IsCustom, Label, License.Name
            FROM PermissionSet
            WHERE IsOwnedByProfile = FALSE
        ]) {
            permissionSets.add(new PermissionSetWrapper(permissionSet));
        }
        return permissionSets;
    }
}