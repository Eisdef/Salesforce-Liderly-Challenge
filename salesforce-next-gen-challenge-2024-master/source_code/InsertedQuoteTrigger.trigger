trigger InsertedQuoteTrigger on Contract (before insert, after insert) {

    if(Trigger.isBefore)
    {
        QuoteTotalCalculator.CalculateTotalAndSubtotal(Trigger.New);
    }
    if(Trigger.isAfter)
    {
        QuoteEmailService emailService = new QuoteEmailService(Trigger.New);
        System.enqueueJob(emailService);
    }
}