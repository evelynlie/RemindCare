//
//  SplashScreenView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 28/11/2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color("CustomBlue")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .clipShape(Circle())
                    .shadow(radius: 20)
                
                Text("RemindCare")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .opacity(1)
                    .padding(.top, 20)
                
                Spacer()
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.size = 1.0
                    self.opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
