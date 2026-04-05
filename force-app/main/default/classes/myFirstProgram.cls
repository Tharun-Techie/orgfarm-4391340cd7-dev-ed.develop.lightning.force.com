public class myFirstProgram {
    public static void hello()
    {
        List<Account> accList = new List<Account>();
        accList = [Select id, type from account limit 200];
        System.debug(accList);

        for(Account acc : accList)
        {
            System.debug(acc.id);
            System.debug(acc.type);
        }

        Id id = accList[0].id;
        System.debug(id);

        String str = accList[0].type;
        System.debug(str);

        List<String> strList = new List<String>();
        strList.add('Hello');
        strList.add('World');
        strList.add('!');

        for(String str1 : strList)
        {
            System.debug(str1);
        }
        //CREATE 10 RANDOM DUMMY DATA FOR CONTACT 
        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < 10; i++) 
        {
            Contact con = new Contact();
            con.FirstName = 'Test' + i;
            con.LastName = 'Test' + i;
            con.Email = 'test' + i + '@test.com';
            conList.add(con);
        }
        insert conList;

    }

}