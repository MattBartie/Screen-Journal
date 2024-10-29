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
            ZStack{
                Color(.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.all)
                LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.05)
                    .edgesIgnoringSafeArea(.top)
                VStack {
                    //Rectangle()
                    //   .fill(Color.clear)
                    // .frame(width: UIScreen.main.bounds.width, height: 40)
                    Spacer()
                        .padding(100)
                    Text("Journals")
                    
                        .font(.largeTitle)
                        .bold()
                    
                    
                    List {
                        ForEach(items.reversed()) { entry in
                            JournalEntryView(entry: entry)
                        }
                        
                    }
                    .frame(width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-180)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                        .padding(80)
                    
                    
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
                        insertSampleData()
                        isDataInserted = true
                    }
                }
               
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
        let temp3 = JournalEntry(app: "Instagram", joural: "This is a test, nothing more and nothing less")
        modelContext.insert(temp3)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        let temp4 = JournalEntry(app: "Instagram", joural: "This is also a test")
        modelContext.insert(temp4)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        let temp5 = JournalEntry(app: "Instagram", joural: "This is a test, nothing more and nothing less")
        modelContext.insert(temp5)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        let temp6 = JournalEntry(app: "Instagram", joural: "This is also a test")
        modelContext.insert(temp6)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        let temp7 = JournalEntry(app: "Instagram", joural: "This is a test, nothing more and nothing less")
        modelContext.insert(temp7)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        let temp8 = JournalEntry(app: "Instagram", joural: "This is also a test")
        modelContext.insert(temp8)
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

