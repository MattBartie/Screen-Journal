//
//  Quick_Screen_JournalApp.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 8/22/24.
//

import SwiftUI
import SwiftData

@main
struct Quick_Screen_JournalApp: App {
    @State private var lastOpenedApp: String = SharedData.lastOpenedApp
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if(lastOpenedApp != "none"){
                journalView(lastOpenedApp: $lastOpenedApp)
            }else{
                TabView {
                        ContentView()
                            .tabItem {
                                Label("Content", systemImage: "list.dash")
                            }
                        
                        JournalDisplay()
                            .tabItem {
                                Label("Journal", systemImage: "book")
                            }
                    }
            }
            
        }
        .modelContainer(for: JournalEntry.self)
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
