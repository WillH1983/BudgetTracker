//
//  PurchasesTableViewController.swift
//  BudgetTracker
//
//  Created by William Hindenburg on 1/30/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

import UIKit

class PurchasesTableViewController: UITableViewController {
    var dataSourceArray = [AnyObject]()
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItem = UIBarButtonItem(title: "Add Purchase", style:UIBarButtonItemStyle.Plain, target:self, action:"addNewPurchase")
        self.navigationItem.leftBarButtonItem = barButtonItem
        RetrievePurchasesService().retrievePurchases({ (arrayOfPurchases) -> Void in
            self.dataSourceArray = arrayOfPurchases;
            self.tableView.reloadData()
        }, errorHandler: { (error) -> Void in
            
        })
    }
    
    func addNewPurchase() {
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            let textFieldArray = self.alertController.textFields
            let purchase = Purchase()
            
            if let purchasePlaceTextField = textFieldArray?.first {
                purchase.purchasePlace = purchasePlaceTextField.text!;
            }
            
            if let purchaseAmountTextField = textFieldArray?.last {
                purchase.purchaseAmount = (Int(purchaseAmountTextField.text!) ?? 0)
            }
            
            if purchase.purchasePlace.isEmpty == false && purchase.purchaseAmount > 0 {
                SavePurchaseService().savePurchase(purchase, completionHandler: { (purchaseWithDate) -> Void in
                    var purchaseDictionary = self.dataSourceArray[0] as! Dictionary <String, AnyObject>
                    var purchaseArrayForCurrentMonth = purchaseDictionary["purchases"] as! Array<Purchase>
                    purchaseArrayForCurrentMonth.append(purchaseWithDate)
                    purchaseDictionary["purchases"] = purchaseArrayForCurrentMonth
                    self.dataSourceArray[0] = purchaseDictionary
                    self.tableView.reloadData()
                    }, errorHandler: { (error) -> Void in
                        
                })
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        self.alertController = UIAlertController(title: "Add New Purchase", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        self.alertController.addAction(saveAction)
        self.alertController.addAction(cancelAction)
        
        self.alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Purchase Place"
        }
        
        self.alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Purchase Amount"
        }
        
        presentViewController(self.alertController, animated: true, completion: nil);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.dataSourceArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let dictionaryWithPurchases = self.dataSourceArray[section] as! NSDictionary
        let arrayOfPurchases = dictionaryWithPurchases.valueForKey("purchases") as! NSArray
        return arrayOfPurchases.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseCell", forIndexPath: indexPath) as UITableViewCell
        
        let dictionaryWithPurchases = self.dataSourceArray[indexPath.section] as! NSDictionary
        let arrayOfPurchases = dictionaryWithPurchases.valueForKey("purchases") as! NSArray
        let purchase = arrayOfPurchases[indexPath.row] as! Purchase
        
        cell.textLabel?.text = purchase.purchasePlace
        cell.detailTextLabel?.text = String(purchase.purchaseAmount)
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dictionaryWithPurchases = self.dataSourceArray[section] as! NSDictionary
        let monthDate = dictionaryWithPurchases.valueForKey("month") as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(monthDate);
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
