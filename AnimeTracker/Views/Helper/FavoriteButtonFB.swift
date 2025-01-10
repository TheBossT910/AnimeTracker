//
//  FavoriteButtonFB.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-03.
//

import SwiftUI

struct FavoriteButtonFB: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //AnimeDataFirebase object
    var animeID: String //the document ID of an anime
    @Binding var favorite: Bool //holds the favorite value of the represented anime
    
    var body: some View {
        Button(action: {
            favorite.toggle()
            
            //update favorite in Firebase
            let updateDocument = "general"
            let updateItems: [String : Any] = ["isFavorite": favorite]
            animeDataFB.updateData(animeID: animeID, updateDocument: updateDocument, updateItems: updateItems)
        }, label: {
            //displaying a filled/unfilled heart depending on if favorite is true/false
            Label("Toggle favorite", systemImage: favorite ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundStyle(favorite ? .red : .primary)
        })
    }
}

#Preview {
    //environment object
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    
    FavoriteButtonFB(animeID: "6KaHVRxICvkkrRYsDiMY", favorite: .constant(true))
        .environmentObject(animeDataFB)
}
