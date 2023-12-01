//
//  HomeView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 22/11/2023.
//

import SwiftUI

struct HomeView: View {
    @Binding var medications: [Medicine]
    @State private var isShowingSheet = false
    @State var isMedicationViewActive = false
    
    @Binding var selectedTab: Int
    @State private var selectedDate = Date()
    @State private var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 170))]
    
    // Function to format the date (e.g. Wednesday, 22 November)
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: date)
    }
    
    // Function to check if selectedDate is in the past
    private func isDateInPast(_ date: Date) -> Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: date)
        return selectedDate < currentDate
    }
    
    // Today's medication
    var todaysMedications: [Medicine] {
        medications.filter { medication in
            medication.dates.contains { alertDate in
                Calendar.current.isDate(alertDate, inSameDayAs: Date())
            }
        }
    }
    
    var body: some View {
        ZStack{
            NavigationStack {
                ScrollView{
                    VStack{
                        HStack{
                            Text(formattedDate(date: Date())) // Display today's date
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.customBlue)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        
                        if medications.isEmpty == true{
                            HStack{
                                Text("Your Medications for Today")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
                                    .padding(.bottom, 50)
                                Spacer()
                            }
                        }
                        
                        if medications.isEmpty == false{
                            HStack{
                                Text("Your Medications for Today")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            // Display today's medications
                            LazyVGrid(columns: adaptiveColumns, spacing: 20){
                                ForEach(todaysMedications) { medication in
                                    NavigationLink {
                                        MedicationView(medications: $medications, isMedicationViewActive: $isMedicationViewActive, medicine: medication)
                                    } label: {
                                        MedicineLayout(medication: medication)
                                            .frame(maxWidth: 100)
                                    }
                                    .onDisappear {
                                        isMedicationViewActive = true
                                    }
                                    .onAppear {
                                        isMedicationViewActive = false
                                    }
                                }.padding(.bottom, 10)
                            }
                        }
                        
                        HStack{
                            if isDateInPast(selectedDate) == true{
                                Text("Past Medications")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
                            }
                            else{
                                Text("Upcoming Medications")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.heavy/*@END_MENU_TOKEN@*/)
                            }
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 2)
                        
                        // Calendar and selected date medication
                        CustomDatePicker(selectedDate: $selectedDate, medications: $medications)
                            .padding(.top, 2)
                            .padding([.leading, .trailing], -14)
                    }
                    .padding(22)
                    .onAppear {
                        // Set selectedDate to tomorrow's date whenever the HomeView appears
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                    }
                }
                .onAppear {
                    // Load medications from UserDefaults
                    if let savedMedications = UserDefaults.standard.data(forKey: "medications") {
                        let decoder = JSONDecoder()
                        if let decodedMedications = try? decoder.decode([Medicine].self, from: savedMedications) {
                            self.medications.removeAll()
                            self.medications.append(contentsOf: decodedMedications)
                        }
                    }
                }
            }
            
            // Plus sign button to add medication
            VStack{
                Spacer()
                if !isMedicationViewActive || medications.isEmpty{
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
                        }
                        .padding(.trailing, 30)
                    }
                }
                // Top border for tab bar
                Rectangle().frame(height: 1)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ContentView()
}
