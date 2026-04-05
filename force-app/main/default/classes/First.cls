public class First {
    public static void hello() {
        List<Account> accList = new List<Account>();
        
        accList = [Select id, type from account limit 200];
        
        System.debug(accList);
    }
}