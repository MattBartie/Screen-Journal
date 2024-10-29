import SwiftUI
import AppIntents
import SwiftData

struct ContentView: View {
    @State private var lastOpenedApp: String = SharedData.lastOpenedApp
    @Environment(\.scenePhase) private var scenePhase
    @Query private var items: [JournalEntry]
    
    private let startColor: Color = .blue
    private let endColor: Color = .purple
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.all)
                LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.05)
                    .edgesIgnoringSafeArea(.top)
                
                
                VStack(spacing: 20) {
                    Text("Overview")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                                    
                                    let apps = SharedData.appNamesArray
                                    let pairs = stride(from: 0, to: apps.count, by: 2).map {
                                        Array(apps[$0..<min($0 + 2, apps.count)])
                                    }
                                    
                                    VStack(spacing: 15) {
                                        ForEach(pairs.indices, id: \.self) { index in
                                            HStack(spacing: 10) {
                                                ForEach(pairs[index], id: \.self) { app in
                                                    let appTally = SharedData.appOpenTally[app] ?? ["openTally": 0, "notOpenTally": 0]
                                                    let openCount = appTally["openTally"] ?? 0
                                                    let notOpenCount = appTally["notOpenTally"] ?? 0
                                                    
                                                    AppUsageBubble(appName: app, openCount: openCount, notOpenCount: notOpenCount)
                                                }
                                                
                                                
                                                // Add spacer if the last row has only one item
                                                if pairs[index].count == 1 {
                                                    AddAppBubble()
                                                }
                                            }
                                            
                                        }
                                        // If last row is full, add AddAppBubble in a new row
                                        if let lastPair = pairs.last, lastPair.count == 2 {
                                            HStack {
                                                AddAppBubble()
                                                Spacer()
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                }
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
            }
        }
    }
}

struct AppUsageBubble: View {
    let appName: String
    let openCount: Int
    let notOpenCount: Int
    
    func formatNumber(_ number: Int) -> String {
            if number < 10000 {
                return "\(number)"
            } else if number < 1000000 {
                let thousands = Double(number) / 1000.0
                return String(format: "%.1fK", thousands)
            } else {
                let millions = Double(number) / 1000000.0
                return String(format: "%.1fM", millions)
            }
        }
    // Define gradient colors based on app name
    func getAppGradient(for appName: String) -> Color {
            switch appName {
            case "Reddit":
                return Color.red
            case "X":
                return Color.gray
            case "Instagram":
                return Color.pink
            case "TikTok":
                return Color.purple
            case "Snapchat":
                return Color.yellow
            default:
                return Color.white
            }
        }
    
    var body: some View {
      
        VStack(alignment: .leading, spacing: 8) {
                    Text(appName)
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TOTAL")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(formatNumber(openCount + notOpenCount))")
                                .font(.title2)
                                .bold()
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("BLOCKED")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(formatNumber(notOpenCount))")
                                .font(.title2)
                                .bold()
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: UIScreen.main.bounds.width/2.3, alignment: .leading)
                .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(getAppGradient(for: appName))
                                .opacity(0.7)
                
                        )
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
            
          
        
    }
}

struct AddAppBubble: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 57, height: 57)
                
                Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
            }
            
            Text("Add App")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .frame(maxWidth: UIScreen.main.bounds.width / 2.3, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
                .opacity(0.7)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        .onTapGesture {
            // Action to guide the user on adding an app
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = setupPreviewData()
        
        ContentView()
            .modelContainer(for: JournalEntry.self, inMemory: true)
    }
    
    static func setupPreviewData() {
        if let defaults = UserDefaults(suiteName: "group.MattBartie.Quick-Screen-Journal.shareddata") {
            // Set up sample app names
            let sampleApps = ["Test", "Safari", "Mail", "Reddit"]
            defaults.set(sampleApps, forKey: SharedData.Keys.appNamesArray.key)
            
            // Set up sample app tallies
            let sampleTallies: [String: [String: Int]] = [
                "Test": ["openTally": 5000, "notOpenTally": 2423],
                "Safari": ["openTally": 3435, "notOpenTally": 14234],
                "Mail": ["openTally": 4252, "notOpenTally": 332],
                "Reddit": ["openTally": 4252, "notOpenTally": 332]
            ]
            defaults.set(sampleTallies, forKey: SharedData.Keys.appOpenTally.key)
            
            // Set last opened app
            defaults.set("Messages", forKey: SharedData.Keys.lastOpenedApp.key)
            
            defaults.synchronize()
        }
    }
}
