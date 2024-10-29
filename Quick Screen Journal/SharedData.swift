//
//  SharedData.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 8/27/24.
//

import Foundation

class SharedData {
    static let defaultsGroup: UserDefaults? = UserDefaults(suiteName: "group.MattBartie.Quick-Screen-Journal.shareddata")
    
    enum Keys: String {
        case lastOpenedApp = "lastOpenedApp"
        case shouldOpenApp = "shouldOpenApp"
        case appOpenTally = "appOpenTally"
        case appNamesArray = "appNamesArray"
        
        
        var key: String {
            return self.rawValue
        }
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
