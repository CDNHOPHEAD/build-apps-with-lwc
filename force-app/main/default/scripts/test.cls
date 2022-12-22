public Map<String, Decimal> industrySummary(List<Account> accounts) {
    //code here
    Map<String,Decimal> industryRev = new Map<String,Decmial>();

    for(Account acc: accounts){
        if(industryRev.containsKey(acc.Industry)){
            //Add acc.Industry as a key
            //Add acc.AnnualRevenue to value
            Decimal currentRev = industryRev.get(acc.Industry);
            industryRev.put(acc.Industry,currentRev + acc.AnnualRevenue);
            
        }else{
            //find acc.Industry in map
            //Add acc.AnnualRevenue to exsisting value
            industryRev.put(acc.Industry, acc.AnnualRevenue);
        }
    }
    return industryRev;
}
