//
//  DragonWebPageViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 25/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class DragonWebPageViewController: UIViewController {

    var dragon: Dragon!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = dragon.name
        let request = URLRequest(url: URL(string: "https://dragcave.net/view/\(dragon.code)")!)
        webView.loadRequest(request)
    }
}

extension DragonWebPageViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wordsViewController = segue.destination as? WordsViewController {
            wordsViewController.dragon = dragon
        }
    }
}
