//
//  CategoryItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryItem: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    var animeID: String //holds the document id for a specific anime
    
    var body: some View {
        //getting an anime object
        let anime = db.animeNew[animeID]
        //gettting anime data objects
        let animeGeneral = anime?.data?.general
        let animeFiles = anime?.data?.files
        
        //getting the box image
        let boxImage = URL(string: animeFiles?.box_image ?? "N/A")
        
        //adding the image, and changing its apperance
        VStack(alignment: .center) {
            AsyncImage(url: boxImage) { image in
                image
                .resizable()
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
            } placeholder: {
                Color.gray
                    .frame(width: 220, height: 300)
            }
        
            
            //adding the show name
            Text(animeGeneral?.title_english ?? "N/A")
                .fontWeight(.semibold)
                //changing the look
                .foregroundStyle(.primary)
                .font(.callout)
                // same frame size as the image
                .frame(width: 220)
        }
        //allows us to space each item out when put together in another view
//        .padding(.leading, 15)
        
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    //"163134" is ReZero
    CategoryItem(animeID: "163134")
        .environmentObject(db)
        .environmentObject(authManager)
}
