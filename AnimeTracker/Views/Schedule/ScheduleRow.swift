//
//  ScheduleRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

//TODO: Add the "top shows" section

import SwiftUI
import Foundation

struct ScheduleRow: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager
    
    var day: String
    @Binding var showFavorites: Bool // a toggle to show favorite shows only (true) or not (false)
    @State var initiallyLoaded: Bool = false
    let columns = [GridItem(.flexible())]
    
    //a filtered list of keys based on if we want to show all shows or only favorite shows
    var filteredKeys: [String] {
        let allKeys = db.airingKeys[day] ?? []
        // getting all favorites
        let userID = authManager.userID ?? ""
        let userFavorites = db.userData[userID]?.favorites ?? []
        
        // going through all animes
        return allKeys.filter { key in
            // if we want to only see favorites, and the current show is a favorite, return
            return !showFavorites || userFavorites.contains(Int(key) ?? -1)
        }
    }

    var body: some View {
        //grabbing keys of all animes airing on date
        let animeKeys = filteredKeys
        let lastKey = animeKeys.last
        
        ScrollView(.vertical) {
            Text(day)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            //default text for when no animes are found
            Text(animeKeys.isEmpty ? "No Animes Found" : "")
                .font(.headline)
            
            LazyVGrid(columns: columns) {
                // display each airing show
                ForEach(animeKeys, id: \.self) { animeKey in
                    
                    //NavigationLink allows us to navigate to AnimeDetail when clicked (when importing this view into another view)
                    NavigationLink {
                        AnimeDetail(animeID: animeKey)
                    } label: {
                        ScheduleItem(animeID: animeKey)
                    }
                    //fixes the bug where all text is highlighted blue in views that use this view
                    .buttonStyle(.plain)
                    .onReceive(db.$lastAiringSnapshots) { newValue in
                        // if the nextDoc exists
                        if let nextDoc = newValue[day] {
                            // if value is NOT nil (we have data) and we load the last show
                            if (nextDoc != nil) && (animeKey == lastKey) {
                                print("Adding more weekday data...")
                                Task {
                                    // add more airing shows
                                    await db.getNextAiring(weekday: day)
                                }
                            }
                        }
                    }
                }
            }
            // initially load airing shows
            .onAppear {
                if (!initiallyLoaded) {
                    Task {
                        print("Initial weekday load...")
                        await db.getInitialAiring(weekday: day)
                    }
                    initiallyLoaded.toggle()
                }
            }
        }
        .scrollTargetBehavior(.viewAligned) // Forces more preloading
        
        Button("Load More Anime") {
            Task {
                await db.getInitialAiring(weekday: day)
                print(db.animeData.count)
            }
        }
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    ScheduleRow(day: "Tuesdays", showFavorites: .constant(false))
        .environmentObject(db)
        .environmentObject(authManager)
}
