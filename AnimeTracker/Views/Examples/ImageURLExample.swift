//
//  ImageURLExample.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-18.
//

import SwiftUI

struct ImageURLExample: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        // images for Solo Leveling S2
        let boxImage = URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx176496-xCNtU4llsUpu.png")
        let splashImage = URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/176496-5oY4k2NRqlYs.jpg")
        
        // We can use the same code inside of AsyncImage, so migration to AsyncImage should be really easy!
        AsyncImage(url: boxImage) { image in
            image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                //overlaying a rounded rectangle with a white border
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                }
                //adding a shadow. Gray on light mode, white on dark mode
                .shadow(color: Color.gray.opacity(0.7), radius: 10)
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
        } placeholder: {
            Color.blue
            .frame(width: 150, height: 212)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            //overlaying a rounded rectangle with a white border
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
            }
            //adding a shadow. Gray on light mode, white on dark mode
            .shadow(color: Color.gray.opacity(0.7), radius: 10)
        }
        
        AsyncImage(url: splashImage) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
        } placeholder: {
            Color.blue
        }
        
        Text("Bye!")
    }
}

#Preview {
    ImageURLExample()
}
