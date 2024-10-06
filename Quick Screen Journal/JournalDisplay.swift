//
//  JournalDisplay.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 9/11/24.
//


import SwiftUI
import AppIntents
import SwiftData

struct JournalDisplay: View {
    @State private var lastOpenedApp: String = SharedData.lastOpenedApp
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [JournalEntry]
    
    @State private var isDataInserted = false
    private let startColor: Color = .blue
    private let endColor: Color = .purple
    @State private var animateGradient: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    
                List {
                    ForEach(items.reversed()) { entry in
                        JournalEntryView(entry: entry)
                    }
                }
                .frame(width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 275)
                .scrollContentBackground(.hidden)
                
               
                
                
                /*
                List(items.reversed()) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.app)
                            .font(.headline)
                        Text(entry.joural)
                        Text(entry.creationDate, style: .date)
                            .font(.caption)
                    }
                }
                 */

            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .padding()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    lastOpenedApp = SharedData.lastOpenedApp
                    print("App is active, content view reloaded")
                } else if newPhase == .background {
                    SharedData.lastOpenedApp = "none"
                    lastOpenedApp = SharedData.lastOpenedApp
                    print("leaving")
                }
            }
            .onAppear {
                if !isDataInserted {
                    //insertSampleData()
                    isDataInserted = true
                }
            }
            .background {
                LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    .hueRotation(.degrees(animateGradient ? 45 : 0))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }
                    .opacity(0.1)
            }
        }
    }
    
    private func insertSampleData() {
        let temp = JournalEntry(app: "Instagram", joural: "This is a test, nothing more and nothing less")
        modelContext.insert(temp)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        let temp2 = JournalEntry(app: "Instagram", joural: "This is also a test")
        modelContext.insert(temp2)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

struct JournalEntryView: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.app)
                .font(.headline)
            Text(entry.joural)
                
            Text(entry.creationDate, style: .date)
                .font(.caption)
                .padding(.bottom)
        }
        //.frame(width:  UIScreen.main.bounds.width-100)
        .background(Color.clear)
        
       
    }
    
}




#Preview {
    JournalDisplay()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

