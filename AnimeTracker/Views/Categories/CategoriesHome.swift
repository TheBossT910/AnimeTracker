//
//  CategoriesHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoriesHome: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds an AnimeDataFirebase object, with data from Firebase

    var splashImage: Image {
        //hard-coded top image for now
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
                    CategoryRow(categoryName: category)
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
    //environment objects
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    CategoriesHome()
        .environmentObject(animeDataFB)
}
