//
//  CodeProcessor.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 26/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation

class DragonCodeProcessor {
    fileprivate var operationQueue: OperationQueue!
    
    static let shared = DragonCodeProcessor()
    
    private init() {
        setupOperationQueue()
    }
    
    private func setupOperationQueue() {
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func cancelAllProcessing() {
        operationQueue.cancelAllOperations()
        setupOperationQueue()
    }
    
    func process(dragons: [Dragon], completion: @escaping (_ newDragons: [Dragon]) -> ()) {
        
        var processedDragons: [Dragon]!
        
        let operation = BlockOperation {
            processedDragons = dragons.map { dragon -> Dragon in
                let words = dragon.code.allScrabbleWords() + dragon.code.allEnglishNames()
                let sorted = words.sorted()
                return Dragon(code: dragon.code, name: dragon.name, words: sorted)
            }
        }
        
        operation.completionBlock = {
            completion(processedDragons)
        }
        
        operationQueue.addOperation(operation)
    }
}
