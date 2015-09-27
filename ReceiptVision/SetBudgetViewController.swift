//
//  SetBudgetViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class SetBudgetViewController: UIViewController {

    @IBOutlet var budgetField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func letsGo(sender: AnyObject) {
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.budgetField.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
