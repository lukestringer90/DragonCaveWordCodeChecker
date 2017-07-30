//
//  ChangeSet.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import Foundation

struct Move {
    let from: Int
    let to: Int
}

extension Move: Equatable {
    static func ==(lhs: Move, rhs: Move) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
}

struct ChangeSet {
    let insertions: [Int]?
    let moves: [Move]?
    let deletions: [Int]?
}

extension ChangeSet: Equatable {
    static func ==(lhs: ChangeSet, rhs: ChangeSet) -> Bool {
        let insertionsEqual = ChangeSet.isEqual(lhs.insertions, rhs.insertions)
        let reloadsEqual = ChangeSet.isEqual(lhs.moves, rhs.moves)
        let deletionsEqual = ChangeSet.isEqual(lhs.deletions, rhs.deletions)
        
        return insertionsEqual && reloadsEqual && deletionsEqual
    }
    
    private static func isEqual<T>(_ lhsObjects: [T]?, _ rhsObjects: [T]?) -> Bool where T: Equatable {
        if lhsObjects == nil && rhsObjects != nil || lhsObjects != nil && rhsObjects == nil {
            // Different optionality
            return false
        }
        else if let lhs = lhsObjects, let rhs = rhsObjects {
            // Both non-nil
            return lhs == rhs
        }
        else {
            // Both nil
            return true
        }
        
    }
}
