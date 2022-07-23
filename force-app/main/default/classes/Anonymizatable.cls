public interface Anonymizatable {

    Database.QueryLocator buildQueryLocator(AnonymizationConfiguration__mdt processingCustomMetadataConfig);

    Set<Id> anonymize(List<SObject> records, AnonymizationConfiguration__mdt processingCustomMetadataConfig);

    void executePostProcessing(List<AnonymizationConfiguration__mdt> toBeProcessedCustomMetadataConfigs,
                               Set<Id> processedRecordsIds);
}