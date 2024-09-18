public class ContactNewVFController {
	
    public Contact newContact { get; set; }
    public Contact contact { get; set; }
    public Boolean isSaved { get; set; }
    public Boolean isEdit { get; set; }
    
    public ContactNewVFController() {
        String contactId = ApexPages.currentPage().getParameters().get('id');
        newContact = new Contact();
        contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
    }
    
    public void saveContact() {
        if(validateNewContact()){
            try {
                insert newContact;
                isSaved = true;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating contact: ' + e.getMessage()));
                isSaved = false;
            }
        }      
    }
    
    public void updateContact(){
        if(validateUpdateContact()){
            try {
                update contact;
                isEdit = true;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating contact: ' + e.getMessage()));
                isEdit = false;
            }
        }
        
    }
    
    private Boolean validateNewContact() {
        Boolean isValid = true;
        if (newContact.LastName == null || newContact.LastName.length() < 2) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Last Name must be at least 2 characters long.'));
            isValid = false;
        }
        if (newContact.Email == null || newContact.Email == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email cannot be empty.'));
            isValid = false;
        }
        return isValid;
    }
    
    private Boolean validateUpdateContact() {
        Boolean isValid = true;
        if (contact.LastName == null || contact.LastName.length() < 2) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Last Name must be at least 2 characters long.'));
            isValid = false;
        }
        if (contact.Email == null || contact.Email == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email cannot be empty.'));
            isValid = false;
        }
        return isValid;
    }
}