public with sharing class AnonomousApex {
    /**
     * Inserts a sample Account, queries up to 10 Accounts,
     * logs their Id and Name, and returns the list.
     */
    public static List<Account> runDemo() {
        // Create and insert a sample Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Query first 10 accounts
        List<Account> accList = [
            SELECT Id, Name
            FROM Account
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];

        // Log details
        for (Account ac : accList) {
            System.debug('Account Id: ' + ac.Id);
            System.debug('Account Name: ' + ac.Name);
        }

        // Example of logging a constructed Account variable
        Account sample = new Account(Name = 'tharun r');
        System.debug(sample);

        return accList;
    }
}
        