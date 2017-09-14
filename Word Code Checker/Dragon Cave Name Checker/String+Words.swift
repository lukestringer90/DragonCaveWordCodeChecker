//
//  String+Words.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 22/07/2017.
//  Copyright © 2017 Luke Stringer.. All rights reserved.
//

import Foundation

fileprivate extension Int {
    
    typealias Range = (start: Int, end: Int)
    
    func ranges() -> [Range] {
        var computed = [Range]()
        
        for length in Config.TokenLength.minimum.rawValue...self {
            
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

fileprivate extension Array where Iterator.Element == Word {
    
    func filter(matching tokenWords: [Word]) -> [Word] {
        
        let reference = Set(self)
        let stringsAsWords = Set(tokenWords)
        
        return Array(reference.intersection(stringsAsWords))
    }
}

extension String {
    
    func allScrabbleWords() -> [Word] {
        let tokenWords = tokens().map { Word.scrabble($0) }
        return WordReference.scrabble.filter(matching: tokenWords)
    }
    
    func allEnglishNames() -> [Word] {
        let tokenWords = tokens().map { Word.englishName($0) }
        return WordReference.englishNames.filter(matching: tokenWords)
    }
    
    func allCountryCodes() -> [Word] {
        // Does not work
        let tokenWords = tokens().map { Word.countryCode(code: $0, country: $0) }
        return WordReference.countryCodes.filter(matching: tokenWords)
    }
    
    func tokens() -> [String] {
        
        return characters.count.ranges().map { (startValue, endValue) in
            let substringStartIndex = index(startIndex, offsetBy: startValue)
            let substringEndIndex = index(startIndex, offsetBy: endValue)
            
            let range = substringStartIndex..<substringEndIndex
            
            return substring(with: range)
        }
    }
    
}
