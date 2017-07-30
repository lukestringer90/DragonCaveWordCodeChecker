//
//  ScrollViewController.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 29/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    fileprivate var wordsViewController: ScrollWordsViewController?
    fileprivate var dragonsViewController: ScrollDragonsViewController?
    
    fileprivate var dragons = [Dragon]()
    fileprivate var scrollParser: ScrollParser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "EmbedWords", sender: nil)
        
        showScrollNameEntry()
    }
}

extension ScrollViewController: DragonsDataSource {
    func initalDragons() -> [Dragon] {
        return dragons
    }
}

extension ScrollViewController: ScrollParserDelegate {
    
    func parser(_ parser: ScrollParser, startedScroll scrollName: String) {}
    
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?) {}
    
    func parser(_ parser: ScrollParser, parsed dragons: [Dragon], from scrollName: String) {
        
        wordsViewController?.display(dragons: dragons)
        dragonsViewController?.display(dragons: dragons)
        
        let batchSize = 5
        for batch in dragons.batches(of: batchSize) {
            DragonCodeProcessor.shared.process(dragons: batch) { processedDragons in
                self.dragons.append(contentsOf: processedDragons)
                DispatchQueue.main.async {
                    self.wordsViewController?.display(dragons: processedDragons)
                    self.dragonsViewController?.display(dragons: processedDragons)
                }
            }
        }

        
    }
}

extension ScrollViewController {
    fileprivate func swap(from source: UIViewController, to destination: UIViewController) {
        destination.view.frame = containerView.frame
        
        source.willMove(toParentViewController: nil)
        addChildViewController(destination)
        transition(from: source, to: destination, duration: 0.0, options: .layoutSubviews, animations: nil) { _ in
            source.removeFromParentViewController()
            destination.didMove(toParentViewController: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var viewControllerToSwap: UIViewController!
        
        if segue.identifier == "EmbedWords" {
            if wordsViewController == nil {
                wordsViewController = segue.destination as? ScrollWordsViewController
                wordsViewController?.dragonDataSource = self
            }
            
            viewControllerToSwap = wordsViewController!
        }
        else if segue.identifier == "EmbedDragons" {
            if dragonsViewController == nil {
                dragonsViewController = segue.destination as? ScrollDragonsViewController
                dragonsViewController?.dragonDataSource = self
            }
            
            viewControllerToSwap = dragonsViewController!
        }
        
        
        guard childViewControllers.count > 0 else {
            addChildViewController(wordsViewController!)
            segue.destination.view.frame = containerView.frame
            view.addSubview(wordsViewController!.view)
            segue.destination.didMove(toParentViewController: self)
            return
        }
        
        swap(from: childViewControllers.first!, to: viewControllerToSwap)
    }
    
    
}

fileprivate extension ScrollViewController {
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        let nextSegueID: String = {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return "EmbedWords"
            case 1: return "EmbedDragons"
            default:
                fatalError("Unknown Segment")
            }
        }()
        
        performSegue(withIdentifier: nextSegueID, sender: nil)
    }
    
    @IBAction func inputScrollTapped(_ sender: Any) {
        showScrollNameEntry()
    }
    
    @IBAction func filterTapped(_ sender: Any) {
    }
}

fileprivate extension ScrollViewController {
    
    func showScrollNameEntry() {
        let alert = UIAlertController(title: "Scroll Name", message: "Enter a scroll name to look for words.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Scroll name"
            textField.text = "lulu_witch"
            textField.clearButtonMode = .always
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let done = UIAlertAction(title: "Done", style: .default, handler: { _ in
            guard let scrollName = alert.textFields?[0].text, scrollName.characters.count > 0 else { return }
            self.scrollParser = ScrollParser(scrollName: scrollName, delegate: self )
            self.scrollParser?.start()
        })
        
        alert.addAction(cancel)
        alert.addAction(done)
        
        present(alert, animated: true, completion: nil)
    }
}
