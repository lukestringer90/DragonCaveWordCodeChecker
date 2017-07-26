//
//  ScrollWordsViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class ScrollWordsViewController: UITableViewController {
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

extension ScrollWordsViewController: ScrollParserDelegate {
    
    func parser(_ parser: ScrollParser, startedScroll scrollName: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func parser(_ parser: ScrollParser, parsed parsedDragons: [Dragon], from scrollName: String) {
        processWords(from: parsedDragons)
    }
}

extension ScrollWordsViewController {
    func processWords(from newDragons: [Dragon]) {
        
        for batch in newDragons.batches(of: 1) {
            DragonCodeProcessor.shared.process(dragons: batch) { processedDragons in
                self.dragons = self.dragons + processedDragons
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }

        
    }
}

extension ScrollWordsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewController = segue.destination as? DragonWebPageViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            let dragon = dragons[selectedIndexPath.section]
            webViewController.dragon = dragon
        }
    }
}

extension ScrollWordsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dragons.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dragon = dragons[section]
        if let words = dragon.words {
            return words.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dragon = dragons[indexPath.section]
        guard let words = dragon.words else { fatalError("Dragon has no words") }
        let word = words[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word")!
        
        cell.textLabel?.text = word.text()
        cell.detailTextLabel?.text = dragon.name
        
        return cell
    }
}
