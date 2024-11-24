//
//  AnimeTrackerApp.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

@main
struct AnimeTrackerApp: App {
    @State private var animeData = AnimeData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(animeData)
        }
    }
}
