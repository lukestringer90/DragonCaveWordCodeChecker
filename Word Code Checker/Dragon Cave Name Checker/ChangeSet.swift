//
//  ChangeSet.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import Foundation
import UIKit

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

extension ChangeSet {
    func executeUpdates(to tableView: UITableView) {
        tableView.beginUpdates()
        
        if let insertions = insertions {
            let indexPaths = insertions.map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        
        if let moves = moves {
            for move in moves {
                let source = IndexPath(row: move.from, section: 0)
                let destination = IndexPath(row: move.to, section: 0)
                tableView.moveRow(at: source, to: destination)
            }
        }
        if let deletions = deletions {
            let indexPaths = deletions.map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        
        tableView.endUpdates()
    }
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

extension Array where Iterator.Element: Equatable {
    
    func changes(to next: Array<Iterator.Element>) -> ChangeSet {
        
        let mappedInsertions = next.flatMap { nextElement -> Int? in
            if !contains(nextElement) {
                return next.index(of: nextElement)
            }
            return nil
        }
        let insertions = mappedInsertions.count > 0 ? mappedInsertions : nil
        
        let mappedMoves = flatMap { currentElement -> Move? in
            if next.contains(currentElement) {
                let currentIndex = index(of: currentElement)!
                let newIndex = next.index(of: currentElement)!
                
                if currentIndex != newIndex {
                    return Move(from: currentIndex, to: newIndex)
                }
            }
            return nil
        }
        let moves = mappedMoves.count > 0 ? mappedMoves : nil
        
        let mappedDeletions = flatMap { currentElement -> Int? in
            if !next.contains(currentElement) {
                return index(of: currentElement)
            }
            return nil
        }
        let deletions = mappedDeletions.count > 0 ? mappedDeletions : nil
        
        return ChangeSet(insertions: insertions, moves: moves, deletions: deletions)
    }
}
