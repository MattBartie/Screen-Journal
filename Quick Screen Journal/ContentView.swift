//
//  ContentView.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 8/22/24.
//

import SwiftUI
import AppIntents
import SwiftData

struct ContentView: View {
    @State private var lastOpenedApp: String = SharedData.lastOpenedApp
    @Environment(\.scenePhase) private var scenePhase
    @Query private var items: [JournalEntry]
    
    
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Text("Home to be implemented...")
                
                }
            .padding()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    lastOpenedApp = SharedData.lastOpenedApp
                    print("App is active, content view reloaded")
                }
                else if newPhase == .background{
                    SharedData.lastOpenedApp = "none"
                    lastOpenedApp = SharedData.lastOpenedApp
                    print("leaving")
                    
                }
            }
            
        }
    }
    
}


#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

