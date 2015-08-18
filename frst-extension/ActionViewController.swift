//
//  ActionViewController.swift
//  frst-extension
//
//  Created by Kyle Frost on 8/17/15.
//  Copyright © 2015 Kyle Frost. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MobileCoreServices

class ActionViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var aliasField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var recievedURL: NSURL!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navBar.delegate = self
        
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItemForTypeIdentifier(propertyList, options: nil, completionHandler: { (item, error) -> Void in
                let dictionary = item as! NSDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    let urlString = results["URL"] as? String
                    self.recievedURL = NSURL(string: urlString!)
                    self.urlLabel.text = self.recievedURL.absoluteString
                }
            })
        } else {
            print("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

    @IBAction func done() {
        
        var statusMessage: String = ""
        
        statusMessage = "Testing"
        if (passwordField.text == "") {
            statusMessage = "Can not shorten URL without password."
        } else {
            
            let parameters = [
                "url": self.recievedURL!.absoluteString,
                "custom": aliasField.text!,
                "password": passwordField.text!
            ]

            Alamofire.request(.POST, "http://frst.xyz/api/create", parameters: parameters).response {
                request, response, data, error in
                let json = JSON(data: data!)
                if let urlString = json["url"].string {
                    
                    UIPasteboard.generalPasteboard().string = urlString
                }
            }
            
            statusMessage = "Shortened URL for \(self.recievedURL.absoluteString) copied to clipboard."
        }
        
        let extensionItem = NSExtensionItem()
        let statusDictionary = [ NSExtensionJavaScriptFinalizeArgumentKey : [ "statusMessage" : statusMessage ]]
        extensionItem.attachments = [ NSItemProvider(item: statusDictionary, typeIdentifier: kUTTypePropertyList as String)]
        
        self.extensionContext!.completeRequestReturningItems([extensionItem], completionHandler: nil)
    }

}
