//
//  FirebaseExample.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-29.
//

import SwiftUI

struct FirebaseExample: View {

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
//                Text(cur?["general"].debugDescription ?? "N/A")
//                Text(cur?["files"].debugDescription ?? "N/A")
//                Text(cur?["media"].debugDescription ?? "N/A")
                
                let files = cur?["files"] as? files
                let general = cur?["general"] as? general
                let media = cur?["media"] as? media
                
                //Text(curObj.debugDescription)
                Text(files?.box_image ?? "N/A")
                Text(general?.title_eng ?? "N/A")
                Text(general?.description ?? "N/A")
                Text(media?.episodes?["1"]?.air_day ?? "N/A")
                Text(media?.movies?["1"]?.name_eng ?? "N/A")
                
                //get the titles for all animes
                let keys = Array(viewModel.animes.keys).sorted()
                ForEach(keys, id: \.self) { key in
                    let currentAnime = viewModel.animes[key]
                    let general = currentAnime?["general"] as? general
                    Text(general?.title_eng ?? "N/A")
                }
                
                Text("_______SPACER_______")
                
                //testing Firebase update function
//                Text("Testing Firebase update function")
//                Text("animeDocumentID: 6KaHVRxICvkkrRYsDiMY")
//                Text("updateDocument: general")
//                Text("updateItems: [\"isFavorite\": true]")
                Text("isFav value before was TRUE")
                Text("isFav value AFTER: \(general?.isFavorite)")
                
            } else {
                Text("Loading...")
            }
        
        }
        .onAppear {
            // Trigger fetching data when the view appears (if needed)
            viewModel.updateData(animeDocumentID: "6KaHVRxICvkkrRYsDiMY", updateDocument: "general", updateItems: ["isFavorite": true])
        }
    }
}

#Preview {
    FirebaseExample()
}
