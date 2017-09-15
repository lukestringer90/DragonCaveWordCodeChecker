//
//  Array+Helpers.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 Luke Stringer.. All rights reserved.
//

import Foundation

extension Array {
    func batches(of batchSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: batchSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: batchSize) > self.count) ? self.count-startIndex : batchSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }
}
