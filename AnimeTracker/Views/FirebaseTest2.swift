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
                
                //get the dictionary at key "description" and display it
                let temp = viewModel.docs["description"]
                Text(temp.debugDescription)
                
                Text("____SPACER____")
                
                //show data!
                Text(temp?.anime ?? "No desc")

                
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
