@isTest
public class TestBaseAnonymizator {
    
    @isTest
    static void testDeletion() {
        System.Test.loadData(Account.sObjectType, 'TestAccounts');

        final AnonymizationConfiguration__mdt accountConfig = findConfigFor('Account');

        System.assert([SELECT Id FROM Account].size() > 0);

        System.Test.startTest();
            AnonymizationBatch batch = new AnonymizationBatch(new List<AnonymizationConfiguration__mdt> { accountConfig });
            Database.executeBatch(batch);
        System.Test.stopTest();

        System.assert([SELECT Id FROM Account].size() == 0);
    }

    // Static resource has to be updated
    @isTest
    static void testAnonymization() {
        System.Test.loadData(Account.sObjectType, 'TestRecentAccounts');

        final AnonymizationConfiguration__mdt accountConfig = findConfigFor('Account');

        System.assert([SELECT Id FROM Account].size() > 0);

        System.Test.startTest();
            AnonymizationBatch batch = new AnonymizationBatch(new List<AnonymizationConfiguration__mdt> { accountConfig });
            Database.executeBatch(batch);
        System.Test.stopTest();

        System.assert([SELECT Id FROM Account].size() > 0);
    }

    public static AnonymizationConfiguration__mdt findConfigFor(String sobjectAPIName) {
        final List<AnonymizationConfiguration__mdt> configs = AnonymizationConfiguration__mdt.getAll().values();
        final AnonymizationConfiguration__mdt accountConfig;
        for (AnonymizationConfiguration__mdt config: configs) {
            if (config.SobjectAPIName__c == sobjectAPIName) {
                accountConfig = config;

                break;
            }
        }

        return accountConfig;
    }
}
