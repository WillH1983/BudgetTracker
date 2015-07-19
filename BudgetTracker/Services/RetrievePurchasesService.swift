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
    func retrievePurchases (completionHandler:((Array:[AnyObject]) -> Void), errorHandler:((NSError) -> Void)) {
        let cloudDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Purchase", predicate: predicate)
        
        cloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (arrayOfRecords, error) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                if error == nil {
                    /* Array of dictionaries, each dictionary has two keys, one has key of "month" which is an NSDate.
                    The second is "purchases" which contains Array of "Purchases"*/
                    var arrayOfMonths = [Dictionary<String, AnyObject>]()
                    let arrayOfPurchases = arrayOfRecords ?? [CKRecord]()
                    
                    for purchase in arrayOfPurchases {
                        
                        /* If there are no months created, then there are none to search for,
                        add the month for the current purchase. */
                        if arrayOfMonths.count > 0 {
                            /* Search for the month for the purchase, and add it to the dictionary */
                            var foundMatch = false
                            for var index = 0; index < arrayOfMonths.count; ++index {
                                var purchaseDictionary = arrayOfMonths[index]
                                let month = purchaseDictionary["month"] as! NSDate
                                let purchaseDate = self.purchaseDateFromRecord(purchase)
                                if month == self.dataAtTheBeginningOfTheMonthFromDate(purchaseDate) {
                                    var purchaseArray = purchaseDictionary["purchases"] as! Array<Purchase>
                                    purchaseArray.append(self.createPurchaseFromRecord(purchase))
                                    purchaseDictionary["purchases"] = purchaseArray
                                    arrayOfMonths[index] = purchaseDictionary
                                    foundMatch = true
                                    break
                                }
                            }
                            if (foundMatch == false) {
                                arrayOfMonths.append(self.topLevelPurchaseDictionaryFromRecord(purchase))
                            }
                        } else {
                            /* Create the first month dictionary in the array */
                            arrayOfMonths.append(self.topLevelPurchaseDictionaryFromRecord(purchase))
                            
                        }
                    }
                    let dateSortDescriptiors = NSSortDescriptor(key: "month", ascending: false)
                    let newArrayOfMonths = arrayOfMonths as NSArray
                    let arrayOfDictionaries = newArrayOfMonths.sortedArrayUsingDescriptors([dateSortDescriptiors])
                    completionHandler(Array: arrayOfDictionaries)
                }
            })
            
        })
        
    }
    
    private func topLevelPurchaseDictionaryFromRecord (record: CKRecord) -> [String: AnyObject] {
        let purchaseArray: Array <Purchase> = [self.createPurchaseFromRecord(record)]
        var purchaseDictionary = [String: AnyObject]()
        purchaseDictionary = ["purchases": purchaseArray]
        purchaseDictionary.updateValue(self.dateAtTheBeginningOfTheMonthFromRecord(record), forKey: "month")
        return purchaseDictionary
    }
    
    private func purchaseDateFromRecord (record: CKRecord) -> NSDate {
        return record.objectForKey("PurchaseDate") as? NSDate ?? NSDate()
    }
    
    private func dataAtTheBeginningOfTheMonthFromDate (date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let timeZone = NSTimeZone.systemTimeZone()
        calendar.timeZone = timeZone
        
        let dateComps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
        dateComps.day = 1
        
        let beginningOfMonth = calendar.dateFromComponents(dateComps)
        return beginningOfMonth ?? NSDate()
    }
    
    private func createPurchaseFromRecord (record: CKRecord) -> Purchase {
        let purchase = Purchase()
        purchase.purchaseAmount = record.objectForKey("PurchaseAmount") as! Int
        purchase.purchasePlace = record.objectForKey("PurchasePlace") as! String
        purchase.purchaseDate = self.purchaseDateFromRecord(record)
        return purchase
    }
    
    private func dateAtTheBeginningOfTheMonthFromRecord (record: CKRecord) -> NSDate {
        let date = self.purchaseDateFromRecord(record)
        return self.dataAtTheBeginningOfTheMonthFromDate(date)
    }
}
