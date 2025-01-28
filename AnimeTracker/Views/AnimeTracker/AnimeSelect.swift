//
//  AnimeSelect.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeSelect: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase //holds an AnimeDataFirebase object, with Firebase data
    @Environment(\.colorScheme) var colorScheme //used to detect light/dark mode
    var animeID: String //holds the document id to a specific anime
    
    var body: some View {
        //getting anime object
        let animeFB = animeDataFB.animes[animeID]
        //getting anime data objects
        let animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        //getting anime favorite value
        let isFavorite = animeGeneral?.isFavorite ?? false
        
        VStack {
            //displaying top text, premiere and rating
            HStack {
                Text(animeGeneral?.premiere ?? "N/A")
                    .font(.caption2)
                    .fontWeight(.heavy)
                    //changes color depending on light/dark mode
                    .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                Text(animeGeneral?.rating ?? "N/A")
                    .font(.caption2)
            }

            //displaying the image
            VStack {
                //getting the image
                var boxImage: Image {
                    Image(animeFiles?.box_image ?? "N/A")
                }
                
                //formatting the image
                boxImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    //the ratio for fitting it is 11/15 (width/height)
                    .frame(width: 169, height: 230)
                    .clipped()
                    .cornerRadius(10)
                    .overlay {

                        RoundedRectangle(cornerRadius: 10)
                            //changes the color of the outline based on light/dark modes
                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 4)
                        
                        //display/hide a heart if favorite is true/false
                        if isFavorite {
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
            //display the english and japanese title at the bottom
            Text(animeGeneral?.title_eng ?? "N/A")
                .font(.headline)
            Text(animeGeneral?.title_jp ?? "N/A")
        }
        .padding(10)
    }
}

#Preview {
    //environment
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    AnimeSelect(animeID: "6KaHVRxICvkkrRYsDiMY")
        .environmentObject(animeDataFB)
}
