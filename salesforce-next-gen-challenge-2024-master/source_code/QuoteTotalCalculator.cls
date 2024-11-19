public class QuoteTotalCalculator{
    
    public static void CalculateTotalAndSubtotal(List<Contract> insertedContracts)
    {
        Decimal numberOfSubjects = 0;
        Decimal totalDiscount = 0.00;
        List<Contact> students = [SELECT FirstName, LastName, Campus__c, ID FROM Contact];
        
        for(Contract c : insertedContracts)
        {
            Decimal pricePerSubject;
            Decimal subtotal = 0.00;
            
            Contact student;
            
            for(Contact s : students)
            {
                if(s.Id == c.CustomerSignedId){
                    student = s;
                }
            }
             
            numberofSubjects = c.Number_of_Subjects__c;
            
            switch on student.Campus__c{
                when 'Guanajuato'{
                    pricePerSubject = 17000.00;
                }
                when 'Nuevo Leon'{
                    pricePerSubject = 18000.00;
                }
                when 'Jalisco'{
                    pricePerSubject = 13000.00;
                }
                when 'Queretaro'{
                    pricePerSubject = 15000.00;
                }
            }
            
            if(numberOfSubjects == 1)
                subtotal = pricePerSubject;
            
            
            if(numberOfSubjects == 2)
            {
                subtotal = pricePerSubject;
                subtotal += pricePerSubject - pricePerSubject*(0.10);
            }
            
            if(numberOfSubjects > 2)
            {
                subtotal = pricePerSubject;
                for(Integer i = 1; i<numberOfSubjects; i++)
                {
                    subtotal += (pricePerSubject - pricePerSubject*(0.15));
                }               
            }
            
            if(c.Payment_Method__c == 'Cash')
                subtotal = subtotal - subtotal*(0.05);
            
            c.Subtotal__c = subtotal; 
            
            if(c.Excellence_Scholarship__c == true)
            	totalDiscount += 10.00;
            
            if(c.Sports_Scholarship__c == true)
            	totalDiscount += 10.00;
            
            if(c.Teaching_Relatives_Scholarship__c == true)
            	totalDiscount += 30.00; 
            
            if(c.Economic_Need_Scholarship__c == true)
            	totalDiscount += 30.00;
            
            if(totalDiscount > 60.00)
                totalDiscount = 60.00;
            
            c.Total_Cost__c = subtotal - subtotal*(totalDiscount/100.00);
        }     
    }   
}