//
//  AnimeList.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeList: View {
    //Firebase
    @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    //stuff for making favorites
    @Environment(AnimeData.self) var animeData
    @State private var showFavoritesOnly: Bool = false
    
    //    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    //alignment: .top makes it so that all items are aligned at the top (and not in the center by default!)
    let columns = [GridItem(.adaptive(minimum: 150), alignment: .top)]

    var filteredAnimes: [Anime] {
        animeData.animes.filter { anime in
            !showFavoritesOnly || anime.isFavorite
        }
    }

    var body: some View {
        //grabbing the keys of all animes
        let animeKeys = Array(animeDataFB.animes.keys).sorted()
        
        //TEMPORARY! TODO: implement favoruties with Firebase, so that we dont need this!
        let anime = animeData.animes.first!
        
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
                        NavigationLink(destination: AnimeDetail(anime: anime, animeFB: currentAnime)) {
                            AnimeSelect(anime: anime, animeFB: currentAnime)
                        }
                    }
                }
            }
        }
        //animation for when switching between favorites only and all animes view
        .animation(.default, value: filteredAnimes)
    }
}

#Preview {
    AnimeList()
        .environment(AnimeData())
}
