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
    
    //a filtered list of animes based on the day of the week, and if we want to show all shows or only favorite shows
    var filteredAnimes: [String: anime] {
        // getting all favorites
        let userID = authManager.userID ?? ""
        let userFavorites = db.userData[userID]?.favorites ?? []
        
        // going through all animes
        return db.animeNew.filter { anime in
            // TODO: We are only basing the air date off of the 1st show... Fix this!
            let latestEpisode = anime.value.episodes?.first
            let broadcastUnix: TimeInterval = Double(latestEpisode?.broadcast ?? 0)
            let weekday = getWeekday(from: broadcastUnix)
            
            let currentID = anime.value.id
            // if we want to only see favorites, and the current show is a favorite, return
            return (!showFavorites || userFavorites.contains(Int(currentID ?? "-1") ?? -1)) && ((weekday + "s") == day)
        }
    }

    var body: some View {
        //grabbing keys of all animes
        let animeKeys = Array(filteredAnimes.keys).sorted()
        
        ScrollView(.vertical) {
            Text(day)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            //default text for when no animes are found
            Text(animeKeys.isEmpty ? "No Animes Found" : "")
                .font(.headline)
            
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
            }
        }
    }

    // function courtesy of ChatGPT.
    // TODO: create your own implementation
    func getWeekday(from unixTimestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full weekday name (e.g., "Monday")
        formatter.timeZone = TimeZone.current  // Uses the device's timezone
        
        return formatter.string(from: date)
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    ScheduleRow(day: "Tuesdays", showFavorites: .constant(true))
        .environmentObject(db)
        .environmentObject(authManager)
}
