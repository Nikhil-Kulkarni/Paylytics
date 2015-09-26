//
//  ViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import PNChartSwift
import LiveSDK

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var historyTable: UITableView!
    @IBOutlet var budgetGraphView: UIView!
    @IBOutlet var showBudgets: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        // Do any additional setup after loading the view, typically from a nib.
        
        historyTable.delegate = self
        historyTable.dataSource = self
        
        showBudgets.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        let locationNib = UINib(nibName: "HistoryCell", bundle: nil)
        let topHistoryNib = UINib(nibName: "BudgetTransactions", bundle: nil)
        let allTransactionsNib = UINib(nibName: "AllTransactions", bundle: nil)
        historyTable.registerNib(locationNib, forCellReuseIdentifier: "locationCell")
        historyTable.registerNib(topHistoryNib, forCellReuseIdentifier: "topHistoryNib")
        historyTable.registerNib(allTransactionsNib, forCellReuseIdentifier: "allTransactions")
        
        let barChart: PNBarChart = PNBarChart(frame: CGRectMake(0, 25, budgetGraphView.frame.width, budgetGraphView.frame.height - 55))
        barChart.xLabels = ["Clothing", "Grocery", "Restaurants", "Electronics", "Fun"]
        barChart.yValues = [1, 8, 2, 6, 4]
        barChart.strokeColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        barChart.strokeChart()
        self.budgetGraphView.addSubview(barChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row != 0 && indexPath.row != 4) {
            let cell = historyTable.dequeueReusableCellWithIdentifier("locationCell") as! HistoryCell
            cell.placeName.text = "Trader Joe's"
            cell.placeCategory.text = "Grocery"
            cell.datePurchased.text = "Today"
            cell.moneySpent.text = "-$50.00"
            
            return cell
        }
        else if (indexPath.row == 0) {
            let cell = historyTable.dequeueReusableCellWithIdentifier("topHistoryNib") as! BudgetTransactions
            cell.budgetTransactions.text = "Recent Transactions"
            return cell
        } else {
            let cell = historyTable.dequeueReusableCellWithIdentifier("allTransactions") as! AllTransactions
            cell.allTransactions.text = "All Transactions"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 4) {
            performSegueWithIdentifier("allTransactions", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row != 0 && indexPath.row != 4) {
            return 55
        } else {
            return 40
        }
    }


}

