//
//  WachlistMenu.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-15.
//

import SwiftUI

struct WachlistMenu: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager
    
    var animeID: String
    var userID: String
    var watchlists: [String: Bool]
    
    @State var isDropped = false
    @State var isCompleted = false
    @State var isWatching = false
    @State var isPlanToWatch = false
    
    var body: some View {
        Menu {
            Button(action: {
                isDropped.toggle()
                let watchlist = db.userData[userID]?.dropped ?? []
                db.toggleWatchlist(userID: userID, animeID: Int(animeID) ?? -1, watchlist: watchlist, watchlistName: "dropped")
            }) {
                Label("Dropped", systemImage: isDropped ? "folder" : "folder.fill")
            }
            Button(action: {
                isCompleted.toggle()
                let watchlist = db.userData[userID]?.completed ?? []
                db.toggleWatchlist(userID: userID, animeID: Int(animeID) ?? -1, watchlist: watchlist, watchlistName: "completed")
            }) {
                Label("Completed", systemImage: isCompleted ? "folder" : "folder.fill")
            }
            Button(action: {
                isWatching.toggle()
                let watchlist = db.userData[userID]?.watching ?? []
                db.toggleWatchlist(userID: userID, animeID: Int(animeID) ?? -1, watchlist: watchlist, watchlistName: "watching")
            }) {
                Label("Watching", systemImage: isWatching ? "folder" : "folder.fill")
            }
            Button(action: {
                isPlanToWatch.toggle()
                let watchlist = db.userData[userID]?.plan_to_watch ?? []
                db.toggleWatchlist(userID: userID, animeID: Int(animeID) ?? -1, watchlist: watchlist, watchlistName: "plan_to_watch")
            }) {
                Label("Plan to Watch", systemImage: isPlanToWatch ? "folder" : "folder.fill")
            }
        } label: {
            Label("Add to Watchlist", systemImage: "star")
        }
        // initially setting values
        .onAppear {
            isDropped = watchlists["Dropped"] ?? false
            isWatching = watchlists["Watching"] ?? false
            isCompleted = watchlists["Completed"] ?? false
            isPlanToWatch = watchlists["Plan to Watch"] ?? false
        }
    }
}

#Preview {
    //environment
    let db = Database()
    let authManager = AuthManager.shared
    
    WachlistMenu(animeID: "163134", userID: "zZ81pmI0bQcU7a6NsocUn7A4owU2", watchlists: ["Dropped": false, "Watching": true, "Completed": false, "Plan to Watch": true])
        .environmentObject(db)
        .environmentObject(authManager)
}
