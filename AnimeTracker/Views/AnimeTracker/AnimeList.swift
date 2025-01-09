//
//  AnimeList.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

//BUG: unfavoriting animes when "show favorites only" is clicked doesn't update the heart to be empty

import SwiftUI

struct AnimeList: View {
    //Firebase
//    @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    @EnvironmentObject var animeDataFB: AnimeDataFirebase
    @State private var showFavoritesOnly: Bool = false
    
    //TODO: Remove this, and implement @Environment with AnimeDataFirebase instead
    @Environment(AnimeData.self) var animeData
    
    //    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    //alignment: .top makes it so that all items are aligned at the top (and not in the center by default!)
    let columns = [GridItem(.adaptive(minimum: 150), alignment: .top)]

    //gives us animes depending if we want to see all or only favorites
    //NOTE: So whats going on is that when we unfavorite an anime, it removes it from this filteredAnimes list and therefore breaks the binding.
    var filteredAnimes: [String: [String: Any]] {
        animeDataFB.animes.filter { anime in
            let curGeneral = anime.value["general"] as? general
            let curFavorite = curGeneral?.isFavorite ?? false
            return !showFavoritesOnly || curFavorite
        }
    }

    var body: some View {
        //grabbing the keys of all animes we want to see
        let animeKeys = Array(filteredAnimes.keys).sorted()
        var favMem: [String] = []
        
        NavigationStack {
            //favorites toggle
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show Favorites Only")
            }
            .padding()

            //displaying all of our shows
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(animeKeys, id: \.self) { animeKey in
                        let currentAnime = animeDataFB.animes[animeKey]
                        NavigationLink(destination: AnimeDetail( animeFB: currentAnime)) {
                            AnimeSelect(animeFB: currentAnime)
                        }
                        .onChange(of: showFavoritesOnly) {
                            if (showFavoritesOnly) {
                                print("fav showed!")
                            }
                        }
                    }
                    
                }
                .onAppear() {
                    //do something
                }
            }
        }
        //animation when switching between favorites only and all animes view
        .animation(.default, value: showFavoritesOnly)
    }
    
    func createFavoriteList() {
        print("Creating favorite list")
    }
    
    func addFavorite() {
        print("Adding favorite")
    }
    
    func removeFavorite() {
        print("Removing favorite")
    }
}


#Preview {
    //environment objects
    let animeData = AnimeData()
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    AnimeList()
        .environment(AnimeData())
        .environmentObject(animeDataFB)
}
