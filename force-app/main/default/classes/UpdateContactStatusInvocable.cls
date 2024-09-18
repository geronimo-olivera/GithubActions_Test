public class UpdateContactStatusInvocable {
    
    @InvocableMethod
    public static List<ContactCount> updateContacts(List<String> emailContainingPhrase) {        
        List<Contact> contactsToUpdate = new List<Contact>();
        
        List<Contact> contacts = [SELECT Id, Email, Is_Active__c FROM Contact];
        for (Contact con : contacts) {
            
            if (con.Email != null) {
                String contactEmail = con.Email.trim().toLowerCase();
               
                for (String emailPhrase : emailContainingPhrase) {
                    if (emailPhrase != null && contactEmail.contains(emailPhrase)) {
                        con.Is_Active__c = false;                    
                        contactsToUpdate.add(con);
                    }
                }
            }
        }
        
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
        
        ContactCount contactCount = new ContactCount();
        contactCount.count = contactsToUpdate.size();
        return new List<ContactCount> { contactCount };
	}
    
    public class ContactCount {
        @InvocableVariable(required=true)
        public Integer count;
    }
}