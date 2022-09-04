public without sharing class ContactsAnonymizator extends BaseAnonymizator {

    public static final String BASE64_CONTACTS_IDS = 'base64ContactsIds';

    public override void anonymize(List<SObject> records, AnonymizationConfiguration__mdt processingCustomMetadataConfig) {
        super.anonymize(records, processingCustomMetadataConfig);

        final Set<Id> ids = (new Map<Id, sObject>(records)).keySet();

        final String contactsIdsJson = JSON.serialize(ids);

        // Maybe not the best way, as per base64 encoding makes a payload heavier
        final String base64ContactsIds = EncodingUtil.base64Encode(Blob.valueof(contactsIdsJson));

        PageReference ref = Page.ContactsAnonymizationReport;
        ref.getParameters().put(ContactsAnonymizator.BASE64_CONTACTS_IDS, base64ContactsIds);

        if(System.Test.isRunningTest()) {
            return;
        }

        Blob b = ref.getContentAsPDF();

        EmailUtils.sendEmail(
            new List<String> { 'marketing@mycompany.com' },
            'Test Subject',
            'Test Body',
            new List<Blob> { b }
        );
    }
}
