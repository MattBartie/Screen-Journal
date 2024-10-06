//
//  JournalEntry.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 9/11/24.
//

import Foundation
import SwiftData

@Model

final class JournalEntry {
    var app: String
    var joural: String
    var creationDate: Date
    
    init(app: String, joural: String) {
        self.app = app
        self.joural = joural
        self.creationDate = Date()
    }
}
