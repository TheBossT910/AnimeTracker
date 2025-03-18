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
    
    //a filtered list of animes based on the day of the week, if the show aired within a span of 2 months, and if we want to show all shows or only favorite shows
    // TODO: Change logic
    var filteredAnimes: [String] {
        // getting all favorites
        let userID = authManager.userID ?? ""
        let userFavorites = db.userData[userID]?.favorites ?? []
        
        // going through all animes
        return db.orderedKeys.filter { key in
            let anime = db.animeData[key]
            
            // TODO: We are only basing the air date off of the 1st show... Fix this!
            let latestEpisode = anime?.episodes?.first
            let broadcastUnix: TimeInterval = Double(latestEpisode?.broadcast ?? 0)
            
            // cheking weekday
            let weekday = getWeekday(from: broadcastUnix)

            // checking if aired within 6 month interval (2 cours)
            let isActivelyAiring = isWithinTwoCours(unixTimestamp: broadcastUnix)

            
            // for checking favorite
            let currentID = anime?.id
            // if we want to only see favorites, and the current show is a favorite, return
//            return (!showFavorites || userFavorites.contains(Int(currentID ?? "-1") ?? -1)) && ((weekday + "s") == day)
//            return (!showFavorites || userFavorites.contains(Int(currentID ?? "-1") ?? -1))
            return((weekday + "s") == day)
        }
    }

    var body: some View {
        //grabbing keys of all animes
//        let animeKeys = Array(filteredAnimes.keys)
        let animeKeys = filteredAnimes
        let lastKey = animeKeys.last ?? ""
        var run = false
        
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
//                    .onAppear {
//                        if ((animeKey == lastKey) && db.lastAiringSnapshots["Tuesday"]! != nil) {
//                            print("Adding more shows")
//                            run = true
//                            Task {
//                                await db.getNextAiring(weekday: "Tuesday")
//                                print(db.animeData.count)
//                            }
//                        }
//                    }
                    .onReceive(db.$lastAiringSnapshots) { newValue in
                        if (animeKey == lastKey) {
                            print("update pls!")
                            Task {
                                await db.getNextAiring(weekday: "Tuesday")
                                print(db.animeData.count)
                            }
                        }
                    }
                }
            }
        }
        .scrollTargetBehavior(.viewAligned) // Forces more preloading
        
        // TODO: do initial load when view loads. Perhaps in ScheduleHome view?
        Button("Load More Anime") {
            Task {
                await db.getNextAiring(weekday: "Tuesday")
                print(db.animeData.count)
            }
        }
    }

    // function courtesy of ChatGPT.
    // TODO: create your own implementation
    // gets the weekday
    func getWeekday(from unixTimestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full weekday name (e.g., "Monday")
        formatter.timeZone = TimeZone.current  // Uses the device's timezone
        
        return formatter.string(from: date)
    }
    
    // function courtesy of ChatGPT
    // TODO: create your own implementation
    // returns true if the airdate is within 6 months (2 cours) of the current date (false otherwise)
    func isWithinTwoCours(unixTimestamp: TimeInterval) -> Bool {
        let givenDate = Date(timeIntervalSince1970: unixTimestamp)
        let currentDate = Date()
        
        guard let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: currentDate),
              let sixMonthsLater = Calendar.current.date(byAdding: .month, value: 6, to: currentDate) else {
            return false
        }
        
        return givenDate >= sixMonthsAgo && givenDate <= sixMonthsLater
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
