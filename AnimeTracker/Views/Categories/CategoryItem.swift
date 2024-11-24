//
//  CategoryItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryItem: View {
    var anime: Anime
    
    var body: some View {
        //adding the image, and changing its apperance
        VStack(alignment: .leading) {
            anime.image
                .renderingMode(.original)
                //.resizable()
                //allows us to maintain the correct aspect ratio
                .aspectRatio(contentMode: .fit)
            
                //having a universal size for all images
                //setting the size of the frame
                //the ratio for fitting it is 11/15 (width/height)
                .frame(width: 220, height: 300)
                //then clipping anything that is outside of that frame
                .clipped()
                //and rounding the corners
                .cornerRadius(10)
        
            
            //adding the show name
            Text(anime.name)
                //changing the look
                .foregroundStyle(.primary)
                .font(.caption)
        }
        //allows us to space each item out when put together in another view
        .padding(.leading, 15)
        
    }
}

#Preview {
    CategoryItem(anime: AnimeData().animes[0])
}
