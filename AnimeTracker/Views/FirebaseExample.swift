//
//  FirebaseTest2.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-29.
//

import SwiftUI

struct FirebaseTest2: View {

    @StateObject private var viewModel = AnimeDataFirebase(collection: "s1")
    //"/animes/6KaHVRxICvkkrRYsDiMY/s1"

    var body: some View {
        VStack {
            //show data if the dictionary has items
            if viewModel.docs.isEmpty == false {
                //number of documents and document ids
                Text("Show Documents: \(viewModel.docs.count)")
//                Text(viewModel.docs.description)
                
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
//                Text(cur?["description"].debugDescription ?? "N/A")
//                Text(cur?["general"].debugDescription ?? "N/A")
//                Text(cur?["files"].debugDescription ?? "N/A")
//                Text(cur?["recap"].debugDescription ?? "N/A")
                
//                let description = cur?["description"] as? description
                let files = cur?["files"] as? files
                let general = cur?["general"] as? general
//                let recap = cur?["recap"] as? recap
                let media = cur?["media"] as? media
                
                //Text(curObj.debugDescription)
//                Text(description?.anime ?? "N/A")
                Text(files?.boxImage ?? "N/A")
                Text(general?.engTitle ?? "N/A")
//                Text(recap?.recap?["1"] ?? "N/A")
//                Text(media?.episodes?["1"]?["air_day"] ?? "N/A")
//                Text(media?.episodes?.debugDescription ?? "N/A")
//                Text(media.debugDescription)
                Text(media?.episodes?["1"]?.air_day ?? "N/A")
                Text(media?.movies?["1"]?.name_eng ?? "N/A")
                
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
