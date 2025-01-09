//
//  FavoriteButtonTester.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-03.
//

import SwiftUI

struct FavoriteButtonTester: View {
    var animeDataFB: AnimeDataFirebase?
    var animeGeneral: general?
    var animeFiles: files?
    
    @Binding var favorite: Bool
    
    var body: some View {
        Button(action: {
            favorite.toggle()
            print(favorite)
            
            //update Firebase
            let animeDocumentID = animeFiles?.doc_id_anime ?? "N/A"
            let updateDocument = "general"
            let updateItems: [String : Any] = ["isFavorite": favorite]
            
            animeDataFB?.updateData(animeDocumentID: animeDocumentID, updateDocument: updateDocument, updateItems: updateItems)
        }, label: {
            Text("\(favorite)")
            Label("Toggle favorite", systemImage: favorite ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundStyle(favorite ? .red : .primary)
        })
        .onChange(of: favorite) {
            print("changed!")
        }
    }
}

#Preview {
    //We only take in the animeGeneral object, nothing else
    @Previewable @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    var animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]    //Oshi no Ko
    var animeGeneral = animeFB?["general"] as? general
    var animeFiles = animeFB?["files"] as? files
//    var currentFavorite = animeGeneral?.isFavorite ?? false
    
    FavoriteButtonTester(animeDataFB: animeDataFB, animeGeneral: animeGeneral, animeFiles: animeFiles, favorite: .constant(true))
}
