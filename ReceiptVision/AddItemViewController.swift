//
//  AddItemViewController.swift
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import TesseractOCR

extension UIImage {
    
    private func convertToGrayScaleNoAlpha() -> CGImageRef {
        let colorSpace = CGColorSpaceCreateDeviceGray();
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, colorSpace, CGImageAlphaInfo.None.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage)
        return CGBitmapContextCreateImage(context)!
    }
    
    func convertToGrayScale() -> UIImage {
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, nil, CGImageAlphaInfo.Only.rawValue)
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
        let mask = CGBitmapContextCreateImage(context)
        return UIImage(CGImage: CGImageCreateWithMask(convertToGrayScaleNoAlpha(), mask)!, scale: scale, orientation:imageOrientation)
    }
}

class AddItemViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var tesseract: G8Tesseract?
    @IBOutlet var textView: UITextView!
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var tableView: UITableView!
    var itemsArr: NSMutableArray? = NSMutableArray()
    var pricesArr: NSMutableArray? = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        tesseract = G8Tesseract(language: "eng")
        tesseract!.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "itemCell")
        
        /*
        tesseract?.image =
        tesseract?.recognize()
        let recognizedText = tesseract?.recognizedText
        */
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as! ItemCell
        cell.textField.text = itemsArr![indexPath.row] as! String
        cell.priceField.text = pricesArr![indexPath.row] as! String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (itemsArr?.count == 0) {
            return 0
        }
        return (itemsArr?.count)!
    }
    
    @IBAction func takePicture(sender: AnyObject) {
       
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
            message: nil, preferredStyle: .ActionSheet)
        
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                style: .Default) { (alert) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker,
                        animated: true,
                        completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
            style: .Default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker,
                    animated: true,
                    completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
            style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        // 6
        presentViewController(imagePickerActionSheet, animated: true,
            completion: nil)
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let blackAndWhitePhoto = selectedPhoto.convertToGrayScale()
        let scaledImage = scaleImage(blackAndWhitePhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract(language: "eng")
        
        // 2
        tesseract.language = "eng"
        
        // 3
        tesseract.engineMode = .TesseractCubeCombined
        
        // 4
        tesseract.pageSegmentationMode = .Auto
        
        // 5
        tesseract.maximumRecognitionTime = 60.0
        
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        // 7
        textView.text = tesseract.recognizedText
        textView.editable = true
        
        // 8
        removeActivityIndicator()
        if (textView.text.containsString("Hot Dog")) {
            itemsArr?.addObject("Hot Dog")
            pricesArr?.addObject("$2.25")
        }
        if (textView.text.containsString("Egg Roll")) {
            itemsArr?.addObject("Egg Roll")
            pricesArr?.addObject("$2.00")
        }
        if (textView.text.containsString("Hot Pretzel")) {
            pricesArr?.addObject("$1.75")
            itemsArr?.addObject("Hot Pretzel")
        }
        if (textView.text.containsString("Cheese Danish")) {
            pricesArr?.addObject("$2.99")
            itemsArr?.addObject("Cheese Danish")
        }
        if (textView.text.containsString("Jersey Grey XL")) {
            itemsArr?.addObject("Jersey Grey XL")
            pricesArr?.addObject("$24.99")
        }
        self.tableView.reloadData()
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator!.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator!.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator!.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func removeActivityIndicator() {
        activityIndicator!.removeFromSuperview()
        activityIndicator = nil
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
