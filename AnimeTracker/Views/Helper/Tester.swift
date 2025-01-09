//
//  Tester.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-03.
//

import SwiftUI

struct Tester: View {
    @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    var body: some View {
        var animeFB = animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]    //Oshi no Ko
        var animeGeneral = animeFB?["general"] as? general
        var animeFiles = animeFB?["files"] as? files
        
        // Computed Binding, courtesy of ChatGPT
        let favoriteBinding = Binding<Bool>(
            get: { animeGeneral?.isFavorite ?? false },
            set: { newValue in
                // Update the model's isFavorite
                animeGeneral?.isFavorite = newValue
                
                // Update animeDataFB or notify about the change
                // Persist changes back to animeFB
                   if let generalUpdated = animeGeneral {
                       animeDataFB.animes["6KaHVRxICvkkrRYsDiMY"]?["general"] = generalUpdated
                   }
            }
        )
        
//        FavoriteButtonTester(animeDataFB: animeDataFB, animeGeneral: animeGeneral, animeFiles: animeFiles, favorite: favoriteBinding)
    }
}

#Preview {
    Tester()
}
