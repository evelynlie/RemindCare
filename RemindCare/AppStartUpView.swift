//
//  AppStartUpView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 28/11/2023.
//

import SwiftUI

struct AppStartUpView: View {
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                ContentView()
            } else {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
    }
}
