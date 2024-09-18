@RestResource(UrlMapping='/AccountDML/*')
global class REST_Service {
    
    @HttpPost
    global static String insertAccount(Account account) {
        System.debug('account: ' + account);
        insert account;
        return account.Id;
    }
}