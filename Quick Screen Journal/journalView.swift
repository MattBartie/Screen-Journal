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
    @AppStorage("selectedTimeDelay") private var selectedTimeDelay: Int = 5
    @State private var showingTimePicker = false
     

    
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
                        HStack{
                            
                            
                            // NavigationLink to navigate to the new view when button is pressed
                            Button(action: {
                                isFocused = false
                                addJournal(app: lastOpenedApp, journal: userResponse)
                                navigateToDifferentView = true
                                SharedData.incrementNotOpenTally(for: lastOpenedApp)
                                SharedData.logPastData(appName: lastOpenedApp, wasOpened: false)
                                SharedData.lastOpenedApp = "none"
                                SharedData.shouldOpenApp = true
                                
                                
                                
                            }) {
                                Text("Do not Open \(lastOpenedApp)")
                                    .frame(width: UIScreen.main.bounds.width/2, height: 50)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                            // DONT DELETE THIS, it makes the do not open button work
                            NavigationLink(destination: TabContainerView(), isActive: $navigateToDifferentView) {
                                EmptyView()
                            }
                            
                            TimePickerButton()
                            
                            
                           
                            
                        }
                        
                        
                        Button(action: {
                            if(Double(userResponse.count) / 30.0 >= 1){
                                isFocused = false
                                SharedData.shouldOpenApp = false
                                addJournal(app: lastOpenedApp, journal: userResponse)
                                SharedData.incrementOpenTally(for: lastOpenedApp)
                                SharedData.logPastData(appName: lastOpenedApp, wasOpened: true)
                                openApp(app: lastOpenedApp)

                                SharedData.setAppAccessTime(for: lastOpenedApp, to: Date().addingTimeInterval(TimeInterval(selectedTimeDelay*60)))
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
                        SharedData.logPastData(appName: lastOpenedApp, wasOpened: false)
                        SharedData.incrementNotOpenTally(for: lastOpenedApp)
                        SharedData.lastOpenedApp = "none"
                        lastOpenedApp = SharedData.lastOpenedApp
                        print("leaving")
                    }
                }
                .background {
                    LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.05)
                        .ignoresSafeArea()
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

struct TimePickerButton: View {
    @AppStorage("selectedTimeDelay") var selectedTimeDelay: Int = 5
    @State private var showingTimePicker = false
    private let timeDelayOptions = [5, 10, 15, 30, 60]
    
    var body: some View {
        Button {
            showingTimePicker.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                Text("\(selectedTimeDelay)m")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.primary)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2)
            )
        }
        .popover(isPresented: $showingTimePicker, arrowEdge: .bottom) {
            VStack(spacing: 0) {
                Text("Select Delay")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 12)
                
                Picker("", selection: $selectedTimeDelay) {
                    ForEach(timeDelayOptions, id: \.self) { minutes in
                        Text("\(minutes) min").tag(minutes)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 120)
            }
            .padding(.horizontal)
            .presentationCompactAdaptation(.popover) // Ensures it stays as a popover on iPhone
        }
    }
}


#Preview {
    viewForPreview()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
