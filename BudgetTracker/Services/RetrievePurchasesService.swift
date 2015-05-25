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
        let predicate = NSPredicate(value:true)
        let query = CKQuery(recordType: "Purchase", predicate: predicate)
        
        cloudDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (arrayOfPurchases, error) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                if error == nil {
                    var mutableArrayOfPurchaseMonths = NSMutableArray()
                    var purchaseArray = [Purchase]()
                    for record in arrayOfPurchases {
                        if let actualRecord = record as? CKRecord {
                            var purchase = Purchase()
                            purchase.purchaseAmount = actualRecord.objectForKey("PurchaseAmount") as! Int
                            purchase.purchasePlace = actualRecord.objectForKey("PurchasePlace") as! String
                            purchase.purchaseDate = (actualRecord.objectForKey("PurchaseDate") as! NSDate) ?? NSDate()
                            
                            var beginningOfTheMonthDate = self.dateAtTheBeginningOfTheMonth(purchase.purchaseDate)
                            
                            var monthDictionary = NSDictionary()
                            var foundMatch = false
                            if mutableArrayOfPurchaseMonths.count > 0 {
                                for object in mutableArrayOfPurchaseMonths {
                                    monthDictionary = object as! NSDictionary
                                    if let monthDate = monthDictionary.valueForKey("month") as? NSDate {
                                        if (monthDate.isEqualToDate(beginningOfTheMonthDate)) {
                                            if let arrayOfPurchases2 = monthDictionary.valueForKey("purchases") as? NSMutableArray {
                                                arrayOfPurchases2.addObject(purchase)
                                            }
                                            foundMatch = true
                                            continue
                                        }
                                    }
                                }
                                
                                if foundMatch == false {
                                    let mutablePurchaseArray = NSMutableArray()
                                    mutablePurchaseArray.addObject(purchase)
                                    mutableArrayOfPurchaseMonths.addObject(["month":beginningOfTheMonthDate, "purchases":mutablePurchaseArray])
                                }
                            } else {
                                let mutablePurchaseArray = NSMutableArray()
                                mutablePurchaseArray.addObject(purchase)
                                mutableArrayOfPurchaseMonths.addObject(["month":beginningOfTheMonthDate, "purchases":mutablePurchaseArray])
                            }
                            
                            
                            
                            
                            purchaseArray.append(purchase)
                        }
                    }
                    let dateSortDescriptiors = NSSortDescriptor(key: "month", ascending: false)
                    let arrayOfDictionaries = mutableArrayOfPurchaseMonths.sortedArrayUsingDescriptors([dateSortDescriptiors])
                    completionHandler(Array: arrayOfDictionaries);
                } else {
                    errorHandler(error)
                }
            })
            
        })
        
    }
    
    private func dateAtTheBeginningOfTheMonth (date: NSDate) -> NSDate {
        var calendar = NSCalendar.currentCalendar()
        var timeZone = NSTimeZone.systemTimeZone()
        calendar.timeZone = timeZone
        
        var dateComps = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: date)
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
        dateComps.day = 1
        
        var beginningOfMonth = calendar.dateFromComponents(dateComps)
        return beginningOfMonth ?? NSDate()
    }
}
