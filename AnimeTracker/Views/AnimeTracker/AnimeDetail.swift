//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeDetail: View {
    //TODO: maybe it is not uodating because we pass a seperate animeFB object. Try passing in a anime key only? -> IT IS WORKING!!!
    //Firebase
    @EnvironmentObject var animeDataFB: AnimeDataFirebase
//    var animeDataFB: AnimeDataFirebase
    var animeID: String
    var animeFB: [String: Any]?
    
    var body: some View {
        //get Firebase doc objects
        //TODO: temporary hard-code to reference Oshi no Ko directly from EnvironmentObject. IT IS WORKING!!!!! IT FIXES EVERYTHING!!!!
        var animeGeneral = animeDataFB.animes[animeID]?["general"] as? general
//        var animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        let animeDocID = animeFiles?.doc_id_anime ?? "N/A"
        
        
        
        // Computed Binding, courtesy of ChatGPT
        let favoriteBinding = Binding<Bool>(
            get: { animeGeneral?.isFavorite ?? false },
            set: { newValue in
                // Update the model's isFavorite
                animeGeneral?.isFavorite = newValue
                
                // Update animeDataFB or notify about the change
                // Persist changes back to animeFB
                   if let generalUpdated = animeGeneral {
                       animeDataFB.animes[animeDocID]?["general"] = generalUpdated
                   }
            }
        )
        
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
                    
                    //add favorite button
                    FavoriteButtonTester(animeDataFB: animeDataFB, animeGeneral: animeGeneral, animeFiles: animeFiles, favorite: favoriteBinding)
                }
                
                HStack {
                    //Release schedule info?
                    Text(animeGeneral?.broadcast ?? "N/A")
                    Spacer()
                    //TODO: Implement displaying the show's season (s1, s2, etc.) with Firebase
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
    //for the dummy data
    @Previewable @StateObject var animeDataFB2 = AnimeDataFirebase(collection: "s1")
    
    //just some dummy data
    //Have Oshi no Ko and Spy x Family
    var animeFB = animeDataFB2.animes["6KaHVRxICvkkrRYsDiMY"]
    let animeGeneral = animeFB?["general"] as? general
    let isFavorite = animeGeneral?.isFavorite ?? false
    //    let animeFB = animeDataFB.animes["OZtFGA9sVtdxtOCZZTEw"]
    
    //environment objects
    let animeData = AnimeData()
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    
    AnimeDetail(animeID: "6KaHVRxICvkkrRYsDiMY", animeFB: animeFB)
    //We need this because we reference @Environment in the code
        .environment(animeData)
        .environmentObject(animeDataFB)
}
