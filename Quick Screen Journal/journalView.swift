//
//  journalView.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 8/29/24.
//

import SwiftUI
import AppIntents
import SwiftData

struct journalView: View {
    @Binding var lastOpenedApp: String
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    
    @State private var userResponse: String = ""
    @FocusState private var isFocused: Bool
    private let startColor: Color = .blue
    private let endColor: Color = .purple
    @State private var animateGradient: Bool = false
    
    @State private var navigateToDifferentView = false

    
    var body: some View {
            NavigationStack {
                VStack{
                    
                    Text("Why do you want to use \(lastOpenedApp)?")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .padding()
                   
                    TextField("click to type",
                              text: $userResponse,
                              axis: .vertical)
                        .background(Color.clear)
                        .padding()
                        .focused($isFocused)
        
                    Spacer()
                    VStack{
                        
                        
                        
                        
                        // NavigationLink to navigate to the new view when button is pressed
                        Button(action: {
                                isFocused = false
                                addJournal(app: lastOpenedApp, journal: userResponse)
                                navigateToDifferentView = true // Set the navigation state
                            }) {
                                Text("Do not Open \(lastOpenedApp)")
                                    .frame(width: 300, height: 50)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)

                            // NavigationLink to navigate to the new view when the state changes
                            NavigationLink(destination: TabContainerView(), isActive: $navigateToDifferentView) {
                                EmptyView()
                                // Use an EmptyView to keep the NavigationLink functional without displaying anything
                            }
                        
                        
                        
                        Button(action: {
                            if(Double(userResponse.count) / 30.0 >= 1){
                                isFocused = false
                                SharedData.shouldOpenApp = false
                                addJournal(app: lastOpenedApp, journal: userResponse)
                                openApp(app: lastOpenedApp)
                            }
                        }) {
                            Text("Open \(lastOpenedApp)")
                        }
                        
                        .background(Color.clear)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        
                        // Progress Calculation
                        let progress = min(Double(userResponse.count) / 30.0, 1.0) // Capped at 1.0 (100%)
                        let progressColor = Color(red: 1.0 - progress, green: progress, blue: 0.0) // Red to green transition

                        // ProgressView with animated progress
                        HStack{
                            ProgressView(value: progress)
                                .progressViewStyle(LinearProgressViewStyle())
                                .tint(progressColor) // Apply the dynamic color
                                .frame(width: 300)
                                .animation(.easeInOut(duration: 2), value: progress) // Apply animation here
                                .opacity(0.5)
                            
                            // Optional Text to show progress percentage
                            Text("\(min(userResponse.count, 30))/30")
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                                .opacity(0.5)
                        }
                        
                        
                            
                    }
                }
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
                .background {
                    LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .hueRotation(.degrees(animateGradient ? 45 : 0))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                                animateGradient.toggle()
                            }
                        }
                        .opacity(0.2)
                }
            }
        }
    
    
    private func addJournal(app: String, journal: String) {
        let newJournal = JournalEntry(app: app, joural: journal)
        modelContext.insert(newJournal)
    }
  
    private func openApp(app: String) {
            if let url = URL(string: "\(app)://app") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback to opening Reddit in Safari if the app is not installed
                    if let url = URL(string: "\(app)://"){
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    if let webUrl = URL(string: "https://www.\(app).com") {
                        UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                    }
                }
            }
        }
}

struct TabContainerView: View {
    var body: some View {
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
        .navigationBarBackButtonHidden(true) 
    }
}

struct viewForPreview : View {
     @State
     private var value = "Instagram"

     var body: some View {
          journalView(lastOpenedApp: $value)
     }
}


#Preview {
    viewForPreview()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
