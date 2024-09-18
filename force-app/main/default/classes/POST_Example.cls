public class POST_Example {

    public void sendPostReq() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SalesforcePOST');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        String accToPass = JSON.serialize(wrapAccount(generateAccount()));
        Account test = (Account)JSON.deserialize(
               accToPass, Account.class);
        System.debug(accToPass);
        System.debug(test);
        System.debug(req);
        req.setBody(accToPass);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }
    
    private Account generateAccount(){
        Account acct = new Account();
        acct.Name = 'Hi';
        return acct;
    }
    
    private AccountWrapper wrapAccount(Account acct){
        AccountWrapper wrapper = new AccountWrapper();
        wrapper.acct = acct;
        return wrapper;
    }
    
    private class AccountWrapper {
        public Account acct;
    }
}