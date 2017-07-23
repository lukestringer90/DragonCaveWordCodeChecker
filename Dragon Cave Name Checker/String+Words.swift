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
    
    func allScrabbleWords() -> [String] {
        return subStrings().filter { subString in
            let scrabbleWord = Word.scrabble(subString.lowercased())
            return Reference.scrabbleWords.contains(scrabbleWord)
        }
    }
    
    func allEnglishNames() -> [String] {
        return subStrings().filter { subString in
            let englishName = Word.englishName(subString.lowercased())
            return Reference.englishNames.contains(englishName)
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
