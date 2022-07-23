public without sharing class AnonymizationService {

    public static Configuration buildConfiguration(List<AnonymizationConfiguration__mdt> customMetadataConfigs) {
        final List<AnonymizationConfiguration__mdt> configsToProceedWith = customMetadataConfigs == null ?
            AnonymizationConfiguration__mdt.getAll().values() :
            customMetadataConfigs;

        if (configsToProceedWith.isEmpty()) {
            throw new AnonymizationService.AnonymizationException('No configurations were found.');
        }

        return new Configuration(configsToProceedWith);
    }

    public class Configuration {
        public List<AnonymizationConfiguration__mdt> toBeProcessedCustomMetadataConfigs { get; private set; }

        public AnonymizationConfiguration__mdt processingCustomMetadataConfig { get; private set; }

        public Anonymizatable anonymizator { get; private set; }

        public Configuration(List<AnonymizationConfiguration__mdt> customMetadataConfigs) {
            final List<AnonymizationConfiguration__mdt> clonedCustomMetadataConfigs = customMetadataConfigs.clone();

            this.processingCustomMetadataConfig = clonedCustomMetadataConfigs.remove(0);

            this.toBeProcessedCustomMetadataConfigs = clonedCustomMetadataConfigs;

            this.anonymizator = this.buildAnonymizator(this.processingCustomMetadataConfig.SobjectAPIName__c);
        }

        private Anonymizatable buildAnonymizator(String apexClassAPIName) {
            try {
                Type t = Type.forName(apexClassAPIName);
    
                return (Anonymizatable)t.newInstance();
            } catch(DmlException e) {
                System.debug('Could not instantiate an instance of ' + apexClassAPIName + ': ' + e.getMessage());
    
                return new BaseAnonymizator();
            }
        }
    }

    public virtual class AnonymizationException extends Exception {}
}
