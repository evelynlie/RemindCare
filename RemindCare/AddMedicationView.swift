//
//  AddMedication.swift
//  Add Meds
//
//  Created by Evelyn Lie on 20/11/2023.
//

import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var medicationName: String = ""
    
    func addMedication(){
        print("Medication Added")
    }

    var body: some View {
        VStack{
            HStack{
                Button("Cancel") {
                    dismiss()
                }.foregroundColor(.red)
                Spacer()
                Text("Add Medication").fontWeight(.semibold)
                    .padding(.trailing, 25)
                Spacer()
                Button(action: addMedication) {
                    Text("Add")
                }.foregroundColor(.gray)
            }
            .padding(20)
            .padding(.bottom, -10)
            .background()
            Spacer()
            Form{
                TextField(text: $medicationName, prompt: Text("Medication Name")) {
                }.foregroundColor(.black)
                
            }
        }
    }
}
