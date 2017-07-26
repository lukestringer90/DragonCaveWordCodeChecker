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
    
    func parser(_ parser: ScrollParser, parsed parsedDragons: [Dragon], from scrollName: String) {
        self.dragons = self.dragons + parsedDragons
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        processWords(from: parsedDragons)
    }
}

extension ScrollViewController {
    
    func processWords(from newDragons: [Dragon]) {
        
        for batch in newDragons.batches(of: 5) {
            DragonCodeProcessor.shared.process(dragons: batch) { processedDragons in
                let dragonsWithWords = self.dragons
                    .map { originalDragon -> Dragon in
                        if let newDragon = processedDragons.first(where: { $0.code == originalDragon.code }) {
                            return newDragon
                        }
                        return originalDragon
                    }.filter { dragon in
                        guard let words = dragon.words else { return true }
                        return words.count > 0
                    }.sorted(by: { a, b -> Bool in
                        guard let aWords = a.words, let bWords = b.words else { return false }
                        return aWords.count > bWords.count
                    })
                
                
                DispatchQueue.main.async {
                    self.dragons = dragonsWithWords
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }
                
            }
        }
        
        
    }
    
}

extension ScrollViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard
            let selectedIndexPatch = tableView.indexPathForSelectedRow,
            let words = dragons[selectedIndexPatch.row].words
            else {
                return false
        }
    
        if words.count > 0 {
            return true
        }
        tableView.deselectRow(at: selectedIndexPatch, animated: true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wordsViewController = segue.destination as? WordsViewController {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            let dragon = dragons[row]
            
            wordsViewController.dragon = dragon
        }
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
        
        cell.codeLabel.text = "\(dragon.code)"
        cell.nameLabel.text = "\(dragon.name)"
        
        if let words = dragon.words {
            cell.countLabel.text = String(words.count)
        }
        else {
            cell.activityIndicator?.startAnimating()
        }
        
        return cell
    }
}

extension Array {
    func batches(of batchSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: batchSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: batchSize) > self.count) ? self.count-startIndex : batchSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }
}
