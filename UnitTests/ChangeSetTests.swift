//
//  ChangeSetTests.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import XCTest
@testable import Word_Code_Checker

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
