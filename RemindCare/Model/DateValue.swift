//
//  DateValue.swift
//  RemindCare
//
//  Created by Evelyn Lie on 23/11/2023.
//

import SwiftUI

struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
    
    // Initializer to create a DateValue with isSelected defaulting to false
    init(day: Int, date: Date) {
        self.day = day
        self.date = date
    }
}
