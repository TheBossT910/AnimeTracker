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
        VStack {
            HStack {
                Text(anime.premiere)
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                Text(anime.rating)
                    .font(.caption2)
            }

            //making the image
            VStack {
                anime.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    //the ratio for fitting it is 11/15 (width/height)
                    .frame(width: 169, height: 230)
                    .clipped()
                    .cornerRadius(10)
                    .overlay {

                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 4)
                        //padding()
                        if anime.isFavorite {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                //x should be 1/2 of width, y should be 1/2 of height (because its 0,0 is the center of the image!)
                                .offset(x: 84, y: 115)
                                .foregroundColor(.red)
                        }
                    }

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
    AnimeSelect(anime: AnimeData().animes[1])
}
