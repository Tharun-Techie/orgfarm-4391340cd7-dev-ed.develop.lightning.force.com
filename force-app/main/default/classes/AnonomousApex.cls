public with sharing class AnonomousApex {


    Account acc = new Account();
    acc.Name = 'Test Account';
    insert acc;


    List<Account> accList =[select id, name from Account limit 10];

    for(Account ac : accList){
        System.debug(ac.id);
        System.debug(ac.name);
    }






    
}