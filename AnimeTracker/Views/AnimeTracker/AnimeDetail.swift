//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeDetail: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager
    
    var animeID: String //holds the document ID to a specific anime
    
    var body: some View {
        // getting user data
        let userID = authManager.userID ?? ""
        let userData = db.userData[userID]
        
        // getting the current anime's data
        let anime = db.animeNew[animeID]
        let animeGeneral = anime?.data?.general
        let animeFiles = anime?.data?.files
        
        // favorite button initial value
        @State var favorite: Bool = userData?.favorites?.contains(Int(animeID) ?? -1) ?? false
        
        ScrollView {
            //getting the box image
            let boxImage = URL(string: animeFiles?.box_image ?? "N/A")!
            BoxImage(imageURL: boxImage)
            
            VStack(alignment: .leading) {
                HStack {
                    //Title and favourite button
                    Text(animeGeneral?.title_english ?? "N/A")
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    FavoriteButtonFB(animeID: animeID, userID: userID, favorite: $favorite)
                }
                
                HStack {
                    // show premiere date
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
            
            // displaying the actual description
            Text(animeGeneral?.description ?? "N/A")
                .font(.body)
                .fontWeight(.medium)
        }
            .padding()
    }
}

#Preview {
    //environment
    let db = Database()
    let authManager = AuthManager.shared
    
    //"163134" is ReZero
    AnimeDetail(animeID: "163134")
        .environmentObject(db)
        .environmentObject(authManager)
}
