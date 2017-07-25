//
//  ScrollViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 23/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit
import Kanna

class ScrollViewController: UITableViewController {
    
    fileprivate let scrollName = "lulu_witch"
    fileprivate var dragons = [Dragon]()
    
    fileprivate var scrollParser: ScrollParser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = scrollName
        scrollParser = ScrollParser(scrollName: scrollName, delegate: self)
        scrollParser.start()
    }
}

extension ScrollViewController: ScrollParserDelegate {
    
    func parser(_ parser: ScrollParser, startedScroll scrollName: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func parser(_ parser: ScrollParser, parsed dragons: [Dragon], from scrollName: String) {
        self.dragons = self.dragons + dragons
        self.tableView.reloadData()
    }
}

extension ScrollViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dragons.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dragon = dragons[indexPath.row]
        let words = dragon.words
        
        let cellID = words != nil ? "Processed" : "Processing";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CodeCell
        
        cell.codeLabel.text = "\(dragon.name): \(dragon.code)"
        
        if let words = dragon.words {
            cell.countLabel.text = String(words.count)
        }
        else {
            cell.activityIndicator?.startAnimating()
        }
        
        return cell
    }
}
