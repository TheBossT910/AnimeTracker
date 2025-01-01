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
    
    //Firebase
    var animeFB: [String: Any]?
    
    var body: some View {
        let animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        
        @Bindable var animeData = animeData
        ScrollView {
            //getting the box image
            var boxImage: Image {
                Image(animeFiles?.box_image ?? "N/A")
            }
            BoxImage(image: boxImage)
            
            //Putting all the text stuff within a VStack
            VStack(alignment: .leading) {
                HStack {
                    
                    //Title and favourite button
                    Text(animeGeneral?.title_eng ?? "N/A")
                        .font(.title)
                    Spacer()
                    
                    //TODO: implement favorite button with Firebase
                    //add favorite button
                    FavoriteButton(isSet: $animeData.animes[animeIndex].isFavorite)
                }
                HStack {
                    //Release schedule info?
                    Text(animeGeneral?.broadcast ?? "N/A")
                    Spacer()
                    //TODO: Implement show season with Firebase. Disabled for now
                    //Anime season info
                    Text(animeGeneral?.premiere ?? "N/A")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                //adding description stuff
                Text("Description")
                    .font(.title2)
                    .padding(.bottom, 10)
        
                }
            Text(animeGeneral?.description ?? "N/A")
            
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
    @Previewable @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    //Oshi no Ko and Spy x Family
//    var animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]
    let animeFB = animeDataFB.animes["OZtFGA9sVtdxtOCZZTEw"]
    
    let animeData = AnimeData()
    AnimeDetail(anime: animeData.animes[0], animeFB: animeFB)
        //We need this because we reference @Environment in the code
        .environment(animeData)
}
