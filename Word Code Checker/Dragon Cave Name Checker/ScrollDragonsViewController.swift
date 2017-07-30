//
//  ScrollViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 23/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit
import Kanna

class ScrollDragonsViewController: UITableViewController {
    
    var dragonDataSource: DragonsDataSource? = nil
    
    fileprivate var dragons = [Dragon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        if let dataSource = dragonDataSource {
            display(dragons: dataSource.initalDragons())
        }
    }
}

extension ScrollDragonsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView?.cellForRow(at: indexPath) else { return nil }
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "DragonWebViewController") as? DragonWebPageViewController else { return nil }
        
        let dragon = dragons[indexPath.row]
        viewController.dragon = dragon
        
        previewingContext.sourceRect = cell.frame
        return viewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.show(viewControllerToCommit, sender: self)
    }
}

extension ScrollDragonsViewController: ScrollParserDelegate {
    
    func parser(_ parser: ScrollParser, startedScroll scrollName: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func parser(_ parser: ScrollParser, parsed parsedDragons: [Dragon], from scrollName: String) {
        self.dragons = self.dragons + parsedDragons
        
        let indexPaths = parsedDragons.flatMap { dragon -> IndexPath? in
            guard let row = self.dragons.index(of: dragon) else { return nil }
            return IndexPath(row: row, section: 0)
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
    }
}

extension ScrollDragonsViewController: DisplayDragons {
    func display(dragons newDragons: [Dragon]) {
        let dragonsWithWords = newDragons
            .filter { dragon -> Bool in
                guard let words = dragon.words else { return false }
                return words.count > 0
            }
        
        self.dragons.append(contentsOf: dragonsWithWords)
        self.dragons.sort()
        
        let newIndexPaths = dragonsWithWords.flatMap { newDragon -> IndexPath? in
            if let row = dragons.index(where: { $0.code == newDragon.code }) {
                return IndexPath(row: row, section: 0)
            }
            return nil
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPaths, with: .fade)
        self.tableView.endUpdates()
        
        
        
    }
    
    func reset() {
        dragons = []
        tableView.reloadSections(IndexSet([0]), with: .automatic)
    }
}

extension ScrollDragonsViewController {
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
        if let webViewController = segue.destination as? DragonWebPageViewController {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            let dragon = dragons[row]
            webViewController.dragon = dragon
        }
    }
    
}

extension ScrollDragonsViewController {
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
            cell.countLabel.text = "\(String(words.count)), longest \(words.maxWordLength())"
        }
        else {
            cell.activityIndicator?.startAnimating()
        }
        
        return cell
    }
}
