//
//  AnimeSelect.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeSelect: View {
    var anime: Anime
    var body: some View {
        VStack() {
            HStack () {
                Text(anime.premiere)
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                Text(anime.rating)
                    .font(.caption2)
            }
            
            //making the image
            Image(anime.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 4 )
                }
           
                Text(anime.name)
                    .font(.headline)
                Text(anime.jpTitle)
//                .padding(.bottom, 10)
//
          
        }
        .padding(10)
//        .padding(.bottom, 10)
//        .padding(.leading, 10)
//        .padding(.trailing, 10)
    }
}

#Preview {
    AnimeSelect(anime: animes[1])
}
