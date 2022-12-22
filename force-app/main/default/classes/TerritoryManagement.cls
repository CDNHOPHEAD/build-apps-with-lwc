public class TerritoryManagement {
    public static void AccountOwner(List<Account> acctList){
        
        List<String> postalCodeList = new List<String>();

        //[SELECT Id, BillingPostalCode, (SELECT Id,Owner, Name from Contacts), (SELECT Id, //Name From Opportunities WHERE IsClosed = false)FROM Account WHERE Id IN :actIds]

        for(Account acc: acctList){
            postalCodeList.add(acc.BillingPostalCode);
        }
        
        List<Territory__c> territoryList = [SELECT Id,Sales_Rep__c, Zip_Code__c FROM Territory__c WHERE Zip_Code__c IN :postalCodeList];

        Map<String, Territory__c> territoryMap = new Map<String, Territory__c>();
        for(Territory__c territory : territoryList){
            territoryMap.put(territory.Zip_Code__c, territory);
        }

        List<Id> targetAcctIds = new List<Id>();

        for(Account acc: acctList){
            //Look for sales rep
            if(territoryMap.containsKey(acc.BillingPostalCode) && territoryMap.get(acc.BillingPostalCode).Sales_Rep__c != null){
                acc.OwnerId = territoryMap.get(acc.BillingPostalCode).Sales_Rep__c;
                targetAcctIds.add(acc.Id);
            }
        }

        List<Opportunity> oppList =[SELECT Id,AccountId,Account.BillingPostalCode,OwnerId,IsClosed FROM Opportunity WHERE IsClosed = false AND AccountId IN :targetAcctIds];

        for(Opportunity opp: oppList){
            opp.OwnerId = territoryMap.get(opp.Account.BillingPostalCode).Sales_Rep__c;
            System.debug(opp.OwnerId);
        }
        update oppList;
    }
}
//91000