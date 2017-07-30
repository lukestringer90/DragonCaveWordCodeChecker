//
//  Config.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 23/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation

enum Config {
    
    enum TokenLength: Int {
        case minimum = 3
        case maximum = 5
        
        static var range: CountableClosedRange<Int> {
            return TokenLength.minimum.rawValue...TokenLength.maximum.rawValue
        }
    }
    
    static let useLocalHTML = false
    static let defaultScrollName: String = "Velociraptor"
}
