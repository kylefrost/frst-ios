//
//  ViewController.swift
//  frst
//
//  Created by Kyle Frost on 8/17/15.
//  Copyright © 2015 Kyle Frost. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var aliasField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var shortenButton: UIButton!
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPressShortenButton(sender: AnyObject) {
        resignFirstResponder()
        blurView.frame = UIScreen.mainScreen().bounds
        blurView.alpha = 0.0
        indicatorView.frame = UIScreen.mainScreen().bounds
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicatorView.color = UIColor.blackColor()
        indicatorView.startAnimating()
        blurView.addSubview(indicatorView)
        self.view.addSubview(blurView)
        UIView.animateWithDuration(0.5, animations: {
            self.blurView.alpha = 1.0
        })
        
        let urlString = urlField.text as String?
        let aliasString = aliasField.text as String?
        let passwordString = passwordField.text as String?
        
        var newURL = ""
        
        let parameters = [
            "url": urlString!,
            "custom": aliasString!,
            "password": passwordString!
        ]
        
        Alamofire.request(.POST, "http://frst.xyz/api/create", parameters: parameters).response {
            request, response, data, error in
            let json = JSON(data: data!)
            if let urlString = json["url"].string {
                
                newURL = urlString
                
                UIPasteboard.generalPasteboard().string = newURL
                
                UIView.animateWithDuration(0.5, animations: {
                    
                    self.blurView.alpha = 0.0
                    
                    }, completion: { (finished: Bool) in
                        self.urlField.text = ""
                        self.aliasField.text = ""
                        self.passwordField.text = ""
                        self.blurView.removeFromSuperview()
                        self.indicatorView.stopAnimating()
                        
                        let alert = UIAlertController(title: "Copied", message: "\(newURL) was copied to your clipboard.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
        urlField.becomeFirstResponder()
    }
}

