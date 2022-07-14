public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        System.debug('Testing...code for git.....');
                List<Account> accLst=new List<Account>();
         accLst=[SELECT Id, Name FROM Account LIMIT 500];
        return accLst;
    }

    @AuraEnabled(cacheable=true)
    public static Account getSingleAccount() {
        return [SELECT Id, Name, Phone, Type FROM Account LIMIT 1];
    }
}