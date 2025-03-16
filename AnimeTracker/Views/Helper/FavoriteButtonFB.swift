//
//  FavoriteButtonFB.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-03.
//

import SwiftUI

struct FavoriteButtonFB: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    var animeID: String // the document ID of an anime
    var userID: String  // the user's id
    @Binding var favorite: Bool // holds the favorite value of the represented anime
    
    var body: some View {
        // check if we have user data to show/assign a favorites value for
        if (authManager.isAuthenticated) {
            Button(action: {
                // toggle the favorite, and update in databse
                favorite.toggle()
                db.updateFavorite(userID: userID, isFavorite: !favorite, animeID: Int(animeID) ?? -1)
            }, label: {
                // displaying a filled/unfilled heart depending on if favorite is true/false
                Label("Toggle favorite", systemImage: favorite ? "heart.fill" : "heart")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(favorite ? .red : .primary)
            })
        }
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    FavoriteButtonFB(animeID: "163134", userID: "T26C4LmC7zN5j8SAPNnoy7cziuS2", favorite: .constant(true))
        .environmentObject(db)
        .environmentObject(authManager)
}
