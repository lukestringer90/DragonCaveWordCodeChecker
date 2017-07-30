//
//  DisplayDragons.swift
//  Word Code Checker
//
//  Created by Luke Stringer on 30/07/2017.
//  Copyright © 2017 Luke Stringer. All rights reserved.
//

import Foundation

protocol DisplayDragons {
    var dragonDataSource: DragonsDataSource? { get set }
    func display(dragons: [Dragon])
}

protocol DragonsDataSource {
    func initalDragons() -> [Dragon]
}
