//
//  Item.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 11/04/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
