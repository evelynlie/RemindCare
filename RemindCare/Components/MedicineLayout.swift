//
//  MedicineLayout.swift
//  RemindCare
//
//  Created by Evelyn Lie on 23/11/2023.
//

import SwiftUI

struct MedicineLayout: View {
    var medication: Medicine
    
    // Converts unique Date to a string "HH:mm" format
    func alertsToString(_ alerts: [Date]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let uniqueAlerts = Set(alerts.map { dateFormatter.string(from: $0) })
        return uniqueAlerts.joined(separator: ", ")
    }
    
    var body: some View {
        VStack{
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 144, height: 142)
                    .background(Color(red: 1, green: 1, blue: 1).opacity(0.30))
                    .cornerRadius(34)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34)
                            .inset(by: 1)
                            .stroke(Color(red: 0.40, green: 0.78, blue: 0.82), lineWidth: 1)
                    )
                VStack{
                    HStack{
                        if medication.type == "Capsule" {
                            Image("cap")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .padding(.leading, -10)
                                .padding(.bottom, -5)
                        } else if medication.type == "Tablet"{
                            Image("tab")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                                .padding(.leading, -4)
                                .padding(.trailing, 10)
                        } else {
                            Image("liq")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .padding(.leading, -10)
                                .padding(.top, -10)
                                .padding(.bottom, -10)
                        }
                        VStack(alignment: .leading) {
                            Text("x \(medication.dosage)")
                                .padding(.leading, -10)
                                .padding(.bottom, medication.type == "Capsule" ? -20 : 0)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.semibold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    Text("\(medication.hour):\(String(format: "%02d", medication.minute))")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top, -10)
                        .padding(.bottom, medication.type == "Capsule" ? 20 : 0)
                }
            }.padding(.bottom, 10)
            Text("\(medication.name)")
                .font(.title2 .bold())
                .foregroundColor(.customBlue)
                .padding(.top, medication.type == "Capsule" ? -20 : 0)
                .padding(.top, medication.type == "Tablet" ? -20 : 0)
                .padding(.top, medication.type == "Liquid" ? -5 : 0)
                .offset(y: medication.type == "Tablet" ? 7 : 0)
                .frame(width: 150, height: 30)
        }
    }
}

#Preview {
    ContentView()
}
