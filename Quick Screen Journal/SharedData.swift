//
//  SharedData.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 8/27/24.
//

import Foundation

class SharedData {
    static let defaultsGroup: UserDefaults? = UserDefaults(suiteName: "group.MattBartie.Quick-Screen-Journal.shareddata")
    
    struct PastDataEntry: Codable {
        let appName: String
        let date: Date
        let wasOpened: Bool
    }
    struct AppAccessEntry: Codable {
        let appName: String
        let accessTime: Date
    }
    
    enum Keys: String {
        case lastOpenedApp = "lastOpenedApp"
        case shouldOpenApp = "shouldOpenApp"
        case appOpenTally = "appOpenTally"
        case appNamesArray = "appNamesArray"
        case pastData = "pastData"
        case appAccessTimes = "appAccessTimes"
        
        var key: String {
            return self.rawValue
        }
    }
    // Store access times for apps
    static var appAccessTimes: [String: Date] {
        get {
            guard let data = defaultsGroup?.data(forKey: Keys.appAccessTimes.key) else {
                return [:]
            }
            let decoder = JSONDecoder()
            return (try? decoder.decode([String: Date].self, from: data)) ?? [:]
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaultsGroup?.set(encoded, forKey: Keys.appAccessTimes.key)
            }
        }
    }
    
    // Add or update an app's access time
    static func setAppAccessTime(for appName: String, to accessTime: Date) {
        var currentAccessTimes = appAccessTimes
        currentAccessTimes[appName] = accessTime
        appAccessTimes = currentAccessTimes
    }
    
    // Get the access time for a specific app
    static func getAppAccessTime(for appName: String) -> Date? {
        return appAccessTimes[appName]
    }
    
    static var pastData: [PastDataEntry] {
        get {
            guard let data = defaultsGroup?.data(forKey: Keys.pastData.key) else {
                return []
            }
            let decoder = JSONDecoder()
            return (try? decoder.decode([PastDataEntry].self, from: data)) ?? []
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaultsGroup?.set(encoded, forKey: Keys.pastData.key)
            }
        }
    }
    
    static func logPastData(appName: String, wasOpened: Bool) {
        var currentPastData = pastData
        let newEntry = PastDataEntry(appName: appName, date: Date(), wasOpened: wasOpened)
        currentPastData.append(newEntry)
        pastData = currentPastData
    }
    
    static var lastOpenedApp: String {
        get {
            defaultsGroup?.string(forKey: Keys.lastOpenedApp.key) ?? "None Yet"
        } set {
            defaultsGroup?.set(newValue, forKey: Keys.lastOpenedApp.key)
        }
    }
    
    
    static var shouldOpenApp: Bool {
        get {
            defaultsGroup?.bool(forKey: Keys.shouldOpenApp.key) ?? true
        }
        set {
            defaultsGroup?.set(newValue, forKey: Keys.shouldOpenApp.key)
        }
    }
    
    // Dictionary for storing both open and not open tallies for apps
    static var appOpenTally: [String: [String: Int]] {
        get {
            return defaultsGroup?.dictionary(forKey: Keys.appOpenTally.key) as? [String: [String: Int]] ?? [:]
        }
        set {
            defaultsGroup?.set(newValue, forKey: Keys.appOpenTally.key)
        }
    }
    
    // Increment the open tally for a specific app
    static func incrementOpenTally(for appName: String) {
        var currentTally = appOpenTally
        
        // Retrieve or initialize the tally dictionary for the app
        var appTally = currentTally[appName] ?? ["openTally": 0, "notOpenTally": 0]
        
        // Increment the open tally
        appTally["openTally", default: 0] += 1
        
        // Update the tally in the main dictionary
        currentTally[appName] = appTally
        appOpenTally = currentTally
    }
    
    // Increment the 'not open' tally for a specific app
    static func incrementNotOpenTally(for appName: String) {
        var currentTally = appOpenTally
        
        // Retrieve or initialize the tally dictionary for the app
        var appTally = currentTally[appName] ?? ["openTally": 0, "notOpenTally": 0]
        
        // Increment the 'not open' tally
        appTally["notOpenTally", default: 0] += 1
        
        // Update the tally in the main dictionary
        currentTally[appName] = appTally
        appOpenTally = currentTally
    }
    
    // Array to store app names (new code)
    static var appNamesArray: [String] {
        get {
            return defaultsGroup?.stringArray(forKey: Keys.appNamesArray.key) ?? []
        }
        set {
            defaultsGroup?.set(newValue, forKey: Keys.appNamesArray.key)
        }
    }
    
    // Add a new app name to the array (new method)
    static func addAppName(_ appName: String) {
        var appNames = appNamesArray
        
        // Add the app name only if it's not already in the array
        if !appNames.contains(appName) {
            appNames.append(appName)
            appNamesArray = appNames
        }
    }
    
    
}
