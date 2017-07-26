//
//  WordReference.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation

class WordReference {
    
    private static var scrabbleStorage: [Word]?
    private static var englishNamesStorage: [Word]?
    
    static var scrabble: [Word] {
        if scrabbleStorage == nil {
            scrabbleStorage = WordReference.loadWords(forFileNamed: "scrabble").map { Word.scrabble($0) }
        }
        
        return scrabbleStorage!
    }
    
    static var englishNames: [Word] {
        if englishNamesStorage == nil {
            englishNamesStorage = WordReference.loadWords(forFileNamed: "english_names").map { Word.englishName($0) }
        }
        
        return englishNamesStorage!
    }
    
    static var all: [Word] {
        return scrabble + englishNames
    }
    
    private static func loadWords(forFileNamed filename: String) -> [String] {
        let url = Bundle.main.url(forResource: filename, withExtension: "txt")!
        let data = try! Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)!
        return string
            .lowercased()
            .components(separatedBy: "\n")
            .filter { return Config.TokenLength.range ~= $0.characters.count }
    }
}
