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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        wordToDragons.append(contentsOf: newEntries)
        wordToDragons = Array(Set(wordToDragons))
        wordToDragons.sort()
        
        tableView.reloadData()
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
            let dragon = wordToDragons[selectedIndexPath.row].dragon
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word") as! ScrollWordCell
        
        cell.wordLabel?.text = wordToDragon.word.text()
        cell.codeLabel?.text = wordToDragon.dragon.name
        
        return cell
    }
}
