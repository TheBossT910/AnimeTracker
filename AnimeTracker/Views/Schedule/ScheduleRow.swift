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
    // TODO: show week by selected date
    let date: Date
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
            
            Button("Reload") {
                Task {
                    // NOTE: This "solves" the problem where we need to load in a new season of shows
                    // TODO: this is not an ideal solution, but it works for now!
                    db.resetAiringKeys()
                    await db.getInitialAiring(weekday: day, week: date)
                    print(db.animeData.count)
                }
            }
            // no padding
            .padding(0)
            
            LazyVGrid(columns: columns) {
                // display each airing show
                ForEach(animeKeys, id: \.self) { animeKey in
                    
                    //NavigationLink allows us to navigate to AnimeDetail when clicked (when importing this view into another view)
                    NavigationLink {
                        AnimeDetail(animeID: animeKey)
                    } label: {
                        ScheduleItem(animeID: animeKey, weekday: day, date: date)
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
                                    await db.getNextAiring(weekday: day, week: date)
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
                        await db.getInitialAiring(weekday: day, week: date)
                    }
                    initiallyLoaded.toggle()
                }
            }
        }
        .scrollTargetBehavior(.viewAligned) // Forces more preloading
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    ScheduleRow(day: "Sundays", showFavorites: .constant(false), date: Date())
        .environmentObject(db)
        .environmentObject(authManager)
}
