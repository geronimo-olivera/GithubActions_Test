@isTest
private class CountNumberOfEmployeesTriggerHandlerTest {
 @testSetup
    static void setupData() {
        // Crea cuentas de prueba
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };

        // Crea contactos de prueba
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc1.Id);
        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc1.Id);
        insert new List<Contact>{ con1, con2 };
    }
    
    @isTest
    static void testOnAfterInsert() {
        // Crea nueva cuenta
        Account acc = new Account(Name = 'New Test Account');
        insert acc;

        // Crea contactos y prueba inserción
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id);
        Test.startTest();
        insert con;
        Test.stopTest();

        // Verifica que el número de empleados se actualiza correctamente
        Account updatedAcc = [SELECT NumberOfEmployees FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, updatedAcc.NumberOfEmployees, 'El número de empleados debe ser 1');
    }

    @isTest
    static void testOnAfterUpdate() {
        // Obtener un contacto existente
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id, AccountId FROM Contact WHERE AccountId = :acc.Id LIMIT 1];

        // Crea otra cuenta
        Account acc2 = new Account(Name = 'Test Account 2');
        insert acc2;

        // Actualiza el contacto a una nueva cuenta
        con.AccountId = acc2.Id;
        Test.startTest();
        update con;
        Test.stopTest();

        // Verifica que el número de empleados en ambas cuentas se actualiza correctamente
        Account updatedAcc1 = [SELECT NumberOfEmployees FROM Account WHERE Id = :acc.Id];
        Account updatedAcc2 = [SELECT NumberOfEmployees FROM Account WHERE Id = :acc2.Id];
        
        System.assertEquals(0, updatedAcc1.NumberOfEmployees, 'El número de empleados en la primera cuenta debe ser 0');
        System.assertEquals(1, updatedAcc2.NumberOfEmployees, 'El número de empleados en la segunda cuenta debe ser 1');
    }

    @isTest
    static void testOnAfterDelete() {
        // Obtener un contacto existente
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id, AccountId FROM Contact WHERE AccountId = :acc.Id LIMIT 1];

        // Elimina el contacto
        Test.startTest();
        delete con;
        Test.stopTest();

        // Verifica que el número de empleados se actualiza correctamente después del delete
        Account updatedAcc = [SELECT NumberOfEmployees FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, updatedAcc.NumberOfEmployees, 'El número de empleados debe ser 0 después del borrado');
    }
}