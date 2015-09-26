//
//  AllTransactionsTableViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class AllTransactionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        let headerNib = UINib(nibName: "BudgetTransactions", bundle: nil)
        tableView.registerNib(headerNib, forCellReuseIdentifier: "tableHeader")
        
        let locationNib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.registerNib(locationNib, forCellReuseIdentifier: "locationCell")
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 15
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("tableHeader", forIndexPath: indexPath) as! BudgetTransactions
            cell.budgetTransactions.text = "Recent Transactions"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! HistoryCell
            cell.placeName.text = "Trader Joe's"
            cell.placeCategory.text = "Grocery"
            cell.datePurchased.text = "Today"
            cell.moneySpent.text = "-$50.00"
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 40
        } else {
            return 55
        }
    }
   
}
