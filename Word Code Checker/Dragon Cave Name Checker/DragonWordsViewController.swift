//
//  WordsViewController.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import UIKit

class DragonWordsViewController: UITableViewController {
    
    fileprivate var scrabbleWords = [Word]()
    fileprivate var englishNames = [Word]()
    fileprivate var countryCodes = [Word]()
    
    var dragon: Dragon! {
        didSet {
            if let allWords = dragon.words {
                scrabbleWords = allWords
                    .filter { word -> Bool in
                        if case Word.scrabble(_) = word { return true }
                        return false
                    }
                    .sorted()
                englishNames = allWords
                    .filter { word -> Bool in
                        if case Word.englishName(_) = word { return true }
                        return false
                    }
                    .sorted()
                countryCodes = allWords
                    .filter { word -> Bool in
                        if case Word.countryCode(_) = word { return true }
                        return false
                    }
                    .sorted()
            }
        }
    }

}

fileprivate extension DragonWordsViewController {
    enum Section: Int {
        case scrabble, englishNames, countryCodes
    }
    
    func showDefinition(for word: Word) {
        if case .scrabble(let text) = word {
            guard UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: text) else { return }
            
            let definitionViewController = UIReferenceLibraryViewController(term: text)
            present(definitionViewController, animated: true, completion: nil)
        }
    }
    
    func word(at indexPath: IndexPath) -> Word {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .scrabble: return scrabbleWords[indexPath.row]
        case .englishNames: return englishNames[indexPath.row]
        case .countryCodes: return countryCodes[indexPath.row]
        }
    }
}

extension DragonWordsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        guard let section = Section(rawValue: sectionIndex) else { return 0 }
        
        switch section {
        case .scrabble: return scrabbleWords.count
        case .englishNames: return englishNames.count
        case .countryCodes: return countryCodes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let word = self.word(at: indexPath)
        showDefinition(for: word)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let section = Section(rawValue: indexPath.section),
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID())
            else {
                fatalError("Cannot dequeue cell for section")
        }
        
        let word = self.word(at: indexPath)
        cell.textLabel?.text = word.text()
        
        if case Word.countryCode(_, let country) = word {
            cell.detailTextLabel?.text = country
        }
        else if case Word.scrabble(let text) = word {
            if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: text) {
                cell.accessoryType = .detailButton
            }
            else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        guard let section = Section(rawValue: sectionIndex) else { return nil }
        
        switch section {
        case .scrabble:
            guard scrabbleWords.count > 0 else { return nil }
            return "Words (\(scrabbleWords.count))"
        case .englishNames:
            guard englishNames.count > 0 else { return nil }
            return "Names (\(englishNames.count))"
        case .countryCodes:
            guard countryCodes.count > 0 else { return nil }
            return "Country Codes (\(countryCodes.count))"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = self.word(at: indexPath)
        showDefinition(for: word)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension DragonWordsViewController.Section {
    func cellID() -> String {
        switch self {
        case .englishNames: return "EnglishName"
        case .scrabble: return "Scrabble"
        case .countryCodes: return "CountryCode"
        }
    }
}
