//
//  Scrabble.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 22/07/2017.
//  Copyright © 2017 Luke Stringer.. All rights reserved.
//

import Foundation

enum Word {
    case scrabble(String)
    case englishName(String)
    case countryCode(code: String, country: String)
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
        case .countryCode(let countryCodeLHS, _):
            switch rhs {
            case .countryCode(let countryCodeRHS, _):
                return countryCodeLHS == countryCodeRHS
            default:
                return false
            }
        }
    }
}

extension Word {
    func text() -> String {
        switch self {
        case .scrabble(let text): return text
        case .englishName(let text): return text
        case .countryCode(let code, _): return code
        }
    }
}

extension Word: Comparable {
    
    private func charactersCount() -> Int {
        return text().characters.count
    }
    
    public static func <(lhs: Word, rhs: Word) -> Bool {
        return lhs.charactersCount() < rhs.charactersCount()
    }
    
    static func <=(lhs: Word, rhs: Word) -> Bool {
        return lhs.charactersCount() <= rhs.charactersCount()
    }
    
    static func >=(lhs: Word, rhs: Word) -> Bool {
        return lhs.charactersCount() >= rhs.charactersCount()
    }
    
    static func >(lhs: Word, rhs: Word) -> Bool {
        return lhs.charactersCount() > rhs.charactersCount()
    }
}

extension Word: Hashable {
    var hashValue: Int {
        return text().hash
    }
}
