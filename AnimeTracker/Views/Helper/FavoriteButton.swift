//
//  FavoriteButton.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-19.
//

//DEPRECATED: Replaced by newer FavoriteButtonFB as of 1/2/2025

import SwiftUI

struct FavoriteButton: View {
    //TODO: implement animeDataFB as @Environment
    @StateObject private var animeDataFB = AnimeDataFirebase(collection: "s1")
    @State var isSet = true //just used as a toggle to update the values
    
    let animeGeneral: general?
    let docIDAnime: String
    
    var body: some View {
        
        //TODO: need to figure out how to update this variable when it changes value
        @State var curFav = animeGeneral?.isFavorite ?? false
        
        Button {
            isSet.toggle()
            curFav.toggle()
        } label: {
            Label("Toggle favorite", systemImage: curFav ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundColor(curFav ? .red : .primary)
                .onChange(of: isSet) {
                    curFav = !curFav
                    //isFavorites will always be in general as "isFavorites"
                    animeDataFB.updateData(animeDocumentID: docIDAnime, updateDocument: "general", updateItems: ["isFavorite": curFav])
                }
        }
        Text("\(curFav)")
    }
}

#Preview {
    @Previewable @State var testBool = true
    @Previewable @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    var animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]
    var animeGeneral = animeFB?["general"] as? general
    
    FavoriteButton(animeGeneral: animeGeneral, docIDAnime: "6KaHVRxICvkkrRYsDiMY")
}
