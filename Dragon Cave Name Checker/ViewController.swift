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
        
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "scroll_1", withExtension: "html")!
            let data = try! Data(contentsOf: url)
            let html = String(data: data, encoding: .utf8)!
            
            if let doc = HTML(html: html, encoding: .utf8) {
                
                let codes = doc.xpath("//*[@id=\"udragonlist\"]/tbody/tr/td/a").flatMap { pathObject -> String? in
                    if let text = pathObject["href"], let code = text.components(separatedBy: "/").last {
                        return code
                    }
                    return nil
                }
                
                let allScrabbleWords = codes.flatMap { code -> [String] in
                    print("Starting \(code)")
                    return code.allScrabbleWords()
                    }.sorted(by: { a, b -> Bool in
                        return a.characters.count > b.characters.count
                    }).sorted()
                
                
                
                self.allWords = allScrabbleWords
                self.scrabbleWords = allScrabbleWords
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            activityIndicator.startAnimating()
            DispatchQueue.global().async {
                self.scrabbleWords = text.allScrabbleWords()
                self.englishNames = text.allEnglishNames()
                self.allWords = self.scrabbleWords + self.englishNames
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
