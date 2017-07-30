//
//  ChangeSetTests.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import XCTest
@testable import Word_Code_Checker

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

class ChangeSetTests: XCTestCase {
    
    let A = "A"
    let B = "B"
    let C = "C"
    
    func testInsertAtEnd() {
        let before = [A]
        let after = [A, B]
        
        let changeSet = ChangeSet(insertions: [1], moves: nil, deletions: nil)
        XCTAssertEqual(before.changes(to: after), changeSet)
    }
    
    func testInsertAtStart() {
        let before = [A]
        let after = [B, A]
        
        let changeSet = ChangeSet(insertions: [0], moves: [Move(from: 0, to: 1)], deletions: nil)
        XCTAssertEqual(before.changes(to: after), changeSet)
    }
    
    func testRemoveAtEnd() {
        let before = [A, B]
        let after = [A]
        
        let changeSet = ChangeSet(insertions: nil, moves: nil, deletions: [1])
        XCTAssertEqual(before.changes(to: after), changeSet)
    }
    
    func testRemoveAtStart() {
        let before = [A, B]
        let after = [B]
        
        let changeSet = ChangeSet(insertions: nil, moves: [Move(from: 1, to: 0)], deletions: [0])
        XCTAssertEqual(before.changes(to: after), changeSet)
    }
    
}
