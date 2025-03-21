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
    @State var initiallyLoaded: Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    

    //for the LazyVGrid. Tells it how to organize/display the items in the grid
    //alignment: .top makes it so that all items are aligned at the top (and not in the center by default!)
    
//    let columns = [GridItem(.adaptive(minimum: 150), alignment: .top)]
    
    var columns: [GridItem] {
        let minSize: CGFloat = (horizontalSizeClass == .regular) ? 200 : 180
        return [GridItem(.adaptive(minimum: minSize), alignment: .top)]
    }

    //a filtered list of keys based on if we want to show all shows or only favorite shows
    var filteredKeys: [String] {
        // getting all favorites
        let userFavorites = db.userData?.favorites ?? []
        
        // going through all animes
        return db.orderedKeys.filter { key in
            // if we want to only see favorites, and the current show is a favorite, return
            return !showFavoritesOnly || userFavorites.contains(Int(key) ?? -1)
        }
    }

    var body: some View {
        //grabbing the keys of all animes we want to see
        let animeKeys = filteredKeys
        // grabbing the key of the last anime, for checking if we have rendered the last item in the Array
        let lastKey = animeKeys.last
        
        NavigationStack {
            //favorites toggle
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show Favorites Only")
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            .disabled(!authManager.isAuthenticated)
            // updates toggle so it is "off" when disabled
            .onChange(of: authManager.isAuthenticated) {
                if !authManager.isAuthenticated {
                    showFavoritesOnly = false
                }
            }
            .padding()

            //display all shows
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(animeKeys, id: \.self) { animeKey in
                        NavigationLink(destination: AnimeDetail(animeID: animeKey)) {
                            AnimeSelect(animeID: animeKey)
                        }
                        .onAppear {
                            // if the last anime is loaded and we are NOT showing favorites (i.e. all animes are visible), then load more animes
                            if ((animeKey == lastKey) && (!showFavoritesOnly)) {
                                Task {
                                    await db.getNextDocuments()
                                }
                            }
                        }
                    }
                }
            }
            .scrollTargetBehavior(.paging) // Forces more preloading
            
            Button("Load More Anime") {
                Task {
                    await db.getNextDocuments()
                }
            }
            // only load more animes if we can see ALL animes
            .disabled(showFavoritesOnly)
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
