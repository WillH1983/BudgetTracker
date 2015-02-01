//
//  retrievePurchases.swift
//  BudgetTracker
//
//  Created by William Hindenburg on 1/31/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

import UIKit

class RetrievePurchasesService: NSObject {
    func retrievePurchases (completionHandler:((Array:[Purchase]) -> Void), errorHandler:((NSError) -> Void)) {
        completionHandler (Array: [Purchase(), Purchase()])
    }
}
