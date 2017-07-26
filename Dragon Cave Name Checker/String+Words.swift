//
//  String+Words.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 22/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation

extension Int {
    
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

extension String {
    
    func allScrabbleWords() -> [Word] {
        let tokens = self.tokens()
        return WordReference.scrabble
            .filter { word -> Bool in
                let tokensContainsWords = tokens.contains(where: { token -> Bool in
                    return token.lowercased() == word.text().lowercased()
                })
                return tokensContainsWords
        }
    }
    
    func allEnglishNames() -> [Word] {
        let tokens = self.tokens()
        return WordReference.englishNames
            .filter { word -> Bool in
                let tokensContainsWords = tokens.contains(where: { token -> Bool in
                    return token.lowercased() == word.text().lowercased()
                })
                return tokensContainsWords
        }
    }
    
    func allCountryCodes() -> [Word] {
        let tokens = self.tokens()
        return WordReference.countryCodes
            .filter { word -> Bool in
               let tokensContainsWords = tokens.contains(where: { token -> Bool in
                return token.lowercased() == word.text().lowercased()
               })
                return tokensContainsWords
        }
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
