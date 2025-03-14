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
    // TODO: add auth, new DB file to here!
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject private var animeDataFB = AnimeDataFirebase(collection: "s1")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(animeDataFB)
        }
    }
}
