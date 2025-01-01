//
//  CategoriesHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoriesHome: View {
    //Firebase
    @StateObject var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    //making AnimeData accessible through animeData
    @Environment(AnimeData.self) var animeData
    
    //hard-coded top image
    var splashImage: Image {
        Image("oshi_no_ko_splash")
    }
    
    var body: some View {
        //stating the categories we have
        let categories = ["Watching", "Completed", "Plan to Watch", "Dropped"]
        
        NavigationSplitView {
            List {
                splashImage
                    .resizable()
                    //allows the image to fill the entire container (will mean some of our image lies outside of the view, thus will look cropped)
                    .scaledToFill()
                    .frame(width: 368, height: 267)
                    //allows the image to be displayed to the edge of the screen
                    .listRowInsets(EdgeInsets())
                
                //display each category with its respective animes
                ForEach(categories, id: \.self) { category in
                    CategoryRow(categoryName: category, items: animeData.animes)
                }
                
                //allows the content to be extended to the edge of the display
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Anime Status")
        } detail: {
            Text("Select an anime to view its details.")
        }
    }
}

#Preview {
    CategoriesHome()
        .environment(AnimeData())
}
