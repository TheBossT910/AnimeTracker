//
//  AnimeSelect.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeSelect: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager
    
    @Environment(\.colorScheme) var colorScheme //used to detect light/dark mode
    var animeID: String //holds the document id to a specific anime
    
    var body: some View {
        // getting current anime's data
        let anime = db.animeData[animeID]
        let animeGeneral = anime?.data?.general
        let animeFiles = anime?.data?.files
        
        // getting current user's data
        let userID = authManager.userID ?? ""
        let userData = db.userData[userID]
        
        //getting anime's favorite value
        let isFavorite = userData?.favorites?.contains(Int(animeID) ?? -1) ?? false
        
        VStack {
            //displaying top text, premiere and rating
            HStack {
                Text(animeGeneral?.premiere ?? "N/A")
                    .font(.caption)
                    .fontWeight(.heavy)
                    //changes color depending on light/dark mode
                    .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                Text(animeGeneral?.rating ?? "N/A")
                    .font(.caption)
                    .fontWeight(.semibold)
            }

            //displaying the image
            VStack {
                //getting the image
                let boxImage = URL(string: animeFiles?.box_image ?? "N/A")
                
                //formatting the image
                AsyncImage(url: boxImage) { image in
                    image
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
                } placeholder: {
                    Color.gray
                    //the ratio for fitting it is 11/15 (width/height)
                        .frame(width: 169, height: 230)
                        .clipped()
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                            //changes the color of the outline based on light/dark modes
                                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 4)
                        }
                }

            }
            // display the english and native title at the bottom
            Text(animeGeneral?.title_english ?? "N/A")
                .font(.title3)
                .fontWeight(.bold)
            Text(animeGeneral?.title_native ?? "N/A")
                .font(.callout)
        }
        .padding(10)
    }
}

#Preview {
    //environment
    let db = Database()
    let authManager = AuthManager.shared
    
    //"163134" is ReZero
    AnimeSelect(animeID: "163134")
        .environmentObject(db)
        .environmentObject(authManager)
}
