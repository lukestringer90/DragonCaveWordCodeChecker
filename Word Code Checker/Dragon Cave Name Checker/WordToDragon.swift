//
//  File.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 29/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import Foundation

struct WordToDragon {
    let word: Word
    let dragon: Dragon
}

extension WordToDragon: Equatable {
    static func ==(lhs: WordToDragon, rhs: WordToDragon) -> Bool {
        return lhs.dragon == rhs.dragon && lhs.word == rhs.word
    }
}

extension WordToDragon: Hashable {
    var hashValue: Int {
        return dragon.hashValue + word.hashValue
    }
}

extension WordToDragon: Comparable {
    
    var wordLength: Int { return word.text().characters.count }
    
    public static func <(lhs: WordToDragon, rhs: WordToDragon) -> Bool {
        if rhs.wordLength == lhs.wordLength {
            return lhs.word.text() < rhs.word.text()
        }
        return rhs.wordLength < lhs.wordLength
    }
    
    static func <=(lhs: WordToDragon, rhs: WordToDragon) -> Bool {
        if rhs.wordLength == lhs.wordLength {
            return lhs.word.text() <= rhs.word.text()
        }
        return rhs.wordLength <= lhs.wordLength
    }
    
    static func >=(lhs: WordToDragon, rhs: WordToDragon) -> Bool {
        if rhs.wordLength == lhs.wordLength {
            return lhs.word.text() >= rhs.word.text()
        }
        return rhs.wordLength >= lhs.wordLength
    }
    
    static func >(lhs: WordToDragon, rhs: WordToDragon) -> Bool {
        if rhs.wordLength == lhs.wordLength {
            return lhs.word.text() > rhs.word.text()
        }
        return rhs.wordLength > lhs.wordLength
    }
}
