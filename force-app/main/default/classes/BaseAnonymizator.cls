public virtual without sharing class BaseAnonymizator implements Anonymizatable {

    public virtual Database.QueryLocator buildQueryLocator(AnonymizationConfiguration__mdt processingCustomMetadataConfig) {
        final List<Schema.FieldSetMember> fieldSetMembers = SchemaUtils.getFieldSetMembers(processingCustomMetadataConfig.SobjectAPIName__c, 
                                                                                           processingCustomMetadataConfig.FieldSetAPIName__c);

        final List<String> fieldsPaths = new List<String> { 'LastModifiedDate' };
        for (Schema.FieldSetMember member: fieldSetMembers) {
            fieldsPaths.add(member.getFieldPath());
        }

        Integer ttl = (Integer)processingCustomMetadataConfig.AnonymizationTTLInDays__c;

        String query = 'SELECT ' + 
            String.join(fieldsPaths, ',') + 
            ' FROM ' + processingCustomMetadataConfig.SobjectAPIName__c + 
            ' WHERE LastModifiedDate < LAST_N_DAYS:' + ttl;

        return Database.getQueryLocator(query);
    }

    public virtual void anonymize(List<SObject> records, AnonymizationConfiguration__mdt processingCustomMetadataConfig) {
        if (records.isEmpty()) {
            return;
        }

        final List<Schema.FieldSetMember> fieldSetMembers = SchemaUtils.getFieldSetMembers(processingCustomMetadataConfig.SobjectAPIName__c, 
                                                                                           processingCustomMetadataConfig.FieldSetAPIName__c);

        final List<sObject> toDelete = new List<sObject>();
        final List<sObject> toUpdate = new List<sObject>();

        for (sObject record : records) {
            if (processingCustomMetadataConfig.DeletionTTLInDays__c != null &&
                (Datetime)record.get('LastModifiedDate') <= Datetime.now().addDays(-(Integer)processingCustomMetadataConfig.DeletionTTLInDays__c)) {
                toDelete.add(record);

                continue;
            }

            for (Schema.FieldSetMember member : fieldSetMembers) {
                this.anonymizeField(record, member.getSObjectField().getDescribe());
            }

            toUpdate.add(record);
        }

        if (!toDelete.isEmpty()) {
            delete toDelete;
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    public virtual void executePostProcessing(List<AnonymizationConfiguration__mdt> toBeProcessedCustomMetadataConfigs,
                                      Set<Id> processedRecordsIds) {
        if (toBeProcessedCustomMetadataConfigs.isEmpty()) {
            return;
        }
        
        // We can imagine that it could be necessary to execute some custom logic based on processed records
        Database.executeBatch(new AnonymizationBatch(toBeProcessedCustomMetadataConfigs));
    }

    protected void anonymizeField(sObject record, Schema.DescribeFieldResult fieldDescribe) {
        if (fieldDescribe.isCalculated()) {
            return;
        }

        if (fieldDescribe.getDefaultValue() != null) {
            record.put(fieldDescribe.getName(), fieldDescribe.getDefaultValue());

            return;
        }

        if (fieldDescribe.isNillable()) {
            record.put(fieldDescribe.getName(), null);

            return;
        }

        final Schema.DisplayType type = fieldDescribe.getType();

        switch on type {
            when STRING, TEXTAREA, PHONE {
                record.put(fieldDescribe.getName(), 'anonymized');
            }
            when INTEGER, LONG, DOUBLE, CURRENCY, PERCENT {
                record.put(fieldDescribe.getName(), 0);
            }
            when BOOLEAN {
                record.put(fieldDescribe.getName(), false);
            }
            when EMAIL {
                record.put(fieldDescribe.getName(), 'anonymized@anonymized.com');
            }
            when URL {
                record.put(fieldDescribe.getName(), 'http://anonymized.com');
            }
            when else {
                System.debug('Unanonymized field: ' + fieldDescribe.getName());
            }
        }
    }
}
