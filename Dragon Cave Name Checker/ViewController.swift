//
//  ViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 22/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var allWords = [String]()
    fileprivate var scrabbleWords = [String]()
    fileprivate var englishNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let word = allWords[indexPath.row]
        let cellID = scrabbleWords.contains(word) ? "Scrabble" : "EnglishName"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel!.text = word
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = allWords[indexPath.row]
        if scrabbleWords.contains(word) {
            let vc = UIReferenceLibraryViewController(term: word)
            present(vc, animated: true, completion: nil)
        }
    }
}
