//
//  CustomDatePicker.swift
//  RemindCare
//
//  Created by Evelyn Lie on 23/11/2023.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    @Binding var medications: [Medicine]
    @State private var isMedicationActive = false
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 170))]
    
    @State var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    // Month update on arrow button clicks
    @State var currentMonth: Int = 0
    
    // Selected date's medication
    var filteredMedications: [Medicine] {
        medications.filter { medication in
            medication.dates.contains { alertDate in
                Calendar.current.isDate(alertDate, inSameDayAs: selectedDate)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 35){
            
            // Days
            let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            if medications.isEmpty == true{
                HStack{
                    // Display selected date
                    Text(formattedSelectedDate())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.customBlue)
                    Spacer()
                }
                .padding(.leading, 13)
                .padding(.bottom, 10)
            }
            else {
                HStack{
                    // Display selected date
                    Text(formattedSelectedDate())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.customBlue)
                    Spacer()
                }
                .padding(.leading, 13)
                .padding(.bottom, -10)
                
                if !filteredMedications.isEmpty{
                    // Display today's medications
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        ForEach(filteredMedications) { medication in
                            NavigationLink {
                                MedicationView(medications: $medications, isMedicationViewActive: $isMedicationActive, medicine: medication)
                            } label: {
                                MedicineLayout(medication: medication)
                                    .frame(maxWidth: 100)
                            }
                        }.padding(.bottom, 10)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 15)
                }
            }
            
            // Display Calendar
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extractDate()[1] + " " + extractDate()[0])
                        .font(.title2.bold())
                }
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                Button{
                    withAnimation{
                        currentMonth -= 1
                    }
                } label:{
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button{
                    withAnimation{
                        currentMonth += 1
                    }
                } label:{
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding([.leading, .trailing], 13)
            
            // Day View
            HStack(spacing: 0){
                ForEach(days, id: \.self){ day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates in Lazy Grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()){ value in
                    CardView(value: value)
                        .onTapGesture {
                            selectedDate = value.date
                        }
                }
            }
            Spacer()
        }
        .onChange(of: currentMonth) {
            selectedDate = getCurrentMonth() // Update month
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        ZStack{
            if value.day != -1 {
                Circle()
                    .fill(isToday(value.date) ? Color.customBlue : Color.clear)
                    .frame(width: 150)
                    .opacity(0.5)
                Circle()
                    .fill(isSelectedDate(value.date) && isSameMonth(value.date) || isSelectedDate(value.date) ? Color.customBlue : Color.clear)
                    .frame(width: 150)
                    .opacity(1)
                Text("\(value.day)")
                    .font(.title3.bold())
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    
    // Function to format selected date
    func formattedSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: selectedDate)
    }
    
    // Function to check if a date is today
    func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    // Function to check if a date is the selected date
    func isSelectedDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }
    
    // Function to check if a date is in the same month as the current date
    func isSameMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let componentsGivenDate = calendar.dateComponents([.year, .month], from: date)
        
        let componentsTomorrow = calendar.dateComponents([.year, .month], from: tomorrow)
        
        return (componentsTomorrow.year == componentsGivenDate.year && componentsTomorrow.month == componentsGivenDate.month)
    }
    
    // Extract year and month from display
    func extractDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: selectedDate)
        
        return date.components(separatedBy: " ")
    }
    
    // Function to get the data of current month
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // Getting current month and dates
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date())
        else {
            return Date()
        }
        
        // Adding 1 day to the current month
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentMonth) {
            return nextDay
        } else {
            return Date()
        }
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        // Getting current month and dates
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // Adding offset to days to get exact week day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

// Extending Date to get current month and dates
extension Date{
    func getAllDates() -> [Date]{
        let calendar = Calendar.current
        
        // Getting First Date
        let firstDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: firstDate)!
        
        // Getting Date
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: firstDate)!
        }
    }
}

#Preview {
    ContentView()
}
