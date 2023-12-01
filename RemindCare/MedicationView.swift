//
//  MedicationView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 27/11/2023.
//

import SwiftUI

struct MedicationView: View {
    @Binding var medications: [Medicine]
    @Binding var isMedicationViewActive: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingSheet = false
    @State private var selectedTab = 1

    var medicine: Medicine
    
    func deleteMedication(with id: UUID) {
        guard let index = medications.firstIndex(where: { $0.id == id }) else {
            return // Medicine with the given UUID not found
        }
        
        medications.remove(at: index)
        
        // Update UserDefaults
        saveToUserDefaults()
        
        dismiss()
        
        isMedicationViewActive = false
    }
    
    private func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(medications) {
            UserDefaults.standard.set(encoded, forKey: "medications")
        }
    }
    
    var body: some View {
        ScrollView{
            VStack {
                Text("\(medicine.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                HStack{
                    Text("Name: ").bold().font(.title2) + Text("\(medicine.name)").font(.title2)
                    Spacer()
                }.padding(.bottom, 10)
                
                HStack{
                    Text("Type of Medication: ").bold().font(.title2) + Text("\(medicine.type)").font(.title2)
                    Spacer()
                }.padding(.bottom, 10)
                
                HStack{
                    Text("Dosage: ").bold().font(.title2) + Text("\(medicine.dosage)").font(.title2)
                    Spacer()
                }.padding(.bottom, 10)
                
                HStack{
                    Text("Duration: ").bold().font(.title2) + Text("\(medicine.duration) \(medicine.selectedDuration)").font(.title2)
                    Spacer()
                }.padding(.bottom, 10)
                
                HStack {
                    Text("Alert: ").bold().font(.title2) + Text("\(medicine.hour):\(String(format: "%02d", medicine.minute))").font(.title2)
                    Spacer()
                }.padding(.bottom, 10)
                
                // Additional Information
                if medicine.additionalInfo != "" {
                    HStack{
                        Text("Additional Information: ").bold().font(.title2) + Text("\(medicine.additionalInfo)").font(.title2)
                        Spacer()
                    }.padding(.bottom, 10)
                }
                
                // Meal
                if medicine.meal == 0 {
                    HStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.customGrey)
                                .frame(height: 50)
                            Text("Before Meal")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding(.bottom, 10)
                    }
                }
                else {
                    HStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.customGrey)
                                .frame(height: 50)
                            Text("After Meal")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding(.bottom, 10)
                    }
                }
                
                HStack{
                    if let packagePhoto = medicine.package?.asPhoto {
                        VStack{
                            Text("Package")
                                .bold()
                                .font(.title2)
                                .padding(.bottom, -10)
                            Image(uiImage: packagePhoto)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 180, height: 200)
                        }
                    }
                    
                    if let transcriptPhoto = medicine.transcript?.asPhoto {
                        VStack{
                            Text("Transcript")
                                .bold()
                                .font(.title2)
                                .padding(.bottom, -10)
                            Image(uiImage: transcriptPhoto)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 180, height: 200)
                        }
                    }
                }
                
                HStack{
                    ZStack{
                        // Add Edit Button Background
                        Rectangle()
                            .frame(height:50)
                            .foregroundColor(.customBlue)
                            .cornerRadius(10)
                        Button(action: {
                            isShowingSheet.toggle()
                        }) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.white)
                                .font(.title)
                            Text("Edit")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $isShowingSheet) {
                            AddMedicationView(selectedTab: $selectedTab, medications: $medications)
                            
                        }
                    }
                    ZStack{
                        // Add Delete Button Background
                        Rectangle()
                            .frame(height:50)
                            .foregroundColor(.customBlue)
                            .cornerRadius(10)
                        Button(action: { deleteMedication(with: medicine.id) }) {
                            Image(systemName: "trash.circle")
                                .foregroundColor(.white)
                                .font(.title)
                            Text("Delete")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding([.leading, .trailing], 20)
        .background(.white)
    }
}

#Preview {
    ContentView()
}
