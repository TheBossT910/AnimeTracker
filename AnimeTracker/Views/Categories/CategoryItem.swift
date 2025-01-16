//
//  CategoryItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryItem: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds an AnimeDataFirebase object, with data from Firebase
    var animeID: String //holds the document id for a specific anime
    
    var body: some View {
        //getting an anime object
        let animeFB = animeDataFB.animes[animeID]
        //gettting anime data objects
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
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    CategoryItem(animeID: "OZtFGA9sVtdxtOCZZTEw")
        .environmentObject(animeDataFB)
}
