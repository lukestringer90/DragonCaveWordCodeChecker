//
//  Dragon.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation

struct Dragon {
    let code: String
    let name: String
    let words: [Word]?
}

extension Array where Iterator.Element == Dragon {
    func sortedByKeepUnprocessedOrder() -> [Dragon] {
        let processed = filter { $0.words != nil }.sorted()
        let unProcessed = filter { $0.words == nil }
        return processed + unProcessed
    }
}

extension Dragon: Equatable {
    
    static func ==(lhs: Dragon, rhs: Dragon) -> Bool {
        let codesAreEqual = lhs.code == rhs.code
        let wordNilalityIsEqual =
            lhs.words == nil && rhs.words == nil
                ||
                lhs.words != nil && rhs.words != nil
        
        guard codesAreEqual && wordNilalityIsEqual else { return false }
        
        if let lhsWords = lhs.words, let rhsWords = rhs.words {
            return lhsWords == rhsWords
        }
        
        return false
    }
}

// Dragons with more words should come before dragons with fewer words
// Dragons with same amount of words are sorted on code alphabetically
extension Dragon: Comparable {
    
    private func wordCount() -> Int {
        guard let words = self.words else { return 0 }
        return words.count
    }
    
    public static func <(lhs: Dragon, rhs: Dragon) -> Bool {
        if lhs.wordCount() == rhs.wordCount() {
            let comparison = lhs.code.caseInsensitiveCompare(rhs.code)
            return comparison == .orderedAscending
        }
        
        return rhs.wordCount() < lhs.wordCount()
    }
    
    static func <=(lhs: Dragon, rhs: Dragon) -> Bool {
        if lhs.wordCount() == rhs.wordCount() {
            let comparison = lhs.code.caseInsensitiveCompare(rhs.code)
            return comparison == .orderedAscending || comparison == .orderedSame
        }
        
        return rhs.wordCount() <= lhs.wordCount()
    }
    
    static func >=(lhs: Dragon, rhs: Dragon) -> Bool {
        if lhs.wordCount() == rhs.wordCount() {
            let comparison = lhs.code.caseInsensitiveCompare(rhs.code)
            return comparison == .orderedDescending || comparison == .orderedSame
        }
        
        return rhs.wordCount() > lhs.wordCount()
    }
    
    static func >(lhs: Dragon, rhs: Dragon) -> Bool {
        if lhs.wordCount() == rhs.wordCount() {
            let comparison = lhs.code.caseInsensitiveCompare(rhs.code)
            return comparison == .orderedDescending
        }
        
        return rhs.wordCount() > lhs.wordCount()
    }
}
