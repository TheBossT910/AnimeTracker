//
//  Tester.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-20.
//

import SwiftUI

struct Tester2: View {
    @ObservedObject var dbTest: Database = Database()
    var body: some View {
        let animeID = "163134"
        
        // episodes struct test
        var debug = dbTest.structEpisodeTest[animeID]?.debugDescription ?? "N/A"
        var firstEp = dbTest.structEpisodeTest[animeID]?.first
        
        var anilist_id = firstEp?.anilist_id
        var tvdb_id = firstEp?.tvdb_id
        var box = firstEp?.box_image
        var broadcast = firstEp?.broadcast
        var desc = firstEp?.description
        var recap = firstEp?.recap
        var runtime = firstEp?.runtime
        var title = firstEp?.title_episode

        
        Text("\(anilist_id ?? 0)")
        Text("\(tvdb_id ?? 0)")
        Text("\(box ?? "N/A")")
        Text("\(broadcast ?? 0)")
        Text("\(desc ?? "N/A")")
        Text("\(recap ?? "N/A")")
        Text("\(runtime ?? 0)")
        Text("\(title ?? "N/A")")
        
        
        Text(dbTest.anime_data[animeID]?["anime"]?["main"]?["title"] as? String ?? "N/A")
//        Text(dbTest.anime_data["107372"]?["data"]?["files"]?["box_image"] as? String ?? "N/A")
        
        var boxImage = URL(string: dbTest.anime_data[animeID]?["data"]?["files"]?["box_image"] as? String ?? "N/A")
        
        // displaying the box image
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
        
        // displaying the splash image
        var splashImage = URL(string: dbTest.anime_data[animeID]?["data"]?["files"]?["splash_image"] as? String ?? "N/A")
        
        
        AsyncImage(url: splashImage) { image in
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
                .frame(height: 80)
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
        
    }
}

#Preview {
    Tester2()
}
