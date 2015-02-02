//
//  retrievePurchases.swift
//  BudgetTracker
//
//  Created by William Hindenburg on 1/31/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

import UIKit
import CloudKit

class RetrievePurchasesService: NSObject {
    func retrievePurchases (completionHandler:((Array:[Purchase]) -> Void), errorHandler:((NSError) -> Void)) {
        let cloudDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(value:true)
        let query = CKQuery(recordType: "Purchase", predicate: predicate)
        
        cloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (arrayOfPurchases, error) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                if error == nil {
                    
                    var purchaseArray = [Purchase]()
                    completionHandler (Array: [Purchase(), Purchase()])
                    for record in arrayOfPurchases {
                        if let actualRecord = record as? CKRecord {
                            var purchase = Purchase()
                            purchase.purchaseAmount = actualRecord.objectForKey("PurchaseAmount") as Int
                            purchase.purchasePlace = actualRecord.objectForKey("PurchasePlace") as String
                            purchase.purchaseDate = actualRecord.creationDate
                            purchaseArray.append(purchase)
                        }
                    }
                    completionHandler(Array: purchaseArray);
                } else {
                    errorHandler(error)
                }
            })
            
        })
        
    }
}
