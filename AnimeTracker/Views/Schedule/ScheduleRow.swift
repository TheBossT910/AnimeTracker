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

    var body: some View {
        //grabbing keys of all animes airing on date
        let animeKeys = db.airingKeys["Tuesday"] ?? []
        let lastKey = animeKeys.last
        
        let columns = [GridItem(.flexible())]
        
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
                        if let nextDoc = newValue["Tuesday"] {
                            // if value is NOT nil (we have data)
                            if nextDoc != nil {
                                print("Adding more weekday data...")
                                Task {
                                    await db.getNextAiring(date: 0)
                                    print(db.animeData.count)
                                }
                            }
                        }
                    }
                }
            }
            // initially load the data
            .onAppear {
                if (!initiallyLoaded) {
                    Task {
                        print("Initial weekday load...")
                        await db.getInitialAiring(date: 0)
                    }
                    initiallyLoaded.toggle()
                }
            }
        }
        .scrollTargetBehavior(.viewAligned) // Forces more preloading
        
        // TODO: do initial load when view loads. Perhaps in ScheduleHome view?
        Button("Load More Anime") {
            Task {
                await db.getInitialAiring(date: 0)
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
