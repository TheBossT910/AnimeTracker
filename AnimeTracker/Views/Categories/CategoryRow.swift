//
//  CategoryRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryRow: View {
    //Firebase
    @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    var categoryName: String
    var items: [Anime]
    
    var body: some View {
        //grabbing the keys of all animes
        let animeKeys = Array(animeDataFB.animes.keys).sorted()
        
        //TODO: fully implement Firebase so we don't need to depend on Anime objects
        let anime = items.first!
        
        VStack(alignment: .leading) {
            //displaying the category name
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            //lets us scroll horizontally. showIndicators: false means don't show a scrollbar
            ScrollView(.horizontal, showsIndicators: false) {
                //putting everything horizontally
                HStack(alignment: .top, spacing: 0) {
                    //displaying each item
                    ForEach(animeKeys, id: \.self) { animeKey in
                        //get the categoryStatus of the current anime
                        let currentAnime = animeDataFB.animes[animeKey]!
                        let animeGeneral = currentAnime["general"] as? general
                        let categoryStatus = animeGeneral?.category_status ?? "N/A"
                        
                        //only display an anime if it is in the category we want
                        if (categoryStatus == categoryName) {
                            //having it link to the correct details page
                            //TODO: implement isFavorite properly
                            NavigationLink {
                                AnimeDetail(animeFB: currentAnime)
                                //image of the anime
                            } label: {
                                CategoryItem(anime: anime, animeFB: currentAnime)
                            }
                        }
                    }
                }
            }
            .frame(height: 350)
        }
    }
}

#Preview {    
    let animes = AnimeData().animes
    return CategoryRow(
        categoryName: animes[0].categoryStatus.rawValue,
        //this is just getting the first 4 items, don't worry about it not matching the actual category. Just using this to see how everything looks!
        items: Array(animes.prefix(4))
    )
}
