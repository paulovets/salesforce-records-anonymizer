public without sharing class AnonymizationBatch implements Database.Batchable<sobject>, 
                                                           Database.Stateful,
                                                           Schedulable {

    private AnonymizationService.Configuration configuration { get; set; }

    private Set<Id> processedRecordsIds = new Set<Id>();

    public AnonymizationBatch(List<AnonymizationConfiguration__mdt> customMetadataConfigs) {
        this.configuration = AnonymizationService.buildConfiguration(customMetadataConfigs);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return this.configuration.anonymizator.buildQueryLocator(this.configuration.processingCustomMetadataConfig);
    }
     
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        final Set<Id> processedScopeIds = this.configuration.anonymizator.anonymize(scope, this.configuration.processingCustomMetadataConfig);

        this.processedRecordsIds.addAll(processedScopeIds);
    }
  
    public void finish(Database.BatchableContext BC) {
        this.configuration.anonymizator.executePostProcessing(this.configuration.toBeProcessedCustomMetadataConfigs, 
                                                              processedRecordsIds);
    }

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new AnonymizationBatch(null));
    }
   
    public static void start() {
        // Class runs the last Friday of every month at 10 PM.
        System.schedule('Anonymization Scheduler', '0 0 22 ? * 6L', new AnonymizationBatch(null));
    }
}
