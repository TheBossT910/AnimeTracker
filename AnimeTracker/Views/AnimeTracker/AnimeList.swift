//
//  AnimeList.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeList: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds an AnimeFirebase object, with Firebase data
    @State private var showFavoritesOnly: Bool = false  //a toggle to show favorite shows only (true) or not (false)

    //for the LazyVGrid. Tells it how to organize/display the items in the grid
    //alignment: .top makes it so that all items are aligned at the top (and not in the center by default!)
    let columns = [GridItem(.adaptive(minimum: 150), alignment: .top)]

    //a filtered list of animes based on if we want to show all shows or only favorite shows
    var filteredAnimes: [String: [String: Any]] {
        //going through all animes in animeDataFB
        animeDataFB.animes.filter { anime in
            let curGeneral = anime.value["general"] as? general
            let curFavorite = curGeneral?.isFavorite ?? false
            return !showFavoritesOnly || curFavorite
        }
    }

    var body: some View {
        //grabbing the keys of all animes we want to see
        let animeKeys = Array(filteredAnimes.keys).sorted()
        
        NavigationStack {
            //favorites toggle
            Toggle(isOn: $showFavoritesOnly) {
                Text("Show Favorites Only")
            }
            .padding()

            //display all shows
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(animeKeys, id: \.self) { animeKey in
                        //showing the AnimeSelect view. Clicking on it leads to the AnimeDetail view
                        NavigationLink(destination: AnimeDetail(animeID: animeKey)) {
                            AnimeSelect(animeID: animeKey)
                        }
                    }
                    
                }
            }
        }
        //animation when switching between favorites only and all animes view
        .animation(.default, value: showFavoritesOnly)
    }
}

#Preview {
    //environment objects
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    
    AnimeList()
        .environmentObject(animeDataFB)
}
