//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeDetail: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds an AnimeDataFirebase object, with Firebase data
    var animeID: String //holds the document ID to a specific anime
    
    var body: some View {
        //getting anime object
        let animeFB = animeDataFB.animes[animeID]
        //getting anime data objects
        var animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        
        // Computed Binding, courtesy of ChatGPT
        //TODO: code it yourslef to fully understand it, and create relevant comments
        let favoriteBinding = Binding<Bool>(
            get: { animeGeneral?.isFavorite ?? false },
            set: { newValue in
                // Update the model's isFavorite
                animeGeneral?.isFavorite = newValue
                
                // Update animeDataFB or notify about the change
                // Persist changes back to animeFB
                   if let generalUpdated = animeGeneral {
                       animeDataFB.animes[animeID]?["general"] = generalUpdated
                   }
            }
        )
        
        ScrollView {
            //getting the box image
            var boxImage: Image {
                Image(animeFiles?.box_image ?? "N/A")
            }
            BoxImage(image: boxImage)
            
            VStack(alignment: .leading) {
                HStack {
                    //Title and favourite button
                    Text(animeGeneral?.title_eng ?? "N/A")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    FavoriteButtonFB(animeID: animeID, favorite: favoriteBinding)
                }
                
                HStack {
                    //display release and schedule info
                    Text(animeGeneral?.broadcast ?? "N/A")
                        .font(.callout)
                        .fontWeight(.semibold)
                    Spacer()
                    //TODO: Implement displaying the show's season (s1, s2, etc.) with Firebase
                    Text(animeGeneral?.premiere ?? "N/A")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                //adding "Description" title
                Text("Description")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
        
                }
            
            //displaying the actual description
            Text(animeGeneral?.description ?? "N/A")
                .font(.body)
                .fontWeight(.medium)
            
//Trying to make a cool shadow effect for around the text, not working properly right now! :(
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
    //environment
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    
    AnimeDetail(animeID: "6KaHVRxICvkkrRYsDiMY")
        .environmentObject(animeDataFB)
}
