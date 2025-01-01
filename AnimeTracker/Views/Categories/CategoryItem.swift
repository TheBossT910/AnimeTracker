//
//  CategoryItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryItem: View {
    var anime: Anime
    var animeFB: [String: Any]?
    
    var body: some View {
        let animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        
        //getting the box image
        var boxImage: Image {
            Image(animeFiles?.box_image ?? "N/A")
        }
        
        //adding the image, and changing its apperance
        VStack(alignment: .leading) {
            boxImage
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
            Text(animeGeneral?.title_eng ?? "N/A")
                //changing the look
                .foregroundStyle(.primary)
                .font(.caption)
        }
        //allows us to space each item out when put together in another view
        .padding(.leading, 15)
        
    }
}

#Preview {
    @Previewable @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    //Oshi no Ko and Spy x Family
//    var animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]
    let animeFB = animeDataFB.animes["OZtFGA9sVtdxtOCZZTEw"]
    
    CategoryItem(anime: AnimeData().animes[0], animeFB: animeFB)
}
