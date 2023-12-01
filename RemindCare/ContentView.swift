//
//  ContentView.swift
//  RemindCare
//
//  Created by Evelyn Lie on 20/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var medications: [Medicine] = []
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack{
            // Top border for tab bar
            TabView(selection: $selectedTab) {
                HomeView(medications: $medications, selectedTab: $selectedTab)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                LibraryView(medications: $medications)
                    .tabItem {
                        Label("Library", systemImage: "line.3.horizontal")
                    }
                    .tag(1)
            }
            .accentColor(.CustomBlue)
        }
        .padding(.top, -10)
    }
}

#Preview {
    ContentView()
}
