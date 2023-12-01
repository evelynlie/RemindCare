//
//  AlertView.swift
//  Add Meds
//
//  Created by Evelyn Lie on 20/11/2023.
//

import SwiftUI

struct AlertView: View {
    @State private var showAlert = false
    var body: some View {
        VStack {
            Button("Medication ⏰") {
                showAlert.toggle()
            }
            .padding()

            // Notification view
            TestView(message: "This is a visual notification", isPresented: $showAlert)
        }
        .frame(width: 300, height: 200)
    }
}

struct TestView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.gray.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("2x 💊")
                        .padding()
                        .cornerRadius(10)
                        
                    Button("Done!") {
                        isPresented = false
                    }
                    Button("Remind in 10 min") {
                        isPresented = false
                    }
                    .padding()
                }
            }
        }
    }
}
#Preview {
    AlertView()
}
        
