public class QuoteEmailService implements Queueable, Database.AllowsCallouts {
    
    List<Contract> quotes;
    
    public QuoteEmailService(List<Contract> triggerquotes)
    {
        this.quotes = triggerquotes;
    }
    
    public void execute(System.QueueableContext context){
        
        PageReference pdfPage = Page.QuotePDF;
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<Contact> students = [SELECT Email, FirstName, Name, Register__c, ID FROM Contact];
        
        for(Contract quote : quotes)
        {       
            Contact student;
            
            for(Contact s : students)
            {
                if(s.Id == quote.CustomerSignedId){
                    student = s;
                    System.debug(student);
                }
            }
            
            pdfPage.getParameters().put('id', (String) quote.Id);
            Blob pdfBlob = pdfPage.getContent();
            
            System.debug('PDF Blob size: ' + pdfBlob.size());
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { student.Email });
            email.setSubject('Enrollment quote for  ' + student.Name);
            email.setPlainTextBody('Hello ' + student.FirstName + ', please check the details about your enrollment in the attached PDF file. Have a good day!');
            
            Messaging.EmailFileAttachment pdfAttachment = new Messaging.EmailFileAttachment();
            pdfAttachment.setFileName('Quote_' + student.Register__c + '.pdf');
            pdfAttachment.setBody(pdfBlob);
            pdfAttachment.setContentType('application/pdf');
            email.setFileAttachments(new Messaging.EmailFileAttachment[] { pdfAttachment });
            
            emails.add(email);
            
        }
        
       
        Messaging.sendEmail(emails);
        
        
    }

}