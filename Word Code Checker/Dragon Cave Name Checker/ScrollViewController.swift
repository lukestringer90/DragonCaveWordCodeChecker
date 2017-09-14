//
//  ScrollViewController.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 29/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import UIKit
import AlamofireImage

class ScrollViewController: UITableViewController {
    
    @IBOutlet weak var processingTextBarButtonItem: UIBarButtonItem!
    
    fileprivate var dragons = [Dragon]()
    fileprivate var scrollParser: ScrollParser?
    
    fileprivate var totalDragonsSeen = 0
    
    fileprivate var remainingDragonsToProcess = 0 {
        didSet {
            if remainingDragonsToProcess == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    fileprivate var totalProcessedDragons: Int {
        return totalDragonsSeen - remainingDragonsToProcess
    }
    
    fileprivate var wordCount: Int {
        return dragons.reduce(0, { previous, dragon -> Int in
            if let words = dragon.words {
                return previous + words.count
            }
            return previous
        })
    }
    
    fileprivate var processingText: String {
        guard totalDragonsSeen > 0 else {
            return "Starting Process..."
        }
        
        let wordCount = self.wordCount
        if remainingDragonsToProcess > 0 {
            return "Processing \(wordCount) words from \(totalProcessedDragons)/\(totalDragonsSeen) dragons..."
        }
        return "\(wordCount) words from \(totalDragonsSeen) dragons"
    }

}

extension ScrollViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseScroll(named: Config.defaultScrollName)
        //        showScrollNameEntry()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destinationTabBarController = segue.destination as? UITabBarController,
            let viewControllers = destinationTabBarController.viewControllers,
            let wordsViewController = viewControllers[0] as? DragonWordsViewController,
            let webViewController = viewControllers[1] as? DragonWebPageViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow
            else { return }
        
        let dragon = dragons[selectedIndexPath.row]
        destinationTabBarController.title = dragon.friendlyName
        wordsViewController.dragon = dragon
        webViewController.dragon = dragon
    }
}

fileprivate extension ScrollViewController {
    
    func process(dragons newDragons: [Dragon]) {
        let dragonsWithWords = newDragons
            .filter { dragon -> Bool in
                guard let words = dragon.words else { return false }
                return words.count > 0 && !self.dragons.contains(dragon)
        }
        
        let before = dragons
        
        dragons.append(contentsOf: dragonsWithWords)
        
        if before != dragons {
            tableView.reloadData()
        }
        
        
        tableView.reloadData()
    }
    
    func resetDragons() {
        dragons = []
        tableView.reloadSections(IndexSet([0]), with: .automatic)
    }
    
    fileprivate func updateProcessingText() {
        processingTextBarButtonItem.title = processingText
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
        let wordTexts = dragon.words!.map { $0.text() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dragon")!
        
        cell.textLabel?.text = "\(dragon.friendlyName)"
        cell.detailTextLabel?.text = wordTexts.joined(separator: ", ")
        cell.imageView?.af_setImage(withURL: dragon.imageURL, placeholderImage: UIImage(named: "placeholder")!)
        
        return cell
    }
}

extension ScrollViewController: ScrollParserDelegate {
    
    func parser(_ parser: ScrollParser, startedScroll scrollName: String) {}
    
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?) {}
    
    func parser(_ parser: ScrollParser, parsed newDragons: [Dragon], from scrollName: String) {
        
        totalDragonsSeen += newDragons.count
        remainingDragonsToProcess +=  newDragons.count
        self.updateProcessingText()
        
        let batchSize = 1
        for batch in newDragons.batches(of: batchSize) {
            DragonCodeProcessor.shared.process(dragons: batch) { processedDragons in
                
                self.remainingDragonsToProcess -=  batchSize
                
                DispatchQueue.main.async {
                    self.updateProcessingText()
                    
                    self.process(dragons: processedDragons)
                }
            }
        }
    }
}

fileprivate extension ScrollViewController {
    
    @IBAction func filterTapped(_ sender: Any) {

    }
    
    @IBAction func startTapped(_ sender: Any) {
        showScrollNameEntry()
    }
}

fileprivate extension ScrollViewController {
    
    func showScrollNameEntry() {
        let alert = UIAlertController(title: "Scroll Name", message: "Enter a scroll name to look for words. Note: scroll names are case sensitive.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Scroll name"
            textField.text = Config.defaultScrollName
            textField.clearButtonMode = .always
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let done = UIAlertAction(title: "Done", style: .default, handler: { _ in
            guard let scrollName = alert.textFields?[0].text, scrollName.characters.count > 0 else { return }
            self.parseScroll(named: scrollName)
        })
        
        alert.addAction(cancel)
        alert.addAction(done)
        
        present(alert, animated: true, completion: nil)
    }
    
    func parseScroll(named scrollName: String) {
        title = scrollName
        scrollParser = nil
        DragonCodeProcessor.shared.cancelAllProcessing()
        dragons.removeAll()
        remainingDragonsToProcess = 0
        totalDragonsSeen = 0
        updateProcessingText()
        resetDragons()
        
        scrollParser = ScrollParser(scrollName: scrollName, delegate: self )
        scrollParser?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
}
