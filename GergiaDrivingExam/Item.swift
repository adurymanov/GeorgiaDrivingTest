//
//  Item.swift
//  GergiaDrivingExam
//
//  Created by Andrew on 01.06.2024.
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
