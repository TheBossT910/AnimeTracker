//
//  AnimeSelect.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeSelect: View {
    var anime: Anime
    var animeFB: [String: Any]?
    
    var body: some View {
        let animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        
        VStack {
            HStack {
                Text(animeGeneral?.premiere ?? "N/A")
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                Text(animeGeneral?.rating ?? "N/A")
                    .font(.caption2)
            }

            //making the image
            VStack {
                var boxImage: Image {
                    Image(animeFiles?.box_image ?? "N/A")
                }
                boxImage
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
                        //TODO: Implement favorite with Firebase
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

            Text(animeGeneral?.title_eng ?? "N/A")
                .font(.headline)
            Text(animeGeneral?.title_jp ?? "N/A")
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
    @Previewable @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    let animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]
    
    AnimeSelect(anime: AnimeData().animes[1], animeFB: animeFB)
}
