# Salesforce records anonymizer

Extensible skeleton Apex-driven project, which can be used for data management-related tasks within your Salesforce org, such as GDPR Compliance or data storage optimization.

![Diagram](/anonymizator.drawio.png "Diagram")

# How it works

An end user should configure Anonymization Configuration custom metadata record for each Sobject, which has to be processed, providing: 
<ul>
    <li>The number of days a record is untouched(comparing to last modified date), which determines that the record has to be anonymized;</li>
    <li>And/or the number of days a record is untouched, which determines that the record has to be deleted;</li>
    <li>Sobject API name;</li>
    <li>Field set API name on the Sobject, which describes fields to be processed;</li>
    <li>Apex class API name, which is responsible for data processing(by default it's BaseAnonymizator).</li>
</ul>
</br>
Afterward, the end user should schedule the processing by calling <code>AnonymizationBatch.start();</code>, what, in its turn, will schedule a batch job execution for each Sobject configured in the custom metadata(by default the job scheduled to be launched once per month).

## Fine-grained control over anonymization values

In case your project requires more fine-grained control over data anonymization - field sets more or less easily can be replaced with a custom metadata definition, where you define which particular field and with which specific value is anonymized. This way creating a master-detail relationship between Anonymization Configuration custom metadata type and the one introduced above.