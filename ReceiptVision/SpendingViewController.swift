//
//  SpendingViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/27/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class SpendingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerOne: UIPickerView!
    @IBOutlet var pickerTwo: UIPickerView!
    @IBOutlet var webView: UIWebView!
    
    var pickerData: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        // Do any additional setup after loading the view.
        
        pickerData = ["Cereals", "Bakery", "Meats", "Poultry", "Fish", "Eggs", "Dairy", "Fruits", "Vegetables", "Sugars/sweets", "Fats/Oils", "Grains"]
        
        pickerOne.delegate = self
        pickerOne.dataSource = self
        pickerTwo.delegate = self
        pickerTwo.dataSource = self
        
        webView.loadHTMLString(<#T##string: String##String#>, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData![row] as! String
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerData?.count)!
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
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
