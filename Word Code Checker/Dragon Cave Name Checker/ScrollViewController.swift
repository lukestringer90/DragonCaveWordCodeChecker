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
    
    private var wordsViewController: ScrollWordsViewController?
    private var dragonsViewController: ScrollDragonsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "EmbedWords", sender: nil)
    }
    
    func swap(from source: UIViewController, to destination: UIViewController) {
        destination.view.frame = containerView.frame
        
        source.willMove(toParentViewController: nil)
        addChildViewController(destination)
        transition(from: source, to: destination, duration: 0.0, options: .layoutSubviews, animations: nil) { _ in
            source.removeFromParentViewController()
            destination.didMove(toParentViewController: self)
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var viewControllerToSwap: UIViewController!
        
        if segue.identifier == "EmbedWords" {
            if wordsViewController == nil {
                wordsViewController = segue.destination as? ScrollWordsViewController
            }
            
            viewControllerToSwap = wordsViewController!
        }
        else if segue.identifier == "EmbedDragons" {
            if dragonsViewController == nil {
                dragonsViewController = segue.destination as? ScrollDragonsViewController
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
