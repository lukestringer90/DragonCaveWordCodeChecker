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
        return subStrings()
            .map { Word.scrabble($0.lowercased()) }
            .filter { word in
            return Reference.scrabbleWords.contains(word)
        }
    }
    
    func allEnglishNames() -> [Word] {
        return subStrings()
            .map { Word.englishName($0.lowercased()) }
            .filter { word in
            return Reference.englishNames.contains(word)
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
