public without sharing class ContactsAnonymizationReportController {

    public final List<String> emails { get; set; } 

    public ContactsAnonymizationReportController() {
        final String base64ContactsIds = ApexPages.currentPage().getParameters().get(ContactsAnonymizator.BASE64_CONTACTS_IDS);

        final String contactsIdsJson = EncodingUtil.base64Decode(base64ContactsIds).toString();

        final List<Id> contactsIds = (List<Id>)JSON.deserialize(contactsIdsJson, List<Id>.class);

        List<Contact> contacts = [SELECT Email FROM Contact WHERE Id IN: contactsIds];

        this.emails = new List<String>();

        for (Contact contact : contacts) {
            this.emails.add(contact.Email);
        }
    }
}
