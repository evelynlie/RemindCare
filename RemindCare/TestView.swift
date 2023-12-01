//
//  TestView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 23/11/2023.
//

import SwiftUI

struct TestView: View {
    @State var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        CustomDatePicker(selectedDate: $tomorrow)
    }
}

#Preview {
    TestView()
}
