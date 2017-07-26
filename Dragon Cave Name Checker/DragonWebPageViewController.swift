//
//  DragonWebPageViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 25/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class DragonWebPageViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: URL(string: "https://dragcave.net/view/KUkEV")!)
        self.webView.loadRequest(request)
    }

    

}
