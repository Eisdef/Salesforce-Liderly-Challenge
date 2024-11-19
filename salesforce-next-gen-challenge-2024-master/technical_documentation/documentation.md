**Objetos estándar utilizados**

Para los estudiantes, se utilizó el objeto estándar "Contact", renombrado "Student", pues ya posee la mayoría de los
datos que se esperaban de los estudiantes, como el Email, número de teléfono, nombre y apellido y fecha de nacimiento.
Se agregaron campos personalizados específicos de un estudiante como el promedio (Grade Point Average), el estado 
donde estudia (representado en la plataforma como "Campus"), y la matrícula (Register).

Student
-Id
-Name
    -FirstName
    -LastName
-Birthdate
-Campus__c
-Email
-Phone
-Grade_Point_Average__C
-Register__c

-Reglas de validación y configuración de campos personalizados

La regla de validación "GPA_must_be_less_than_10_more_than_0", como el nombre lo implica, valida que el promedio sea 
mayor que 0, pero menor que 10. La fórmula que se utilizó para esta validación fue la siguiente:

OR( Grade_Point_Average__c > 10, Grade_Point_Average__c < 0)

El número de cifras antes y después del punto ya se encuentra especificado en el 
campo mismo (dos cifras antes del punto, y una cifra después del punto, para obtener un formato de 00.0).

Para el valor de la matrícula, se utilizó un campo de tipo auto-number, que funciona con la siguiente fórmula:

EST-{00000}

De esta forma, todas las matrículas tendrán el sufijo 'EST-', mientras que el número dentro de los corchetes irá 
incrementando mientras más registros se creen

Para las cotizaciones, se utilizó el objecto "Contract", pues posee campos que pueden utilizarse para definir las
mensualidades, y además, ya tiene un campo de tipo Lookup con el objecto Contact, en este caso, con el objeto 
Student. Cabe destacar que en mi organización no se encontraba el objeto estándar Quote, que era la elección lógica 
en todo caso, así que decidí usar Contract como alternativa. A diferencia del campo Contact, se tuvo que agregar 
bastantes campos personalizados, entre ellos, checklists para cada tipo de beca, el periodo, el número de 
materias, el tipo de pago, el subtotal (el precio antes del descuento) y el total (el precio después del descuento).

Contract
-Id
-CustomerSigned
-Economic_Need_Scholarship__c
-Excellence_Scholarship__c
-Teaching_Relatives_Scholarship__c
-Sports_Scholarship__c
-Term__c
-Number_of_subjects__c
-Payment_Method__c
-Subtotal__c
-Total_Cost__c

-Reglas de validación y configuración de campos personalizados

La regla de validación "Number_of_subjects_must_meet_the_term" valida que el número de materias concorde con el 
periodo, es decir, que un periodo cuatrimestras tenga un máximo de 4 materias, y que uno bimestral tenga un máximo
de 7 materias, tal como se pide en los requerimientos. La fórmula utilizada fue la siguiente:

OR( AND(Number_of_Subjects__c > 4, ISPICKVAL(Term__c,'Quarterly')), AND(Number_of_Subjects__c > 7, ISPICKVAL(Term__c, 'Biannual')))

El campo de Excellence Scholarship (beca por excelencia) es un checklist que utiliza una fórmula para saber si es
true o false, la fórmula es la siguiente: 

If( CustomerSigned.Grade_Point_Average__c >= 9.5, true, false)

Se puede ver que se accede al contacto al que está relacionado el contrato (CustomerSigned) para acceder al campo 
de Grade_Point_Average__c, que es el promedio del estudiante. Es necesario acceder a este promedio para validar
si la beca se aplica o no.

Los campos de Subtotal y Total son calculados mediante un trigger que se ejecuta antes de insertar un nuevo
registro, el cuál se verá a continuación.

**Lógica de automatización**

La automatización recae en un solo trigger, InsertedQuoteTrigger, el cual se ayuda de dos clases helper, 
QuoteTotalCalculator y QuoteEmailService. QuoteTotalCalculator calcula los valores del subtotal y el total de la 
cotización, mientras que QuoteEmailService envía un PDF con la información de la cotización al correo del estudiante.

El trigger ejecuta el método QuoteTotalCalculator.CalculateTotalAndSubtotal(List<Contract> contracts) antes de insertar
el registro (before insert). Después de insertar el registro (after insert), el trigger crea una instancia de la clase 
QuoteEmailService utilizando la lista de cotizaciones a registrar como parámetro del constructor. Posteriormente, se
ejecuta la instancia de forma asíncrona. El trigger es capaz de procesar registros en bulk.

Para calcular el subtotal, el método CalculateTotalAndSubtotal toma el campus en el que estudia el alumno, y de 
ahí define un precio base:

Guanajuato = 17000.00
Nuevo Leon = 18000.00
Jalisco = 13000.00
Queretaro = 15000.00

Posteriormente, basándose en el número de materias inscritas, se rebaja el precio de las materias adicionales (solo
una materia se cobra completa): Si son dos materias, la segunda materia se rebaja en 10%, mientras que si son 3 o más,
el resto de las materias se rebajan en 15%. Adicionalmente, se hace una rebaja del 5% si el pago es al contado (Cash).

Para calcular el total, se validan las becas que posee el alumno (que en este caso, se registran en la cotización), y 
se suman los porcentajes de descuento de cada beca. Al final se valida que, si el descuento es mayor a 60%, el descuento
sea solo del 60%, de esta forma, el descuento nunca será mayor que 60%, por más becas que el alumno tenga.

La clase QuoteEmailService se apoya de una página de Visualforce (QuotePDF), el cual renderiza la información de la cotización
en forma de tablas. La misma página de Visualforce es capaz de validar si el pago se hizo al contado o en mensualidades 
para poder mostrar correctamente las fechas de pago. 

La clase implementa la interfaz Queueable. Esto es necesario ya que, al trabajar con callouts, debe trabajar de forma asíncrona.
El método execute() de la interfaz Queueable, genera una lista de objetos SingleEmailMessage, a los cuales se les asigna
la dirección de correo electrónico del alumno que va a inscribirse, un asunto, y un cuerpo con el contenido del email.
Adicionalmente, se crea un objeto PDF utilizando el ID de la cotización para que aparezcan los datos correctos, este se utiliza
para crear un "Blob" que se utiliza para crear el archivo adjunto del correo. Finalmente, se envían todos los correos
utilizando el método Messaging.sendEmail().

NOTA: Para poder enviar correos desde Salesforce, es necesario activar el correo remitente desde la organización.


