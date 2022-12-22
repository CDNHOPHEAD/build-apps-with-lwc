public without sharing class AccountTriggerHelper {

    public static void AssignSalesReps(List<Account> newAccounts) {
        
        List<String> postalCodeList = new List<String>();
        //[SELECT Id, BillingPostalCode, (SELECT Id,Owner, Name from Contacts), (SELECT Id, //Name From Opportunities WHERE IsClosed = false)FROM Account WHERE Id IN :actIds]

        for(Account acc: newAccounts){
            postalCodeList.add(acc.BillingPostalCode);
        }
        
        List<Territory__c> territoryList = [SELECT Id,Sales_Rep__c, Zip_Code__c FROM Territory__c WHERE Zip_Code__c IN :postalCodeList];

        Map<String, Territory__c> territoryMap = new Map<String, Territory__c>();
        for(Territory__c territory : territoryList){
            territoryMap.put(territory.Zip_Code__c, territory);
        }

        List<Id> targetAcctIds = new List<Id>();

        for(Account acc: newAccounts){
            //Look for sales rep
            if(territoryMap.containsKey(acc.BillingPostalCode) && territoryMap.get(acc.BillingPostalCode).Sales_Rep__c != null){
                acc.OwnerId = territoryMap.get(acc.BillingPostalCode).Sales_Rep__c;
                targetAcctIds.add(acc.Id);
            }
        }

        System.debug('Inside Task 1');
    }

////////////////////////////////////////////////////////////////////////////////////////////////

    public static void UpdateOpps(Map<Id,SObject> newAccounts, Map<ID, SObject> oldAccountMap) {
        
        Map<String,String> salesRepMap = new Map<String,String>();

        for(Territory__c terr: [SELECT Zip_Code__c,Sales_Rep__c FROM Territory__c]){
            salesRepMap.put(terr.Zip_Code__c , terr.Sales_Rep__c);
        }
        System.debug(salesRepMap);

        List<Account> acctList = new List<Account>();
        
        for(SObject acc: newAccounts.values()) {
            Account newAccount = (Account)newAccounts.get(acc.Id);
            Account oldAccount = (Account)oldAccountMap.get(acc.Id);
            if (newAccount.BillingPostalCode != oldAccount.BillingPostalCode && salesRepMap.containsKey(newAccount.BillingPostalCode)){
                newAccount.OwnerId = salesRepMap.get(newAccount.BillingPostalCode);
                System.debug(newAccount.OwnerId);
                acctList.add(newAccount);
            }
        }
        System.debug(acctList);
       // update acctList;
        

        List<Opportunity> oppList =[SELECT Id,AccountId,OwnerId,IsClosed FROM Opportunity WHERE IsClosed = false AND AccountId IN :acctList];
        System.debug(oppList);

        for(Opportunity opp: oppList){
            Account newAcc = (Account)newAccounts.get(opp.AccountId);
            opp.OwnerId = newAcc.OwnerId;
        }
        update oppList;
        
        
        
    }

//////////////////////////////////////////////////////////////////////////////////////
    public static void doTask3(List<Account> newAccounts, Map<ID, SObject> oldAccountMap) {
        Map<String,String> salesRepMap = new Map<String,String>();

        for(Territory__c terr: [SELECT Zip_Code__c,Sales_Rep__c FROM Territory__c]){
            salesRepMap.put(terr.Zip_Code__c , terr.Sales_Rep__c);
        }
        System.debug(salesRepMap);

        List<Account> acctList = new List<Account>();
        for (Account acc: newAccounts) {
            Account oldAccount = (Account)oldAccountMap.get(acc.Id);
            if (acc.BillingPostalCode != oldAccount.BillingPostalCode && salesRepMap.containsKey(acc.BillingPostalCode)){
                acctList.add(acc);
                System.debug(acc.OwnerId);

            }
        }
        System.debug(acctList);
       // update acctList;

        List<Opportunity> oppList =[SELECT Id,AccountId,Account.BillingPostalCode,OwnerId,IsClosed FROM Opportunity WHERE IsClosed = false AND AccountId IN :acctList];
        System.debug(oppList);

        for(Opportunity opp: oppList){
            opp.OwnerId = salesRepMap.get(opp.Account.BillingPostalCode);
        }
        update oppList;
        System.debug('Inside Task 3');
    }



    public void doTask4() {
        System.debug('Inside Task 4');
    }
    public void doTask5() {
        System.debug('Inside Task 5');
    }
}