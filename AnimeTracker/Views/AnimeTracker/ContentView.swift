//
//  ContentView.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
            Text(animes[0].imageName)
        }
        .padding()
    }
}

#Preview {
    ContentView()
//    BoxImage(image: Image("ao_no_hako_box_image"))
    BoxImage(image: Image(animes[0].imageName))
}
