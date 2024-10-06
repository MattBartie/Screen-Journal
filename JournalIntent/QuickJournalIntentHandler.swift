//
//  QuickJournalIntentHandler.swift
//  JournalIntent
//
//  Created by Matt Bartie on 8/22/24.
//

import Foundation
import Intents
import UIKit

class QuickJournalIntentHandler: NSObject, QuickJournalIntentHandling {
    private var shouldOpenedApp: Bool = SharedData.shouldOpenApp
    
    func resolveApp(for intent: QuickJournalIntent, with completion: @escaping (EnumResolutionResult) -> Void) {
        // No need for optional binding if app is an enum
        completion(EnumResolutionResult.success(with: intent.app))
    }
    
    func handle(intent: QuickJournalIntent, completion: @escaping (QuickJournalIntentResponse) -> Void) {
        let app = intent.app // Directly access the enum value
        
        // Handle the app enum
        if app.rawValue == 0{
            SharedData.lastOpenedApp = "none"
            //if it is ever none we should open diffent screen telling them to fix the shortcut setup

        }
        else if app.rawValue == 1{
            SharedData.lastOpenedApp = "reddit"

        }
        else if app.rawValue == 2{
            SharedData.lastOpenedApp = "X"

        }
        else if app.rawValue == 3{
            SharedData.lastOpenedApp = "instagram"
        }
        else if app.rawValue == 4{
            SharedData.lastOpenedApp = "tiktok"
        }
        else if app.rawValue == 5{
            SharedData.lastOpenedApp = "snapchat"
        }
            
        
        // Create a user activity and respond with continueInApp
        let userActivity = NSUserActivity(activityType: NSStringFromClass(QuickJournalIntent.self))
        userActivity.title = "QuickJournal"
        userActivity.userInfo = ["app": app.rawValue] // Pass the necessary data
        
        // Access SharedData.shouldOpenApp directly
        if SharedData.shouldOpenApp {
            let response = QuickJournalIntentResponse(code: .continueInApp, userActivity: userActivity)
            completion(response)
            print("Opening app as expected")
        } else {
            // If app should not open, set the appropriate state
            SharedData.shouldOpenApp = true
            SharedData.lastOpenedApp = "none"
            let response = QuickJournalIntentResponse(code: .success, userActivity: userActivity)
            completion(response)
            print("App will not open as expected")
        }
        
    }
    
    
}


