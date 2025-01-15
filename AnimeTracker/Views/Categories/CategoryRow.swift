//
//  CategoryRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryRow: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds a AnimeDataFirebase object, with data from Firebase
    var categoryName: String    //holds the name of the category we want to display
    
    var body: some View {
        //grabbing the keys of all animes
        let animeKeys = Array(animeDataFB.animes.keys).sorted()
        let aight = animeKeys.count
        Text("\(aight)")
        
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
                            NavigationLink {
                                AnimeDetail(animeID: animeKey)
                            } label: {
                                //image of the anime
                                CategoryItem(animeID: animeKey)
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
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    //implemented category names are "Dropped", "Completed", "Watching", "Plan to Watch"
    CategoryRow(categoryName: "Dropped")
        .environmentObject(animeDataFB)
}
