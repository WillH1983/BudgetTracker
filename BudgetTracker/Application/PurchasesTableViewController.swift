//
//  PurchasesTableViewController.swift
//  BudgetTracker
//
//  Created by William Hindenburg on 1/30/15.
//  Copyright (c) 2015 William Hindenburg. All rights reserved.
//

import UIKit



class PurchasesTableViewController: UITableViewController {
    var dataSourceArray = [Purchase]()
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let purchase1 = Purchase()
        purchase1.purchaseAmount = 24
        purchase1.purchasePlace = "Test Place"
        
        let purchase2 = Purchase()
        purchase2.purchaseAmount = 69
        purchase2.purchasePlace = "Test Place 2";
        self.dataSourceArray = [purchase1, purchase2];
        let barButtonItem = UIBarButtonItem(title: "Add Purchase", style:UIBarButtonItemStyle.Plain, target:self, action:"addNewPurchase")
        self.navigationItem.leftBarButtonItem = barButtonItem

    }
    
    func addNewPurchase() {
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            NSLog(action.debugDescription);
            let textFieldArray = self.alertController.textFields
            
            if let purchasePlaceTextField = textFieldArray?.first as? UITextField {
                NSLog(purchasePlaceTextField.text)
            }
            
            if let purchaseAmountTextField = textFieldArray?.last as? UITextField {
                NSLog(purchaseAmountTextField.text)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController = UIAlertController(title: "Add New Purchase", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Purchase Place"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Purchase Amount"
        }
        
        presentViewController(alertController, animated: true, completion: nil);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataSourceArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseCell", forIndexPath: indexPath) as UITableViewCell
        
        var purchase = self.dataSourceArray[indexPath.row]
        
        cell.textLabel?.text = purchase.purchasePlace
        cell.detailTextLabel?.text = String(purchase.purchaseAmount)
        return cell
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
