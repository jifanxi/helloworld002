//
//  Item.swift
//  hello002
//
//  Created by jishengbao on 2024/7/12.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var s: Double
    
    init(timestamp: Date, s: Double) {
        self.timestamp = timestamp
        self.s = s
    }
}
