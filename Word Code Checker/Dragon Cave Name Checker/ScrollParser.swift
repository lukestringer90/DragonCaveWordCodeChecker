//
//  Scroll.swift
//  Dragon Cave Name Checker
//
//  Created by Luke Stringer on 23/07/2017.
//  Copyright © 2017 3Squared. All rights reserved.
//

import Foundation
import Kanna

protocol ScrollParserDelegate {
    func parser(_ parser: ScrollParser, startedScroll scrollName: String)
    func parser(_ parser: ScrollParser, finishedScroll scrollName: String, error: ScrollParser.Error?)
    func parser(_ parser: ScrollParser, parsed dragons: [Dragon], from scrollName: String)
}

class ScrollParser {
    
    enum Error: Swift.Error {
        case invalid
    }
    
    let scrollName: String
    let delegate: ScrollParserDelegate
    
    init(scrollName: String, delegate: ScrollParserDelegate) {
        self.scrollName = scrollName
        self.delegate = delegate
    }
}

extension ScrollParser {
    fileprivate func urlForScroll(named scrollName: String, page pageNumber: Int) -> URL? {
        if Config.useLocalHTML {
            let resource = "velociraptor_\(pageNumber)"
            return Bundle.main.url(forResource: resource, withExtension: "html")
        }
        return URL(string: "https://dragcave.net/user/\(scrollName)/\(pageNumber)")
    }
    
    func start() {
        self.delegate.parser(self, startedScroll: scrollName)
        
        parse(page: 10)
    }
    
    private func parse(page pageNumber: Int) {
        print("Parsing page \(pageNumber)")
        DispatchQueue.global().async {
            
            guard let scrollURL = self.urlForScroll(named: self.scrollName, page: pageNumber) else {
                DispatchQueue.main.async {
                    self.delegate.parser(self, finishedScroll: self.scrollName, error: .invalid)
                }
                return
            }
            
            guard let html = try? String(contentsOf: scrollURL) else {
                DispatchQueue.main.async {
                    self.delegate.parser(self, finishedScroll: self.scrollName, error: .invalid)
                }
                return
            }
            
            if let doc = HTML(html: html, encoding: .utf8) {
                
                guard pageNumber == 1 || doc.hasMoreScrollPages() else {
                    DispatchQueue.main.async {
                        self.delegate.parser(self, finishedScroll: self.scrollName, error: nil)
                    }
                    return
                }
                
                let dragonHTML = doc.dragonHTML()
                guard dragonHTML.count > 0 else {
                    DispatchQueue.main.async {
                        self.delegate.parser(self, finishedScroll: self.scrollName, error: nil)
                    }
                    return
                }
                
                let dragons = dragonHTML.flatMap { pathObject -> Dragon? in
                    
                    guard
                        let name = pathObject.xpath("td[2]").first?.text,
                        let codeTag = pathObject.xpath("td[1]/a").first?["href"],
                        let code = codeTag.components(separatedBy: "/").last
                        else {
                            return nil
                    }
                    
                    return Dragon(code: code, name: name, words: nil)
                    
                }
                
                DispatchQueue.main.async {
                    self.delegate.parser(self, parsed: dragons, from: self.scrollName)
                }
                self.parse(page: pageNumber + 1)
            }
            else {
                 DispatchQueue.main.async {
                    self.delegate.parser(self, finishedScroll: self.scrollName, error: .invalid)
                }
            }
        }
    }
}

fileprivate extension HTMLDocument {
    
    func hasMoreScrollPages() -> Bool {
//        return true
        
        // TODO: This doesn't work for: https://dragcave.net/user/Velociraptor/100
        // There are more pages if the text "Last" is not a <span>
            let allLastMatches = xpath("//span[@class=\"_29_1\"]")
            .flatMap { element -> String? in
                if let text = element.text, text.contains("Last") {
                    return text
                }
                return nil
            }
            return Set(allLastMatches).count == 0
    }
    
    func dragonHTML() -> XPathObject {
        return xpath("//*[@id=\"udragonlist\"]/tbody/tr")
    }
}
