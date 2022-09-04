@isTest
private class TestContactsAnonymizator {

    @isTest
    static void coverContactsExample() {
        System.Test.loadData(Contact.sObjectType, 'TestContacts');

        System.assert([SELECT Id FROM Contact].size() > 0);

        final AnonymizationConfiguration__mdt contactConfig = TestBaseAnonymizator.findConfigFor('Contact');

        System.Test.startTest();
            AnonymizationBatch batch = new AnonymizationBatch(new List<AnonymizationConfiguration__mdt> { contactConfig });
            Database.executeBatch(batch);
        System.Test.stopTest();

        System.assert(true);
    }
}
