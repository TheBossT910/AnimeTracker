//
//  AnimeList.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeList: View {
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(animes) { anime in
                        NavigationLink(destination: AnimeDetail(anime: anime)) {
                            AnimeSelect(anime: anime)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AnimeList()
}
