//
//  AnimeTrackerApp.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI
import Firebase

@main
struct AnimeTrackerApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject private var db = Database()
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(db)
                .environmentObject(authManager)
        }
    }
}
