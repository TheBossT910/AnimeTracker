//
//  FirebaseTest2.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-29.
//

import SwiftUI

struct FirebaseTest2: View {

    @StateObject private var viewModel = AnimeDataFirebase()
    //"/animes/6KaHVRxICvkkrRYsDiMY/s1"

    var body: some View {
        VStack {
            //show data if the dictionary has items
            if viewModel.docs.isEmpty == false {
                //number of documents and document ids
                Text("Show Documents: \(viewModel.docs.count)")
                Text(viewModel.docs.description)
                
                Text("____SPACER____")
                
                //number of animes (same as number of documents)
                Text("Anime Count: \(viewModel.animes.count)")
//                Text(viewModel.animes.description)
                
                //see the first key (the inner documents of animes)
//                let keys = viewModel.animes.keys
//                Text(keys.first ?? "N/A")
                
                //see a specific anime
//                Text(viewModel.animes["6KaHVRxICvkkrRYsDiMY"]?.debugDescription ?? "None")
//                Text(viewModel.animes["6KaHVRxICvkkrRYsDiMY"]?.keys.first ?? "N/A")
                
                //gets the anime at that doc id
                let cur = viewModel.animes["6KaHVRxICvkkrRYsDiMY"]
                //goes through its properties
//                Text(cur?["general"].debugDescription ?? "N/A")
                Text(cur?["general"]?.engTitle ?? "N/A")
                Text(cur?["description"]?.anime ?? "N/A")
                
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
