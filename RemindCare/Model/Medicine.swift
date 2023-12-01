//
//  Medicine.swift
//  RemindCare
//
//  Created by Evelyn Lie on 22/11/2023.
//

import Foundation
import SwiftUI

struct Medicine: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var dosage: Int
    var duration: Int
    var selectedDuration: String
    var hour: Int
    var minute: Int
    var dates: [Date] // Array to store multiple alerts
    var meal: Int
    
    var package: String? = nil
    var transcript: String? = nil
    
    var additionalInfo: String
}
