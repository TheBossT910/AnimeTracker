//
//  CategoryRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Anime]
    
    var body: some View {
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
                    ForEach(items) { anime in
                        //having it link to the correct details page
                        NavigationLink {
                            AnimeDetail(anime: anime)
                            //image of the anime
                        } label: {
                            CategoryItem(anime: anime)
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
