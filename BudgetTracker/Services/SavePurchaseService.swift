//
//  SavePurchaseService.swift
//  BudgetTracker
//
//  Created by William Hindenburg on 1/31/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

import UIKit
import CloudKit

class SavePurchaseService: NSObject {
    func savePurchase (purchase: Purchase, completionHandler:((Purchase) -> Void), errorHandler:((NSError) -> Void)) {
        let record = CKRecord(recordType: "Purchase")
        record.setValue(purchase.purchasePlace, forKey: "PurchasePlace")
        record.setValue(purchase.purchaseAmount, forKey: "PurchaseAmount")
        
        let cloudDatabase = CKContainer.defaultContainer().publicCloudDatabase
        cloudDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                if error == nil {
                    purchase.purchaseDate = record.creationDate
                    completionHandler(purchase)
                } else {
                    errorHandler(error)
                }
            });
            
        })
    }
}
