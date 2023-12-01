//
//  LibraryView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 22/11/2023.
//

import SwiftUI

struct LibraryView: View {
    @Binding var medications: [Medicine]
    @State private var isShowingSheet = false
    @State var isMedicationViewActive = false
    @State var imageType = ""
    @State private var selectedTab = 1
    
    private var groupedMedications: [Date: [Medicine]] {
        // Group medications by date
        Dictionary(grouping: medications) { medicine in
            // Use the first date in the 'dates' array of each medication
            return Calendar.current.startOfDay(for: medicine.dates.first ?? Date())
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        ZStack{
            NavigationStack {
                List {
                    ForEach(groupedMedications.keys.sorted(), id: \.self) { date in
                        Section(header: Text(formatDate(date))
                            .font(.headline)
                            .padding(.leading, -15)
                            .foregroundColor(.black)) {
                            ForEach(groupedMedications[date]!) { medicine in
                                NavigationLink {
                                    MedicationView(medications: $medications, isMedicationViewActive: $isMedicationViewActive, medicine: medicine)
                                } label: {
                                    HStack{
                                        if medicine.type == "Capsule" {
                                            Image("cap")
                                            Text(medicine.name).font(.title2)
                                        }
                                        else if medicine.type == "Tablet" {
                                            Image("tab")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80)
                                            Text(medicine.name).font(.title2)
                                        }
                                        else {
                                            Image("liq")
                                            Text(medicine.name).font(.title2)
                                        }
                                    }
                                }
                                .onDisappear {
                                    isMedicationViewActive = true
                                }
                                .onAppear {
                                    isMedicationViewActive = false
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Library")
            }
            
            // Plus sign button to add medication
            VStack{
                Spacer()
                if !isMedicationViewActive {
                    HStack{
                        Spacer() // Place button to the right
                        Button(action: {
                            isShowingSheet.toggle() // isShowingSheet = true
                        }) {
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.CustomBlue)
                                    .padding(.bottom, 10)
                            }
                        }
                        .sheet(isPresented: $isShowingSheet) {
                            AddMedicationView(selectedTab: $selectedTab, medications: $medications)
                        }.padding(.trailing, 30)
                    }
                }
                // Top border for tab bar
                Rectangle().frame(height: 1)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview{
    ContentView()
}
