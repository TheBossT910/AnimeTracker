//
//  CategoriesHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoriesHome: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    var splashImage: Image {
        // TODO: have this as a rotating carosuel. This is a hard-coded image for now
        Image("oshi_no_ko_splash")
    }
    
    var body: some View {
        // the watch lists we have
        let categories = ["Watching", "Completed", "Plan to Watch", "Dropped"]
        
        NavigationStack {
            List {
                splashImage
                    .resizable()
                    //allows the image to fill the entire container (will mean some of our image lies outside of the view, thus will look cropped)
                    .scaledToFill()
                    .frame(width: .infinity, height: 267)
                    //allows the image to be displayed to the edge of the screen
                    .listRowInsets(EdgeInsets())
                
                if (authManager.isAuthenticated) {
                    Text("Add shows to your watchlists, and they will appear here!")
                        .font(.caption)
                    //display each category with its respective animes
                    ForEach(categories, id: \.self) { category in
                        CategoryRow(categoryName: category)
                    }
                    
                    //allows the content to be extended to the edge of the display
                    .listRowInsets(EdgeInsets())
                    .listRowSeparatorTint(Color.gray)
                } else {
                    Text("Create an account to:")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("-- Access and create watchlists!")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("-- Save your favorite animes!")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Click the icon on the bottom right to sign in/create your account.")
                }
            }
            .navigationTitle("Anime Status")
        }
    }
}

#Preview {
    //environment objects
    let db = Database()
    let authManager = AuthManager.shared
    
    CategoriesHome()
        .environmentObject(db)
        .environmentObject(authManager)
}
