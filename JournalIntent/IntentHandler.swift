//
//  IntentHandler.swift
//  JournalIntent
//
//  Created by Matt Bartie on 8/22/24.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        guard intent is QuickJournalIntent else {
              fatalError("Unhandled Intent error : \(intent)")
            }
        return QuickJournalIntentHandler()
    }
    
}
