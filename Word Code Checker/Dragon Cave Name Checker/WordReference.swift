//
//  WordReference.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 Luke Stringer.. All rights reserved.
//

import Foundation

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}

class WordReference {
    
    private static var scrabbleStorage: [Word]?
    private static var englishNamesStorage: [Word]?
    private static var countryCodesStorage: [Word]?
    
    static var scrabble: [Word] {
        if scrabbleStorage == nil {
            scrabbleStorage = WordReference.loadText(from: "scrabble").map { Word.scrabble($0) }
        }
        
        return scrabbleStorage!
    }
    
    static var countryCodes: [Word] {
        if countryCodesStorage == nil {
            countryCodesStorage = WordReference.loadCSVLines(from: "country_codes").compactMap { csvLine -> Word? in                
                let code = csvLine[4]
                let name = csvLine[1]
                
                guard code.characters.count > 0 && name.characters.count > 0 else { return nil }
                
                return Word.countryCode(code: code, country: name)
            }
        }
        
        return countryCodesStorage!
    }
    
    static var englishNames: [Word] {
        if englishNamesStorage == nil {
            englishNamesStorage = WordReference.loadText(from: "english_names").map { Word.englishName($0) }
        }
        
        return englishNamesStorage!
    }
    
    static var all: [Word] {
        return scrabble + englishNames + countryCodes
    }
    
    private typealias CSVLine = [String]
    private static func loadCSVLines(from filename: String) -> [CSVLine] {
        let url = Bundle.main.url(forResource: filename, withExtension: "csv")!
        let data = try! Data(contentsOf: url)
        let allText = String(data: data, encoding: .utf8)!
        let allLines = allText
            .components(separatedBy: "\n")
            .map { line -> CSVLine in
                return line.components(separatedBy: ",")
            }
        // Remove first line (headings) and last line (blank) 
        return allLines.filter { $0 != allLines.first! && $0 != allLines.last! }
    }
    
    private static func loadText(from filename: String) -> [String] {
        let url = Bundle.main.url(forResource: filename, withExtension: "txt")!
        let data = try! Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)!
        return string
            .components(separatedBy: "\n")
            .filter { return Config.TokenLength.range ~= $0.characters.count }
    }
}
