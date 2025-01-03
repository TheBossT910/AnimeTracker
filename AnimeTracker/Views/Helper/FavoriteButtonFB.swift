//
//  FavoriteButtonFB.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-02.
//

import SwiftUI

struct FavoriteButtonFB: View {
    var animeDataFB: AnimeDataFirebase
    var animeGeneral: general?
    var animeFiles: files?
    
    @State var isFavorite: Bool
    
    init(animeDataFB: AnimeDataFirebase, animeGeneral: general?, animeFiles : files?) {
        self.animeDataFB = animeDataFB
        self.animeGeneral = animeGeneral
        self.animeFiles = animeFiles
        
        //setting intial value of favorite as false
        self.isFavorite = false
    }
    
    var body: some View {
        //get favorite value from Firebase
        let setFavorite = animeGeneral?.isFavorite ?? false
        
        Button(
            //the logic to update the favorites value in the database when the button is clicked
            action: {
                //update Firebase
                let animeDocumentID = animeFiles?.doc_id_anime ?? "N/A"
                let updateDocument = "general"
                //we give the opposite  value of isFavorite here
                let updateItems: [String : Any] = ["isFavorite": !isFavorite]
                animeDataFB.updateData(animeDocumentID: animeDocumentID, updateDocument: updateDocument, updateItems: updateItems)
            },
            //setting the heart display
            label: {
                Label("Toggle favorite", systemImage: isFavorite ? "heart.fill" : "heart")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(isFavorite ? .red : .primary)
            }
        )
        .onChange(of: setFavorite ) {
            //this updates our isFavorite value when the actual database gets its value updated
            isFavorite = setFavorite
        }
    }
}

#Preview {
    //We only take in the animeGeneral object, nothing else
    @Previewable @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    var animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]    //Oshi no Ko
    var animeGeneral = animeFB?["general"] as? general
    var animeFiles = animeFB?["files"] as? files
    
    FavoriteButtonFB(animeDataFB: animeDataFB, animeGeneral: animeGeneral, animeFiles: animeFiles)
}
