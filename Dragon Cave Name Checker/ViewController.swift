//
//  ViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 22/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

extension Int {
    
    typealias Range = (start: Int, end: Int)
    
    func ranges() -> [Range] {
        var computed = [Range]()
        
        for length in 3...self {
            
            var start = 0
            
            while start+length-1 < self {
                let range = (start, start+length)
                computed.append(range)
                start += 1
            }
            
        }
        
        
        return computed
    }
}

extension String {
    
    
    func allScrabbleWords() -> [String] {
        return subStrings().filter { subString in
            let scrabbleWord = Word.scrabble(subString)
            return DictionaryWords.scrabbleWords.contains(scrabbleWord)
        }
    }
    
    func allEnglishNames() -> [String] {
        return subStrings().filter { subString in
            let englishName = Word.englishName(subString)
            return DictionaryWords.englishNames.contains(englishName)
        }
    }
    
    func subStrings() -> [String] {
        
        return characters.count.ranges().map { (startValue, endValue) in
            let substringStartIndex = index(startIndex, offsetBy: startValue)
            let substringEndIndex = index(startIndex, offsetBy: endValue)
            
            let range = substringStartIndex..<substringEndIndex
            
            return substring(with: range)
        }
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var all = [String]()
    private var scrabbleWords = [String]()
    private var englishNames = [String]()
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            activityIndicator.startAnimating()
            DispatchQueue.global().async {
                self.scrabbleWords = text.allScrabbleWords()
                self.englishNames = text.allEnglishNames()
                self.all = self.scrabbleWords + self.englishNames
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let word = all[indexPath.row]
        let cellID = scrabbleWords.contains(word) ? "Scrabble" : "EnglishName"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel!.text = word
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = all[indexPath.row]
        if scrabbleWords.contains(word) {
            let vc = UIReferenceLibraryViewController(term: word)
            present(vc, animated: true, completion: nil)
        }
    }

}

