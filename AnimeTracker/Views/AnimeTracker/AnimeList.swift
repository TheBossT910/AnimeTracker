//
//  AnimeList.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeList: View {
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
        NavigationStack {
            //favorites toggle
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show Favorites Only")
            }
            .padding()

            //displaying all of our shows
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(filteredAnimes) { anime in
                        NavigationLink(destination: AnimeDetail(anime: anime)) {
                            AnimeSelect(anime: anime)
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
