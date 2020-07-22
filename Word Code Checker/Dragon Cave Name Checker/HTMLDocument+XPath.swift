//
//  HTMLDocument+XPath.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import Foundation
//import Kanna

//extension HTMLDocument {
//    
//    func hasMoreScrollPages() -> Bool {
//        // There are more pages if the text "Last" is a span
//        let allLastMatches = xpath("//span[@class=\"_2n_1\"]")
//            .flatMap { element -> String? in
//                if let text = element.text, text.contains("Last") {
//                    return text
//                }
//                return nil
//        }
//        
//        return Set(allLastMatches).count == 0
//    }
//    
//    func dragonHTML() -> XPathObject {
//        return xpath("//*[@id=\"udragonlist\"]/tbody/tr")
//    }
//}
