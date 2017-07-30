//
//  ScrollWordsViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class ScrollWordsViewController: UITableViewController {
    var dragonDataSource: DragonsDataSource? = nil
    
    fileprivate var wordToDragons = [WordToDragon]()
    
    fileprivate var scrollParser: ScrollParser!
    
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

extension ScrollWordsViewController: DisplayDragons {
    func display(dragons: [Dragon]) {
        let newEntries = dragons
            .flatMap { dragon -> [WordToDragon]? in
                if let words = dragon.words {
                    return words.map { WordToDragon(word: $0, dragon: dragon) }
                }
                return nil
            }
            .flatMap { $0 }
        self.wordToDragons.append(contentsOf: newEntries)
        self.wordToDragons.sort()
        
        let newIndexPaths = newEntries.flatMap { wordDragon -> IndexPath? in
            if let row = self.wordToDragons.index(of: wordDragon) {
                return IndexPath(row: row, section: 0)
            }
            return nil
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPaths, with: .fade)
        self.tableView.endUpdates()
    }
    
    func reset() {
        wordToDragons = []
        tableView.reloadSections(IndexSet([0]), with: .automatic)
    }
}

extension ScrollWordsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView?.cellForRow(at: indexPath) else { return nil }
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "DragonWebViewController") as? DragonWebPageViewController else { return nil }
        
        let dragon = wordToDragons[indexPath.section].dragon
        viewController.dragon = dragon
        
        previewingContext.sourceRect = cell.frame
        return viewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.isToolbarHidden = false
        navigationController?.show(viewControllerToCommit, sender: self)
    }
}

extension ScrollWordsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewController = segue.destination as? DragonWebPageViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            let dragon = wordToDragons[selectedIndexPath.section].dragon
            webViewController.dragon = dragon
            navigationController?.isToolbarHidden = true
        }
    }
}

extension ScrollWordsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordToDragons.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wordToDragon = wordToDragons[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word")!
        
        cell.textLabel?.text = wordToDragon.word.text()
        cell.detailTextLabel?.text = wordToDragon.dragon.name
        
        return cell
    }
}
