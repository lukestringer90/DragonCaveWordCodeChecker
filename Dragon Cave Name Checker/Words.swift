//
//  Scrabble.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 22/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation

enum Word {
    case scrabble(String)
    case englishName(String)
}

extension Word: Equatable {
    static func ==(lhs: Word, rhs: Word) -> Bool {
        switch lhs {
        case .englishName(let englishLHS):
            switch rhs {
            case .englishName(let englishRHS):
                return englishLHS == englishRHS
            default:
                return false
            }
        case .scrabble(let scrabbleLHS):
            switch rhs {
            case .scrabble(let scrabbleRHS):
                return scrabbleLHS == scrabbleRHS
            default:
                return false
            }
        }
    }
}

class Reference {
    
    private static var scrabbleStorage: [Word]?
    private static var englishNamesStorage: [Word]?
    
    static var scrabbleWords: [Word] {
        if scrabbleStorage == nil {
            scrabbleStorage = Reference.loadWords(forFileNamed: "scrabble").map { Word.scrabble($0) }
        }
        
        return scrabbleStorage!
    }
    
    static var englishNames: [Word] {
        if englishNamesStorage == nil {
            englishNamesStorage = Reference.loadWords(forFileNamed: "english_names").map { Word.englishName($0) }
        }
        
        return englishNamesStorage!
    }
    
    static var allWords: [Word] {
        return scrabbleWords + englishNames
    }
    
    private static func loadWords(forFileNamed filename: String) -> [String] {
        let url = Bundle.main.url(forResource: filename, withExtension: "txt")!
        let data = try! Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)!
        return string.lowercased().components(separatedBy: "\n")
    }
}
