//
//  ViewController.swift
//  frst
//
//  Created by Kyle Frost on 8/17/15.
//  Copyright © 2015 Kyle Frost. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parameters = [
            "url": "http://www.thisisfromiossim.com/",
            "alias": "",
            "password": "this is kyle.1"
        ]
        
        Alamofire.request(.POST, "http://frst.xyz/api/create", parameters: parameters).response {
            request, response, data, error in
            print(request)
            print(response)
            print(data?.description)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

