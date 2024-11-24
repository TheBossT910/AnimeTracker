//
//  AnimeDetail.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct AnimeDetail: View {
    var body: some View {
        ScrollView {
            
            //hardcoded image
            BoxImage(image: Image("ao_no_hako_box_image"))
            
            //Putting all the text stuff within a VStack
            VStack(alignment: .leading) {
                Text("Ao no Hako")
                    .font(.title)
                HStack {
                    //Release schedule info?
                    Text("Thursdays, 10:00 PM")
                    Spacer()
                    //Anime season info?
                    Text("S1, Fall 2024")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                Text("Description")
                    .font(.title2)
                Text("lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum")
            }
            .padding()
            
        }
    }
}

#Preview {
    AnimeDetail()
}
