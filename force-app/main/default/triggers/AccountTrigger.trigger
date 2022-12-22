trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
        if (Org_Specific_Setting__mdt.getInstance('Run_All_Triggers')?.Value__c == true) {
            TriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);
            switch on Trigger.operationType {
                when BEFORE_INSERT {
                     handler.beforeInsert(Trigger.new);
                }
                when BEFORE_UPDATE {
                    handler.afterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                    //  handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                }
                when BEFORE_DELETE {
                    // handler.beforeDelete(Trigger.old, Trigger.oldMap);
                }
                when AFTER_INSERT {
                    // handler.afterInsert(Trigger.new, Trigger.newMap);
                }
                when AFTER_UPDATE {
                    handler.afterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                    // handler.afterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                }
                when AFTER_DELETE {
                    // handler.afterDelete(Trigger.old, Trigger.oldMap);
                }
                when AFTER_UNDELETE {
                    // handler.afterUndelete(Trigger.new, Trigger.newMap);
                }
            }
        }
    }




  /*  if(Trigger.isUpdate){
        for (Account acc: Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(acc.Id);
        
            if (acc.BillingPostalCode != oldAccount.BillingPostalCode) {
                acctList.add(acc);
            }
        }
        TerritoryManagement.AccountOwner(acctList);
    } */

