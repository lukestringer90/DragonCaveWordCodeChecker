//
//  ScrollWordsViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class ScrollWordsViewController: UITableViewController {
    fileprivate var remainingProcessingCount = 0 {
        didSet {
            if remainingProcessingCount == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    fileprivate var scrollName: String? = nil {
        didSet {
            guard let scrollName = scrollName else { return }
            
            // Update UI
            remainingProcessingCount = 0
            dragons = []
            tableView.reloadData()
            title = scrollName
            updateProcessingText()
            
            // Start parser
            scrollParser = nil
            scrollParser = ScrollParser(scrollName: scrollName, delegate: self)
            scrollParser.start()
        }
    }
    
    fileprivate var processingText: String {
        let wordCount = dragons.reduce(0) { result, dragon -> Int in
            if let words = dragon.words {
                return result + words.count
            }
            return result
        }
        if remainingProcessingCount > 0 {
            return "\(wordCount) words from \(dragons.count)/\(remainingProcessingCount + dragons.count) dragons"
        }
        return "\(wordCount) words from \(dragons.count) dragons"
    }
    
    fileprivate var dragons = [Dragon]()
    
    @IBOutlet weak var processingTextBarButtonItem: UIBarButtonItem!
    
    fileprivate var scrollParser: ScrollParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        showScrollNameEntry()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    
    fileprivate func updateProcessingText() {
        processingTextBarButtonItem.title = processingText
    }
}


extension ScrollWordsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView?.cellForRow(at: indexPath) else { return nil }
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "DragonWebViewController") as? DragonWebPageViewController else { return nil }
        
        let dragon = dragons[indexPath.section]
        viewController.dragon = dragon
        
        previewingContext.sourceRect = cell.frame
        return viewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.isToolbarHidden = false
        navigationController?.show(viewControllerToCommit, sender: self)
    }
}

fileprivate extension ScrollWordsViewController {
    
    @IBAction func searchTapped(_ sender: Any) {
        showScrollNameEntry()
    }
    
    func showScrollNameEntry() {
        let alert = UIAlertController(title: "Scroll Name", message: "Enter a scroll name to look for words.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Scroll name"
            textField.text = "lulu_witch"
            textField.clearButtonMode = .always
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let done = UIAlertAction(title: "Done", style: .default, handler: { _ in
            guard let text = alert.textFields?[0].text, text.characters.count > 0 else { return }
            self.scrollName = text
        })
        
        alert.addAction(cancel)
        alert.addAction(done)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ScrollWordsViewController: ScrollParserDelegate {
    
    func parser(_ parser: ScrollParser, startedScroll scrollName: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?) {
    }
    
    func parser(_ parser: ScrollParser, parsed parsedDragons: [Dragon], from scrollName: String) {
        remainingProcessingCount += parsedDragons.count
        processWords(from: parsedDragons)
    }
}

extension ScrollWordsViewController {
    func processWords(from newDragons: [Dragon]) {
        
        let batchSize = 1
        for batch in newDragons.batches(of: batchSize) {
            DragonCodeProcessor.shared.process(dragons: batch) { processedDragons in
                self.dragons = self.dragons + processedDragons
                self.remainingProcessingCount -= batchSize
                DispatchQueue.main.async {
                    self.updateProcessingText()
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
            navigationController?.isToolbarHidden = true
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
