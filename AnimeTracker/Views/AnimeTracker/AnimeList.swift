//
//  AnimeList.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeList: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager
    
    @State private var showFavoritesOnly: Bool = false  // a toggle to show favorite shows only (true) or not (false)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    

    //for the LazyVGrid. Tells it how to organize/display the items in the grid
    //alignment: .top makes it so that all items are aligned at the top (and not in the center by default!)
    
//    let columns = [GridItem(.adaptive(minimum: 150), alignment: .top)]
    
    var columns: [GridItem] {
        let minSize: CGFloat = (horizontalSizeClass == .regular) ? 200 : 180
        return [GridItem(.adaptive(minimum: minSize), alignment: .top)]
    }

    //a filtered list of animes based on if we want to show all shows or only favorite shows
    var filteredAnimes: [String: anime] {
        // getting all favorites
        let userID = authManager.userID ?? ""
        let userFavorites = db.userData[userID]?.favorites ?? []
        
        // going through all animes
        return db.animeData.filter { anime in
            let currentID = anime.value.id
            // if we want to only see favorites, and the current show is a favorite, return
            return !showFavoritesOnly || userFavorites.contains(Int(currentID ?? "-1") ?? -1)
        }
    }

    var body: some View {
        //grabbing the keys of all animes we want to see
        let animeKeys = Array(filteredAnimes.keys).sorted()
        
        NavigationStack {
            //favorites toggle
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show Favorites Only")
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            .disabled(!authManager.isAuthenticated)
            .padding()

            //display all shows
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(animeKeys, id: \.self) { animeKey in
                        NavigationLink(destination: AnimeDetail(animeID: animeKey)) {
                            AnimeSelect(animeID: animeKey)
                        }
                    }
                }
            }
            .scrollTargetBehavior(.paging) // Forces more preloading
        }
        //animation when switching between favorites only and all animes view
        .animation(.default, value: showFavoritesOnly)
    }
}

#Preview {
    //environment objects
    let db = Database()
    let authManager = AuthManager.shared
    
    AnimeList()
        .environmentObject(db)
        .environmentObject(authManager)
}
