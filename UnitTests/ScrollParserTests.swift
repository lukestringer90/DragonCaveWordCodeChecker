//
//  UnitTests.swift
//  UnitTests
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import XCTest
import Kanna
@testable import Word_Code_Checker

class ScrollParserTests: XCTestCase {

    func htmlDocument(named name: String) -> HTMLDocument {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: name, withExtension: "html")!
        let html = try! String(contentsOf: url)
        return try! HTML(html: html, encoding: .utf8)
    }

    func testScrollWitouthMorePages() {
        let doc = htmlDocument(named: "velociraptor_10")
        XCTAssertFalse(doc.hasMoreScrollPages())
    }

    func testScrollWithMorePages() {
        let doc = htmlDocument(named: "lulu_witch_1")
        XCTAssertTrue(doc.hasMoreScrollPages())
    }

}
