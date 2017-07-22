//: Playground - noun: a place where people can play

import UIKit

//let index = cat.input.process()


extension Int {
    
    typealias Range = (start: Int, end: Int)
    
    func ranges() -> [Range] {
        var computed = [Range]()
        
        for length in 2...self {
         
            var start = 0
            
            while start+length-1 < self {
                let range = (start, start+length)
                computed.append(range)
                start += 1
            }
            
        }
        
        
        return computed
    }
}

extension String {
    
    
    func validSubStrings() -> [String] {

        return subStrings().flatMap { subString -> String? in
            
            if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: subString) {
                return subString
            }
            return nil
        }
    }
    
    func subStrings() -> [String] {
        
        return characters.count.ranges().map { (startValue, endValue) in
            let substringStartIndex = index(startIndex, offsetBy: startValue)
            let substringEndIndex = index(startIndex, offsetBy: endValue)
            
            let range = substringStartIndex..<substringEndIndex
            
            return substring(with: range)
        }
    }
    
}

let ranges = 5.ranges()


let subStrings = "order".subStrings()
let valid = "order".validSubStrings()

print(subStrings)
print(valid)

