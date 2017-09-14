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
    
    func filter(matching strings: [String]) -> [Word] {
        return filter { word -> Bool in
            let stringContainsWords = strings.contains(where: { string -> Bool in
                return string.lowercased() == word.text().lowercased()
            })
            return stringContainsWords
        }
    }
}

extension String {
    
    func allScrabbleWords() -> [Word] {
        return WordReference.scrabble.filter(matching: tokens())
    }
    
    func allEnglishNames() -> [Word] {
        return WordReference.englishNames.filter(matching: tokens())
    }
    
    func allCountryCodes() -> [Word] {
        return WordReference.countryCodes.filter(matching: tokens())
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
