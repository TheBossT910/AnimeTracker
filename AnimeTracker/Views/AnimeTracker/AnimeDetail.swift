//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeDetail: View {
    
    //our variables
    @Environment(AnimeData.self) var animeData
    //We make it into a state variable so we can change the value during program run
    var anime: Anime
    var animeIndex: Int {
        //the ! unwraps the data into the Int type
        animeData.animes.firstIndex(where: { $0.id == anime.id })!
    }
    
    var body: some View {
        @Bindable var animeData = animeData
        ScrollView {
            //hardcoded image
            BoxImage(image: anime.image)
            
            //Putting all the text stuff within a VStack
            VStack(alignment: .leading) {
                HStack {
                    
                    //Title and favourite button
                    Text(anime.name)
                        .font(.title)
                    Spacer()
                    
                    //add favorite button
                    FavoriteButton(isSet: $animeData.animes[animeIndex].isFavorite)
                }
                HStack {
                    //Release schedule info?
                    Text(anime.broadcast)
                    Spacer()
                    //Anime season info?
                    Text("S\(anime.season), \(anime.premiere)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                //adding description stuff
                Text("Description")
                    .font(.title2)
                    .padding(.bottom, 10)
        
                }
                    Text(anime.description)
            
//Trying to make a cool shadow effect, not working properly right now! :(
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(.white)
//                                .shadow(radius: 10)
//                        )
                            
        }
            .padding()
    }
}

#Preview {
    let animeData = AnimeData()
    AnimeDetail(anime: animeData.animes[0])
        //We need this because we reference @Environment in the code
        .environment(animeData)
}
