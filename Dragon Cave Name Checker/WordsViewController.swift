//
//  WordsViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class WordsViewController: UITableViewController {

    var dragon: Dragon! {
        didSet {
            title = dragon.name
        }
    }
}

extension WordsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let words = dragon.words {
            return words.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word = dragon.words![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: word.cellID())!
        cell.textLabel?.text = word.text()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = dragon.words![indexPath.row]
        
        switch word {
        case .scrabble(let text):
            let definitionViewController = UIReferenceLibraryViewController(term: text)
            present(definitionViewController, animated: true, completion: nil)
            
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
    }
    
}

fileprivate extension Word {
    func cellID() -> String {
        switch self {
        case .englishName(_): return "EnglishName"
        case .scrabble(_): return "Scrabble"
        }
    }
}
