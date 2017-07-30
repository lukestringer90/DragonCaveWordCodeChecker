//
//  DragonWebPageViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 25/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class DragonWebPageViewController: UIViewController {

    var dragon: Dragon? = nil
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dragon = self.dragon else {
            title = nil
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        
        title = dragon.name
        
        if let words = dragon.words {
            navigationItem.rightBarButtonItem?.title = "Words (\(words.count))"
        }

        let request = URLRequest(url: URL(string: "https://dragcave.net/view/\(dragon.code)")!)
        webView.loadRequest(request)
    }
}

extension DragonWebPageViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wordsViewController = segue.destination as? DragonWordsViewController {
            wordsViewController.dragon = dragon
        }
    }
}
