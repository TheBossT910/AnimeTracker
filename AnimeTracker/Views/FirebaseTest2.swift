//
//  FirebaseTest2.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-29.
//

import SwiftUI

struct FirebaseTest2: View {

    @StateObject private var viewModel = AnimeDataFirebase(collection: "/animes/6KaHVRxICvkkrRYsDiMY/s1")

    var body: some View {
        VStack {
            //show data if the dictionary has items
            if viewModel.docs.isEmpty == false {
                //number of dictionary items
                Text("Anime: \(viewModel.docs.count)")
                Text(viewModel.docs.description)
                
                Text("____SPACER____")
                
                //get the dictionary at key "general" and display it
                let temp = viewModel.docs["general"]
                Text(temp?.description ?? "Nothing found")
                //shows specific value from the dicitonary
                let temp2 = temp?["rating"]
                //NOTE: I think I need to "cast" this into a struct to access it... look at the AnimeFirebaseData class!
                Text(temp2.debugDescription)
                
            } else {
                Text("Loading...")
            }
            
        }
        .onAppear {
            // Trigger fetching data when the view appears (if needed)
        }
    }
}

#Preview {
    FirebaseTest2()
}
