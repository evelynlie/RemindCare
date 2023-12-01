//
//  AddNewMedicationSheet.swift
//  RemindCare
//
//  Created by Evelyn Lie on 21/11/2023.
//

import SwiftUI
import UserNotifications

struct AddMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int // from ContentView
    @Binding var medications: [Medicine]
    @State private var showPackageCameraView = false
    @State private var showTranscriptCameraView = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var medicationName = ""
    @State private var selectedType: MedicationType = .Capsule
    @State private var selectedDuration: DurationTime = .days
    @State private var dosage = 0
    @State private var duration = 0
    @State private var numAlerts = 0
    @State private var alertInfo: [Date] = Array(repeating: Date(), count: 10)
    @State private var meal = 0 // before = 0 and after = 1
    @State private var additionalInfo = ""
    
    let prefix = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth"]
        
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var timeComponents: [(hour: Int, minute: Int)] = Array(repeating: (hour: 0, minute: 0), count: 10)
    
    @State private var capturedPackage: UIImage? = nil
    @State private var capturedTranscript: UIImage? = nil
    
    enum MedicationType: String, CaseIterable, Identifiable {
        case Capsule, Tablet, Liquid
        var id: Self { self }
    }
    
    enum DurationTime: String, CaseIterable, Identifiable {
        case days, months
        var id: Self { self }
    }
    
    // Helper function to update alertInfo and timeComponents
    func updateArrays(date: Date, index: Int) {
        alertInfo[index] = date
        let components = Calendar.current.dateComponents(in: .current, from: date)
        
        // Update individual properties without using a tuple
        hour = components.hour ?? 0
        minute = components.minute ?? 0
        
        // Update timeComponents without using a tuple
        timeComponents[index].hour = hour
        timeComponents[index].minute = minute
        
        print("Hour: \(hour), Minute: \(minute)")
    }
    
    // Function to generate an array of dates from the current date until the end date
    private func generateDateRange() -> [Date] {
        // Calculate the end date by adding the duration to the current date based on days/months
        guard let durationEndDate: Date = {
            switch selectedDuration {
            case .days:
                return Calendar.current.date(byAdding: .day, value: duration, to: Date())
            case .months:
                return Calendar.current.date(byAdding: .month, value: duration, to: Date())
            }
        }() else {
            return []
        }
        
        var currentDate = Date()
        var dateRange: [Date] = []
        
        while currentDate <= durationEndDate {
            dateRange.append(currentDate)
            
            // Move to the next day
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        }
        return dateRange
    }
    
    // Function to add medication to user defaults
    func addMedication() {
        // Data validations
        guard !medicationName.isEmpty else {
            alertMessage = "Medication name could not be empty"
            showAlert = true
            return
        }
        
        guard dosage != 0 else {
            alertMessage = "Dosage could not be 0"
            showAlert = true
                return
            }
        
        guard duration != 0 else {
            alertMessage = "Duration could not be empty"
            showAlert = true
            return
        }
        
        guard numAlerts != 0 else {
            alertMessage = "Number of Alerts could not be 0"
            showAlert = true
            return
        }
        
        // Data validated
        print("========================================================================")
        var medicationsToAdd: [Medicine] = []
            
        for alertIndex in 0..<numAlerts {
            let timeComponent = timeComponents[alertIndex]
            if capturedPackage?.base64 != nil {
                print("There is a package photo.")
            }
            if capturedTranscript?.base64 != nil {
                print("There is a transcript photo.")
            }
            // Create Medicine instance
            let newMedication = Medicine(
                name: medicationName,
                type: selectedType.rawValue,
                dosage: dosage,
                duration: duration,
                selectedDuration: selectedDuration.rawValue,
                hour: timeComponent.hour,
                minute: timeComponent.minute,
                dates: generateDateRange(),
                meal: meal,
                package: capturedPackage?.base64,
                transcript: capturedTranscript?.base64,
                additionalInfo: additionalInfo
            )
            
            medicationsToAdd.append(newMedication)
            
            requestNotificationPermission()
            registerNotifications(currentMedication: newMedication, delay: Double(5 * (alertIndex + 1)))
            
            print(newMedication)
            print("=================== NEW MEDICATION ========================")
        }
        
        medications.append(contentsOf: medicationsToAdd)
        
        // Sort medications array based on the time component
        medications.sort { (med1, med2) -> Bool in
            // Compare hours first
            if med1.hour != med2.hour {
                return med1.hour < med2.hour
            }
            
            // If hours are equal, compare minutes
            return med1.minute < med2.minute
        }
        
        // Update UserDefaults
        saveToUserDefaults()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
            if success {
                print ("Notification authorization received!")
            } else if let error = error {
                print (error.localizedDescription)
            }
        }
    }
    
    private func registerNotifications(currentMedication: Medicine, delay: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Take Your Medication"
        content.subtitle = medicationName
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("Sent notification?")
    }
    
    // Function to save medications to user default
    private func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(medications) {
            UserDefaults.standard.set(encoded, forKey: "medications")
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel") {
                    dismiss() // Close sheet
                }.foregroundColor(.red)
                Spacer()
                Text("Add Medication")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.trailing, 55)
                Spacer()
            }
            .padding(20)
            .padding(.bottom, -10)
            
            Form{
                Section{
                    HStack {
                        Text("Name").fontWeight(.semibold)
                        TextField("", text: $medicationName)
                    }
                    List {
                        Picker("Type of Medication", selection: $selectedType) {
                            ForEach(MedicationType.allCases) { type in
                                Text(type.rawValue)
                                    .foregroundColor(.red)
                            }
                        }
                        .fontWeight(.semibold)
                        .pickerStyle(MenuPickerStyle()).accentColor(.customBlue)
                    }
                }
                
                Section{
                    Stepper(value: $dosage) {
                        Text("Dosage: \(dosage)").fontWeight(.semibold)
                    }
                }
                
                Section {
                    HStack {
                        Text("Duration:").fontWeight(.semibold)
                        Spacer()
                        
                        TextField("", value: $duration, format: .number).fontWeight(.semibold)
                        
                        Picker("", selection: $selectedDuration) {
                            ForEach(DurationTime.allCases) { time in
                                Text(time.rawValue)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(MenuPickerStyle()).accentColor(.customBlue)
                    }
                }
                
                // Alert Section
                Section {
                    Stepper(value: $numAlerts, in: 0...100) {
                        Text("Number of Alerts: \(numAlerts)").fontWeight(.semibold)
                    }
                    ForEach(0..<numAlerts, id: \.self) { index in
                        DatePicker("\(prefix[index]) Alert", selection: $alertInfo[index], displayedComponents: .hourAndMinute)
                            .onChange(of: alertInfo[index]) { newDate, _ in
                                updateArrays(date: newDate, index: index)
                            }
                    }
                    .accentColor(.customBlue)
                }
                
                CustomSegmentedPicker(meal: $meal, options: ["Before Meal", "After Meal"])
                
                Section{
                    HStack {
                        Button(action: {
                            self.showPackageCameraView = true
                        }) {
                            HStack {
                                if capturedPackage?.base64 != nil {
                                    Text("Preview Medication Package")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                else{
                                    Text("Add Medication Package")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "camera.fill")
                            }
                        }
                        .sheet(isPresented: $showPackageCameraView) {
                            CreateImageView(capturedImage: $capturedPackage)
                        }
                    }.foregroundColor(.black)
                }
                
                Section{
                    HStack {
                        Button(action: {
                            self.showTranscriptCameraView = true
                        }) {
                            HStack {
                                if capturedTranscript?.base64 != nil {
                                    Text("Preview Transcript")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                else{
                                    Text("Add Transcript")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "camera.fill")
                            }
                        }
                        .sheet(isPresented: $showTranscriptCameraView) {
                            CreateImageView(capturedImage: $capturedTranscript)
                        }
                    }.foregroundColor(.black)
                }
                
                Section{
                    TextField("Additional Information", text: $additionalInfo,  axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            
            ZStack{
                // Add Button Background
                Rectangle()
                    .padding(.top, -30)
                    .padding(.bottom, -30)
                    .frame(width: 400, height:50)
                    .offset(y:10)
                    .foregroundColor(.formGrey)
                Button(action: {
                    addMedication()
                    if !showAlert {
                        dismiss()
                    }
                }) {
                    Image(systemName: "plus.circle")
                    Text("Add")
                        .fontWeight(.bold)
                        .font(.title2)
                }
                .frame(width: 350, height: 50)
                .foregroundColor(.white)
                .background(.customBlue)
                .cornerRadius(30)
            }
            // If medicineName / dosage / duration = "" or 0
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        // Set all values for alertInfo (dates) and timeComponents
        .onAppear {
            let currentDate = Date()
            let currentHour = Calendar.current.component(.hour, from: currentDate)
            let currentMinute = Calendar.current.component(.minute, from: currentDate)
            
            for index in 0..<10 {
                
                // User hasn't changed the time, set it to the current time
                alertInfo[index] = Calendar.current.date(bySettingHour: currentHour, minute: currentMinute, second: 0, of: currentDate) ?? currentDate
                
                // Extract hour and minute and save them to the timeComponents
                let timeTuple = (hour: currentHour, minute: currentMinute)
                timeComponents[index] = timeTuple
            }
        }
    }
}

#Preview {
    //AddMedicationView(selectedTab: .constant(1))
    ContentView()
}
