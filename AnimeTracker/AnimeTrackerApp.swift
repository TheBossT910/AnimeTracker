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
    
    @State private var animeData = AnimeData()
    @StateObject private var animeDataFB = AnimeDataFirebase(collection: "s1")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(animeData)
                .environmentObject(animeDataFB)
        }
    }
}
