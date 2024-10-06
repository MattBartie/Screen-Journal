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
        
        var key: String {
            switch self {
            default: self.rawValue
            }
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
    
}
