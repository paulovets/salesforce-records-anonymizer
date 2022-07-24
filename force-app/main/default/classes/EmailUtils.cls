public without sharing class EmailUtils {
    
    public static void sendEmail(List<String> emails, 
                                 String subject, 
                                 String htmlBody,
                                 List<Blob> plainAttachments) {
        final List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        for (Integer i = 0; i < plainAttachments.size(); i++) {
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();

            attachment.setBody(plainAttachments.get(i));
            attachment.setFileName('Attachment ' + (i + 1));

            attachments.add(attachment);
        }

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();

        emailMessage.setSubject(subject);
        emailMessage.setToAddresses(emails);
        emailMessage.setHtmlBody(htmlBody);
        emailMessage.setFileAttachments(attachments);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { emailMessage });
    }
}
