public without sharing class SchemaUtils {
    
    public static List<Schema.FieldSetMember> getFieldSetMembers(String objectAPIName, String fieldSetAPIName) {
        return Schema.getGlobalDescribe()
            .get(objectAPIName)
            .getDescribe()
            .FieldSets
            .getMap()
            .get(fieldSetAPIName)
            .getFields();
    }
}
