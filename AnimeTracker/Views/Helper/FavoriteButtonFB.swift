//
//  FavoriteButtonFB.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-02.
//

import SwiftUI

struct FavoriteButtonFB: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase
    var animeGeneral: general?
    var animeFiles: files?
    
    @State var isFavorite: Bool = false
    
    //TODO: perhaps remove this init, or make it consistent between files
    init(animeGeneral: general?, animeFiles : files?) {
        self.animeGeneral = animeGeneral
        self.animeFiles = animeFiles
        
        //setting intial value of favorite as false
//        self.isFavorite = false
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
    //for the dummy data
    //We only take in the animeGeneral object, nothing else
    @Previewable @StateObject var animeDataFB2 = AnimeDataFirebase(collection: "s1")
    
    //dummy data
    var animeFB = animeDataFB2.animes["6KaHVRxICvkkrRYsDiMY"]    //Oshi no Ko
    var animeGeneral = animeFB?["general"] as? general
    var animeFiles = animeFB?["files"] as? files
    
    //environment objects
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    
    FavoriteButtonFB(animeGeneral: animeGeneral, animeFiles: animeFiles)
        .environmentObject(animeDataFB)
    
}
