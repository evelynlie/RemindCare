//
//  EditMedicationSheet.swift
//  RemindCare
//
//  Created by Evelyn Lie on 27/11/2023.
//

import SwiftUI

struct EditMedicationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var medications: [Medicine]
    @Binding var medicine: Medicine

    var body: some View {
        Text("Test")
    }
}
